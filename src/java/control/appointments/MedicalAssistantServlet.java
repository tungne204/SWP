package control.appointments;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.List;
import java.util.UUID;
import dao.appointments.AppointmentDAO;
import entity.User;
import entity.appointments.Appointment;
import entity.appointments.AppointmentStatus;
import entity.appointments.MedicalReport;
import entity.appointments.TestResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "MedicalAssistantServlet", urlPatterns = {"/medicalassistant/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 20     // 20MB
)
public class MedicalAssistantServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
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

        // ✅ Kiểm tra đăng nhập
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        // ✅ Chỉ cho phép vai trò Medical Assistant (roleId = 4)
        if (acc.getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showTestingAppointments(request, response);
        } else if (pathInfo.startsWith("/test/")) {
            String[] parts = pathInfo.split("/");
            int appointmentId = Integer.parseInt(parts[2]);
            showTestForm(appointmentId, request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/medicalassistant");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("acc");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        if (acc.getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("submitTest".equals(action)) {
            submitTestResult(request, response);
        } else {
            sessionMessage(request, "Invalid action!", "error");
            response.sendRedirect(request.getContextPath() + "/medicalassistant");
        }
    }

    // =============== CÁC HÀM NGHIỆP VỤ ===============
    // Hiển thị danh sách appointments đang xét nghiệm
    private void showTestingAppointments(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Appointment> testingList = appointmentDAO.getAppointmentsByStatus(
                AppointmentStatus.TESTING.getValue());

        request.setAttribute("appointments", testingList);
        request.setAttribute("pageTitle", "Appointments for Testing");
        request.getRequestDispatcher("/views/medicalassistant/testing-appointments.jsp")
                .forward(request, response);
    }

    // Hiển thị form nhập kết quả xét nghiệm
    private void showTestForm(int appointmentId, HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);

        List<TestResult> existingTests = null;
        if (report != null) {
            existingTests = appointmentDAO.getTestResultsByRecordId(report.getRecordId());
        }

        request.setAttribute("appointment", appointment);
        request.setAttribute("medicalReport", report);
        request.setAttribute("existingTests", existingTests);
        request.setAttribute("requestedTestType", report != null ? report.getRequestedTestType() : null);
        request.getRequestDispatcher("/views/medicalassistant/test-form.jsp")
                .forward(request, response);
    }

    // Nộp kết quả xét nghiệm
    private void submitTestResult(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        String testResult = null;
        String imagePath = null;
        
        try {
            // Check if request is multipart
            if (request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/form-data")) {
                // Get text result from multipart
                testResult = request.getParameter("testResult");
                
                // Handle file upload
                Part filePart = request.getPart("testImage");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = filePart.getSubmittedFileName();
                    if (fileName != null && !fileName.isEmpty()) {
                        // Validate file type
                        String contentType = filePart.getContentType();
                        if (contentType == null || !contentType.startsWith("image/")) {
                            sessionMessage(request, "Vui lòng chọn file ảnh!", "error");
                            response.sendRedirect(request.getContextPath() + "/medicalassistant");
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
                testResult = request.getParameter("testResult");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sessionMessage(request, "Lỗi khi upload ảnh: " + e.getMessage(), "error");
            response.sendRedirect(request.getContextPath() + "/medicalassistant");
            return;
        }

        // Validate test result length (max 255 characters for nvarchar(255))
        if (testResult != null && testResult.length() > 255) {
            sessionMessage(request, "Kết quả xét nghiệm quá dài! Tối đa 255 ký tự. Hiện tại: " + testResult.length() + " ký tự.", "error");
            response.sendRedirect(request.getContextPath() + "/medicalassistant");
            return;
        }

        MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
        if (report == null) {
            sessionMessage(request, "Medical report not found!", "error");
            response.sendRedirect(request.getContextPath() + "/medicalassistant");
            return;
        }
        String testType = report.getRequestedTestType();   // <-- dùng loại bác sĩ đã yêu cầu
        if (testType == null || testType.isBlank()) {
            sessionMessage(request, "No requested test type from doctor!", "error");
            response.sendRedirect(request.getContextPath() + "/medicalassistant");
            return;
        }

        TestResult test = new TestResult();
        test.setRecordId(report.getRecordId());
        test.setTestType(testType);                    // <-- chốt bằng loại đã yêu cầu
        test.setResult(testResult);
        test.setDate(new java.sql.Date(System.currentTimeMillis()));
        test.setImagePath(imagePath);                  // <-- set image path

        boolean testSaved = appointmentDAO.createTestResult(test);
        boolean statusUpdated = appointmentDAO.updateAppointmentStatus(
                appointmentId, AppointmentStatus.WAITING.getValue());

        if (testSaved && statusUpdated) {
            sessionMessage(request, "Test result submitted successfully! Patient moved to waiting queue.", "success");
        } else {
            sessionMessage(request, "Failed to submit test result!", "error");
        }
        response.sendRedirect(request.getContextPath() + "/medicalassistant");

    }

    // =============== TIỆN ÍCH ===============
    private void sessionMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("message", message);
        request.getSession().setAttribute("messageType", type);
    }

    @Override
    public String getServletInfo() {
        return "MedicalAssistantServlet integrated with LoginControl session (acc)";
    }
}
