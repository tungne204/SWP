package entity;

import java.util.Date;

public class RolePermission {
    private int rolePermissionId;
    private int roleId;
    private int permissionId;
    private boolean granted;
    private Integer grantedBy; // User ID who granted this permission
    private Date grantedDate;
    
    // Additional fields for joined data
    private String roleName;
    private String permissionName;
    private String permissionCode;

    public RolePermission() {
    }

    public RolePermission(int rolePermissionId, int roleId, int permissionId, 
                         boolean granted, Integer grantedBy, Date grantedDate) {
        this.rolePermissionId = rolePermissionId;
        this.roleId = roleId;
        this.permissionId = permissionId;
        this.granted = granted;
        this.grantedBy = grantedBy;
        this.grantedDate = grantedDate;
    }

    // Constructor for creating new role permission
    public RolePermission(int roleId, int permissionId, boolean granted, Integer grantedBy) {
        this.roleId = roleId;
        this.permissionId = permissionId;
        this.granted = granted;
        this.grantedBy = grantedBy;
    }

    // Getters and Setters
    public int getRolePermissionId() {
        return rolePermissionId;
    }

    public void setRolePermissionId(int rolePermissionId) {
        this.rolePermissionId = rolePermissionId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getPermissionId() {
        return permissionId;
    }

    public void setPermissionId(int permissionId) {
        this.permissionId = permissionId;
    }

    public boolean isGranted() {
        return granted;
    }

    public void setGranted(boolean granted) {
        this.granted = granted;
    }

    public Integer getGrantedBy() {
        return grantedBy;
    }

    public void setGrantedBy(Integer grantedBy) {
        this.grantedBy = grantedBy;
    }

    public Date getGrantedDate() {
        return grantedDate;
    }

    public void setGrantedDate(Date grantedDate) {
        this.grantedDate = grantedDate;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getPermissionName() {
        return permissionName;
    }

    public void setPermissionName(String permissionName) {
        this.permissionName = permissionName;
    }

    public String getPermissionCode() {
        return permissionCode;
    }

    public void setPermissionCode(String permissionCode) {
        this.permissionCode = permissionCode;
    }

    @Override
    public String toString() {
        return "RolePermission{" +
                "rolePermissionId=" + rolePermissionId +
                ", roleId=" + roleId +
                ", permissionId=" + permissionId +
                ", granted=" + granted +
                ", grantedBy=" + grantedBy +
                ", grantedDate=" + grantedDate +
                ", roleName='" + roleName + '\'' +
                ", permissionName='" + permissionName + '\'' +
                ", permissionCode='" + permissionCode + '\'' +
                '}';
    }
}