package entity;

import java.util.Date;

public class AuditLog {
    private int auditId;
    private int userId; // User who performed the action
    private String actionType; // 'GRANT_PERMISSION', 'REVOKE_PERMISSION', 'ROLE_CHANGE', etc.
    private Integer targetUserId; // User affected by the action
    private Integer targetRoleId; // Role affected by the action
    private Integer permissionId; // Permission affected by the action
    private String oldValue; // Previous value
    private String newValue; // New value
    private String description;
    private String ipAddress;
    private String userAgent;
    private Date createdDate;
    
    // Additional fields for joined data
    private String username;
    private String targetUsername;
    private String roleName;
    private String permissionName;

    public AuditLog() {
    }

    public AuditLog(int auditId, int userId, String actionType, Integer targetUserId, 
                   Integer targetRoleId, Integer permissionId, String oldValue, String newValue, 
                   String description, String ipAddress, String userAgent, Date createdDate) {
        this.auditId = auditId;
        this.userId = userId;
        this.actionType = actionType;
        this.targetUserId = targetUserId;
        this.targetRoleId = targetRoleId;
        this.permissionId = permissionId;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.description = description;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
        this.createdDate = createdDate;
    }

    // Constructor for creating new audit log
    public AuditLog(int userId, String actionType, String description) {
        this.userId = userId;
        this.actionType = actionType;
        this.description = description;
    }

    // Constructor with target user
    public AuditLog(int userId, String actionType, Integer targetUserId, String description) {
        this.userId = userId;
        this.actionType = actionType;
        this.targetUserId = targetUserId;
        this.description = description;
    }

    // Constructor with permission change
    public AuditLog(int userId, String actionType, Integer targetUserId, Integer permissionId, 
                   String oldValue, String newValue, String description) {
        this.userId = userId;
        this.actionType = actionType;
        this.targetUserId = targetUserId;
        this.permissionId = permissionId;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.description = description;
    }

    // Getters and Setters
    public int getAuditId() {
        return auditId;
    }

    public void setAuditId(int auditId) {
        this.auditId = auditId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public Integer getTargetUserId() {
        return targetUserId;
    }

    public void setTargetUserId(Integer targetUserId) {
        this.targetUserId = targetUserId;
    }

    public Integer getTargetRoleId() {
        return targetRoleId;
    }

    public void setTargetRoleId(Integer targetRoleId) {
        this.targetRoleId = targetRoleId;
    }

    public Integer getPermissionId() {
        return permissionId;
    }

    public void setPermissionId(Integer permissionId) {
        this.permissionId = permissionId;
    }

    public String getOldValue() {
        return oldValue;
    }

    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getTargetUsername() {
        return targetUsername;
    }

    public void setTargetUsername(String targetUsername) {
        this.targetUsername = targetUsername;
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

    @Override
    public String toString() {
        return "AuditLog{" +
                "auditId=" + auditId +
                ", userId=" + userId +
                ", actionType='" + actionType + '\'' +
                ", targetUserId=" + targetUserId +
                ", targetRoleId=" + targetRoleId +
                ", permissionId=" + permissionId +
                ", oldValue='" + oldValue + '\'' +
                ", newValue='" + newValue + '\'' +
                ", description='" + description + '\'' +
                ", ipAddress='" + ipAddress + '\'' +
                ", userAgent='" + userAgent + '\'' +
                ", createdDate=" + createdDate +
                '}';
    }
}