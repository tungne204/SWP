package service;

import dao.PermissionDAO;
import entity.*;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

/**
 * Service class for handling authorization and permission management business logic
 */
public class AuthorizationService {
    
    private PermissionDAO permissionDAO;
    
    public AuthorizationService() {
        this.permissionDAO = new PermissionDAO();
    }
    
    // ==================== PERMISSION MANAGEMENT ====================
    
    /**
     * Get all available permissions
     */
    public List<Permission> getAllPermissions() {
        return permissionDAO.getAllPermissions();
    }
    
    /**
     * Get permissions by module
     */
    public List<Permission> getPermissionsByModule(String module) {
        return permissionDAO.getPermissionsByModule(module);
    }
    
    /**
     * Get permission by code
     */
    public Permission getPermissionByCode(String permissionCode) {
        return permissionDAO.getPermissionByCode(permissionCode);
    }
    
    // ==================== ROLE PERMISSION MANAGEMENT ====================
    
    /**
     * Get all permissions assigned to a role
     */
    public List<Permission> getRolePermissions(int roleId) {
        return permissionDAO.getPermissionsByRole(roleId);
    }
    
    /**
     * Check if a role has a specific permission
     */
    public boolean checkRolePermission(int roleId, String permissionCode) {
        return permissionDAO.hasRolePermission(roleId, permissionCode);
    }
    
    /**
     * Grant permission to role
     */
    public boolean grantPermissionToRole(int roleId, int permissionId, int grantedBy) {
        // Validate inputs
        if (roleId <= 0 || permissionId <= 0 || grantedBy <= 0) {
            return false;
        }
        
        // Check if permission already exists for this role
        Permission permission = permissionDAO.getPermissionByCode(getPermissionCodeById(permissionId));
        if (permission != null && permissionDAO.hasRolePermission(roleId, permission.getPermissionCode())) {
            return false; // Permission already granted
        }
        
        return permissionDAO.grantPermissionToRole(roleId, permissionId, grantedBy);
    }
    
    /**
     * Revoke permission from role
     */
    public boolean revokePermissionFromRole(int roleId, int permissionId, int revokedBy) {
        // Validate inputs
        if (roleId <= 0 || permissionId <= 0 || revokedBy <= 0) {
            return false;
        }
        
        return permissionDAO.revokePermissionFromRole(roleId, permissionId, revokedBy);
    }
    
    /**
     * Bulk grant permissions to role
     */
    public boolean grantMultiplePermissionsToRole(int roleId, List<Integer> permissionIds, int grantedBy) {
        boolean allSuccess = true;
        for (Integer permissionId : permissionIds) {
            if (!grantPermissionToRole(roleId, permissionId, grantedBy)) {
                allSuccess = false;
            }
        }
        return allSuccess;
    }
    
    /**
     * Bulk revoke permissions from role
     */
    public boolean revokeMultiplePermissionsFromRole(int roleId, List<Integer> permissionIds, int revokedBy) {
        boolean allSuccess = true;
        for (Integer permissionId : permissionIds) {
            if (!revokePermissionFromRole(roleId, permissionId, revokedBy)) {
                allSuccess = false;
            }
        }
        return allSuccess;
    }
    
    // ==================== USER PERMISSION MANAGEMENT ====================
    
    /**
     * Get all effective permissions for a user (role + user-specific permissions)
     */
    public List<Permission> getUserEffectivePermissions(int userId) {
        return permissionDAO.getEffectivePermissionsForUser(userId);
    }
    
    /**
     * Check if user has specific permission
     */
    public boolean checkUserPermission(int userId, String permissionCode) {
        return permissionDAO.hasUserPermission(userId, permissionCode);
    }
    
    /**
     * Grant specific permission to user
     */
    public boolean grantPermissionToUser(int userId, int permissionId, int grantedBy, Date expiryDate) {
        // Validate inputs
        if (userId <= 0 || permissionId <= 0 || grantedBy <= 0) {
            return false;
        }
        
        // Check if expiry date is in the past
        if (expiryDate != null && expiryDate.before(new Date())) {
            return false;
        }
        
        return permissionDAO.grantPermissionToUser(userId, permissionId, grantedBy, expiryDate);
    }
    
    /**
     * Revoke specific permission from user
     */
    public boolean revokePermissionFromUser(int userId, int permissionId, int revokedBy) {
        // Validate inputs
        if (userId <= 0 || permissionId <= 0 || revokedBy <= 0) {
            return false;
        }
        
        return permissionDAO.revokePermissionFromUser(userId, permissionId, revokedBy);
    }
    
    // ==================== AUTHORIZATION CHECKS ====================
    
