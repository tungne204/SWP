package entity;

import java.util.Date;

public class Permission {
    private int permissionId;
    private String permissionName;
    private String permissionCode;
    private String description;
    private String module;
    private String action;
    private String resource;
    private boolean isActive;
    private Date createdDate;
    private Date updatedDate;

    public Permission() {
    }

    public Permission(int permissionId, String permissionName, String permissionCode, 
                     String description, String module, String action, String resource, 
                     boolean isActive, Date createdDate, Date updatedDate) {
        this.permissionId = permissionId;
        this.permissionName = permissionName;
        this.permissionCode = permissionCode;
        this.description = description;
        this.module = module;
        this.action = action;
        this.resource = resource;
        this.isActive = isActive;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // Constructor without dates (for creation)
    public Permission(String permissionName, String permissionCode, String description, 
                     String module, String action, String resource) {
        this.permissionName = permissionName;
        this.permissionCode = permissionCode;
        this.description = description;
        this.module = module;
        this.action = action;
        this.resource = resource;
        this.isActive = true;
    }

    // Getters and Setters
    public int getPermissionId() {
        return permissionId;
    }

    public void setPermissionId(int permissionId) {
        this.permissionId = permissionId;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getResource() {
        return resource;
    }

    public void setResource(String resource) {
        this.resource = resource;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }

    @Override
    public String toString() {
        return "Permission{" +
                "permissionId=" + permissionId +
                ", permissionName='" + permissionName + '\'' +
                ", permissionCode='" + permissionCode + '\'' +
                ", description='" + description + '\'' +
                ", module='" + module + '\'' +
                ", action='" + action + '\'' +
                ", resource='" + resource + '\'' +
                ", isActive=" + isActive +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                '}';
    }
}