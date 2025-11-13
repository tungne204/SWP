package control;

import com.google.gson.Gson;
import dao.AppointmentDAO;
import entity.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SearchAppointmentServlet", urlPatterns = {"/receptionist/search-appointment"})
public class SearchAppointmentServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check login session
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        entity.User user = (session != null) ? (entity.User) session.getAttribute("acc") : null;
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }
        
        // Check receptionist permission (roleId = 5)
        if (user.getRoleId() != 5) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Forbidden\"}");
            return;
        }
        
        String keyword = request.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            response.setContentType("application/json;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"appointments\":[]}");
            out.flush();
            return;
        }
        
        List<Appointment> appointments = appointmentDAO.searchAppointmentsForCheckin(keyword);
        
        // Convert to JSON format
        List<Map<String, Object>> appointmentList = new ArrayList<>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        
        for (Appointment apt : appointments) {
            Map<String, Object> aptMap = new HashMap<>();
            aptMap.put("appointmentId", apt.getAppointmentId());
            aptMap.put("patientId", apt.getPatientId());
            aptMap.put("patientName", apt.getPatientName() != null ? apt.getPatientName() : "");
            aptMap.put("parentName", apt.getParentName() != null ? apt.getParentName() : "");
            aptMap.put("doctorName", apt.getDoctorName() != null ? apt.getDoctorName() : "");
            aptMap.put("doctorSpecialty", apt.getDoctorSpecialty() != null ? apt.getDoctorSpecialty() : "");
            aptMap.put("dateTime", apt.getDateTime() != null ? dateFormat.format(apt.getDateTime()) : "");
            aptMap.put("address", apt.getPatientAddress() != null ? apt.getPatientAddress() : "");
            appointmentList.add(aptMap);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("appointments", appointmentList);
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        Gson gson = new Gson();
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
}