    /**
     * Check if user can access a specific resource with given action
     */
    public boolean canUserAccess(int userId, String resource, String action) {
        List<Permission> userPermissions = getUserEffectivePermissions(userId);
        
        for (Permission permission : userPermissions) {
            if (matchesPermission(permission, resource, action)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Check if user can access a specific module
     */
    public boolean canUserAccessModule(int userId, String module) {
        List<Permission> userPermissions = getUserEffectivePermissions(userId);
        
        for (Permission permission : userPermissions) {
            if (module.equals(permission.getModule())) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Get accessible modules for user
     */
    public Set<String> getUserAccessibleModules(int userId) {
        List<Permission> userPermissions = getUserEffectivePermissions(userId);
        Set<String> modules = new HashSet<>();
        
        for (Permission permission : userPermissions) {
            if (permission.getModule() != null && !permission.getModule().trim().isEmpty()) {
                modules.add(permission.getModule());
            }
        }
        return modules;
    }
    
    /**
     * Check multiple permissions at once
     */
    public boolean hasAllPermissions(int userId, List<String> permissionCodes) {
        for (String permissionCode : permissionCodes) {
            if (!checkUserPermission(userId, permissionCode)) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Check if user has any of the specified permissions
     */
    public boolean hasAnyPermission(int userId, List<String> permissionCodes) {
        for (String permissionCode : permissionCodes) {
            if (checkUserPermission(userId, permissionCode)) {
                return true;
            }
        }
        return false;
    }
    
    // ==================== AUDIT AND LOGGING ====================
    
    /**
     * Get audit logs with pagination
     */
    public List<AuditLog> getAuditLogs(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return permissionDAO.getAuditLogs(offset, pageSize);
    }
    
    /**
     * Log custom audit action
     */
    public void logAuditAction(int userId, String actionType, Integer targetUserId, 
                              Integer targetRoleId, Integer permissionId, 
                              String oldValue, String newValue, String description) {
        permissionDAO.logAuditAction(userId, actionType, targetUserId, targetRoleId, 
                                   permissionId, oldValue, newValue, description);
    }
    
    // ==================== UTILITY METHODS ====================
    
    /**
     * Check if permission matches resource and action
     */
    private boolean matchesPermission(Permission permission, String resource, String action) {
        // Exact match
        if (resource.equals(permission.getResource()) && action.equals(permission.getAction())) {
            return true;
        }
        
        // Wildcard resource match
        if ("*".equals(permission.getResource())) {
            return action.equals(permission.getAction()) || "*".equals(permission.getAction());
        }
        
        // Wildcard action match
        if ("*".equals(permission.getAction())) {
            return resource.equals(permission.getResource());
        }
        
        // Both wildcards
        if ("*".equals(permission.getResource()) && "*".equals(permission.getAction())) {
            return true;
        }
        
        // Pattern matching for resources (e.g., /admin/* matches /admin/users)
        if (permission.getResource().endsWith("/*")) {
            String baseResource = permission.getResource().substring(0, permission.getResource().length() - 2);
            if (resource.startsWith(baseResource)) {
                return action.equals(permission.getAction()) || "*".equals(permission.getAction());
            }
        }
        
        return false;
    }
    
    /**
     * Get permission code by permission ID (helper method)
     */
    private String getPermissionCodeById(int permissionId) {
        List<Permission> allPermissions = getAllPermissions();
        for (Permission permission : allPermissions) {
            if (permission.getPermissionId() == permissionId) {
                return permission.getPermissionCode();
            }
        }
        return null;
    }
    
    /**
     * Validate permission data
     */
    public boolean isValidPermission(Permission permission) {
        return permission != null 
            && permission.getPermissionName() != null && !permission.getPermissionName().trim().isEmpty()
            && permission.getPermissionCode() != null && !permission.getPermissionCode().trim().isEmpty()
            && permission.getModule() != null && !permission.getModule().trim().isEmpty()
            && permission.getAction() != null && !permission.getAction().trim().isEmpty()
            && permission.getResource() != null && !permission.getResource().trim().isEmpty();
    }
    
    /**
     * Check if user is admin (has admin role or admin permissions)
     */
    public boolean isUserAdmin(int userId) {
        return checkUserPermission(userId, "SYSTEM_CONFIG") || 
               canUserAccessModule(userId, "SYSTEM") ||
               checkUserPermission(userId, "USER_CREATE") ||
               checkUserPermission(userId, "ROLE_CREATE");
    }
    
    /**
     * Check if user can manage permissions
     */
    public boolean canManagePermissions(int userId) {
        return checkUserPermission(userId, "PERMISSION_VIEW") ||
               checkUserPermission(userId, "PERMISSION_CREATE") ||
               checkUserPermission(userId, "PERMISSION_UPDATE") ||
               checkUserPermission(userId, "ROLE_PERMISSION_MANAGE") ||
               checkUserPermission(userId, "SYSTEM_CONFIG");
    }
    
    /**
     * Check if user can manage roles
     */
    public boolean canManageRoles(int userId) {
        return checkUserPermission(userId, "MANAGE_ROLES") ||
               checkUserPermission(userId, "ADMIN_ACCESS") ||
               checkUserPermission(userId, "SYSTEM_ADMIN");
    }
    
    /**
     * Check if user can manage other users
     */
    public boolean canManageUsers(int userId) {
        return checkUserPermission(userId, "MANAGE_USERS") ||
               checkUserPermission(userId, "ADMIN_ACCESS") ||
               checkUserPermission(userId, "SYSTEM_ADMIN");
    }
}