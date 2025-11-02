package control.ReceptionistControl;

import dao.Receptionist.AppointmentDAO;
import entity.Receptionist.Appointment;
import entity.Receptionist.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import util.ValidationUtils;

@WebServlet(name = "AppointmentUpdateServlet", urlPatterns = {"/Appointment-Update"})
public class AppointmentUpdateServlet extends HttpServlet {

    private final AppointmentDAO dao = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        Appointment appointment = dao.getAppointmentById(id);
        List<Doctor> doctors = dao.getAllDoctors();

        if (appointment == null) {
            resp.sendRedirect("Appointment-List?error=notfound");
            return;
        }

        req.setAttribute("appointment", appointment);
        req.setAttribute("doctors", doctors);
        req.getRequestDispatcher("/receptionist/AppointmentUpdate.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));
        int doctorId = Integer.parseInt(req.getParameter("doctorId"));
        String date = req.getParameter("appointmentDate");
        String time = req.getParameter("appointmentTime");
        String status = req.getParameter("status");

        // 🩺 Thông tin bệnh nhân và phụ huynh (mới thêm)
        String patientName = req.getParameter("patientName");
        String parentName = req.getParameter("parentName");
        String patientAddress = req.getParameter("patientAddress");
        String patientEmail = req.getParameter("patientEmail");
        String parentPhone = req.getParameter("parentPhone");

        String dateTimeStr = null;
        if (date != null && !date.isEmpty() && time != null && !time.isEmpty()) {
            // format người dùng nhập: dd/MM/yyyy HH:mm
            dateTimeStr = date + " " + time;
        }

        // --- VALIDATE ---
        ValidationUtils validator = new ValidationUtils();
        validator.validatePositiveId(appointmentId, "Mã lịch hẹn");
        validator.validatePositiveId(doctorId, "Bác sĩ");
        validator.validateNotEmpty(date, "Ngày khám");
        validator.validateNotEmpty(time, "Giờ khám");
        validator.validateNotEmpty(patientName, "Tên bệnh nhân");
        validator.validateNotEmpty(parentName, "Tên phụ huynh");
        validator.validateNotEmpty(patientAddress, "Địa chỉ");
        validator.validateNotEmpty(patientEmail, "Email");
        validator.validateNotEmpty(parentPhone, "Số điện thoại");

        if (dateTimeStr != null) {
            validator.validateDateTime(dateTimeStr, "Ngày giờ khám");
        }

        validator.validateInList(status, List.of("Pending", "Confirmed", "Cancelled", "Completed"), "Trạng thái");

        if (validator.hasErrors()) {
            Appointment appointment = dao.getAppointmentById(appointmentId);
            List<Doctor> doctors = dao.getAllDoctors();

            req.setAttribute("appointment", appointment);
            req.setAttribute("doctors", doctors);
            req.setAttribute("errors", validator.getErrors());

            req.getRequestDispatcher("/receptionist/AppointmentUpdate.jsp").forward(req, resp);
            return;
        }

        // --- CẬP NHẬT ---
        boolean success = dao.updateAppointmentFull(
                appointmentId,
                dateTimeStr,
                doctorId,
                status,
                patientName,
                parentName,
                patientAddress,
                patientEmail,
                parentPhone
        );

        if (success) {
            resp.sendRedirect("Appointment-List?msg=updated");
        } else {
            Appointment appointment = dao.getAppointmentById(appointmentId);
            List<Doctor> doctors = dao.getAllDoctors();

            req.setAttribute("appointment", appointment);
            req.setAttribute("doctors", doctors);
            req.setAttribute("errorMsg", "❌ Cập nhật thất bại, vui lòng thử lại!");
            req.getRequestDispatcher("/receptionist/AppointmentUpdate.jsp").forward(req, resp);
        }
    }
}
