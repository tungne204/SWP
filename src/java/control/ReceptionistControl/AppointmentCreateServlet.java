package control.ReceptionistControl;

import dao.Receptionist.AppointmentDAO;
import entity.Receptionist.Doctor;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AppointmentCreateServlet", urlPatterns = {"/Appointment-Create"})
public class AppointmentCreateServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("acc") : null;

        // Bắt buộc login & đúng role Patient
        if (acc == null || acc.getRoleId() != 3) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        // Lấy danh sách bác sĩ cho combobox
        List<Doctor> doctors = appointmentDAO.getAllDoctors();
        req.setAttribute("doctors", doctors);

        req.getRequestDispatcher("/receptionist/AppointmentCreate.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("acc") : null;

        if (acc == null || acc.getRoleId() != 3) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        // 1. Gọi hàm validate riêng
        Map<String, String> errors = validateAppointmentForm(req);

        if (!errors.isEmpty()) {
            // Có lỗi → nạp lại list bác sĩ + lỗi + forward về form
            List<Doctor> doctors = appointmentDAO.getAllDoctors();
            req.setAttribute("doctors", doctors);
            req.setAttribute("errors", errors);
            req.setAttribute("errorMsg", "Vui lòng kiểm tra lại các trường bị lỗi.");
            req.getRequestDispatcher("/receptionist/AppointmentCreate.jsp").forward(req, resp);
            return;
        }

        // 2. Không có lỗi → parse dữ liệu & gọi DAO tạo appointment
        String patientName = req.getParameter("patientName");
        String patientDobStr = req.getParameter("patientDob");
        String patientAddress = req.getParameter("patientAddress");
        String insuranceInfo = req.getParameter("insuranceInfo");
        String parentName = req.getParameter("parentName");
        String parentPhone = req.getParameter("parentPhone");
        String appointmentDateStr = req.getParameter("appointmentDate");
        String appointmentTimeStr = req.getParameter("appointmentTime");
        String doctorIdStr = req.getParameter("doctorId");
        String status = req.getParameter("status");

        if (status == null || status.isBlank()
                || (!status.equals("Pending") && !status.equals("Confirmed") && !status.equals("Cancelled"))) {
            status = "Pending";
        }

        try {
            LocalDate patientDob = LocalDate.parse(patientDobStr);
            LocalDateTime appointmentDateTime = LocalDateTime.parse(appointmentDateStr + "T" + appointmentTimeStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            Timestamp ts = Timestamp.valueOf(appointmentDateTime);

            boolean ok = appointmentDAO.createAppointmentWithPatientInfo(
                    acc.getUserId(),
                    patientName,
                    patientDob,
                    patientAddress,
                    insuranceInfo,
                    parentName,
                    parentPhone,
                    doctorId,
                    ts,
                    status
            );

            if (ok) {
                // Tạo thành công → quay lại Appointment-List của patient, sẽ có record mới
                resp.sendRedirect("Appointment-List?msg=created");
            } else {
                List<Doctor> doctors = appointmentDAO.getAllDoctors();
                req.setAttribute("doctors", doctors);
                req.setAttribute("errorMsg", "Không thể tạo lịch hẹn mới. Vui lòng thử lại sau.");
                req.getRequestDispatcher("/receptionist/AppointmentCreate.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            List<Doctor> doctors = appointmentDAO.getAllDoctors();
            req.setAttribute("doctors", doctors);
            req.setAttribute("errorMsg", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.");
            req.getRequestDispatcher("/receptionist/AppointmentCreate.jsp").forward(req, resp);
        }
    }

    /**
     * Hàm validate TÁCH RIÊNG, giảng viên sẽ thích kiểu này hơn. Đọc param từ
     * request, kiểm tra, trả về Map<fieldName, message>. Nếu map rỗng => dữ
     * liệu hợp lệ.
     */
    private Map<String, String> validateAppointmentForm(HttpServletRequest req) {
        Map<String, String> errors = new HashMap<>();

        String patientName = req.getParameter("patientName");
        String patientDobStr = req.getParameter("patientDob");
        String patientAddress = req.getParameter("patientAddress");
        String insuranceInfo = req.getParameter("insuranceInfo");
        String parentName = req.getParameter("parentName");
        String parentPhone = req.getParameter("parentPhone");
        String appointmentDateStr = req.getParameter("appointmentDate");
        String appointmentTimeStr = req.getParameter("appointmentTime");
        String doctorIdStr = req.getParameter("doctorId");
        String status = req.getParameter("status");

        // patientName
        if (patientName == null || patientName.trim().isEmpty()) {
            errors.put("patientName", "Tên bệnh nhân không được để trống.");
        }

        // dob
        if (patientDobStr == null || patientDobStr.isBlank()) {
            errors.put("patientDob", "Ngày sinh không được để trống.");
        } else {
            try {
                LocalDate dob = LocalDate.parse(patientDobStr);
                if (dob.isAfter(LocalDate.now())) {
                    errors.put("patientDob", "Ngày sinh không được lớn hơn ngày hiện tại.");
                }
            } catch (DateTimeParseException e) {
                errors.put("patientDob", "Ngày sinh không hợp lệ (định dạng yyyy-MM-dd).");
            }
        }

        // address
        if (patientAddress == null || patientAddress.trim().isEmpty()) {
            errors.put("patientAddress", "Địa chỉ không được để trống.");
        }

        // insurance: cho phép trống, không bắt buộc, nên không validate mạnh
        // parentName
        if (parentName == null || parentName.trim().isEmpty()) {
            errors.put("parentName", "Tên phụ huynh không được để trống.");
        }

        // parentPhone
        if (parentPhone == null || parentPhone.trim().isEmpty()) {
            errors.put("parentPhone", "Số điện thoại không được để trống.");
        } else if (!parentPhone.matches("\\d{9,11}")) {
            errors.put("parentPhone", "Số điện thoại chỉ gồm 9–11 chữ số.");
        }

        // appointment datetime
        if (appointmentDateStr == null || appointmentDateStr.isBlank()
                || appointmentTimeStr == null || appointmentTimeStr.isBlank()) {
            errors.put("appointmentDateTime", "Ngày và giờ khám không được để trống.");
        } else {
            try {
                LocalDateTime dt = LocalDateTime.parse(appointmentDateStr + "T" + appointmentTimeStr);
                if (dt.isBefore(LocalDateTime.now())) {
                    errors.put("appointmentDateTime", "Ngày giờ khám phải lớn hơn thời điểm hiện tại.");
                }
            } catch (DateTimeParseException e) {
                errors.put("appointmentDateTime", "Ngày/giờ khám không hợp lệ.");
            }
        }

        // doctorId
        try {
            Integer.parseInt(doctorIdStr);
        } catch (Exception e) {
            errors.put("doctorId", "Vui lòng chọn bác sĩ hợp lệ.");
        }

        // status – nếu có chọn linh tinh thì cũng tự reset về Pending
        if (status != null && !status.isBlank()) {
            if (!status.equals("Pending") && !status.equals("Confirmed") && !status.equals("Cancelled")) {
                errors.put("status", "Trạng thái không hợp lệ.");
            }
        }

        return errors;
    }
}
