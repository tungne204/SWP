package entity;

import java.util.Date;

public class UserPermission {
    private int userPermissionId;
    private int userId;
    private int permissionId;
    private boolean granted;
    private Integer grantedBy; // User ID who granted this permission
    private Date grantedDate;
    private Date expiryDate; // Optional expiry for temporary permissions
    
    // Additional fields for joined data
    private String username;
    private String permissionName;
    private String permissionCode;

    public UserPermission() {
    }

    public UserPermission(int userPermissionId, int userId, int permissionId, 
                         boolean granted, Integer grantedBy, Date grantedDate, Date expiryDate) {
        this.userPermissionId = userPermissionId;
        this.userId = userId;
        this.permissionId = permissionId;
        this.granted = granted;
        this.grantedBy = grantedBy;
        this.grantedDate = grantedDate;
        this.expiryDate = expiryDate;
    }

    // Constructor for creating new user permission
    public UserPermission(int userId, int permissionId, boolean granted, Integer grantedBy) {
        this.userId = userId;
        this.permissionId = permissionId;
        this.granted = granted;
        this.grantedBy = grantedBy;
    }

    // Constructor with expiry date
    public UserPermission(int userId, int permissionId, boolean granted, Integer grantedBy, Date expiryDate) {
        this.userId = userId;
        this.permissionId = permissionId;
        this.granted = granted;
        this.grantedBy = grantedBy;
        this.expiryDate = expiryDate;
    }

    // Getters and Setters
    public int getUserPermissionId() {
        return userPermissionId;
    }

    public void setUserPermissionId(int userPermissionId) {
        this.userPermissionId = userPermissionId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    // Helper method to check if permission is expired
    public boolean isExpired() {
        if (expiryDate == null) {
            return false; // No expiry date means never expires
        }
        return new Date().after(expiryDate);
    }

    // Helper method to check if permission is currently valid
    public boolean isValid() {
        return granted && !isExpired();
    }

    @Override
    public String toString() {
        return "UserPermission{" +
                "userPermissionId=" + userPermissionId +
                ", userId=" + userId +
                ", permissionId=" + permissionId +
                ", granted=" + granted +
                ", grantedBy=" + grantedBy +
                ", grantedDate=" + grantedDate +
                ", expiryDate=" + expiryDate +
                ", username='" + username + '\'' +
                ", permissionName='" + permissionName + '\'' +
                ", permissionCode='" + permissionCode + '\'' +
                '}';
    }
}