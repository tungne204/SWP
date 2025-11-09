package control;

import dao.DiscountDAO;
import entity.Discount;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for handling discount management operations
 * Provides CRUD operations for discounts with proper validation and authorization
 * 
 * @author System
 */
@WebServlet(name = "DiscountManagementServlet", urlPatterns = {"/admin/discount", "/admin/promotion"})
public class DiscountManagementServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(DiscountManagementServlet.class.getName());
    private DiscountDAO discountDAO;
    private SimpleDateFormat dateFormat;
    
    @Override
    public void init() throws ServletException {
        discountDAO = new DiscountDAO();
        dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    }
    
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
        
        // Check authentication and authorization
        if (!isAuthorized(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listDiscounts(request, response);
                    break;
                case "view":
                    viewDiscount(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteDiscount(request, response);
                    break;
                case "expiring":
                    listExpiringDiscounts(request, response);
                    break;
                case "active":
                    listActiveDiscounts(request, response);
                    break;
                default:
                    listDiscounts(request, response);
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing GET request", e);
            request.setAttribute("error", "Da xay ra loi khi xu ly yeu cau: " + e.getMessage());
            request.getRequestDispatcher("/admin/discount-list.jsp").forward(request, response);
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
        
        // Check authentication and authorization
        if (!isAuthorized(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    createDiscount(request, response);
                    break;
                case "update":
                    updateDiscount(request, response);
                    break;
                default:
                    listDiscounts(request, response);
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing POST request", e);
            request.setAttribute("error", "Da xay ra loi khi xu ly yeu cau: " + e.getMessage());
            request.getRequestDispatcher("/admin/discount-list.jsp").forward(request, response);
        }
    }
    
    /**
     * Check if user is authorized to access discount management
     */
    private boolean isAuthorized(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("Login.jsp");
            return false;
        }
        
        User user = (User) session.getAttribute("acc");
        
        // Check if user is manager/admin (role_id 1 for manager/admin)
        if (user.getRoleId() != 1) {
            response.sendRedirect("403.jsp");
            return false;
        }
        
        return true;
    }
    
    /**
     * List discounts with pagination and search
     */
    private void listDiscounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchKeyword = request.getParameter("search");
        String sortOrder = request.getParameter("sort");
        String pageStr = request.getParameter("page");
        
        // Default values
        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "DESC";
        }
        
        int page = 1;
        int pageSize = 10;
        
        try {
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        // Get discounts and total count
        List<Discount> discounts = discountDAO.getAllDiscounts(searchKeyword, sortOrder, page, pageSize);
        int totalDiscounts = discountDAO.getTotalDiscounts(searchKeyword);
        int totalPages = (int) Math.ceil((double) totalDiscounts / pageSize);
        
        // Get expiring discounts for warning
        List<Discount> expiringDiscounts = discountDAO.getExpiringSoonDiscounts();
        
        // Set attributes
        request.setAttribute("promotions", discounts); // Keep as "promotions" for JSP compatibility
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalPromotions", totalDiscounts); // Keep as "totalPromotions" for JSP compatibility
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("expiringPromotions", expiringDiscounts); // Keep as "expiringPromotions" for JSP compatibility
        
        request.getRequestDispatcher("/admin/discount-list.jsp").forward(request, response);
    }
    
    /**
     * View single discount details
     */
    private void viewDiscount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/discount?action=list");
            return;
        }
        
        try {
            int discountId = Integer.parseInt(idStr);
            Discount discount = discountDAO.getDiscountById(discountId);
            
            if (discount == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Không tìm thấy khuyến mãi với ID: " + discountId);
                response.sendRedirect(request.getContextPath() + "/admin/discount?action=list");
                return;
            }
            
            request.setAttribute("promotion", discount); // Keep as "promotion" for JSP compatibility
            request.getRequestDispatcher("/admin/discount-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "ID khuyến mãi không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/discount?action=list");
        }
    }
    
    /**
     * Show add discount form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/discount-form.jsp").forward(request, response);
    }
    
    /**
     * Show edit discount form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/discount?action=list");
            return;
        }
        
        try {
            int discountId = Integer.parseInt(idStr);
            Discount discount = discountDAO.getDiscountById(discountId);
            
            if (discount == null) {
                request.setAttribute("error", "Không tìm thấy khuyến mãi với ID: " + discountId);
                listDiscounts(request, response);
                return;
            }
            
            request.setAttribute("promotion", discount); // Keep as "promotion" for JSP compatibility
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/admin/discount-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID khuyến mãi không hợp lệ");
            listDiscounts(request, response);
        }
    }
    
    /**
     * Create new discount
     */
    private void createDiscount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Discount discount = buildDiscountFromRequest(request);
            
            // Validate discount
            String validationError = validateDiscount(discount, null);
            if (validationError != null) {
                request.setAttribute("error", validationError);
                request.setAttribute("promotion", discount); // Keep as "promotion" for JSP compatibility
                request.getRequestDispatcher("/admin/discount-form.jsp").forward(request, response);
                return;
            }
            
            // Check if code already exists
            if (discountDAO.isDiscountCodeExists(discount.getCode(), null)) {
                request.setAttribute("error", "Mã khuyến mãi đã tồn tại: " + discount.getCode());
                request.setAttribute("promotion", discount); // Keep as "promotion" for JSP compatibility
                request.getRequestDispatcher("/admin/discount-form.jsp").forward(request, response);
                return;
            }
            
            // Insert discount
            boolean success = discountDAO.createDiscount(discount);
            
            if (success) {
                request.setAttribute("success", "Tạo khuyến mãi thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/discount?action=list&success=1");
            } else {
                request.setAttribute("error", "Không thể tạo khuyến mãi. Vui lòng thử lại.");
                request.setAttribute("promotion", discount); // Keep as "promotion" for JSP compatibility
                request.getRequestDispatcher("/admin/discount-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating discount", e);
            request.setAttribute("error", "Da xay ra loi khi tao khuyen mai: " + e.getMessage());
            request.getRequestDispatcher("/admin/discount-form.jsp").forward(request, response);
        }
    }
    
    /**
     * Update existing discount
     */
    private void updateDiscount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("discountId");
        if (idStr == null || idStr.isEmpty()) {
            idStr = request.getParameter("promotionId"); // Fallback for JSP compatibility
        }
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/discount?action=list");
            return;
        }
        
        try {
            int discountId = Integer.parseInt(idStr);
            Discount discount = buildDiscountFromRequest(request);
            discount.setDiscountId(discountId);
            
            // Validate discount
            String validationError = validateDiscount(discount, discountId);
            if (validationError != null) {
                request.setAttribute("error", validationError);
                request.setAttribute("promotion", discount); // Keep as "promotion" for JSP compatibility
                request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/admin/discount-form.jsp").forward(request, response);
                return;
            }
            
            // Check if code already exists (excluding current discount)
            if (discountDAO.isDiscountCodeExists(discount.getCode(), discountId)) {
                request.setAttribute("error", "Mã khuyến mãi đã tồn tại: " + discount.getCode());
                request.setAttribute("promotion", discount); // Keep as "promotion" for JSP compatibility
                request.setAttribute("isEdit", true);
                request.getRequestDispatcher("/admin/discount-form.jsp").forward(request, response);
                return;
            }
            
            // Update discount
            boolean success = discountDAO.updateDiscount(discount);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/discount?action=list&updated=1");
            } else {
                request.setAttribute("error", "Không thể cập nhật khuyến mãi. Vui lòng thử lại.");
                request.setAttribute("promotion", discount); // Keep as "promotion" for JSP compatibility
                request.setAttribute("isEdit", true);
                request.getRequestDispatcher("/admin/discount-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating discount", e);
            request.setAttribute("error", "Da xay ra loi khi cap nhat khuyen mai: " + e.getMessage());
            request.getRequestDispatcher("/admin/discount-form.jsp").forward(request, response);
        }
    }
    
    /**
     * Delete discount
     */
    private void deleteDiscount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/discount?action=list");
            return;
        }
        
        try {
            int discountId = Integer.parseInt(idStr);
            boolean success = discountDAO.deleteDiscount(discountId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/discount?action=list&deleted=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/discount?action=list&error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/discount?action=list&error=invalid_id");
        }
    }
    
    /**
     * List expiring discounts
     */
    private void listExpiringDiscounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Discount> expiringDiscounts = discountDAO.getExpiringSoonDiscounts();
        request.setAttribute("expiringPromotions", expiringDiscounts); // Keep as "expiringPromotions" for JSP compatibility
        request.getRequestDispatcher("/admin/discount-expiring.jsp").forward(request, response);
    }
    
    /**
     * List active discounts
     */
    private void listActiveDiscounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Discount> activeDiscounts = discountDAO.getActiveDiscounts();
        request.setAttribute("activePromotions", activeDiscounts); // Keep as "activePromotions" for JSP compatibility
        request.getRequestDispatcher("/admin/discount-active.jsp").forward(request, response);
    }
    
    /**
     * Build Discount object from request parameters
     */
    private Discount buildDiscountFromRequest(HttpServletRequest request) throws ParseException {
        Discount discount = new Discount();
        
        discount.setCode(request.getParameter("code"));
        
        String percentageStr = request.getParameter("percentage");
        if (percentageStr == null || percentageStr.isEmpty()) {
            percentageStr = request.getParameter("discountValue"); // Fallback for JSP compatibility
        }
        if (percentageStr != null && !percentageStr.isEmpty()) {
            discount.setPercentage(new BigDecimal(percentageStr));
        }
        
        String startDateStr = request.getParameter("validFrom");
        if (startDateStr == null || startDateStr.isEmpty()) {
            startDateStr = request.getParameter("startDate"); // Fallback for JSP compatibility
        }
        if (startDateStr != null && !startDateStr.isEmpty()) {
            discount.setValidFrom(dateFormat.parse(startDateStr));
        }
        
        String endDateStr = request.getParameter("validTo");
        if (endDateStr == null || endDateStr.isEmpty()) {
            endDateStr = request.getParameter("endDate"); // Fallback for JSP compatibility
        }
        if (endDateStr != null && !endDateStr.isEmpty()) {
            discount.setValidTo(dateFormat.parse(endDateStr));
        }
        
        return discount;
    }
    
    /**
     * Validate discount data
     */
    private String validateDiscount(Discount discount, Integer excludeId) {
        if (discount.getCode() == null || discount.getCode().trim().isEmpty()) {
            return "Mã khuyến mãi không được để trống";
        }
        
        if (!discount.getCode().matches("^[A-Za-z0-9]+$")) {
            return "Mã khuyến mãi chỉ được chứa chữ cái và số";
        }
        
        if (discount.getPercentage() == null || discount.getPercentage().compareTo(BigDecimal.ZERO) <= 0) {
            return "Mức giảm giá phải lớn hơn 0";
        }
        
        if (discount.getPercentage().compareTo(new BigDecimal("100")) > 0) {
            return "Mức giảm giá không được vượt quá 100%";
        }
        
        if (discount.getValidFrom() != null && discount.getValidTo() != null) {
            if (discount.getValidFrom().after(discount.getValidTo())) {
                return "Ngày bắt đầu không được sau ngày kết thúc";
            }
        }
        
        return null; // No validation errors
    }
    
    @Override
    public String getServletInfo() {
        return "Discount Management Servlet";
    }
}