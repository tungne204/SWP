package control.appointments;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;
import dao.appointments.AppointmentDAO;
import entity.User;
import entity.appointments.Appointment;
import entity.appointments.AppointmentStatus;
import entity.appointments.MedicalReport;
import entity.appointments.TestResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "MedicalAssistantServlet", urlPatterns = {"/medicalassistant/*"})
public class MedicalAssistantServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
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
        String testResult = request.getParameter("testResult");

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
