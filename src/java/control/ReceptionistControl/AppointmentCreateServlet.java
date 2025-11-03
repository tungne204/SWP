package control.ReceptionistControl;

import dao.Receptionist.AppointmentDAO;
import entity.Receptionist.Doctor;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import util.ValidationUtils;

@WebServlet(name = "AppointmentCreateServlet", urlPatterns = {"/Appointment-Create"})
public class AppointmentCreateServlet extends HttpServlet {

    private final AppointmentDAO dao = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Lấy danh sách bác sĩ
        List<Doctor> doctors = dao.getAllDoctors();
        req.setAttribute("doctors", doctors);
        
        // Lấy email của user đang đăng nhập
        HttpSession session = req.getSession(false);
        if (session != null) {
            User loggedInUser = (User) session.getAttribute("acc");
            if (loggedInUser != null) {
                req.setAttribute("userEmail", loggedInUser.getEmail());
                req.setAttribute("userPhone", loggedInUser.getPhone());
            }
        }
        
        req.getRequestDispatcher("/receptionist/AppointmentCreate.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String patientName = req.getParameter("patientName");
        String patientDob = req.getParameter("patientDob");
        String parentName = req.getParameter("parentName");
        String patientAddress = req.getParameter("patientAddress");
        String insuranceInfo = req.getParameter("insuranceInfo");
        String parentPhone = req.getParameter("parentPhone");
        
        // Lấy email từ session
        String patientEmail = null;
        HttpSession session = req.getSession(false);
        if (session != null) {
            User loggedInUser = (User) session.getAttribute("acc");
            if (loggedInUser != null) {
                patientEmail = loggedInUser.getEmail();
            }
        }
        String appointmentDate = req.getParameter("appointmentDate");
        String appointmentTime = req.getParameter("appointmentTime");
        String status = req.getParameter("status");
        int doctorId = Integer.parseInt(req.getParameter("doctorId"));

        String dateTimeStr = appointmentDate + " " + appointmentTime;

        // --- VALIDATE ---
        ValidationUtils validator = new ValidationUtils();
        validator.validateNotEmpty(patientName, "Tên bệnh nhân");
        validator.validateNotEmpty(patientDob, "Ngày sinh");
        validator.validateNotEmpty(parentName, "Phụ huynh");
        validator.validateNotEmpty(patientAddress, "Địa chỉ");
        validator.validateNotEmpty(insuranceInfo, "Thông tin bảo hiểm");
        validator.validatePhone(parentPhone, "Số điện thoại");
        validator.validateNotEmpty(appointmentDate, "Ngày khám");
        validator.validateNotEmpty(appointmentTime, "Giờ khám");
        validator.validatePositiveId(doctorId, "Bác sĩ");
        validator.validateInList(status, List.of("Pending", "Confirmed", "Cancelled"), "Trạng thái");

        if (dateTimeStr != null) {
            validator.validateDateTime(dateTimeStr, "Ngày giờ khám");
        }

        if (validator.hasErrors()) {
            List<Doctor> doctors = dao.getAllDoctors();
            req.setAttribute("doctors", doctors);
            req.setAttribute("errors", validator.getErrors());
            // Set lại email và phone cho form
            if (session != null) {
                User loggedInUser = (User) session.getAttribute("acc");
                if (loggedInUser != null) {
                    req.setAttribute("userEmail", loggedInUser.getEmail());
                    req.setAttribute("userPhone", loggedInUser.getPhone());
                }
            }
            req.getRequestDispatcher("/receptionist/AppointmentCreate.jsp").forward(req, resp);
            return;
        }

        // --- INSERT ---
        boolean success = dao.createAppointment(
                patientName, patientDob, parentName, patientAddress, insuranceInfo,
                patientEmail, parentPhone, dateTimeStr,
                doctorId, status
        );

        if (success) {
            resp.sendRedirect("Appointment-List?msg=created");
        } else {
            List<Doctor> doctors = dao.getAllDoctors();
            req.setAttribute("errorMsg", "❌ Không thể tạo lịch hẹn. Vui lòng thử lại!");
            req.setAttribute("doctors", doctors);
            // Set lại email và phone cho form
            if (session != null) {
                User loggedInUser = (User) session.getAttribute("acc");
                if (loggedInUser != null) {
                    req.setAttribute("userEmail", loggedInUser.getEmail());
                    req.setAttribute("userPhone", loggedInUser.getPhone());
                }
            }
            req.getRequestDispatcher("/receptionist/AppointmentCreate.jsp").forward(req, resp);
        }
    }
}
