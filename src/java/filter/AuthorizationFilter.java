package filter;

import service.AuthorizationService;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * Authorization Filter for checking permissions on protected resources
 * This filter works alongside ServletAuthFilter to provide fine-grained permission control
 * 
 * It checks if the authenticated user has the required permissions to access specific resources
 */
@WebFilter(urlPatterns = {
    "/admin/*",
    "/permission-management",
    "/user-management/*",
    "/role-management/*",
    "/system-config/*",
    "/reports/*",
    "/audit/*"
})
public class AuthorizationFilter implements Filter {

    private AuthorizationService authService;
    
    // Public endpoints that don't require permission checks
    private static final Set<String> PUBLIC_ENDPOINTS = new HashSet<>(Arrays.asList(
        "/login",
        "/logout",
        "/error",
        "/public"
    ));
    
    // Permission mappings for different URL patterns
    private static final String[][] PERMISSION_MAPPINGS = {
        // Admin module
        {"/admin/", "ADMIN_ACCESS"},
        {"/admin/users", "MANAGE_USERS"},
        {"/admin/roles", "MANAGE_ROLES"},
        {"/admin/permissions", "MANAGE_PERMISSIONS"},
        {"/admin/system", "SYSTEM_ADMIN"},
        
        // Permission management
        {"/permission-management", "PERMISSION_VIEW"},
        
        // User management
        {"/user-management/", "MANAGE_USERS"},
        {"/user-management/create", "CREATE_USER"},
        {"/user-management/edit", "EDIT_USER"},
        {"/user-management/delete", "DELETE_USER"},
        {"/user-management/view", "VIEW_USER"},
        
        // Role management
        {"/role-management/", "MANAGE_ROLES"},
        {"/role-management/create", "CREATE_ROLE"},
        {"/role-management/edit", "EDIT_ROLE"},
        {"/role-management/delete", "DELETE_ROLE"},
        
        // System configuration
        {"/system-config/", "SYSTEM_ADMIN"},
        {"/system-config/database", "DATABASE_ADMIN"},
        {"/system-config/backup", "BACKUP_ADMIN"},
        
        // Reports
        {"/reports/", "VIEW_REPORTS"},
        {"/reports/user", "VIEW_USER_REPORTS"},
        {"/reports/system", "VIEW_SYSTEM_REPORTS"},
        {"/reports/audit", "VIEW_AUDIT_REPORTS"},
        
        // Audit
        {"/audit/", "VIEW_AUDIT_LOGS"},
        {"/audit/export", "EXPORT_AUDIT_LOGS"}
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        authService = new AuthorizationService();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
//        HttpServletRequest httpRequest = (HttpServletRequest) request;
//        HttpServletResponse httpResponse = (HttpServletResponse) response;
//
//        String requestURI = httpRequest.getRequestURI();
//        String contextPath = httpRequest.getContextPath();
//
//        // Remove context path from URI
//        if (requestURI.startsWith(contextPath)) {
//            requestURI = requestURI.substring(contextPath.length());
//        }
//
//        // Check if this is a public endpoint
//        if (isPublicEndpoint(requestURI)) {
//            chain.doFilter(request, response);
//            return;
//        }
//
//        // Get user from session
//        HttpSession session = httpRequest.getSession(false);
//        if (session == null) {
//            redirectToLogin(httpRequest, httpResponse);
//            return;
//        }
//
//        User user = (User) session.getAttribute("acc");
//
//        if (user == null) {
//            redirectToLogin(httpRequest, httpResponse);
//            return;
//        }
//
//        int userId = user.getUserId();
//
//        // Check permissions
//        if (!hasRequiredPermission(userId, requestURI, httpRequest.getMethod())) {
//            handleAccessDenied(httpRequest, httpResponse, requestURI);
//            return;
//        }
//
//        // Log access for audit purposes
//        logAccess(userId, requestURI, httpRequest.getMethod(), getClientIP(httpRequest),
//                 httpRequest.getHeader("User-Agent"));
//
        // Continue with the request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }

    /**
     * Check if the endpoint is public and doesn't require authentication
     */
    private boolean isPublicEndpoint(String uri) {
        return PUBLIC_ENDPOINTS.stream().anyMatch(uri::startsWith);
    }

    /**
     * Check if user has required permission for the requested resource
     */
    private boolean hasRequiredPermission(int userId, String uri, String method) {
        try {
            // Check if user is admin (admins have access to everything)
            if (authService.isUserAdmin(userId)) {
                return true;
            }
            
            // Get required permission for this URI
            String requiredPermission = getRequiredPermission(uri, method);
            
            if (requiredPermission == null) {
                // No specific permission required, allow access
                return true;
            }
            
            // Check if user has the required permission
            return authService.checkUserPermission(userId, requiredPermission);
            
        } catch (Exception e) {
            e.printStackTrace();
            return false; // Deny access on error
        }
    }

    /**
     * Get required permission for a specific URI and HTTP method
     */
    private String getRequiredPermission(String uri, String method) {
        // Check exact matches first
        for (String[] mapping : PERMISSION_MAPPINGS) {
            if (uri.equals(mapping[0])) {
                return mapping[1];
            }
        }
        
        // Check prefix matches
        for (String[] mapping : PERMISSION_MAPPINGS) {
            if (uri.startsWith(mapping[0])) {
                return mapping[1];
            }
        }
        
        // Method-specific permissions
        if ("POST".equals(method) || "PUT".equals(method)) {
            // Write operations might need additional permissions
            if (uri.contains("/create") || uri.contains("/add")) {
                return getCreatePermission(uri);
            } else if (uri.contains("/edit") || uri.contains("/update")) {
                return getEditPermission(uri);
            } else if (uri.contains("/delete") || uri.contains("/remove")) {
                return getDeletePermission(uri);
            }
        }
        
        // Default: no specific permission required
        return null;
    }

    /**
     * Get create permission based on URI
     */
    private String getCreatePermission(String uri) {
        if (uri.contains("/user")) return "CREATE_USER";
        if (uri.contains("/role")) return "CREATE_ROLE";
        if (uri.contains("/permission")) return "CREATE_PERMISSION";
        return "CREATE_RESOURCE";
    }

    /**
     * Get edit permission based on URI
     */
    private String getEditPermission(String uri) {
        if (uri.contains("/user")) return "EDIT_USER";
        if (uri.contains("/role")) return "EDIT_ROLE";
        if (uri.contains("/permission")) return "EDIT_PERMISSION";
        return "EDIT_RESOURCE";
    }

    /**
     * Get delete permission based on URI
     */
    private String getDeletePermission(String uri) {
        if (uri.contains("/user")) return "DELETE_USER";
        if (uri.contains("/role")) return "DELETE_ROLE";
        if (uri.contains("/permission")) return "DELETE_PERMISSION";
        return "DELETE_RESOURCE";
    }

    /**
     * Redirect to login page
     */
    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String loginURL = request.getContextPath() + "/Login";
        response.sendRedirect(loginURL);
    }

