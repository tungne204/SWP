/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package control.testResult;

import dao.testResult.TestResultDAO;
import entity.testResult.TestResult;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.util.List;

/**
 *
 * @author Quang Anh
 */
@WebServlet(name="TestResultServlet1", urlPatterns={"/testresult"})
public class TestResultServlet extends HttpServlet {
    private TestResultDAO testResultDAO = new TestResultDAO();
    private static final int PAGE_SIZE = 10;
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet TestResultServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TestResultServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Check if user is Medical Assistant

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listTestResults(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteTestResult(request, response);
                break;
            default:
                listTestResults(request, response);
                break;
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
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
        
        if ("insert".equals(action)) {
            insertTestResult(request, response);
        } else if ("update".equals(action)) {
            updateTestResult(request, response);
        }
    }
     private void listTestResults(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get search and filter parameters
        String searchQuery = request.getParameter("search");
        String testTypeFilter = request.getParameter("testType");
        
        // Get page number
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Get data with pagination
        List<TestResult> testResults = testResultDAO.getTestResults(searchQuery, testTypeFilter, page, PAGE_SIZE);
        int totalRecords = testResultDAO.getTotalCount(searchQuery, testTypeFilter);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        
        // Get distinct test types for filter
        List<String> testTypes = testResultDAO.getDistinctTestTypes();
        
        // Set attributes
        request.setAttribute("testResults", testResults);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("testTypeFilter", testTypeFilter);
        request.setAttribute("testTypes", testTypes);
        
        request.getRequestDispatcher("medical-assistant/testresult-list.jsp").forward(request, response);
    }

    // Show add form
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    // Lấy danh sách hồ sơ y tế
    List<TestResultDAO.MedicalReportInfo> medicalReports = testResultDAO.getAllMedicalReports();

    // ✅ Lấy danh sách loại xét nghiệm (động)
    List<String> testTypes = testResultDAO.getDistinctTestTypes();

    // Gửi sang JSP
    request.setAttribute("medicalReports", medicalReports);
    request.setAttribute("testTypes", testTypes);

    request.getRequestDispatcher("medical-assistant/testresult-add.jsp").forward(request, response);
}


    // Show edit form
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    int testId = Integer.parseInt(request.getParameter("id"));
    TestResult testResult = testResultDAO.getTestResultById(testId);
    List<TestResultDAO.MedicalReportInfo> medicalReports = testResultDAO.getAllMedicalReports();

    // ✅ Lấy danh sách loại xét nghiệm từ DB
    List<String> testTypes = testResultDAO.getDistinctTestTypes();

    request.setAttribute("testResult", testResult);
    request.setAttribute("medicalReports", medicalReports);
    request.setAttribute("testTypes", testTypes); // truyền thêm vào JSP
    request.getRequestDispatcher("medical-assistant/testresult-edit.jsp").forward(request, response);
}


    // Insert new test result
    private void insertTestResult(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("recordId"));
            String testType = request.getParameter("testType");
            String result = request.getParameter("result");
            Date date = Date.valueOf(request.getParameter("date"));
            String consultationIdStr = request.getParameter("consultationId");
            Integer consultationId = null;
            if (consultationIdStr != null && !consultationIdStr.trim().isEmpty()) {
                consultationId = Integer.parseInt(consultationIdStr);
            }

            TestResult testResult = new TestResult();
            testResult.setRecordId(recordId);
            testResult.setTestType(testType);
            testResult.setResult(result);
            testResult.setDate(date);
            testResult.setConsultationId(consultationId);

            boolean success = testResultDAO.insertTestResult(testResult);
            
            if (success) {
                request.getSession().setAttribute("message", "Test result added successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to add test result!");
                request.getSession().setAttribute("messageType", "error");
            }
            
            response.sendRedirect("testresult?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Error: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("testresult?action=add");
        }
    }

    // Update test result
    private void updateTestResult(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int testId = Integer.parseInt(request.getParameter("testId"));
            int recordId = Integer.parseInt(request.getParameter("recordId"));
            String testType = request.getParameter("testType");
            String result = request.getParameter("result");
            Date date = Date.valueOf(request.getParameter("date"));
            String consultationIdStr = request.getParameter("consultationId");
            Integer consultationId = null;
            if (consultationIdStr != null && !consultationIdStr.trim().isEmpty()) {
                consultationId = Integer.parseInt(consultationIdStr);
            }

            TestResult testResult = new TestResult();
            testResult.setTestId(testId);
            testResult.setRecordId(recordId);
            testResult.setTestType(testType);
            testResult.setResult(result);
            testResult.setDate(date);
            testResult.setConsultationId(consultationId);

            boolean success = testResultDAO.updateTestResult(testResult);
            
            if (success) {
                request.getSession().setAttribute("message", "Test result updated successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to update test result!");
                request.getSession().setAttribute("messageType", "error");
            }
            
            response.sendRedirect("testresult?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Error: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("testresult?action=list");
        }
    }

    // Delete test result
    private void deleteTestResult(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int testId = Integer.parseInt(request.getParameter("id"));
            boolean success = testResultDAO.deleteTestResult(testId);
            
            if (success) {
                request.getSession().setAttribute("message", "Test result deleted successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to delete test result!");
                request.getSession().setAttribute("messageType", "error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Error: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
        }
        
        response.sendRedirect("testresult?action=list");
    }
    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
