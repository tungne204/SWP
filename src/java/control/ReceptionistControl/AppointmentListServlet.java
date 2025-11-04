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

        //1. Lấy thông tin user & role
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
        session.setAttribute("role", role);

        //2. Lấy tham số từ request + gán giá trị mặc định để tránh null
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");
        String sort = req.getParameter("sort");

        if (keyword == null) {
            keyword = "";
        }
        if (status == null || status.isEmpty()) {
            status = "all";
        }
        if (sort == null || sort.isEmpty()) {
            sort = "date_desc";
        }

        int page = 1;
        int pageSize = 10;
        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Appointment> list;
        int totalAppointments = 0;

        //3. Xử lý theo từng role
        switch (role) {
            case "Doctor" -> {
                DoctorDAO doctorDAO = new DoctorDAO();
                Doctor doctor = doctorDAO.getDoctorByUserId(acc.getUserId());
                if (doctor != null) {
                    session.setAttribute("doctorId", doctor.getDoctorId());
                    list = dao.getAppointmentsByDoctorId(
                            doctor.getDoctorId(), keyword, status, sort, page, pageSize);
                    totalAppointments = dao.countAppointments(keyword, status, "Doctor", acc.getUserId());
                } else {
                    list = List.of();
                }
            }

            case "Receptionist" -> {
                list = dao.getAppointments(keyword, status, sort, page, pageSize);
                totalAppointments = dao.countAppointments(keyword, status, "Receptionist", acc.getUserId());
            }

            case "Patient" -> {
                list = dao.getAppointmentsByPatientUserId(acc.getUserId(), keyword, status, sort, page, pageSize);
                totalAppointments = dao.countAppointments(keyword, status, "Patient", acc.getUserId());
            }

            default ->
                list = List.of();
        }

        //4. Tính tổng số trang
        int totalPages = (int) Math.ceil((double) totalAppointments / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }

        //5. Gửi dữ liệu sang JSP
        req.setAttribute("list", list);
        req.setAttribute("keyword", keyword);
        req.setAttribute("status", status);
        req.setAttribute("sort", sort);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);

        // 6. Forward sang giao diện JSP
        req.getRequestDispatcher("/receptionist/appointmentList.jsp").forward(req, resp);
    }
}
