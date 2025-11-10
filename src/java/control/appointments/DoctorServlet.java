package control.appointments;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import dao.appointments.AppointmentDAO;
import entity.User;
import entity.appointments.Appointment;
import entity.appointments.AppointmentStatus;
import entity.appointments.MedicalReport;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DoctorServlet", urlPatterns = {"/doctor"})
public class DoctorServlet extends HttpServlet {

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

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        if (acc.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || "/".equals(pathInfo)) {
            // ⭐ Dùng userId để JOIN ra doctor và lấy danh sách WAITING
            showWaitingAppointmentsByUserId(acc.getUserId(), request, response);
            return;
        }

        if (pathInfo.startsWith("/examine/")) {
            String[] parts = pathInfo.split("/");
            int appointmentId = Integer.parseInt(parts[2]);
            showExaminationForm(appointmentId, request, response);
            return;
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
        if (acc.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");
        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

        switch (action) {
            case "start":
                startExamination(appointmentId, request, response);
                break;
            case "requestTest":
                requestTest(appointmentId, request, response);
                break;
            case "complete":
                completeExamination(appointmentId, request, response);
                break;
            default:
                sessionMessage(request, "Invalid action!", "error");
                response.sendRedirect(request.getContextPath() + "/doctor");
                break;
        }
    }

    // =============== CÁC HÀM HỖ TRỢ ===============
    // Hiển thị danh sách bệnh nhân đang chờ theo userId của bác sĩ
    private void showWaitingAppointmentsByUserId(int userId,
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Appointment> waitingList = appointmentDAO
                .getAppointmentsByDoctorUserIdAndStatus(
                        userId,
                        AppointmentStatus.WAITING.getValue()
                );

        // Log kiểm tra nhanh (tuỳ chọn)
        System.out.printf("Doctor(userId=%d) waiting=%d%n", userId, waitingList.size());

        request.setAttribute("appointments", waitingList);
        request.setAttribute("pageTitle", "Waiting Patients");
        request.getRequestDispatcher("/views/doctor/waiting-appointments.jsp")
                .forward(request, response);
    }

    // Hiển thị form khám bệnh
    private void showExaminationForm(int appointmentId, HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);

        request.setAttribute("appointment", appointment);
        request.setAttribute("medicalReport", report);
        request.getRequestDispatcher("/views/doctor/examination-form.jsp")
                .forward(request, response);
    }

    // Bắt đầu khám
    private void startExamination(int appointmentId, HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        boolean success = appointmentDAO.updateAppointmentStatus(
                appointmentId, AppointmentStatus.IN_PROGRESS.getValue());

        if (success) {
            // Nếu chưa có hồ sơ khám thì tạo mới
            MedicalReport existingReport = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
            if (existingReport == null) {
                MedicalReport newReport = new MedicalReport();
                newReport.setAppointmentId(appointmentId);
                newReport.setTestRequest(false);
                newReport.setFinal(false);
                appointmentDAO.createMedicalReport(newReport);
            }

            response.sendRedirect(request.getContextPath() + "/doctor/examine/" + appointmentId);
        } else {
            sessionMessage(request, "Failed to start examination!", "error");
            response.sendRedirect(request.getContextPath() + "/doctor");
        }
    }

    // Yêu cầu xét nghiệm
    private void requestTest(int appointmentId, HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String testType = request.getParameter("testType");
        if (testType == null || testType.isBlank()) {
            sessionMessage(request, "Please choose a test type.", "error");
            response.sendRedirect(request.getContextPath() + "/doctor/examine/" + appointmentId);
            return;
        }
        // bác sĩ đã chọn ở form của bác sĩ
        String diagnosis = request.getParameter("diagnosis");

        MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
        if (report != null) {
            report.setDiagnosis(diagnosis);
            report.setTestRequest(true);
            report.setRequestedTestType(testType);                         // NEW: lưu loại xét nghiệm
            report.setTestRequestedAt(new java.sql.Timestamp(System.currentTimeMillis()));  // optional
            // nếu lấy được doctorId từ session:
            // report.setRequestedByDoctorId( doctorDAO.getDoctorIdByUserId(acc.getUserId()) );

            appointmentDAO.updateMedicalReport(report);
        }

        boolean success = appointmentDAO.updateAppointmentStatus(
                appointmentId, AppointmentStatus.TESTING.getValue());

        if (success) {
            sessionMessage(request, "Test request sent successfully!", "success");
        } else {
            sessionMessage(request, "Failed to send test request!", "error");
        }

        response.sendRedirect(request.getContextPath() + "/doctor");
    }

    // Hoàn thành khám bệnh
    private void completeExamination(int appointmentId, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {

        String diagnosis = request.getParameter("diagnosis");
        String prescription = request.getParameter("prescription");

        // Bắt buộc có diagnosis & prescription khi hoàn tất
        if (diagnosis == null || diagnosis.trim().isEmpty()) {
            sessionMessage(request, "Diagnosis is required to complete the examination!", "error");
            response.sendRedirect(request.getContextPath() + "/doctor/examine/" + appointmentId);
            return;
        }
        if (prescription == null || prescription.trim().isEmpty()) {
            sessionMessage(request, "Prescription is required to complete the examination!", "error");
            response.sendRedirect(request.getContextPath() + "/doctor/examine/" + appointmentId);
            return;
        }

        MedicalReport report = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
        if (report != null) {
            report.setDiagnosis(diagnosis);
            report.setPrescription(prescription);
            report.setFinal(true);
            appointmentDAO.updateMedicalReport(report);
        }

        boolean success = appointmentDAO.updateAppointmentStatus(
                appointmentId, AppointmentStatus.COMPLETED.getValue());

        if (success) {
            // Lưu thời gian hoàn thành khám vào session
            request.getSession().setAttribute("examinationCompletedTime", new java.util.Date());
            sessionMessage(request, "Examination completed successfully! Redirecting to medical record...", "success");
            // Chuyển đến trang in hồ sơ bệnh án
            response.sendRedirect(request.getContextPath() + "/appointments/medical-record/" + appointmentId);
        } else {
            sessionMessage(request, "Failed to complete examination!", "error");
            response.sendRedirect(request.getContextPath() + "/doctor");
        }
    }

    // Hiển thị thông báo session
    private void sessionMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("message", message);
        request.getSession().setAttribute("messageType", type);
    }

    @Override
    public String getServletInfo() {
        return "DoctorServlet integrated with LoginControl session (acc)";
    }
}
