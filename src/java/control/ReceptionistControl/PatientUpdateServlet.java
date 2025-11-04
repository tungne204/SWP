package control.ReceptionistControl;

import dao.Receptionist.PatientDAO;
import entity.Receptionist.Patient;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "PatientUpdateServlet",
        urlPatterns = {"/Patient-Update"})
public class PatientUpdateServlet extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        User acc = (User) session.getAttribute("acc");
        if (acc.getRoleId() != 5) { // chỉ Receptionist
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

        // === CASE: AJAX validate từng field ===
        String action = req.getParameter("action");
        if ("validate".equalsIgnoreCase(action)) {
            handleAjaxValidate(req, resp, acc);
            return;
        }

        // === CASE: mở form update ===
        String pidRaw = req.getParameter("pid");
        if (pidRaw == null) {
            pidRaw = req.getParameter("patientId");
        }

        int patientId;
        try {
            patientId = Integer.parseInt(pidRaw);
        } catch (Exception e) {
            resp.sendRedirect("Patient-List?error=invalidId");
            return;
        }

        Patient patient = patientDAO.getPatientProfileById(patientId);
        if (patient == null) {
            resp.sendRedirect("Patient-List?error=notfound");
            return;
        }

        req.setAttribute("patient", patient);
        req.getRequestDispatcher("/receptionist/PatientUpdate.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }
        User acc = (User) session.getAttribute("acc");
        if (acc.getRoleId() != 5) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        int patientId;
        try {
            patientId = Integer.parseInt(req.getParameter("patientId"));
        } catch (Exception e) {
            resp.sendRedirect("Patient-List?error=invalidId");
            return;
        }

        Patient old = patientDAO.getPatientProfileById(patientId);
        if (old == null) {
            resp.sendRedirect("Patient-List?error=notfound");
            return;
        }

        // Lấy data từ form
        String fullName = req.getParameter("fullName");
        String dobStr = req.getParameter("dob");
        String address = req.getParameter("address");
        String insuranceInfo = req.getParameter("insuranceInfo");
        String parentName = req.getParameter("parentName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        Map<String, String> errors = new HashMap<>();

        // Validate giống ajax, nhưng full form
        String err;

        err = validateFullName(fullName);
        if (err != null) {
            errors.put("fullName", err);
        }

        Date dobSql = null;
        err = validateDob(dobStr);
        if (err != null) {
            errors.put("dob", err);
        } else if (dobStr != null && !dobStr.isBlank()) {
            dobSql = Date.valueOf(LocalDate.parse(dobStr));
        }

        err = validateAddress(address);
        if (err != null) {
            errors.put("address", err);
        }

        err = validateInsurance(insuranceInfo);
        if (err != null) {
            errors.put("insuranceInfo", err);
        }

        err = validateParentName(parentName);
        if (err != null) {
            errors.put("parentName", err);
        }

        err = validateEmail(email);
        if (err != null) {
            errors.put("email", err);
        } else if (old.getUserId() > 0
                && patientDAO.isEmailUsedByAnotherUser(email, old.getUserId())) {
            errors.put("email", "Email đã được sử dụng bởi tài khoản khác.");
        }

        err = validatePhone(phone);
        if (err != null) {
            errors.put("phone", err);
        }

        // Nếu có lỗi -> forward lại form
        if (!errors.isEmpty()) {
            Patient p = new Patient();
            p.setPatientId(patientId);
            p.setUserId(old.getUserId());
            p.setParentId(old.getParentId());

            p.setFullName(fullName);
            p.setDob(dobSql);
            p.setAddress(address);
            p.setInsuranceInfo(insuranceInfo);
            p.setParentName(parentName);
            p.setEmail(email);
            p.setPhone(phone);

            req.setAttribute("patient", p);
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/receptionist/PatientUpdate.jsp")
                    .forward(req, resp);
            return;
        }

        // Không lỗi -> update DB
        Patient toUpdate = new Patient();
        toUpdate.setPatientId(patientId);
        toUpdate.setUserId(old.getUserId());
        toUpdate.setParentId(old.getParentId());
        toUpdate.setFullName(fullName);
        toUpdate.setDob(dobSql);
        toUpdate.setAddress(address);
        toUpdate.setInsuranceInfo(insuranceInfo);
        toUpdate.setParentName(parentName);
        toUpdate.setEmail(email);
        toUpdate.setPhone(phone);

        boolean ok = patientDAO.updatePatientProfile(toUpdate);

        if (ok) {
            // Quay lại Patient-Profile, kèm success
            resp.sendRedirect("Patient-Profile?id=" + patientId + "&success=true");
        } else {
            // Lỗi server -> quay lại form + msg
            req.setAttribute("patient", toUpdate);
            req.setAttribute("updateError", "Cập nhật thất bại. Vui lòng thử lại.");
            req.getRequestDispatcher("/receptionist/PatientUpdate.jsp")
                    .forward(req, resp);
        }
    }

    // ========== AJAX VALIDATION CHO TỪNG FIELD ==========
    private void handleAjaxValidate(HttpServletRequest req, HttpServletResponse resp, User acc)
            throws IOException {

        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String field = req.getParameter("field");
        String value = req.getParameter("value");
        String pidRaw = req.getParameter("patientId");
        int patientId = 0;
        int userId = 0;

        if (pidRaw != null) {
            try {
                patientId = Integer.parseInt(pidRaw);
            } catch (NumberFormatException ignored) {
            }
        }

        if (patientId > 0) {
            Patient p = patientDAO.getPatientProfileById(patientId);
            if (p != null) {
                userId = p.getUserId();
            }
        }

        String error = null;

        switch (field) {
            case "fullName" ->
                error = validateFullName(value);
            case "dob" ->
                error = validateDob(value);
            case "address" ->
                error = validateAddress(value);
            case "insuranceInfo" ->
                error = validateInsurance(value);
            case "parentName" ->
                error = validateParentName(value);
            case "email" -> {
                error = validateEmail(value);
                if (error == null && userId > 0
                        && patientDAO.isEmailUsedByAnotherUser(value, userId)) {
                    error = "Email đã được sử dụng bởi tài khoản khác.";
                }
            }
            case "phone" ->
                error = validatePhone(value);
            default ->
                error = null;
        }

        if (error == null) {
            out.write("{\"valid\":true}");
        } else {
            out.write("{\"valid\":false,\"message\":\"" + escapeJson(error) + "\"}");
        }
        out.flush();
    }

    // ========== VALIDATION COMMON ==========
    private String validateFullName(String fullName) {
        if (fullName == null || fullName.isBlank()) {
            return "Họ tên không được để trống.";
        }
        if (fullName.length() > 100) {
            return "Họ tên quá dài (tối đa 100 ký tự).";
        }
        return null;
    }

    private String validateDob(String dobStr) {
        if (dobStr == null || dobStr.isBlank()) {
            return null; // cho phép trống
        }
        try {
            LocalDate dob = LocalDate.parse(dobStr);
            if (dob.isAfter(LocalDate.now())) {
                return "Ngày sinh không được lớn hơn ngày hiện tại.";
            }
        } catch (DateTimeParseException e) {
            return "Ngày sinh không hợp lệ.";
        }
        return null;
    }

    private String validateAddress(String address) {
        if (address == null || address.isBlank()) {
            return "Địa chỉ không được để trống.";
        }
        if (address.length() > 255) {
            return "Địa chỉ quá dài (tối đa 255 ký tự).";
        }
        return null;
    }

    private String validateInsurance(String insuranceInfo) {
        if (insuranceInfo != null && insuranceInfo.length() > 500) {
            return "Thông tin bệnh nền quá dài.";
        }
        return null;
    }

    private String validateParentName(String parentName) {
        if (parentName == null || parentName.isBlank()) {
            return "Tên phụ huynh không được để trống.";
        }
        if (parentName.length() > 100) {
            return "Tên phụ huynh quá dài (tối đa 100 ký tự).";
        }
        return null;
    }

    private String validateEmail(String email) {
        if (email == null || email.isBlank()) {
            return null; // cho phép trống, nếu muốn bắt buộc thì đổi
        }
        String regex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        if (!email.matches(regex)) {
            return "Email không hợp lệ.";
        }
        if (email.length() > 100) {
            return "Email quá dài (tối đa 100 ký tự).";
        }
        return null;
    }

    private String validatePhone(String phone) {
        if (phone == null || phone.isBlank()) {
            return null; // tuỳ bạn có muốn bắt buộc hay không
        }
        if (!phone.matches("\\d{9,15}")) {
            return "SĐT chỉ gồm số, từ 9-15 ký tự.";
        }
        return null;
    }

    private String escapeJson(String s) {
        return s.replace("\"", "\\\"")
                .replace("\n", "")
                .replace("\r", "");
    }
}
