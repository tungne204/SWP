package dao.Receptionist;

import context.DBContext;
import entity.Receptionist.Role;
import entity.Receptionist.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 * 
 * @author Kiên
 */
public class UserDAO extends DBContext {

// DÀNH CHO APPOINTMENT UPDATE
    /**
     * true
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
    /**
     * true
     * @param user 
     */
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
