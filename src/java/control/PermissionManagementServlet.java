package control;

import service.AuthorizationService;
import entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Set;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Servlet for handling permission management operations
 * Provides REST-like endpoints for managing permissions, roles, and user permissions
 */
@WebServlet(name = "PermissionManagementServlet", urlPatterns = {"/permission-management"})
public class PermissionManagementServlet extends HttpServlet {

    private AuthorizationService authService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        authService = new AuthorizationService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        try {
            switch (action) {
                case "dashboard":
                    showPermissionDashboard(request, response);
                    break;
                case "permissions":
                    listPermissions(request, response);
                    break;
                case "role-permissions":
                    listRolePermissions(request, response);
                    break;
                case "user-permissions":
                    listUserPermissions(request, response);
                    break;
                case "audit-logs":
                    listAuditLogs(request, response);
                    break;
                case "check-permission":
                    checkPermission(request, response);
                    break;
                case "user-modules":
                    getUserModules(request, response);
                    break;
                default:
                    showPermissionDashboard(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            sendErrorResponse(response, "Action parameter is required");
            return;
        }

        try {
            switch (action) {
                case "grant-role-permission":
                    grantRolePermission(request, response);
                    break;
                case "revoke-role-permission":
                    revokeRolePermission(request, response);
                    break;
                case "grant-user-permission":
                    grantUserPermission(request, response);
                    break;
                case "revoke-user-permission":
                    revokeUserPermission(request, response);
                    break;
                case "bulk-grant-role":
                    bulkGrantRolePermissions(request, response);
                    break;
                case "bulk-revoke-role":
                    bulkRevokeRolePermissions(request, response);
                    break;
                default:
                    sendErrorResponse(response, "Invalid action: " + action);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e);
        }
    }

    // ==================== GET METHODS ====================

    /**
     * Show permission management dashboard
     */
    private void showPermissionDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user has permission to manage permissions
        if (!hasManagementPermission(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        request.getRequestDispatcher("/manager/permission-dashboard.jsp").forward(request, response);
    }

    /**
     * List all permissions
     */
    private void listPermissions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String module = request.getParameter("module");
        List<Permission> permissions;
        
        if (module != null && !module.trim().isEmpty()) {
            permissions = authService.getPermissionsByModule(module);
        } else {
            permissions = authService.getAllPermissions();
        }

        if (isAjaxRequest(request)) {
            sendJsonResponse(response, permissions);
        } else {
            request.setAttribute("permissions", permissions);
            request.setAttribute("selectedModule", module);
            request.getRequestDispatcher("/manager/permission-management.jsp").forward(request, response);
        }
    }

    /**
     * List role permissions
     */
    private void listRolePermissions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String roleIdStr = request.getParameter("roleId");
        if (roleIdStr == null) {
            sendErrorResponse(response, "Role ID is required");
            return;
        }

        try {
            int roleId = Integer.parseInt(roleIdStr);
            List<Permission> permissions = authService.getRolePermissions(roleId);

            if (isAjaxRequest(request)) {
                sendJsonResponse(response, permissions);
            } else {
                request.setAttribute("permissions", permissions);
                request.setAttribute("roleId", roleId);
                request.getRequestDispatcher("/manager/role-permissions.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid role ID format");
        }
    }

    /**
     * List user permissions
     */
    private void listUserPermissions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null) {
            sendErrorResponse(response, "User ID is required");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            List<Permission> permissions = authService.getUserEffectivePermissions(userId);

            if (isAjaxRequest(request)) {
                sendJsonResponse(response, permissions);
            } else {
                request.setAttribute("permissions", permissions);
                request.setAttribute("userId", userId);
                request.getRequestDispatcher("/manager/user-permissions.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid user ID format");
        }
    }

    /**
     * List audit logs
     */
    private void listAuditLogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");
        
        int page = 1;
        int pageSize = 20;
        
        try {
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
            if (pageSizeStr != null) {
                pageSize = Integer.parseInt(pageSizeStr);
            }
        } catch (NumberFormatException e) {
            // Use default values
        }

        List<AuditLog> logs = authService.getAuditLogs(page, pageSize);

