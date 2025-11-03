/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package control.payment;
import context.DBContext;
import dao.payment.PaymentDAO;
import vnpay.VNPayConfig;
import vnpay.VNPayUtil;

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
import java.util.*;

/**
 *
 * @author Quang Anh
 */
@WebServlet(name="VNPayIPNServlet", urlPatterns={"/reception/payment/ipn"})
public class VNPayIPNServlet extends HttpServlet {
    private Connection getConnection() throws Exception {
        return new DBContext().getConnection();
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
            out.println("<title>Servlet VNPayIPNServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VNPayIPNServlet at " + request.getContextPath () + "</h1>");
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
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements();) {
            String name = params.nextElement();
            String value = req.getParameter(name);
            if (value != null && !value.isEmpty()) {
                fields.put(name, value);
            }
        }
        String vnp_SecureHash = fields.remove("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");

        String signed = VNPayUtil.buildQuery(fields);
        String calcHash = VNPayUtil.hmacSHA512(VNPayConfig.getHashSecret(getServletContext()), signed);

        String vnp_ResponseCode = fields.get("vnp_ResponseCode");
        String vnp_TxnRef = fields.get("vnp_TxnRef");
        String vnp_TransactionNo = fields.get("vnp_TransactionNo");
        String vnp_BankCode = fields.get("vnp_BankCode");
        String vnp_CardType = fields.get("vnp_CardType");

        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter(); Connection conn = getConnection()) {
            if (!calcHash.equalsIgnoreCase(vnp_SecureHash)) {
                out.print("{\"RspCode\":\"97\",\"Message\":\"Invalid signature\"}");
                return;
            }
            if (!"00".equals(vnp_ResponseCode)) {
                out.print("{\"RspCode\":\"00\",\"Message\":\"OK (not success code)\"}");
                return;
            }
            PaymentDAO dao = new PaymentDAO(conn);
            dao.markPaid(vnp_TxnRef, vnp_TransactionNo, vnp_BankCode, vnp_CardType);
            out.print("{\"RspCode\":\"00\",\"Message\":\"Success\"}");
        } catch (Exception e) {
            resp.getWriter().print("{\"RspCode\":\"99\",\"Message\":\"Unknown error\"}");
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
