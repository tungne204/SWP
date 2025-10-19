package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.DoctorDAO;
import entity.Doctor;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "DoctorListServlet", urlPatterns = {"/doctors"})
public class DoctorListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            DoctorDAO doctorDAO = new DoctorDAO();
            
            // Ensure at least one doctor exists
            doctorDAO.ensureDefaultDoctorExists();
            
            List<Doctor> doctors = doctorDAO.getAllDoctors();

            if (doctors == null || doctors.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_OK);
                PrintWriter out = response.getWriter();
                out.print("[]");
                out.flush();
                return;
            }

            StringBuilder json = new StringBuilder();
            json.append("[");

            for (int i = 0; i < doctors.size(); i++) {
                Doctor doctor = doctors.get(i);
                json.append("{");
                json.append("\"doctorId\":").append(doctor.getDoctorId()).append(",");
                json.append("\"userId\":").append(doctor.getUserId()).append(",");
                json.append("\"username\":\"").append(doctor.getUsername() != null ? doctor.getUsername() : "Unknown").append("\",");
                json.append("\"specialty\":\"").append(doctor.getSpecialty() != null ? doctor.getSpecialty() : "General Medicine").append("\"");
                json.append("}");

                if (i < doctors.size() - 1) {
                    json.append(",");
                }
            }

            json.append("]");

            PrintWriter out = response.getWriter();
            out.print(json.toString());
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\": \"Có lỗi xảy ra khi tải danh sách bác sĩ: " + e.getMessage() + "\"}");
            out.flush();
        }
    }
}

