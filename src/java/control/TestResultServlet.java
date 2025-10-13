/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package control;

import dao.TestResultDAO;
import entity.TestResult;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Quang Anh
 */
@WebServlet(name="TestResultServlet", urlPatterns={"/test-result"})
public class TestResultServlet extends HttpServlet {
   private TestResultDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new TestResultDAO();
    }
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
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listTestResults(request, response);
                break;
            case "view-by-record":
                viewByRecord(request, response);
                break;
            case "view-detail":
                viewDetail(request, response);
                break;
            default:
                listTestResults(request, response);
                break;
        }
    } 
    private void listTestResults(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        
        if (doctorId == null) {
            doctorId = 1; // Giá trị mặc định để test
        }

        List<TestResult> testResults = dao.getAllByDoctorId(doctorId);
        request.setAttribute("testResults", testResults);
        request.getRequestDispatcher("views/test-result-list.jsp").forward(request, response);
    }

    // Xem test results của một medical record cụ thể
    private void viewByRecord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int recordId = Integer.parseInt(request.getParameter("recordId"));
            
            List<TestResult> testResults = dao.getByRecordId(recordId);
            boolean hasTestRequest = dao.hasTestRequest(recordId);
            int testCount = dao.countByRecordId(recordId);
            
            request.setAttribute("testResults", testResults);
            request.setAttribute("recordId", recordId);
            request.setAttribute("hasTestRequest", hasTestRequest);
            request.setAttribute("testCount", testCount);
            
            request.getRequestDispatcher("views/test-result-by-record.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("medical-report?action=list");
        }
    }

    // Xem chi tiết một test result
    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int testId = Integer.parseInt(request.getParameter("id"));
            
            TestResult testResult = dao.getById(testId);
            
            if (testResult != null) {
                request.setAttribute("testResult", testResult);
                request.getRequestDispatcher("test-result-detail.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("message", "Không tìm thấy kết quả xét nghiệm!");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("views/test-result?action=list");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("test-result?action=list");
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
        processRequest(request, response);
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
