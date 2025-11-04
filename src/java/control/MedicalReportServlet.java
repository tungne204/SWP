package control;

import dao.MedicalReportDAO;
import entity.MedicalReport;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "MedicalReportServlet", urlPatterns = {"/medical-report"})
public class MedicalReportServlet extends HttpServlet {

    private MedicalReportDAO dao;

    @Override
    public void init() throws ServletException { dao = new MedicalReportDAO(); }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html><html><head><title>MedicalReportServlet</title></head>");
            out.println("<body><h1>MedicalReportServlet at " + request.getContextPath() + "</h1></body></html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":   listReports(request, response); break;
            case "add": {
                User acc = (User) request.getSession().getAttribute("acc");
                if (acc == null || acc.getRoleId() != 2) { response.sendRedirect("403.jsp"); return; }
                showAddForm(request, response); break;
            }
            case "edit":   showEditForm(request, response); break;
            case "delete": deleteReport(request, response); break;
            case "view":   viewReport(request, response); break;
            default:       listReports(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "insert": insertReport(request, response); break;
            case "update": updateReport(request, response); break;
            default:       listReports(request, response);
        }
    }

    @Override
    public String getServletInfo() { return "MedicalReport CRUD + Draft/Finalize"; }

    private Integer getDoctorIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        User acc = (User) session.getAttribute("acc");
        if (acc == null) return null;
        try {
            int doctorId = dao.getDoctorIdByUserId(acc.getUserId());
            return doctorId > 0 ? doctorId : null;
        } catch (Exception e) {
            Logger.getLogger(MedicalReportServlet.class.getName()).log(Level.SEVERE, "Map user->doctor failed", e);
            return null;
        }
    }

    private void listReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) { response.sendRedirect("Login.jsp"); return; }
            User acc = (User) session.getAttribute("acc");
            if (acc == null) { response.sendRedirect("Login.jsp"); return; }

            int roleId = acc.getRoleId();
            String keyword = request.getParameter("keyword");
            String filterType = request.getParameter("filterType");
            if (filterType == null) filterType = "all";

            int page = 1, pageSize = 10;
            try { if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page")); }
            catch (NumberFormatException ignore) {}
            int offset = (page - 1) * pageSize;

            List<MedicalReport> reports;
            int total;

            if (roleId == 2) { // Doctor
                Integer doctorId = getDoctorIdFromSession(request);
                reports = dao.searchAndFilter(doctorId, keyword, filterType, offset, pageSize);
                total = dao.countFilteredReports(doctorId, keyword, filterType);

                request.setAttribute("reports", reports);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", (int) Math.ceil((double) total / pageSize));
                request.setAttribute("keyword", keyword);
                request.setAttribute("filterType", filterType);
                request.getRequestDispatcher("doctor/medical-report-list.jsp").forward(request, response);

            } else if (roleId == 3) { // Patient
                int patientId = dao.getPatientIdByUserId(acc.getUserId());
                reports = dao.searchAndFilterByPatient(patientId, keyword, filterType, offset, pageSize);
                total = dao.countFilteredReportsByPatient(patientId, keyword, filterType);

                request.setAttribute("reports", reports);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", (int) Math.ceil((double) total / pageSize));
                request.setAttribute("keyword", keyword);
                request.setAttribute("filterType", filterType);
                // Nếu có trang riêng cho patient:
                // request.getRequestDispatcher("patient/medical-report-list.jsp").forward(request, response);
                request.getRequestDispatcher("doctor/medical-report-list.jsp").forward(request, response); // tạm dùng chung
            } else {
                response.sendRedirect("403.jsp");
            }
        } catch (Exception ex) {
            Logger.getLogger(MedicalReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Integer doctorId = getDoctorIdFromSession(request);
            if (doctorId == null) { response.sendRedirect("Login.jsp"); return; }
            List<MedicalReportDAO.Appointment> appointments = dao.getAppointmentsWithoutReport(doctorId);
            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("doctor/medical-report-form.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(MedicalReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));
            MedicalReport report = dao.getById(recordId);
            boolean hasTestResults = dao.hasTestResults(recordId);

            request.setAttribute("report", report);
            request.setAttribute("hasTestResults", hasTestResults);
            request.getRequestDispatcher("doctor/medical-report-form.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(MedicalReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void insertReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String diagnosis = request.getParameter("diagnosis");
            String prescription = request.getParameter("prescription");
            boolean testRequest = request.getParameter("testRequest") != null;

            MedicalReport r = new MedicalReport();
            r.setAppointmentId(appointmentId);
            r.setDiagnosis(diagnosis);
            r.setPrescription((prescription == null || prescription.isBlank()) ? null : prescription);
            r.setTestRequest(testRequest);
            r.setFinal(false); // luôn Draft

            boolean ok = dao.insert(r);

            request.getSession().setAttribute("message", ok
                    ? "Đã tạo báo cáo khám (Draft). Hãy gửi/đợi kết quả xét nghiệm."
                    : "Lỗi khi tạo báo cáo khám!");
            request.getSession().setAttribute("messageType", ok ? "success" : "error");
            response.sendRedirect("medical-report?action=list");
        } catch (Exception ex) {
            Logger.getLogger(MedicalReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void updateReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("recordId"));
            String diagnosis = request.getParameter("diagnosis");
            String prescription = request.getParameter("prescription");
            boolean testRequest = request.getParameter("testRequest") != null;
            boolean finalizeFlag = request.getParameter("finalize") != null;

            // Nếu finalize mà chưa có prescription -> từ chối
            if (finalizeFlag && (prescription == null || prescription.isBlank())) {
                request.getSession().setAttribute("message", "Không thể chốt: cần nhập đơn thuốc.");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("medical-report?action=edit&id=" + recordId);
                return;
            }

            MedicalReport r = new MedicalReport();
            r.setRecordId(recordId);
            r.setDiagnosis(diagnosis);
            r.setPrescription((prescription == null || prescription.isBlank()) ? null : prescription);
            r.setTestRequest(testRequest);
            r.setFinal(finalizeFlag);

            boolean ok = dao.update(r);

            if (ok) {
                request.getSession().setAttribute("message", finalizeFlag ? "Đã chốt đơn thuốc (Final)." : "Đã lưu bản nháp.");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message",
                        finalizeFlag ? "Không thể chốt: chưa có kết quả xét nghiệm." : "Lỗi khi cập nhật báo cáo.");
                request.getSession().setAttribute("messageType", "error");
            }
            response.sendRedirect("medical-report?action=list");
        } catch (Exception ex) {
            Logger.getLogger(MedicalReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void deleteReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));
            boolean ok = dao.delete(recordId);
            request.getSession().setAttribute("message", ok ? "Xóa báo cáo thành công!" : "Lỗi khi xóa báo cáo!");
            request.getSession().setAttribute("messageType", ok ? "success" : "error");
            response.sendRedirect("medical-report?action=list");
        } catch (Exception ex) {
            Logger.getLogger(MedicalReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void viewReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));
            MedicalReport report = dao.getById(recordId);

            dao.testResult.TestResultDAO trDAO = new dao.testResult.TestResultDAO();
            java.util.List<entity.testResult.TestResult> testResults = trDAO.findByRecordId(recordId);

            request.setAttribute("report", report);
            request.setAttribute("testResults", testResults);
            request.getRequestDispatcher("doctor/medical-report-view.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(MedicalReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
