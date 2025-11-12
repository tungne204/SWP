package control.appointments;

import dao.appointments.AppointmentDAO;
import dao.appointments.DoctorDAO;
import dao.appointments.PatientDAO;
import entity.User;
import entity.appointments.Appointment;
import entity.appointments.AppointmentStatus;
import entity.appointments.Doctor;
import entity.appointments.MedicalReport;
import entity.appointments.Patient;
import entity.appointments.TestResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;
import java.util.UUID;

@WebServlet(name = "AppointmentServlet", urlPatterns = {"/appointments/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 20     // 20MB
)
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
    
    private File findProjectRoot() {
        // Strategy 1: Try to find from webapp root
        try {
            String webappRoot = getServletContext().getRealPath("/");
            File current = new File(webappRoot);
            
            // Go up directories looking for build.xml or nbproject
            for (int i = 0; i < 5 && current != null; i++) {
                File buildXml = new File(current, "build.xml");
                File nbproject = new File(current, "nbproject");
                if (buildXml.exists() || nbproject.exists()) {
                    return current;
                }
                current = current.getParentFile();
            }
        } catch (Exception e) {
            // Continue to next strategy
        }
        
        // Strategy 2: Use user.dir (working directory)
        try {
            String userDir = System.getProperty("user.dir");
            if (userDir != null) {
                File dir = new File(userDir);
                File buildXml = new File(dir, "build.xml");
                File nbproject = new File(dir, "nbproject");
                if (buildXml.exists() || nbproject.exists()) {
                    return dir;
                }
            }
        } catch (Exception e) {
            // Continue to next strategy
        }
        
        // Strategy 3: Fallback - go up from webapp root (2 levels typical)
        try {
            String webappRoot = getServletContext().getRealPath("/");
            File webappDir = new File(webappRoot);
            File projectRoot = webappDir.getParentFile();
            if (projectRoot != null) {
                projectRoot = projectRoot.getParentFile();
                if (projectRoot != null) {
                    return projectRoot;
                }
            }
        } catch (Exception e) {
            // Ignore
        }
        
        // Final fallback: return webapp root
        try {
            String webappRoot = getServletContext().getRealPath("/");
            return new File(webappRoot);
        } catch (Exception e) {
            return new File(".");
        }
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
            
            // /appointments/detail/{id}  (View detail - Patient, Doctor, Receptionist, Medical Assistant)
            if (path.startsWith("/detail/") && parts.length >= 3) {
                Integer appointmentId = parseIntOrNull(parts[2]);
                if (appointmentId == null) {
                    backWithMsg(request, response, "Invalid appointment id!", "error");
                    return;
                }
                
                Appointment appt = appointmentDAO.getAppointmentById(appointmentId);
                if (appt == null) {
                    backWithMsg(request, response, "Appointment not found!", "error");
                    return;
                }
                
                // Kiểm tra quyền truy cập
                boolean hasAccess = false;
                switch (acc.getRoleId()) {
                    case 2: // Doctor - chỉ xem được appointment của mình
                        hasAccess = doctorOwnsAppointment(acc, appt);
                        break;
                    case 3: // Patient - chỉ xem được appointment của mình
                        // Kiểm tra trực tiếp trong database vì patient có thể được tạo mới
                        // mà không có user_id liên kết, hoặc tìm thấy patient đã tồn tại
                        hasAccess = appointmentDAO.isAppointmentOwnedByUser(appointmentId, acc.getUserId());
                        break;
                    case 4: // Medical Assistant - xem được tất cả
                    case 5: // Receptionist - xem được tất cả
                    case 1: // Admin - xem được tất cả
                        hasAccess = true;
                        break;
                }
                
                if (!hasAccess) {
                    backWithMsg(request, response, "Access denied!", "error");
                    return;
                }
                
                // Load doctor info
                Doctor doctor = doctorDAO.getDoctorById(appt.getDoctorId());
                
                // Load medical report nếu có
                MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
                List<TestResult> testResults = null;
                if (report != null && report.getRecordId() > 0) {
                    testResults = appointmentDAO.getTestResultsByRecordId(report.getRecordId());
                }
                
                request.setAttribute("appointment", appt);
                request.setAttribute("doctor", doctor);
                request.setAttribute("medicalReport", report);
                request.setAttribute("testResults", testResults);
                request.setAttribute("pageTitle", "Appointment Details");
                request.getRequestDispatcher("/views/patient/appointment-detail.jsp")
                       .forward(request, response);
                return;
            }
            
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
                // Load patient information để hiển thị tên bệnh nhân
                Patient patient = patientDAO.getPatientWithUserInfo(appt.getPatientId());
                
                // Load lịch sử khám bệnh và xét nghiệm của bệnh nhân
                List<MedicalReport> medicalHistory = appointmentDAO.getMedicalHistoryByPatientId(appt.getPatientId(), appointmentId);
                List<TestResult> testHistory = appointmentDAO.getTestHistoryByPatientId(appt.getPatientId(), appointmentId);
                
                request.setAttribute("appointment", appt);
                request.setAttribute("patient", patient);
                request.setAttribute("medicalReport", report);
                request.setAttribute("testResults", testResults);
                request.setAttribute("medicalHistory", medicalHistory);
                request.setAttribute("testHistory", testHistory);
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
            
            // /appointments/medical-record/{id} (Print medical record - Doctor only, completed appointments)
            if (path.startsWith("/medical-record/") && parts.length >= 3) {
                try {
                    Integer appointmentId = parseIntOrNull(parts[2]);
                    if (appointmentId == null) {
                        backWithMsg(request, response, "Invalid appointment id!", "error");
                        return;
                    }
                    
                    Appointment appt = appointmentDAO.getAppointmentById(appointmentId);
                    if (appt == null) {
                        backWithMsg(request, response, "Appointment not found!", "error");
                        return;
                    }
                    
                    // Kiểm tra quyền truy cập - chỉ Doctor được in hồ sơ bệnh án
                    if (acc.getRoleId() != 2 || !doctorOwnsAppointment(acc, appt)) {
                        backWithMsg(request, response, "Access denied! Only the attending doctor can view medical records.", "error");
                        return;
                    }
                    
                    // Load medical report
                    MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
                    if (report == null) {
                        backWithMsg(request, response, "No medical report found for this appointment!", "error");
                        return;
                    }
                    
                    // Load test results nếu có
                    List<TestResult> testResults = null;
                    if (report.getRecordId() > 0) {
                        testResults = appointmentDAO.getTestResultsByRecordId(report.getRecordId());
                    }
                    
                    // Load patient information
                    Patient patient = patientDAO.getPatientWithUserInfo(appt.getPatientId());
                    if (patient == null) {
                        backWithMsg(request, response, "Patient information not found!", "error");
                        return;
                    }
                    
                    // Load doctor information
                    Doctor doctor = doctorDAO.getDoctorById(appt.getDoctorId());
                    if (doctor == null) {
                        backWithMsg(request, response, "Doctor information not found!", "error");
                        return;
                    }
                    
                    request.setAttribute("appointment", appt);
                    request.setAttribute("patient", patient);
                    request.setAttribute("doctor", doctor);
                    request.setAttribute("medicalReport", report);
                    request.setAttribute("testResults", testResults);
                    request.getRequestDispatcher("/views/appointments/medical-record.jsp")
                           .forward(request, response);
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    backWithMsg(request, response, "Error loading medical record: " + e.getMessage(), "error");
                    return;
                }
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
            case 5: // Receptionist - mặc định hiển thị PENDING, nhưng có thể chọn các status khác
                pageTitle = "Reception Desk – Appointments";
                // Set mặc định status filter = Pending cho receptionist (chỉ khi không có filter)
                if (statusFilter == null || statusFilter.trim().isEmpty()) {
                    statusFilter = "Pending";
                }
                // Cho phép "all" và các status khác
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
                forwardToFormWithError(request, response, "Vui lòng cung cấp đầy đủ thông tin bệnh nhân (tên, ngày sinh, địa chỉ và số điện thoại)!");
                return;
            }

            Date dobDate;
            try {
                dobDate = Date.valueOf(dobStr);
            } catch (IllegalArgumentException ex) {
                forwardToFormWithError(request, response, "Định dạng ngày sinh không hợp lệ!");
                return;
            }

            if (dobDate.after(new Date(System.currentTimeMillis()))) {
                forwardToFormWithError(request, response, "Ngày sinh phải là ngày trong quá khứ!");
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
                forwardToFormWithError(request, response, "Có lỗi xảy ra khi tạo hồ sơ bệnh nhân!");
                return;
            }

            if (patientId == null) {
                forwardToFormWithError(request, response, "Không thể tạo hồ sơ bệnh nhân!");
                return;
            }

            Integer doctorId = parseIntOrNull(request.getParameter("doctorId"));
            // Chấp nhận cả name= "date"/"time" hoặc "appointmentDate"/"appointmentTime"
            String dateStr = nvl(request.getParameter("date"));
            if (isBlank(dateStr)) dateStr = nvl(request.getParameter("appointmentDate"));
            String timeStr = nvl(request.getParameter("time"));
            if (isBlank(timeStr)) timeStr = nvl(request.getParameter("appointmentTime"));

            if (doctorId == null || isBlank(dateStr) || isBlank(timeStr)) {
                forwardToFormWithError(request, response, "Vui lòng chọn bác sĩ, ngày và giờ khám!");
                return;
            }

            java.sql.Timestamp ts;
            try {
                var sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
                sdf.setLenient(false);
                ts = new java.sql.Timestamp(sdf.parse(dateStr + " " + timeStr).getTime());
            } catch (Exception ex) {
                forwardToFormWithError(request, response, "Định dạng ngày/giờ không hợp lệ!");
                return;
            }

            if (ts.before(new java.util.Date())) {
                forwardToFormWithError(request, response, "Ngày và giờ khám phải trong tương lai!");
                return;
            }

            if (!appointmentDAO.isDoctorAvailable(doctorId, ts)) {
                forwardToFormWithError(request, response, "Bác sĩ đã có lịch hẹn vào thời gian này! Vui lòng chọn thời gian khác.");
                return;
            }

            String symptoms = nvl(request.getParameter("symptoms")).trim();
            
            // Validate symptoms length (max 400 characters)
            if (symptoms != null && symptoms.length() > 400) {
                forwardToFormWithError(request, response, "Triệu chứng quá dài! Tối đa 400 ký tự. Hiện tại: " + symptoms.length() + " ký tự.");
                return;
            }
            
            Appointment a = new Appointment();
            a.setPatientId(patientId);
            a.setDoctorId(doctorId);
            a.setDateTime(ts);
            a.setStatus(AppointmentStatus.PENDING.getValue());
            a.setSymptoms(isBlank(symptoms) ? null : symptoms);

            boolean ok = appointmentDAO.createAppointment(a);
            backWithMsg(request, response, ok ? "Đặt lịch hẹn thành công! Vui lòng chờ xác nhận từ lễ tân."
                                              : "Đặt lịch hẹn thất bại!", ok ? "success" : "error");
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
                    
                    // Kiểm tra số lượng bệnh nhân đang chờ của bác sĩ
                    int doctorId = appt.getDoctorId();
                    int waitingCount = appointmentDAO.countWaitingPatientsByDoctorId(doctorId);
                    if (waitingCount >= 10) {
                        backWithMsg(request, response, "Khong the check-in! Bac si da co " + waitingCount + " benh nhan dang cho (toi da 10 nguoi).", "error");
                        return;
                    }
                    
                    boolean ok = appointmentDAO.updateAppointmentStatus(appointmentId, AppointmentStatus.WAITING.getValue());
                    // Redirect về trang appointments với statusFilter=Confirmed để tiếp tục xem danh sách Confirmed
                    sessionMessage(request, ok ? "Patient checked in!" : "Check-in failed!", ok ? "success" : "error");
                    response.sendRedirect(request.getContextPath() + "/appointments?statusFilter=Confirmed");
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
                    
                    if (ok) {
                        // Lưu thời gian hoàn thành khám vào session
                        request.getSession().setAttribute("examinationCompletedTime", new java.util.Date());
                        sessionMessage(request, "Hoàn tất khám bệnh thành công! Hồ sơ bệnh án đã được tạo.", "success");
                        // Chuyển đến trang in hồ sơ bệnh án
                        response.sendRedirect(request.getContextPath() + "/appointments/medical-record/" + appointmentId);
                    } else {
                        backWithMsg(request, response, "Hoàn tất khám thất bại!", "error");
                    }
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
                    
                    // Handle multipart request for file upload
                    String testResult = null;
                    String imagePath = null;
                    
                    try {
                        // Check if request is multipart
                        if (request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/form-data")) {
                            // Get text result from multipart
                            testResult = nvl(request.getParameter("testResult"));
                            
                            // Handle file upload
                            Part filePart = request.getPart("testImage");
                            if (filePart != null && filePart.getSize() > 0) {
                                String fileName = filePart.getSubmittedFileName();
                                if (fileName != null && !fileName.isEmpty()) {
                                    // Validate file type
                                    String contentType = filePart.getContentType();
                                    if (contentType == null || !contentType.startsWith("image/")) {
                                        backWithMsg(request, response, "Vui lòng chọn file ảnh!", "error");
                                        return;
                                    }
                                    
                                    // Get file extension
                                    String fileExtension = "";
                                    if (fileName.contains(".")) {
                                        fileExtension = fileName.substring(fileName.lastIndexOf("."));
                                    }
                                    
                                    // Generate unique filename
                                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                                    
                                    // Find project root
                                    File projectRoot = findProjectRoot();
                                    
                                    // Use source folder path (will be copied to build during build process)
                                    String sourcePath = projectRoot.getAbsolutePath() + File.separator + "web" + File.separator + "uploads" + File.separator + "test-results" + File.separator;
                                    File sourceDir = new File(sourcePath);
                                    if (!sourceDir.exists()) {
                                        sourceDir.mkdirs();
                                    }
                                    
                                    // Also save to webapp directory for immediate access
                                    String webappRoot = getServletContext().getRealPath("/");
                                    String webappPath = webappRoot + "uploads" + File.separator + "test-results" + File.separator;
                                    File webappDir = new File(webappPath);
                                    if (!webappDir.exists()) {
                                        webappDir.mkdirs();
                                    }
                                    
                                    // Save file to source folder first (persistent - won't be deleted on clean)
                                    String sourceFilePath = sourcePath + uniqueFileName;
                                    filePart.write(sourceFilePath);
                                    
                                    // Also copy to webapp directory for immediate use
                                    try {
                                        String webappFilePath = webappPath + uniqueFileName;
                                        Files.copy(Paths.get(sourceFilePath), Paths.get(webappFilePath), 
                                                  java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                                    } catch (Exception e) {
                                        // If copy fails, webapp will use file from source during next build
                                        System.out.println("Note: Could not copy to webapp directory: " + e.getMessage());
                                    }
                                    
                                    // Store relative path for database
                                    imagePath = "uploads/test-results/" + uniqueFileName;
                                }
                            }
                        } else {
                            // Regular form submission (no file)
                            testResult = nvl(request.getParameter("testResult"));
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        backWithMsg(request, response, "Lỗi khi upload ảnh: " + e.getMessage(), "error");
                        return;
                    }
                    
                    // Validate test result length (max 255 characters for nvarchar(255))
                    if (testResult != null && testResult.length() > 255) {
                        backWithMsg(request, response, "Kết quả xét nghiệm quá dài! Tối đa 255 ký tự. Hiện tại: " + testResult.length() + " ký tự.", "error");
                        return;
                    }
                    
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
                    tr.setImagePath(imagePath);
                    boolean saved = appointmentDAO.createTestResult(tr);
                    boolean statusUpdated = appointmentDAO.updateAppointmentStatusFromTestingToWaiting(appointmentId);
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
    
    private void forwardToFormWithError(HttpServletRequest req, HttpServletResponse res, String msg) throws ServletException, IOException {
        // Preserve form data
        req.setAttribute("formData", req.getParameterMap());
        req.setAttribute("errorMessage", msg);
        
        // Load doctors list for form
        req.setAttribute("doctors", doctorDAO.getAllDoctors());
        req.setAttribute("pageTitle", "Book New Appointment");
        
        // Forward to create form
        req.getRequestDispatcher("/views/appointments/create-appointment.jsp").forward(req, res);
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
