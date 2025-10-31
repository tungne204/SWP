/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.ListUser;

/**
 *
 * @author Quang Anh
 */
import java.sql.Timestamp;

public class User {

    private int userId;
    private String username;
    private String password;
    private String email;
    private String phone;
    private int roleId;
    private String roleName;
    private boolean status;
    private String resetToken;
    private Timestamp resetExpiry;
    private boolean isBanned;

    // Constructors
    public User() {
    }

    public User(int userId, String username, String password, String email,
            String phone, int roleId, boolean status) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.roleId = roleId;
        this.status = status;
    }

    public boolean isBanned() {
        return isBanned;
    }

    public void setBanned(boolean banned) {
        isBanned = banned;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public Timestamp getResetExpiry() {
        return resetExpiry;
    }

    public void setResetExpiry(Timestamp resetExpiry) {
        this.resetExpiry = resetExpiry;
    }

    @Override
    public String toString() {
        return "User{"
                + "userId=" + userId
                + ", username='" + username + '\''
                + ", email='" + email + '\''
                + ", phone='" + phone + '\''
                + ", roleId=" + roleId
                + ", roleName='" + roleName + '\''
                + ", status=" + status
                + '}';
    }
}
