package dao;

import context.DBContext;
import entity.Role;
import entity.User;
import util.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO extends DBContext {

    // ✅ Login - Verify password hash
    public User login(String email, String password) {
        String sql = "SELECT * FROM [User] WHERE email = ? AND status = 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");
                
                // Verify password hash
                if (PasswordUtil.verifyPassword(password, storedHash)) {
                    return new User(
                            rs.getInt("user_id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("avatar"),
                            rs.getInt("role_id"),
                            rs.getBoolean("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Check email tồn tại chưa
    public boolean checkEmailExists(String email) {
        String sql = "SELECT 1 FROM [User] WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // true nếu đã tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Thêm user mới (mặc định role_id = 3 (Patient), status = 1) - Hash password
    public void register(String username, String password, String email, String phone) {
        String sql = "INSERT INTO [User](username, password, email, phone, role_id, status) VALUES (?, ?, ?, ?, 3, 1)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            // Hash password before storing
            ps.setString(2, PasswordUtil.hashPassword(password));
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Tìm user theo email với role name
    public User findByEmail(String email) {
        String sql = """
            SELECT u.*, r.role_name 
            FROM [User] u 
            LEFT JOIN [Role] r ON u.role_id = r.role_id 
            WHERE u.email = ? AND u.status = 1
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("avatar"),
                        rs.getInt("role_id"),
                        rs.getBoolean("status")
                );
                user.setRoleName(rs.getString("role_name"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Dang ky user moi tu Google (mac dinh role_id = 3 (Patient), status = 1) - Hash password
    public void registerGoogleUser(String username, String password, String email, String phone, String avatar) {
        String sql = "INSERT INTO [User](username, password, email, phone, avatar, role_id, status) VALUES (?, ?, ?, ?, ?, 3, 1)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            // Hash password before storing (even for Google users)
            ps.setString(2, PasswordUtil.hashPassword(password));
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, avatar);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // ✅ Lưu token reset vào DB

    public void saveResetToken(String email, String token) {
        String sql = "UPDATE [User] SET reset_token = ?, reset_expiry = DATEADD(MINUTE, 30, GETDATE()) WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

// ✅ Kiểm tra mật khẩu cũ có đúng không - Verify password hash
    public boolean checkPassword(String email, String oldPassword) {
        String sql = "SELECT password FROM [User] WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password");
                // Verify password hash
                return PasswordUtil.verifyPassword(oldPassword, storedHash);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
// ✅ Cập nhật mật khẩu - Hash password

    public void updatePassword(String email, String newPassword) {
        String sql = "UPDATE [User] SET password = ? WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            // Hash password before storing
            ps.setString(1, PasswordUtil.hashPassword(newPassword));
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

// ✅ Xóa token sau khi dùng
    public void clearToken(String token) {
        String sql = "UPDATE [User] SET reset_token = NULL, reset_expiry = NULL WHERE reset_token = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<User> getAllUsersWithRole() {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.user_id, u.username, u.email, u.role_id, r.role_name
            FROM [User] u
            JOIN [Role] r ON u.role_id = r.role_id
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRoleId(rs.getInt("role_id"));
                u.setRoleName(rs.getString("role_name"));
                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(dao.UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    // ✅ Lấy tất cả users
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.user_id, u.username, u.email, u.phone, u.avatar, u.role_id, u.status, r.role_name
            FROM [User] u
            LEFT JOIN [Role] r ON u.role_id = r.role_id
            WHERE u.status = 1
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                u.setRoleId(rs.getInt("role_id"));
                u.setStatus(rs.getBoolean("status"));
                u.setRoleName(rs.getString("role_name"));
                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(dao.UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    // ✅ Lấy users theo role
    public List<User> getUsersByRole(int roleId) {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.user_id, u.username, u.email, u.phone, u.avatar, u.role_id, u.status, r.role_name
            FROM [User] u
            LEFT JOIN [Role] r ON u.role_id = r.role_id
            WHERE u.role_id = ? AND u.status = 1
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                u.setRoleId(rs.getInt("role_id"));
                u.setStatus(rs.getBoolean("status"));
                u.setRoleName(rs.getString("role_name"));
                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(dao.UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    // ✅ Lấy tất cả các vai trò (role)
    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM [Role]";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Role r = new Role();
                r.setRoleId(rs.getInt("role_id"));
                r.setRoleName(rs.getString("role_name"));
                list.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(dao.UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    // ✅ Cập nhật role cho user
    public void updateUserRole(int userId, int roleId) {
        String sql = "UPDATE [User] SET role_id = ? WHERE user_id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(dao.UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // ✅ Cập nhật avatar cho user
    public boolean updateUserAvatar(int userId, String avatarPath) {
        String sql = "UPDATE [User] SET avatar = ? WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatarPath);
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Cập nhật thông tin profile cho user
    public boolean updateUserProfile(int userId, String username, String phone) {
        String sql = "UPDATE [User] SET username = ?, phone = ? WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, phone);
            ps.setInt(3, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public entity.Receptionist.User getUserByPatientId(int patientId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    // ========== EMAIL VERIFICATION METHODS ==========
    
    // ✅ Save email verification code to database
    public void saveEmailVerificationCode(String email, String code) {
        String sql = "UPDATE [User] SET email_verification_code = ?, email_verification_expiry = DATEADD(MINUTE, 15, GETDATE()) WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // ✅ Verify email verification code
    public boolean verifyEmailCode(String email, String code) {
        String sql = "SELECT 1 FROM [User] WHERE email = ? AND email_verification_code = ? AND email_verification_expiry > GETDATE()";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, code);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // ✅ Mark email as verified and complete registration
    public void completeEmailVerification(String email) {
        String sql = "UPDATE [User] SET email_verified = 1, email_verification_code = NULL, email_verification_expiry = NULL, status = 1 WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // ✅ Check if email is already verified
    public boolean isEmailVerified(String email) {
        String sql = "SELECT email_verified FROM [User] WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBoolean("email_verified");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // ✅ Register user with email verification (unverified status) - Hash password
    public void registerWithEmailVerification(String username, String password, String email, String phone) {
        String sql = "INSERT INTO [User](username, password, email, phone, role_id, status, email_verified) VALUES (?, ?, ?, ?, 3, 0, 0)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            // Hash password before storing
            ps.setString(2, PasswordUtil.hashPassword(password));
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
