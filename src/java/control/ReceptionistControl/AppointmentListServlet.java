package control.ReceptionistControl;

import dao.Receptionist.AppointmentDAO;
import dao.Receptionist.DoctorDAO;
import entity.Receptionist.Appointment;
import entity.Receptionist.Doctor;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/Appointment-List")
public class AppointmentListServlet extends HttpServlet {

    private final AppointmentDAO dao = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        // Lấy thông tin user & role từ session
        User acc = (User) session.getAttribute("acc");
        String role = "";
        if (acc != null && acc.getRoleId() != 0) {
            switch (acc.getRoleId()) {
                case 2 ->
                    role = "Doctor";
                case 3 ->
                    role = "Patient";
                case 5 ->
                    role = "Receptionist";
                default ->
                    role = "Other";
            }
        }

        // Lưu role vào session (phục vụ JSP)
        session.setAttribute("role", role);

        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");
        String sort = req.getParameter("sort");
        int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
        int pageSize = 10;

        if (req.getParameter("page") != null) {
            page = Integer.parseInt(req.getParameter("page"));
        }

        List<Appointment> list;

        //Nếu là Doctor → lấy doctorId từ bảng Doctor (dựa theo user_id)
        if ("Doctor".equalsIgnoreCase(role)) {
            DoctorDAO doctorDAO = new DoctorDAO();
            Doctor doctor = doctorDAO.getDoctorByUserId(acc.getUserId()); // ← phải có hàm này trong DoctorDAO

            if (doctor != null) {
                session.setAttribute("doctorId", doctor.getDoctorId()); // lưu doctorId vào session
                list = dao.getAppointmentsByDoctorId(
                        doctor.getDoctorId(), keyword, status, sort, page, pageSize);
            } else {
                // Nếu không tìm thấy doctor → hiển thị trống
                list = List.of();
            }
        } 
        
        //Nếu là Receptionist → xem toàn bộ
        else if ("Receptionist".equalsIgnoreCase(role)) {
            list = dao.getAppointments(keyword, status, sort, page, pageSize);
        } 
        
        // Nếu là Patient → chỉ xem appointment của chính mình
        else if ("Patient".equalsIgnoreCase(role)) {
            list = dao.getAppointmentsByUserId(acc.getUserId(), keyword, status, sort, page, pageSize);
        } 

        //Các role khác → không có quyền xem
        else {
            list = List.of();
        }

        req.setAttribute("list", list);
        req.setAttribute("keyword", keyword);
        req.setAttribute("status", status);
        req.setAttribute("sort", sort);
        req.setAttribute("page", page);

        // Dùng chung JSP
        req.getRequestDispatcher("/receptionist/AppointmentList.jsp").forward(req, resp);
    }
}
