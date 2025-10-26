package dao;

import context.DBContext;
import entity.User;
import entity.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;

public class UserDAO extends DBContext {

    // ✅ Login
    public User login(String email, String password) {
        String sql = "SELECT * FROM [User] WHERE email = ? AND password = ? AND status = 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getInt("role_id"),
                        rs.getBoolean("status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Check email tồn tại chưa
    public boolean checkEmailExists(String email) {
        String sql = "SELECT 1 FROM [User] WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // true nếu đã tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Thêm user mới (mặc định role_id = 3 (Patient), status = 1)
    public void register(String username, String password, String email, String phone) {
        String sql = "INSERT INTO [User](username, password, email, phone, role_id, status) VALUES (?, ?, ?, ?, 3, 1)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Tìm user theo email
    public User findByEmail(String email) {
        String sql = "SELECT * FROM [User] WHERE email = ? AND status = 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getInt("role_id"),
                        rs.getBoolean("status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Đăng ký user mới từ Google (mặc định role_id = 3 (Patient), status = 1)
    public void registerGoogleUser(String username, String password, String email, String phone) {
        String sql = "INSERT INTO [User](username, password, email, phone, role_id, status) VALUES (?, ?, ?, ?, 3, 1)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // ✅ Lưu token reset vào DB
public void saveResetToken(String email, String token) {
    String sql = "UPDATE [User] SET reset_token = ?, reset_expiry = DATEADD(MINUTE, 30, GETDATE()) WHERE email = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, token);
        ps.setString(2, email);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

// ✅ Tìm email theo token
public String findEmailByToken(String token) {
    String sql = "SELECT email FROM [User] WHERE reset_token = ? AND reset_expiry > GETDATE()";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, token);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getString("email");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

// ✅ Kiểm tra mật khẩu cũ có đúng không
public boolean checkPassword(String email, String oldPassword) {
    String sql = "SELECT 1 FROM [User] WHERE email = ? AND password = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.setString(2, oldPassword);
        ResultSet rs = ps.executeQuery();
        return rs.next();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
// ✅ Cập nhật mật khẩu
public void updatePassword(String email, String newPassword) {
    String sql = "UPDATE [User] SET password = ? WHERE email = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, newPassword);
        ps.setString(2, email);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

// ✅ Xóa token sau khi dùng
public void clearToken(String token) {
    String sql = "UPDATE [User] SET reset_token = NULL, reset_expiry = NULL WHERE reset_token = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, token);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

// ✅ Get all users with their role information
public List<User> getAllUsersWithRole() {
    List<User> users = new ArrayList<>();
    String sql = "SELECT u.user_id, u.username, u.password, u.email, u.phone, u.role_id, u.status, r.role_name " +
                 "FROM [User] u LEFT JOIN [Role] r ON u.role_id = r.role_id " +
                 "WHERE u.status = 1 ORDER BY u.user_id";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            User user = new User(
                rs.getInt("user_id"),
                rs.getString("username"),
                rs.getString("password"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getInt("role_id"),
                rs.getBoolean("status")
            );
            user.setRoleName(rs.getString("role_name"));
            users.add(user);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return users;
}

// ✅ Get all roles
public List<Role> getAllRoles() {
    List<Role> roles = new ArrayList<>();
    String sql = "SELECT role_id, role_name FROM [Role] ORDER BY role_id";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            Role role = new Role();
            role.setRoleId(rs.getInt("role_id"));
            role.setRoleName(rs.getString("role_name"));
            roles.add(role);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return roles;
}

// ✅ Update user role
public void updateUserRole(int userId, int roleId) {
    String sql = "UPDATE [User] SET role_id = ? WHERE user_id = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, roleId);
        ps.setInt(2, userId);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

}
