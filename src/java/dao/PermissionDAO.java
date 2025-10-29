package dao;

import context.DBContext;
import entity.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PermissionDAO extends DBContext {

    // ==================== PERMISSION OPERATIONS ====================
    
    /**
     * Get all permissions
     */
    public List<Permission> getAllPermissions() {
        List<Permission> permissions = new ArrayList<>();
        String sql = "SELECT * FROM Permission WHERE is_active = 1 ORDER BY module, permission_name";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Permission permission = new Permission(
                    rs.getInt("permission_id"),
                    rs.getString("permission_name"),
                    rs.getString("permission_code"),
                    rs.getString("description"),
                    rs.getString("module"),
                    rs.getString("action"),
                    rs.getString("resource"),
                    rs.getBoolean("is_active"),
                    rs.getTimestamp("created_date"),
                    rs.getTimestamp("updated_date")
                );
                permissions.add(permission);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return permissions;
    }

    /**
     * Get permissions by module
     */
    public List<Permission> getPermissionsByModule(String module) {
        List<Permission> permissions = new ArrayList<>();
        String sql = "SELECT * FROM Permission WHERE module = ? AND is_active = 1 ORDER BY permission_name";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, module);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Permission permission = new Permission(
                    rs.getInt("permission_id"),
                    rs.getString("permission_name"),
                    rs.getString("permission_code"),
                    rs.getString("description"),
                    rs.getString("module"),
                    rs.getString("action"),
                    rs.getString("resource"),
                    rs.getBoolean("is_active"),
                    rs.getTimestamp("created_date"),
                    rs.getTimestamp("updated_date")
                );
                permissions.add(permission);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return permissions;
    }

    /**
     * Get permission by code
     */
    public Permission getPermissionByCode(String permissionCode) {
        String sql = "SELECT * FROM Permission WHERE permission_code = ? AND is_active = 1";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, permissionCode);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Permission(
                    rs.getInt("permission_id"),
                    rs.getString("permission_name"),
                    rs.getString("permission_code"),
                    rs.getString("description"),
                    rs.getString("module"),
                    rs.getString("action"),
                    rs.getString("resource"),
                    rs.getBoolean("is_active"),
                    rs.getTimestamp("created_date"),
                    rs.getTimestamp("updated_date")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==================== ROLE PERMISSION OPERATIONS ====================
    
    /**
     * Get all permissions for a specific role
     */
    public List<Permission> getPermissionsByRole(int roleId) {
        List<Permission> permissions = new ArrayList<>();
        String sql = "SELECT p.* FROM Permission p " +
                    "INNER JOIN RolePermission rp ON p.permission_id = rp.permission_id " +
                    "WHERE rp.role_id = ? AND rp.granted = 1 AND p.is_active = 1 " +
                    "ORDER BY p.module, p.permission_name";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Permission permission = new Permission(
                    rs.getInt("permission_id"),
                    rs.getString("permission_name"),
                    rs.getString("permission_code"),
                    rs.getString("description"),
                    rs.getString("module"),
                    rs.getString("action"),
                    rs.getString("resource"),
                    rs.getBoolean("is_active"),
                    rs.getTimestamp("created_date"),
                    rs.getTimestamp("updated_date")
                );
                permissions.add(permission);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return permissions;
    }

    /**
     * Check if a role has a specific permission
     */
    public boolean hasRolePermission(int roleId, String permissionCode) {
        String sql = "SELECT 1 FROM RolePermission rp " +
                    "INNER JOIN Permission p ON rp.permission_id = p.permission_id " +
                    "WHERE rp.role_id = ? AND p.permission_code = ? AND rp.granted = 1 AND p.is_active = 1";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, roleId);
            ps.setString(2, permissionCode);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Grant permission to role
     */
    public boolean grantPermissionToRole(int roleId, int permissionId, int grantedBy) {
        String sql = "INSERT INTO RolePermission (role_id, permission_id, granted, granted_by, granted_date) " +
                    "VALUES (?, ?, 1, ?, GETDATE())";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, roleId);
            ps.setInt(2, permissionId);
            ps.setInt(3, grantedBy);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                // Log the action
                logAuditAction(grantedBy, "GRANT_ROLE_PERMISSION", null, roleId, permissionId, 
                              "false", "true", "Granted permission to role");
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Revoke permission from role
     */
    public boolean revokePermissionFromRole(int roleId, int permissionId, int revokedBy) {
        String sql = "UPDATE RolePermission SET granted = 0, granted_by = ?, granted_date = GETDATE() " +
                    "WHERE role_id = ? AND permission_id = ?";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, revokedBy);
            ps.setInt(2, roleId);
            ps.setInt(3, permissionId);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                // Log the action
                logAuditAction(revokedBy, "REVOKE_ROLE_PERMISSION", null, roleId, permissionId, 
                              "true", "false", "Revoked permission from role");
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== USER PERMISSION OPERATIONS ====================
    
    /**
     * Get all permissions for a specific user (including role permissions and user-specific permissions)
     */
    public List<Permission> getEffectivePermissionsForUser(int userId) {
        List<Permission> permissions = new ArrayList<>();
        String sql = "SELECT DISTINCT p.* FROM Permission p " +
                    "WHERE p.is_active = 1 AND (" +
                    // Role permissions
                    "EXISTS (SELECT 1 FROM RolePermission rp " +
                    "        INNER JOIN [User] u ON u.role_id = rp.role_id " +
                    "        WHERE u.user_id = ? AND rp.permission_id = p.permission_id AND rp.granted = 1) " +
                    "OR " +
                    // User-specific permissions (not expired)
                    "EXISTS (SELECT 1 FROM UserPermission up " +
                    "        WHERE up.user_id = ? AND up.permission_id = p.permission_id " +
                    "        AND up.granted = 1 AND (up.expiry_date IS NULL OR up.expiry_date > GETDATE()))" +
                    ") " +
                    // Exclude explicitly denied user permissions
                    "AND NOT EXISTS (SELECT 1 FROM UserPermission up " +
                    "                WHERE up.user_id = ? AND up.permission_id = p.permission_id " +
                    "                AND up.granted = 0 AND (up.expiry_date IS NULL OR up.expiry_date > GETDATE())) " +
                    "ORDER BY p.module, p.permission_name";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Permission permission = new Permission(
                    rs.getInt("permission_id"),
                    rs.getString("permission_name"),
                    rs.getString("permission_code"),
                    rs.getString("description"),
                    rs.getString("module"),
                    rs.getString("action"),
                    rs.getString("resource"),
                    rs.getBoolean("is_active"),
                    rs.getTimestamp("created_date"),
                    rs.getTimestamp("updated_date")
                );
                permissions.add(permission);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return permissions;
    }

    /**
     * Check if user has specific permission
     */
    public boolean hasUserPermission(int userId, String permissionCode) {
        String sql = "SELECT 1 FROM Permission p " +
                    "WHERE p.permission_code = ? AND p.is_active = 1 AND (" +
                    // Role permissions
                    "EXISTS (SELECT 1 FROM RolePermission rp " +
                    "        INNER JOIN [User] u ON u.role_id = rp.role_id " +
                    "        WHERE u.user_id = ? AND rp.permission_id = p.permission_id AND rp.granted = 1) " +
                    "OR " +
                    // User-specific permissions (not expired)
                    "EXISTS (SELECT 1 FROM UserPermission up " +
                    "        WHERE up.user_id = ? AND up.permission_id = p.permission_id " +
                    "        AND up.granted = 1 AND (up.expiry_date IS NULL OR up.expiry_date > GETDATE()))" +
                    ") " +
                    // Exclude explicitly denied user permissions
                    "AND NOT EXISTS (SELECT 1 FROM UserPermission up " +
                    "                WHERE up.user_id = ? AND up.permission_id = p.permission_id " +
                    "                AND up.granted = 0 AND (up.expiry_date IS NULL OR up.expiry_date > GETDATE()))";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, permissionCode);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ps.setInt(4, userId);
            
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Grant specific permission to user
     */
    public boolean grantPermissionToUser(int userId, int permissionId, int grantedBy, Date expiryDate) {
        String sql = "INSERT INTO UserPermission (user_id, permission_id, granted, granted_by, granted_date, expiry_date) " +
                    "VALUES (?, ?, 1, ?, GETDATE(), ?)";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, permissionId);
            ps.setInt(3, grantedBy);
            if (expiryDate != null) {
                ps.setTimestamp(4, new java.sql.Timestamp(expiryDate.getTime()));
            } else {
                ps.setNull(4, java.sql.Types.TIMESTAMP);
            }
            
            int result = ps.executeUpdate();
            if (result > 0) {
                // Log the action
                logAuditAction(grantedBy, "GRANT_USER_PERMISSION", userId, null, permissionId, 
                              "false", "true", "Granted permission to user");
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Revoke specific permission from user
     */
    public boolean revokePermissionFromUser(int userId, int permissionId, int revokedBy) {
        String sql = "UPDATE UserPermission SET granted = 0, granted_by = ?, granted_date = GETDATE() " +
                    "WHERE user_id = ? AND permission_id = ?";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, revokedBy);
            ps.setInt(2, userId);
            ps.setInt(3, permissionId);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                // Log the action
                logAuditAction(revokedBy, "REVOKE_USER_PERMISSION", userId, null, permissionId, 
                              "true", "false", "Revoked permission from user");
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== AUDIT LOG OPERATIONS ====================
    
    /**
     * Log audit action
     */
    public void logAuditAction(int userId, String actionType, Integer targetUserId, 
                              Integer targetRoleId, Integer permissionId, 
                              String oldValue, String newValue, String description) {
        String sql = "INSERT INTO AuditLog (user_id, action_type, target_user_id, target_role_id, " +
                    "permission_id, old_value, new_value, description, created_date) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, actionType);
            if (targetUserId != null) {
                ps.setInt(3, targetUserId);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            if (targetRoleId != null) {
                ps.setInt(4, targetRoleId);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            if (permissionId != null) {
                ps.setInt(5, permissionId);
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.setString(6, oldValue);
            ps.setString(7, newValue);
            ps.setString(8, description);
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Get audit logs with pagination
     */
    public List<AuditLog> getAuditLogs(int offset, int limit) {
        List<AuditLog> logs = new ArrayList<>();
        String sql = "SELECT a.*, u.username, tu.username as target_username, r.role_name, p.permission_name " +
                    "FROM AuditLog a " +
                    "LEFT JOIN [User] u ON a.user_id = u.user_id " +
                    "LEFT JOIN [User] tu ON a.target_user_id = tu.user_id " +
                    "LEFT JOIN Role r ON a.target_role_id = r.role_id " +
                    "LEFT JOIN Permission p ON a.permission_id = p.permission_id " +
                    "ORDER BY a.created_date DESC " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AuditLog log = new AuditLog(
                    rs.getInt("audit_id"),
                    rs.getInt("user_id"),
                    rs.getString("action_type"),
                    rs.getObject("target_user_id", Integer.class),
                    rs.getObject("target_role_id", Integer.class),
                    rs.getObject("permission_id", Integer.class),
                    rs.getString("old_value"),
                    rs.getString("new_value"),
                    rs.getString("description"),
                    rs.getString("ip_address"),
                    rs.getString("user_agent"),
                    rs.getTimestamp("created_date")
                );
                log.setUsername(rs.getString("username"));
                log.setTargetUsername(rs.getString("target_username"));
                log.setRoleName(rs.getString("role_name"));
                log.setPermissionName(rs.getString("permission_name"));
                logs.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logs;
    }
}