    /**
     * Handle access denied scenarios
     */
    private void handleAccessDenied(HttpServletRequest request, HttpServletResponse response, String uri) 
            throws IOException, ServletException {
        
        // Check if this is an AJAX request
        String requestedWith = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(requestedWith);
        
        if (isAjax) {
            // Return JSON error for AJAX requests
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Access denied\", \"code\": 403}");
        } else {
            // Redirect to access denied page for regular requests
            request.setAttribute("requestedResource", uri);
            request.setAttribute("errorMessage", "You don't have permission to access this resource.");
            request.getRequestDispatcher("/error/access-denied.jsp").forward(request, response);
        }
    }

    /**
     * Log access attempt for audit purposes
     */
    private void logAccess(int userId, String uri, String method, String ipAddress, String userAgent) {
        try {
            String description = String.format("Accessed %s %s", method, uri);
            authService.logAuditAction(userId, "ACCESS", null, null, null, 
                                     null, null, description);
        } catch (Exception e) {
            // Log error but don't fail the request
            e.printStackTrace();
        }
    }

    /**
     * Get client IP address
     */
    private String getClientIP(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIP = request.getHeader("X-Real-IP");
        if (xRealIP != null && !xRealIP.isEmpty()) {
            return xRealIP;
        }
        
        return request.getRemoteAddr();
    }

    /**
     * Check if user can access specific module
     */
    public boolean canAccessModule(int userId, String module) {
        try {
            return authService.canUserAccessModule(userId, module);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if user can perform specific action on resource
     */
    public boolean canPerformAction(int userId, String resource, String action) {
        try {
            return authService.canUserAccess(userId, resource, action);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}