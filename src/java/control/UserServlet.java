/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control;

import entity.ListUser.User;
import entity.ListUser.Role;
import dao.ListUser.RoleDAO;
import dao.ListUser.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Quang Anh
 */
@WebServlet(name = "UserServlet", urlPatterns = {"/admin/users"})
public class UserServlet extends HttpServlet {

    private UserDAO userDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        roleDAO = new RoleDAO();
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
            out.println("<title>Servlet UserServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserServlet at " + request.getContextPath() + "</h1>");
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
                listUsers(request, response);
                break;
            case "toggle":
                toggleUserStatus(request, response);
                break;
            case "ban":
                banUser(request, response);
                break;
            case "view":
                viewUserDetail(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy các tham số tìm kiếm và lọc
        String search = request.getParameter("search");
        String roleFilterStr = request.getParameter("roleFilter");
        String statusFilterStr = request.getParameter("statusFilter");
        String pageStr = request.getParameter("page");

        Integer roleFilter = null;
        Integer statusFilter = null;
        boolean showBanned = false; // ✅ mới thêm
        int page = 1;
        int recordsPerPage = 10;

        try {
            if (roleFilterStr != null && !roleFilterStr.isEmpty()) {
                roleFilter = Integer.parseInt(roleFilterStr);
            }

            if (statusFilterStr != null && !statusFilterStr.isEmpty()) {
                if ("ban".equalsIgnoreCase(statusFilterStr)) {
                    showBanned = true; // ✅ lọc user bị ban
                } else {
                    statusFilter = Integer.parseInt(statusFilterStr);
                }
            }

            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        try {
            if (roleFilterStr != null && !roleFilterStr.isEmpty()) {
                roleFilter = Integer.parseInt(roleFilterStr);
            }
            if (statusFilterStr != null && !statusFilterStr.isEmpty()) {
                statusFilter = Integer.parseInt(statusFilterStr);
            }
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        int offset = (page - 1) * recordsPerPage;

        // Lấy danh sách users
        List<User> users = userDAO.getAllUsers(search, roleFilter, statusFilter,
                showBanned, offset, recordsPerPage);
        int totalRecords = userDAO.getTotalUsers(search, roleFilter, statusFilter, showBanned);

        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        // Lấy danh sách roles để hiển thị filter
        List<Role> roles = roleDAO.getAllRoles();

        // Set attributes
        request.setAttribute("users", users);
        request.setAttribute("roles", roles);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("search", search);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);

        request.getRequestDispatcher("/admin/userList.jsp").forward(request, response);
    }

    // Xem chi tiết user
    private void viewUserDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.getUserById(userId);

        request.setAttribute("user", user);
        request.getRequestDispatcher("/admin/userDetail.jsp").forward(request, response);
    }

    private void setMessage(HttpServletRequest request, boolean success, String successMsg, String errorMsg) {
        if (success) {
            request.getSession().setAttribute("message", successMsg);
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", errorMsg);
            request.getSession().setAttribute("messageType", "error");
        }
    }

    // Bật/tắt trạng thái user
    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            boolean result = userDAO.toggleUserStatus(userId);
            setMessage(request, result, "Thay đổi trạng thái thành công!", "Thay đổi trạng thái thất bại!");
        } catch (Exception e) {
            e.printStackTrace();
            setMessage(request, false, "", "Lỗi hệ thống khi thay đổi trạng thái!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
    }

    // Ban user
    // Ban user
    private void banUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Thiếu tham số id");
            }

            int userId = Integer.parseInt(idParam);
            boolean result = userDAO.banUser(userId);

            setMessage(request, result,
                    "Ban user thành công!",
                    "Ban user thất bại!");
        } catch (Exception e) {
            e.printStackTrace();
            setMessage(request, false, "", "Lỗi hệ thống khi ban user!");
        }

        // Quay lại danh sách người dùng
        response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
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
        processRequest(request, response);
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

}