        if (isAjaxRequest(request)) {
            sendJsonResponse(response, logs);
        } else {
            request.setAttribute("auditLogs", logs);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.getRequestDispatcher("/manager/audit-logs.jsp").forward(request, response);
        }
    }

    /**
     * Check if user has specific permission
     */
    private void checkPermission(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        String permissionCode = request.getParameter("permissionCode");
        
        if (userIdStr == null || permissionCode == null) {
            sendErrorResponse(response, "User ID and permission code are required");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            boolean hasPermission = authService.checkUserPermission(userId, permissionCode);
            
            JsonObject result = new JsonObject();
            result.addProperty("hasPermission", hasPermission);
            result.addProperty("userId", userId);
            result.addProperty("permissionCode", permissionCode);
            
            sendJsonResponse(response, result);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid user ID format");
        }
    }

    /**
     * Get accessible modules for user
     */
    private void getUserModules(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null) {
            sendErrorResponse(response, "User ID is required");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            Set<String> modules = authService.getUserAccessibleModules(userId);
            
            sendJsonResponse(response, modules);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid user ID format");
        }
    }

    // ==================== POST METHODS ====================

    /**
     * Grant permission to role
     */
    private void grantRolePermission(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManagementPermission(request)) {
            sendErrorResponse(response, "Access denied");
            return;
        }

        String roleIdStr = request.getParameter("roleId");
        String permissionIdStr = request.getParameter("permissionId");
        
        if (roleIdStr == null || permissionIdStr == null) {
            sendErrorResponse(response, "Role ID and permission ID are required");
            return;
        }

        try {
            int roleId = Integer.parseInt(roleIdStr);
            int permissionId = Integer.parseInt(permissionIdStr);
            int grantedBy = getCurrentUserId(request);
            
            boolean success = authService.grantPermissionToRole(roleId, permissionId, grantedBy);
            
            JsonObject result = new JsonObject();
            result.addProperty("success", success);
            result.addProperty("message", success ? "Permission granted successfully" : "Failed to grant permission");
            
            sendJsonResponse(response, result);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid ID format");
        }
    }

    /**
     * Revoke permission from role
     */
    private void revokeRolePermission(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManagementPermission(request)) {
            sendErrorResponse(response, "Access denied");
            return;
        }

        String roleIdStr = request.getParameter("roleId");
        String permissionIdStr = request.getParameter("permissionId");
        
        if (roleIdStr == null || permissionIdStr == null) {
            sendErrorResponse(response, "Role ID and permission ID are required");
            return;
        }

        try {
            int roleId = Integer.parseInt(roleIdStr);
            int permissionId = Integer.parseInt(permissionIdStr);
            int revokedBy = getCurrentUserId(request);
            
            boolean success = authService.revokePermissionFromRole(roleId, permissionId, revokedBy);
            
            JsonObject result = new JsonObject();
            result.addProperty("success", success);
            result.addProperty("message", success ? "Permission revoked successfully" : "Failed to revoke permission");
            
            sendJsonResponse(response, result);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid ID format");
        }
    }

    /**
     * Grant permission to user
     */
    private void grantUserPermission(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManagementPermission(request)) {
            sendErrorResponse(response, "Access denied");
            return;
        }

        String userIdStr = request.getParameter("userId");
        String permissionIdStr = request.getParameter("permissionId");
        String expiryDateStr = request.getParameter("expiryDate");
        
        if (userIdStr == null || permissionIdStr == null) {
            sendErrorResponse(response, "User ID and permission ID are required");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            int permissionId = Integer.parseInt(permissionIdStr);
            int grantedBy = getCurrentUserId(request);
            
            Date expiryDate = null;
            if (expiryDateStr != null && !expiryDateStr.trim().isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                expiryDate = sdf.parse(expiryDateStr);
            }
            
            boolean success = authService.grantPermissionToUser(userId, permissionId, grantedBy, expiryDate);
            
            JsonObject result = new JsonObject();
            result.addProperty("success", success);
            result.addProperty("message", success ? "Permission granted successfully" : "Failed to grant permission");
            
            sendJsonResponse(response, result);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid ID format");
        } catch (ParseException e) {
            sendErrorResponse(response, "Invalid date format. Use yyyy-MM-dd");
        }
    }

    /**
     * Revoke permission from user
     */
    private void revokeUserPermission(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManagementPermission(request)) {
            sendErrorResponse(response, "Access denied");
            return;
        }

        String userIdStr = request.getParameter("userId");
        String permissionIdStr = request.getParameter("permissionId");
        
        if (userIdStr == null || permissionIdStr == null) {
            sendErrorResponse(response, "User ID and permission ID are required");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            int permissionId = Integer.parseInt(permissionIdStr);
            int revokedBy = getCurrentUserId(request);
            
            boolean success = authService.revokePermissionFromUser(userId, permissionId, revokedBy);
            
            JsonObject result = new JsonObject();
            result.addProperty("success", success);
            result.addProperty("message", success ? "Permission revoked successfully" : "Failed to revoke permission");
            
            sendJsonResponse(response, result);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid ID format");
        }
    }

    /**
     * Bulk grant permissions to role
     */
    private void bulkGrantRolePermissions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManagementPermission(request)) {
            sendErrorResponse(response, "Access denied");
            return;
        }

        String roleIdStr = request.getParameter("roleId");
        String[] permissionIds = request.getParameterValues("permissionIds");
        
        if (roleIdStr == null || permissionIds == null) {
            sendErrorResponse(response, "Role ID and permission IDs are required");
            return;
        }

        try {
            int roleId = Integer.parseInt(roleIdStr);
            int grantedBy = getCurrentUserId(request);
            
            java.util.List<Integer> permissionIdList = new java.util.ArrayList<>();
            for (String permissionIdStr : permissionIds) {
                permissionIdList.add(Integer.parseInt(permissionIdStr));
            }
            
            boolean success = authService.grantMultiplePermissionsToRole(roleId, permissionIdList, grantedBy);
            
            JsonObject result = new JsonObject();
            result.addProperty("success", success);
            result.addProperty("message", success ? "Permissions granted successfully" : "Some permissions failed to grant");
            
            sendJsonResponse(response, result);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid ID format");
        }
    }

    /**
     * Bulk revoke permissions from role
     */
    private void bulkRevokeRolePermissions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManagementPermission(request)) {
            sendErrorResponse(response, "Access denied");
            return;
        }

        String roleIdStr = request.getParameter("roleId");
        String[] permissionIds = request.getParameterValues("permissionIds");
        
        if (roleIdStr == null || permissionIds == null) {
            sendErrorResponse(response, "Role ID and permission IDs are required");
            return;
        }

        try {
            int roleId = Integer.parseInt(roleIdStr);
            int revokedBy = getCurrentUserId(request);
            
            java.util.List<Integer> permissionIdList = new java.util.ArrayList<>();
            for (String permissionIdStr : permissionIds) {
                permissionIdList.add(Integer.parseInt(permissionIdStr));
            }
            
            boolean success = authService.revokeMultiplePermissionsFromRole(roleId, permissionIdList, revokedBy);
            
            JsonObject result = new JsonObject();
            result.addProperty("success", success);
            result.addProperty("message", success ? "Permissions revoked successfully" : "Some permissions failed to revoke");
            
            sendJsonResponse(response, result);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid ID format");
        }
    }

    // ==================== UTILITY METHODS ====================

    /**
     * Check if current user has permission management rights
     */
    private boolean hasManagementPermission(HttpServletRequest request) {
        int userId = getCurrentUserId(request);
        return authService.canManagePermissions(userId);
    }

    /**
     * Get current user ID from session
     */
    private int getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return 0;
        }
        
        User user = (User) session.getAttribute("acc");
        return user != null ? user.getUserId() : 0;
    }

    /**
     * Check if request is AJAX
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        return "XMLHttpRequest".equals(requestedWith) || 
               "application/json".equals(request.getHeader("Accept"));
    }

    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    /**
     * Send error response
     */
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        JsonObject error = new JsonObject();
        error.addProperty("error", message);
        sendJsonResponse(response, error);
    }

    /**
     * Handle exceptions
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        e.printStackTrace();
        
        if (isAjaxRequest(request)) {
            sendErrorResponse(response, "Internal server error: " + e.getMessage());
        } else {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Permission Management Servlet for handling authorization operations";
    }
}