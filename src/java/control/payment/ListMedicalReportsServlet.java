/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package control.payment;
import context.DBContext;
import dao.payment.MedicalReportViewDAO;
import dao.DiscountDAO;
import entity.Discount;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
/**
 *
 * @author Quang Anh
 */
@WebServlet(name="ListMedicalReportsServlet", urlPatterns={"/reception/medical-reports"})
public class ListMedicalReportsServlet extends HttpServlet {
     private Connection getConn() throws Exception { return new DBContext().getConnection(); }
   
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
            out.println("<title>Servlet ListMedicalReportsServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListMedicalReportsServlet at " + request.getContextPath () + "</h1>");
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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {
        try (Connection c = getConn()) {
            MedicalReportViewDAO dao = new MedicalReportViewDAO(c);
            
            // Lấy các tham số từ request
            String searchKeyword = req.getParameter("search");
            String paymentStatus = req.getParameter("status");
            String pageStr = req.getParameter("page");
            String pageSizeStr = req.getParameter("pageSize");
            
            // Giá trị mặc định
            int page = 1;
            int pageSize = 10;
            
            // Parse page và pageSize
            try {
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            try {
                if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
                    pageSize = Integer.parseInt(pageSizeStr);
                    if (pageSize < 1) pageSize = 10;
                    if (pageSize > 100) pageSize = 100; // Giới hạn tối đa
                }
            } catch (NumberFormatException e) {
                pageSize = 10;
            }
            
            // Lấy danh sách với search, filter và paging
            List<MedicalReportViewDAO.Row> rows = dao.listWithSearchFilterPaging(
                searchKeyword, paymentStatus, page, pageSize
            );
            
            // Lấy tổng số bản ghi để tính số trang
            int totalCount = dao.getTotalCount(searchKeyword, paymentStatus);
            int totalPages = totalCount > 0 ? (int) Math.ceil((double) totalCount / pageSize) : 1;
            
            // Load active discounts for discount selection
            DiscountDAO discountDAO = new DiscountDAO();
            List<Discount> activeDiscounts = discountDAO.getActiveDiscounts();
            
            // Set attributes cho JSP
            req.setAttribute("medicalReports", rows);
            req.setAttribute("searchKeyword", searchKeyword != null ? searchKeyword : "");
            req.setAttribute("paymentStatus", paymentStatus != null ? paymentStatus : "all");
            req.setAttribute("currentPage", page);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("totalCount", totalCount);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("activeDiscounts", activeDiscounts);
            
            req.getRequestDispatcher("/views/payment/list-medical-report.jsp")
               .forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
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
