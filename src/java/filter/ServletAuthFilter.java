package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import entity.User;

/**
 * AuthFilter cho các servlet quan trọng Bảo vệ các servlet như /appointment,
 * /logout, /changePassword, etc.
 */
@WebFilter(urlPatterns = {
    "/appointment",
    "/logout",
    "/changePassword",
    "/forgotPassword",
    "/resetPassword",
    "/doctors",
    "/patientSearch",
    "/setPermission",
    "/updateAppointment",
    "/deleteAppointment",
    "/viewAppointment",
    "/Receptionist-Dashboard",
    "/testresult",
    "/medical-report"

})
public class ServletAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        System.out.println("DEBUG: ServletAuthFilter - URI: " + uri);

        // Kiểm tra session và user
        HttpSession session = req.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("acc") : null;

        // Các servlet không cần đăng nhập
        if (isPublicServlet(uri)) {
            chain.doFilter(request, response);
            return;
        }

        // Kiểm tra đăng nhập
        if (acc == null) {
            System.out.println("DEBUG: ServletAuthFilter - No user session, redirecting to login");
            res.sendRedirect(contextPath + "/Login.jsp");
            return;
        }

        int roleId = acc.getRoleId();
        System.out.println("DEBUG: ServletAuthFilter - User: " + acc.getUsername() + ", Role: " + roleId);

        // Kiểm tra quyền truy cập theo servlet
        if (!hasPermission(uri, roleId)) {
            System.out.println("DEBUG: ServletAuthFilter - Access denied for role " + roleId + " to " + uri);
            res.sendRedirect(contextPath + "/403.jsp");
            return;
        }

        System.out.println("DEBUG: ServletAuthFilter - Access granted");
        chain.doFilter(request, response);
    }

    /**
     * Kiểm tra servlet có cần đăng nhập không
     */
    private boolean isPublicServlet(String uri) {
        return uri.contains("/forgotPassword")
                || uri.contains("/resetPassword")
                || uri.contains("/doctors"); // API để load doctors cho form
    }

    /**
     * Kiểm tra quyền truy cập servlet theo role
     */
    private boolean hasPermission(String uri, int roleId) {
        if (uri.contains("/medical-report")) {
            return roleId == 2 || roleId == 3;
        }
        if (uri.contains("/testresult")) {
            return roleId == 2 || roleId == 4;
        }

        // Patient servlets (role_id = 3)
        if (uri.contains("/viewAppointment") ) {
            return roleId == 3; // Chỉ Patient
        }

        // Doctor servlets (role_id = 2)
        if (!uri.contains("/medical-report") &&
            (uri.contains("/appointment") || uri.contains("/testresult"))) {
            return roleId == 2;
        }

        // Receptionist servlets (role_id = 5)
        if (uri.contains("/patientSearch") || uri.contains("/updateAppointment") || uri.contains("/deleteAppointment") || uri.contains("/Receptionist-Dashboard")) {
            return roleId == 5; // Chỉ Receptionist
        }

        // Manager servlets (role_id = 1)
        if (uri.contains("/setPermission")) {
            return roleId == 1; // Chỉ Manager
        }

        // Logout - tất cả role đều có thể logout
        if (uri.contains("/logout")) {
            return true;
        }

        // Change password - tất cả role đều có thể đổi password
        if (uri.contains("/changePassword")) {
            return true;
        }

        // Mặc định: từ chối truy cập
        return false;
        
    }
    
}
