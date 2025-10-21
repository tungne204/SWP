package dao.Receptionist;

import context.DBContext;
import entity.Role;
import entity.Receptionist.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO extends DBContext {

    // Login
    public User login(String email, String password) {
        String sql = "SELECT * FROM [User] WHERE email = ? AND password = ? AND status = 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

    //Check email tồn tại chưa
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

    //Thêm user mới (mặc định role_id = 3 (Patient), status = 1)
    public void register(String username, String password, String email, String phone) {
        String sql = "INSERT INTO [User](username, password, email, phone, role_id, status) VALUES (?, ?, ?, ?, 3, 1)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //Tìm user theo email
    public User findByEmail(String email) {
        String sql = "SELECT * FROM [User] WHERE email = ? AND status = 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

    // Dang ky user moi tu Google (mac dinh role_id = 3 (Patient), status = 1)
    public void registerGoogleUser(String username, String password, String email, String phone) {
        String sql = "INSERT INTO [User](username, password, email, phone, role_id, status) VALUES (?, ?, ?, ?, 3, 1)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //Lưu token reset vào DB

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

//Tìm email theo token
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

//Kiểm tra mật khẩu cũ có đúng không
    public boolean checkPassword(String email, String oldPassword) {
        String sql = "SELECT 1 FROM [User] WHERE email = ? AND password = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, oldPassword);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
//Cập nhật mật khẩu

    public void updatePassword(String email, String newPassword) {
        String sql = "UPDATE [User] SET password = ? WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

//Xóa token sau khi dùng
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

    //Lấy tất cả các vai trò (role)
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

    //Cập nhật role cho user
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

// DÀNH CHO APPOINTMENT UPDATE
    /**
     * Lấy thông tin User dựa theo patientId (JOIN giữa User & Patient)
     */
    public User getUserByPatientId(int patientId) {
        String sql = """
            SELECT u.user_id, u.username, u.email, u.phone
            FROM [User] u
            JOIN Patient p ON u.user_id = p.user_id
            WHERE p.patient_id = ?
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    // === Cập nhật email cho user (dùng trong UpdateAppointmentServlet) ===

    public void updateEmail(User user) {
        String sql = "UPDATE [User] SET email = ? WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setInt(2, user.getUserId());
            ps.executeUpdate();

            System.out.println("✅ Updated email for user_id=" + user.getUserId());

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("❌ Failed to update email in UserDAO: " + e.getMessage());
        } catch (Exception ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    
}
