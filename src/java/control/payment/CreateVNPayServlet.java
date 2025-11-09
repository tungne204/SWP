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
import java.sql.SQLException;
import java.util.*;

/**
 *
 * @author Quang Anh
 */
@WebServlet(name="CreateVNPayServlet", urlPatterns={"/reception/payment/create"})
public class CreateVNPayServlet extends HttpServlet {
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
            out.println("<title>Servlet CreateVNPayServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateVNPayServlet at " + request.getContextPath () + "</h1>");
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
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {
        String recordIdStr = req.getParameter("recordId");     // có thể gửi cả 2
        String appointmentIdStr = req.getParameter("appointmentId");
        String amountStr = req.getParameter("amount");          // VND (đơn vị số)
        String discountIdStr = req.getParameter("discountId");  // Discount ID (optional)

        if (amountStr == null || amountStr.isEmpty()) {
            resp.sendError(400, "Thiếu amount");
            return;
        }

        try (Connection conn = getConnection()) {
            PaymentDAO paymentDAO = new PaymentDAO(conn);

            int appointmentId;
            if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
                appointmentId = Integer.parseInt(appointmentIdStr);
            } else if (recordIdStr != null && !recordIdStr.isEmpty()) {
                int recordId = Integer.parseInt(recordIdStr);
                appointmentId = paymentDAO.findAppointmentIdByRecordId(recordId);
                if (appointmentId <= 0) {
                    resp.sendError(400, "record_id không hợp lệ hoặc không tìm thấy appointment");
                    return;
                }
            } else {
                resp.sendError(400, "Thiếu appointmentId/recordId");
                return;
            }

            long amountVND = Long.parseLong(amountStr);
            Integer discountId = null;
            if (discountIdStr != null && !discountIdStr.trim().isEmpty()) {
                try {
                    discountId = Integer.parseInt(discountIdStr);
                } catch (NumberFormatException e) {
                    // Invalid discount ID, ignore it
                    discountId = null;
                }
            }
            
            // Lấy thông tin bệnh nhân và đơn thuốc
            PaymentDAO.PatientInfo patientInfo = paymentDAO.getPatientInfoByAppointmentId(appointmentId);
            String patientName = (patientInfo != null && patientInfo.patientName != null && !patientInfo.patientName.trim().isEmpty()) 
                ? patientInfo.patientName : "Bệnh nhân";
            String prescription = (patientInfo != null && patientInfo.prescription != null && !patientInfo.prescription.trim().isEmpty())
                ? patientInfo.prescription : "Chưa có đơn thuốc";
            
            // Giới hạn độ dài đơn thuốc để hiển thị trên VNPay (tối đa 100 ký tự)
            if (prescription != null && prescription.length() > 100) {
                prescription = prescription.substring(0, 97) + "...";
            }
            
            String orderInfo = "Thanh toan - " + patientName + " - Don thuoc: " + prescription;

            // Sinh vnp_TxnRef duy nhất
            String vnp_TxnRef = "CLINIC" + System.currentTimeMillis();

            // Lắp tham số VNPay
            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", VNPayConfig.VNP_VERSION);
            vnp_Params.put("vnp_Command", VNPayConfig.VNP_COMMAND);
            vnp_Params.put("vnp_TmnCode", VNPayConfig.getTmnCode(getServletContext()));
            vnp_Params.put("vnp_Amount", String.valueOf(amountVND * 100)); // x100
            vnp_Params.put("vnp_CurrCode", VNPayConfig.VNP_CURR_CODE);
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", orderInfo);
            vnp_Params.put("vnp_OrderType", "healthcare");
            vnp_Params.put("vnp_Locale", VNPayConfig.DEFAULT_LOCALE);
            // Tự động tạo return URL với context path
            String returnUrl = VNPayConfig.getReturnUrl(getServletContext());
            if (returnUrl == null || returnUrl.isEmpty()) {
                // Fallback: tự động tạo từ request
                String scheme = req.getScheme(); // http hoặc https
                String serverName = req.getServerName();
                int serverPort = req.getServerPort();
                String contextPath = req.getContextPath();
                returnUrl = scheme + "://" + serverName + (serverPort != 80 && serverPort != 443 ? ":" + serverPort : "") 
                           + contextPath + "/reception/payment/return";
            }
            vnp_Params.put("vnp_ReturnUrl", returnUrl);
            vnp_Params.put("vnp_IpAddr", VNPayUtil.getClientIp(req));
            vnp_Params.put("vnp_CreateDate", VNPayUtil.now("yyyyMMddHHmmss"));
            vnp_Params.put("vnp_ExpireDate", VNPayUtil.plusMinutes(15, "yyyyMMddHHmmss"));
            // vnp_Params.put("vnp_BankCode", ""); // nếu muốn cố định bank thì set

            String query = VNPayUtil.buildQuery(vnp_Params);
            String secureHash = VNPayUtil.hmacSHA512(VNPayConfig.getHashSecret(getServletContext()), query);
            String payUrl = VNPayConfig.VNP_PAY_URL + "?" + query + "&vnp_SecureHash=" + secureHash;

            if (!paymentDAO.existsByTxnRef(vnp_TxnRef)) {
                paymentDAO.createPending(appointmentId, orderInfo, amountVND, vnp_TxnRef, payUrl, discountId);
            }

            resp.sendRedirect(payUrl);

        } catch (NumberFormatException ex) {
            resp.sendError(400, "Số tiền không hợp lệ: " + ex.getMessage());
        } catch (SQLException ex) {
            resp.sendError(500, "Lỗi database: " + ex.getMessage());
        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendError(500, "Lỗi hệ thống: " + ex.getMessage());
        }
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
