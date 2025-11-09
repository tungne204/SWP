package control.appointments;

import dao.appointments.AppointmentDAO;
import dao.appointments.DoctorDAO;
import dao.appointments.PatientDAO;
import entity.User;
import entity.appointments.Appointment;
import entity.appointments.AppointmentStatus;
import entity.appointments.MedicalReport;
import entity.appointments.TestResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "AppointmentServlet", urlPatterns = {"/appointments/*"})
public class AppointmentServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("acc");
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String path = request.getPathInfo(); // may be null

        // --- /appointments/new : mở form tạo lịch cho Patient ---
        if ("/new".equals(path) && acc.getRoleId() == 3) {
            var patientProfile = patientDAO.getPatientByUserId(acc.getUserId());
            if (patientProfile == null) {
                Integer pid = patientDAO.createPatientMinimalIfAbsent(acc.getUserId());
                if (pid != null) {
                    patientProfile = patientDAO.getPatientByUserId(acc.getUserId());
                }
            }
            request.setAttribute("patientProfile", patientProfile);
            request.setAttribute("doctors", doctorDAO.getAllDoctors());
            request.setAttribute("pageTitle", "Book New Appointment");
            request.getRequestDispatcher("/views/appointments/create-appointment.jsp")
                   .forward(request, response);
            return;
        }

        if (path != null) {
            String[] parts = path.split("/");
            // /appointments/examine/{id}  (Doctor)
            if (path.startsWith("/examine/") && acc.getRoleId() == 2 && parts.length >= 3) {
                Integer appointmentId = parseIntOrNull(parts[2]);
                if (appointmentId == null) {
                    backWithMsg(request, response, "Invalid appointment id!", "error");
                    return;
                }

                Appointment appt = appointmentDAO.getAppointmentById(appointmentId);
                if (appt == null || !doctorOwnsAppointment(acc, appt)) {
                    backWithMsg(request, response, "Access denied or appointment not found!", "error");
                    return;
                }
                // Cho phép vào form khi đang IN_PROGRESS hoặc WAITING (sau khi test xong)
                if (!AppointmentStatus.IN_PROGRESS.getValue().equals(appt.getStatus()) 
                    && !AppointmentStatus.WAITING.getValue().equals(appt.getStatus())) {
                    backWithMsg(request, response, "Appointment is not IN_PROGRESS or WAITING!", "error");
                    return;
                }
                MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
                // Load test results nếu có medical report
                List<TestResult> testResults = null;
                if (report != null && report.getRecordId() > 0) {
                    testResults = appointmentDAO.getTestResultsByRecordId(report.getRecordId());
                }
                request.setAttribute("appointment", appt);
                request.setAttribute("medicalReport", report);
                request.setAttribute("testResults", testResults);
                request.getRequestDispatcher("/views/doctor/examination-form.jsp")
                       .forward(request, response);
                return;
            }

            // /appointments/test/{id} (Medical Assistant)
            if (path.startsWith("/test/") && acc.getRoleId() == 4 && parts.length >= 3) {
                Integer appointmentId = parseIntOrNull(parts[2]);
                if (appointmentId == null) {
                    backWithMsg(request, response, "Invalid appointment id!", "error");
                    return;
                }

                Appointment appt = appointmentDAO.getAppointmentById(appointmentId);
                if (appt == null || !AppointmentStatus.TESTING.getValue().equals(appt.getStatus())) {
                    backWithMsg(request, response, "Appointment not in TESTING!", "error");
                    return;
                }
                MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
                if (report == null || isBlank(report.getRequestedTestType())) {
                    backWithMsg(request, response, "No test request from doctor!", "error");
                    return;
                }
                List<TestResult> existingTests = appointmentDAO.getTestResultsByRecordId(report.getRecordId());
                request.setAttribute("appointment", appt);
                request.setAttribute("medicalReport", report);
                request.setAttribute("existingTests", existingTests);
                request.setAttribute("requestedTestType", report.getRequestedTestType());
                request.getRequestDispatcher("/views/medicalassistant/test-form.jsp")
                       .forward(request, response);
                return;
            }
        }

        // --- Mặc định: hiển thị danh sách theo role với search, filter và paging ---
        int roleId = acc.getRoleId();
        
        // Lấy các tham số từ request
        String searchKeyword = nvl(request.getParameter("search"));
        String statusFilter = nvl(request.getParameter("statusFilter"));
        String dateFrom = nvl(request.getParameter("dateFrom"));
        String dateTo = nvl(request.getParameter("dateTo"));
        int page = parseIntOrNull(request.getParameter("page")) != null 
                ? parseIntOrNull(request.getParameter("page")) : 1;
        int pageSize = parseIntOrNull(request.getParameter("pageSize")) != null 
                ? parseIntOrNull(request.getParameter("pageSize")) : 10;
        
        // Xác định userId và patientId dựa trên role
        Integer userId = null;
        Integer patientId = null;
        String pageTitle = "";
        
        switch (roleId) {
            case 2: // Doctor - chỉ hiển thị WAITING
                userId = acc.getUserId();
                pageTitle = "Doctor Queue – Waiting Patients";
                // Force status filter = Waiting cho doctor
                if (statusFilter == null || statusFilter.trim().isEmpty() || "all".equals(statusFilter)) {
                    statusFilter = "Waiting";
                }
                break;
            case 3: // Patient
                // Không cần patientId cụ thể, sẽ filter theo user_id trong AppointmentDAO
                // để hiển thị tất cả appointments của user (kể cả các patient mới được tạo)
                userId = acc.getUserId();
                pageTitle = "My Appointments";
                break;
            case 4: // Medical Assistant
                pageTitle = "Lab Queue – Testing Appointments";
                break;
            case 5: // Receptionist - chỉ hiển thị PENDING
                pageTitle = "Reception Desk – Appointments";
                // Force status filter = Pending cho receptionist
                if (statusFilter == null || statusFilter.trim().isEmpty() || "all".equals(statusFilter)) {
                    statusFilter = "Pending";
                }
                break;
            default:
                pageTitle = "Appointments";
        }
        
        // Lấy danh sách appointments với filter và paging
        List<Appointment> appointments = appointmentDAO.getAppointmentsWithFilter(
                roleId, userId, patientId, searchKeyword, statusFilter, dateFrom, dateTo, page, pageSize);
        
        // Đếm tổng số records để tính số trang
        int totalRecords = appointmentDAO.countAppointmentsWithFilter(
                roleId, userId, patientId, searchKeyword, statusFilter, dateFrom, dateTo);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Set attributes
        request.setAttribute("appointments", appointments);
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("roleId", roleId);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/views/appointments/appointment-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("acc");
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String action = nvl(request.getParameter("action"));

        // ================== PATIENT: CREATE (không cần appointmentId) ==================
        if (acc.getRoleId() == 3 && "create".equals(action)) {
            String patientName = nvl(request.getParameter("patientName")).trim();
            String dobStr = nvl(request.getParameter("patientDob"));
            String address = nvl(request.getParameter("patientAddress")).trim();
            String insuranceInfo = nvl(request.getParameter("insuranceInfo"));
            String parentName = nvl(request.getParameter("parentName"));
            String phone = nvl(request.getParameter("patientPhone")).trim();

            if (isBlank(patientName) || isBlank(dobStr) || isBlank(address) || isBlank(phone)) {
                backWithMsg(request, response, "Please provide patient name, date of birth, address and phone!", "error");
                return;
            }

            Date dobDate;
            try {
                dobDate = Date.valueOf(dobStr);
            } catch (IllegalArgumentException ex) {
                backWithMsg(request, response, "Invalid date of birth format!", "error");
                return;
            }

            if (dobDate.after(new Date(System.currentTimeMillis()))) {
                backWithMsg(request, response, "Date of birth must be in the past!", "error");
                return;
            }

            // Tìm hoặc tạo patient mới cho appointment này
            // KHÔNG cập nhật patient profile hiện có để tránh ảnh hưởng đến các appointment khác
            Integer patientId = null;
            try {
                patientId = patientDAO.findOrCreatePatient(
                    patientName, 
                    dobDate, 
                    phone, 
                    address,
                    isBlank(insuranceInfo) ? null : insuranceInfo.trim(),
                    isBlank(parentName) ? null : parentName.trim(),
                    acc.getUserId() // User ID của người đặt appointment
                );
            } catch (Exception ex) {
                ex.printStackTrace();
                backWithMsg(request, response, "Failed to create or find patient record!", "error");
                return;
            }

            if (patientId == null) {
                backWithMsg(request, response, "Failed to create patient record!", "error");
                return;
            }

            Integer doctorId = parseIntOrNull(request.getParameter("doctorId"));
            // Chấp nhận cả name= "date"/"time" hoặc "appointmentDate"/"appointmentTime"
            String dateStr = nvl(request.getParameter("date"));
            if (isBlank(dateStr)) dateStr = nvl(request.getParameter("appointmentDate"));
            String timeStr = nvl(request.getParameter("time"));
            if (isBlank(timeStr)) timeStr = nvl(request.getParameter("appointmentTime"));

            if (doctorId == null || isBlank(dateStr) || isBlank(timeStr)) {
                backWithMsg(request, response, "Please choose doctor, date and time!", "error");
                return;
            }

            java.sql.Timestamp ts;
            try {
                var sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
                sdf.setLenient(false);
                ts = new java.sql.Timestamp(sdf.parse(dateStr + " " + timeStr).getTime());
            } catch (Exception ex) {
                backWithMsg(request, response, "Invalid date/time format!", "error");
                return;
            }

            if (ts.before(new java.util.Date())) {
                backWithMsg(request, response, "Appointment time must be in the future!", "error");
                return;
            }

            if (!appointmentDAO.isDoctorAvailable(doctorId, ts)) {
                backWithMsg(request, response, "Selected doctor is not available at that time!", "error");
                return;
            }

            Appointment a = new Appointment();
            a.setPatientId(patientId);
            a.setDoctorId(doctorId);
            a.setDateTime(ts);
            a.setStatus(AppointmentStatus.PENDING.getValue());

            boolean ok = appointmentDAO.createAppointment(a);
            backWithMsg(request, response, ok ? "Appointment created! Please wait for confirmation."
                                              : "Create failed!", ok ? "success" : "error");
            return;
        }
        // ================== END: PATIENT CREATE ==================

        // Các action còn lại yêu cầu có appointmentId
        Integer appointmentId = parseIntOrNull(request.getParameter("appointmentId"));
        if (isBlank(action) || appointmentId == null) {
            backWithMsg(request, response, "Invalid action or appointment id!", "error");
            return;
        }

        Appointment appt = appointmentDAO.getAppointmentById(appointmentId);
        if (appt == null) {
            backWithMsg(request, response, "Appointment not found!", "error");
            return;
        }

        switch (acc.getRoleId()) {
            // ================== RECEPTIONIST ==================
            case 5:
                if ("confirm".equals(action)) {
                    if (!AppointmentStatus.PENDING.getValue().equals(appt.getStatus())) {
                        backWithMsg(request, response, "Only PENDING can be confirmed!", "error");
                        return;
                    }
                    boolean ok = appointmentDAO.updateAppointmentStatus(appointmentId, AppointmentStatus.CONFIRMED.getValue());
                    backWithMsg(request, response, ok ? "Appointment confirmed!" : "Confirm failed!", ok ? "success" : "error");
                    return;
                }
                if ("checkin".equals(action)) {
                    if (!AppointmentStatus.CONFIRMED.getValue().equals(appt.getStatus())) {
                        backWithMsg(request, response, "Only CONFIRMED can be checked in!", "error");
                        return;
                    }
                    boolean ok = appointmentDAO.updateAppointmentStatus(appointmentId, AppointmentStatus.WAITING.getValue());
                    backWithMsg(request, response, ok ? "Patient checked in!" : "Check-in failed!", ok ? "success" : "error");
                    return;
                }
                break;

            // ================== DOCTOR ==================
            case 2:
                if (!doctorOwnsAppointment(acc, appt)) {
                    backWithMsg(request, response, "Access denied!", "error");
                    return;
                }
                if ("start".equals(action)) {
                    if (!AppointmentStatus.WAITING.getValue().equals(appt.getStatus())) {
                        backWithMsg(request, response, "Only WAITING can be started!", "error");
                        return;
                    }
                    boolean ok = appointmentDAO.updateAppointmentStatus(appointmentId, AppointmentStatus.IN_PROGRESS.getValue());
                    if (ok) {
                        MedicalReport existing = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
                        if (existing == null) {
                            MedicalReport r = new MedicalReport();
                            r.setAppointmentId(appointmentId);
                            r.setTestRequest(false);
                            r.setFinal(false);
                            appointmentDAO.createMedicalReport(r);
                        }
                        response.sendRedirect(request.getContextPath() + "/appointments/examine/" + appointmentId);
                    } else {
                        backWithMsg(request, response, "Failed to start examination!", "error");
                    }
                    return;
                }
                if ("requestTest".equals(action)) {
                    String testType = nvl(request.getParameter("testType"));
                    String diagnosis = nvl(request.getParameter("diagnosis"));
                    if (isBlank(testType)) {
                        backWithMsg(request, response, "Please choose a test type!", "error");
                        return;
                    }
                    if (!AppointmentStatus.IN_PROGRESS.getValue().equals(appt.getStatus())) {
                        backWithMsg(request, response, "Only IN_PROGRESS can request test!", "error");
                        return;
                    }
                    MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
                    if (report != null) {
                        report.setDiagnosis(diagnosis); // diagnosis không bắt buộc khi request test
                        report.setTestRequest(true);
                        report.setRequestedTestType(testType);
                        report.setTestRequestedAt(new Timestamp(System.currentTimeMillis()));
                        appointmentDAO.updateMedicalReport(report);
                    }
                    boolean ok = appointmentDAO.updateAppointmentStatus(appointmentId, AppointmentStatus.TESTING.getValue());
                    backWithMsg(request, response, ok ? "Test request sent!" : "Failed to request test!", ok ? "success" : "error");
                    return;
                }
                if ("complete".equals(action)) {
                    String diagnosis = nvl(request.getParameter("diagnosis"));
                    String prescription = nvl(request.getParameter("prescription"));

                    // Chỉ cho hoàn tất khi đang IN_PROGRESS (hoặc WAITING do business bạn cho phép)
                    if (!(AppointmentStatus.IN_PROGRESS.getValue().equals(appt.getStatus())
                          || AppointmentStatus.WAITING.getValue().equals(appt.getStatus()))) {
                        backWithMsg(request, response, "Invalid status to complete!", "error");
                        return;
                    }

                    // BẮT BUỘC: diagnosis & prescription phải có
                    if (isBlank(diagnosis)) {
                        sessionMessage(request, "Diagnosis is required to complete the examination!", "error");
                        response.sendRedirect(request.getContextPath() + "/appointments/examine/" + appointmentId);
                        return;
                    }
                    if (isBlank(prescription)) {
                        sessionMessage(request, "Prescription is required to complete the examination!", "error");
                        response.sendRedirect(request.getContextPath() + "/appointments/examine/" + appointmentId);
                        return;
                    }

                    MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
                    if (report != null) {
                        report.setDiagnosis(diagnosis);
                        report.setPrescription(prescription);
                        report.setFinal(true);
                        appointmentDAO.updateMedicalReport(report);
                    }
                    boolean ok = appointmentDAO.updateAppointmentStatus(appointmentId, AppointmentStatus.COMPLETED.getValue());
                    backWithMsg(request, response, ok ? "Examination completed!" : "Complete failed!", ok ? "success" : "error");
                    return;
                }
                break;

            // ================== LAB (Medical Assistant) ==================
            case 4:
                if ("submitTest".equals(action)) {
                    if (!AppointmentStatus.TESTING.getValue().equals(appt.getStatus())) {
                        backWithMsg(request, response, "Only TESTING can be submitted!", "error");
                        return;
                    }
                    String testResult = nvl(request.getParameter("testResult"));
                    MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
                    if (report == null || isBlank(report.getRequestedTestType())) {
                        backWithMsg(request, response, "No test request from doctor!", "error");
                        return;
                    }
                    TestResult tr = new TestResult();
                    tr.setRecordId(report.getRecordId());
                    tr.setTestType(report.getRequestedTestType());
                    tr.setResult(testResult);
                    tr.setDate(new java.sql.Date(System.currentTimeMillis()));
                    boolean saved = appointmentDAO.createTestResult(tr);
                    boolean statusUpdated = appointmentDAO.updateAppointmentStatus(appointmentId, AppointmentStatus.WAITING.getValue());
                    backWithMsg(request, response,
                            (saved && statusUpdated) ? "Test submitted. Patient returned to queue."
                                                     : "Failed to submit test!",
                            (saved && statusUpdated) ? "success" : "error");
                    return;
                }
                break;

            // ================== PATIENT (cancel) ==================
            case 3:
                if ("cancel".equals(action)) {
                    var patient = patientDAO.getPatientByUserId(acc.getUserId());
                    if (patient == null || patient.getPatientId() != appt.getPatientId()) {
                        backWithMsg(request, response, "Access denied!", "error");
                        return;
                    }
                    if (!(AppointmentStatus.PENDING.getValue().equals(appt.getStatus())
                          || AppointmentStatus.CONFIRMED.getValue().equals(appt.getStatus()))) {
                        backWithMsg(request, response, "Only PENDING/CONFIRMED can be cancelled!", "error");
                        return;
                    }
                    boolean ok = appointmentDAO.updateAppointmentStatus(appointmentId, AppointmentStatus.CANCELLED.getValue());
                    backWithMsg(request, response, ok ? "Appointment cancelled!" : "Cancel failed!", ok ? "success" : "error");
                    return;
                }
                break;
        }

        backWithMsg(request, response, "Invalid action or permission!", "error");
    }

    // ===== Helpers =====
    private void backWithMsg(HttpServletRequest req, HttpServletResponse res, String msg, String type) throws IOException {
        sessionMessage(req, msg, type);
        res.sendRedirect(req.getContextPath() + "/appointments");
    }

    private boolean doctorOwnsAppointment(User acc, Appointment appt) {
        int doctorId = doctorDAO.getDoctorIdByUserId(acc.getUserId());
        return appt != null && appt.getDoctorId() == doctorId;
    }

    private Integer parseIntOrNull(String s) {
        try { return Integer.valueOf(s); } catch (Exception e) { return null; }
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }

    private String nvl(String s) { return s == null ? "" : s; }

    private void sessionMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("message", message);
        request.getSession().setAttribute("messageType", type);
    }

    @Override
    public String getServletInfo() { return "Unified Appointment Portal"; }
}
