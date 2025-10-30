/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control;

import dao.MedicalReportDAO;
import entity.MedicalReport;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Quang Anh
 */
@WebServlet(name = "MedicalReportServlet", urlPatterns = {"/medical-report"})
public class MedicalReportServlet extends HttpServlet {

    private MedicalReportDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new MedicalReportDAO();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MedicalReportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MedicalReportServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listReports(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteReport(request, response);
                break;
            case "view":
                viewReport(request, response);
                break;
            default:
                listReports(request, response);
                break;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertReport(request, response);
                break;
            case "update":
                updateReport(request, response);
                break;
            default:
                listReports(request, response);
                break;
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private Integer getDoctorIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        User acc = (User) session.getAttribute("acc");
        if (acc == null) {
            return null;
        }

        int userId = acc.getUserId();
        try {
            int doctorId = dao.getDoctorIdByUserId(userId);
            return (doctorId > 0) ? doctorId : null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private void listReports(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        User acc = (User) session.getAttribute("acc");
        if (acc == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int roleId = acc.getRoleId();

        // --- Lấy tham số tìm kiếm & lọc ---
        String keyword = request.getParameter("keyword");
        String filterType = request.getParameter("filterType");
        if (filterType == null) filterType = "all";

        // --- Phân trang ---
        int page = 1, pageSize = 10;
        try {
            if (request.getParameter("page") != null)
                page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * pageSize;

        List<MedicalReport> reports;
        int totalReports;

        if (roleId == 2) { // 👨‍⚕️ Doctor
            Integer doctorId = getDoctorIdFromSession(request);
            reports = dao.searchAndFilter(doctorId, keyword, filterType, offset, pageSize);
            totalReports = dao.countFilteredReports(doctorId, keyword, filterType);

            // ✅ Forward đến trang bác sĩ
            request.setAttribute("reports", reports);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalReports / pageSize));
            request.setAttribute("keyword", keyword);
            request.setAttribute("filterType", filterType);
            request.getRequestDispatcher("doctor/medical-report-list.jsp").forward(request, response);

        } else if (roleId == 3) { // 🧑‍🦰 Patient
            int patientId = dao.getPatientIdByUserId(acc.getUserId());
            reports = dao.searchAndFilterByPatient(patientId, keyword, filterType, offset, pageSize);
            totalReports = dao.countFilteredReportsByPatient(patientId, keyword, filterType);

            // ✅ Forward đến trang dành cho bệnh nhân
            request.setAttribute("reports", reports);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalReports / pageSize));
            request.setAttribute("keyword", keyword);
            request.setAttribute("filterType", filterType);
            request.getRequestDispatcher("doctor/medical-report-list.jsp").forward(request, response);

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
            if (doctorId == null) {
                response.sendRedirect("Login.jsp");
                return;
            }

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
            request.setAttribute("report", report);
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

            MedicalReport report = new MedicalReport();
            report.setAppointmentId(appointmentId);
            report.setDiagnosis(diagnosis);
            report.setPrescription(prescription);
            report.setTestRequest(testRequest);

            boolean success = dao.insert(report);

            if (success) {
                request.getSession().setAttribute("message", "Thêm đơn thuốc thành công!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Lỗi khi thêm đơn thuốc!");
                request.getSession().setAttribute("messageType", "error");
            }

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

            MedicalReport report = new MedicalReport();
            report.setRecordId(recordId);
            report.setDiagnosis(diagnosis);
            report.setPrescription(prescription);
            report.setTestRequest(testRequest);

            boolean success = dao.update(report);

            if (success) {
                request.getSession().setAttribute("message", "Cập nhật đơn thuốc thành công!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Lỗi khi cập nhật đơn thuốc!");
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
            boolean success = dao.delete(recordId);

            if (success) {
                request.getSession().setAttribute("message", "Xóa đơn thuốc thành công!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Lỗi khi xóa đơn thuốc!");
                request.getSession().setAttribute("messageType", "error");
            }

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
            request.setAttribute("report", report);
            request.getRequestDispatcher("doctor/medical-report-view.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(MedicalReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
