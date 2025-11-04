/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.ListUser;

import context.DBContext;
import entity.ListUser.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Quang Anh
 */
public class UserDAO extends DBContext {

    // ========================= LẤY DANH SÁCH USER =========================
    public List<User> getAllUsers(String search, Integer roleFilter, Integer statusFilter,
            int offset, int limit, List<String> roleNamesInGroup) {

        List<User> users = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT u.user_id, u.username, u.password, u.email, u.phone, "
                + "u.role_id, r.role_name, u.status, u.reset_token, u.reset_expiry "
                + "FROM [User] u "
                + "LEFT JOIN Role r ON u.role_id = r.role_id "
                + "WHERE 1=1 "
        );

        // filter theo group (role_name IN ...)
        if (roleNamesInGroup != null && !roleNamesInGroup.isEmpty()) {
            sql.append("AND r.role_name IN (")
                    .append(String.join(",", java.util.Collections.nCopies(roleNamesInGroup.size(), "?")))
                    .append(") ");
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (u.username LIKE ? OR u.email LIKE ? OR u.phone LIKE ?) ");
        }
        if (roleFilter != null) {
            sql.append("AND u.role_id = ? ");
        }
        if (statusFilter != null) {
            sql.append("AND u.status = ? ");
        }

        sql.append("ORDER BY u.user_id DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int p = 1;

            // bind group names
            if (roleNamesInGroup != null && !roleNamesInGroup.isEmpty()) {
                for (String rn : roleNamesInGroup) {
                    ps.setString(p++, rn);
                }
            }

            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search + "%";
                ps.setString(p++, pattern);
                ps.setString(p++, pattern);
                ps.setString(p++, pattern);
            }
            if (roleFilter != null) {
                ps.setInt(p++, roleFilter);
            }
            if (statusFilter != null) {
                ps.setInt(p++, statusFilter);
            }

            ps.setInt(p++, offset);
            ps.setInt(p, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(extractUser(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }

    // ========================= ĐẾM USER =========================
    public int getTotalUsers(String search, Integer roleFilter, Integer statusFilter,
                             List<String> roleNamesInGroup) {

        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) " +
            "FROM [User] u LEFT JOIN Role r ON u.role_id = r.role_id " +
            "WHERE 1=1 "
        );

        if (roleNamesInGroup != null && !roleNamesInGroup.isEmpty()) {
            sql.append("AND r.role_name IN (")
               .append(String.join(",", java.util.Collections.nCopies(roleNamesInGroup.size(), "?")))
               .append(") ");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (u.username LIKE ? OR u.email LIKE ? OR u.phone LIKE ?) ");
        }
        if (roleFilter != null) {
            sql.append("AND u.role_id = ? ");
        }
        if (statusFilter != null) {
            sql.append("AND u.status = ? ");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int p = 1;

            if (roleNamesInGroup != null && !roleNamesInGroup.isEmpty()) {
                for (String rn : roleNamesInGroup) ps.setString(p++, rn);
            }
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search + "%";
                ps.setString(p++, pattern);
                ps.setString(p++, pattern);
                ps.setString(p++, pattern);
            }
            if (roleFilter != null) {
                ps.setInt(p++, roleFilter);
            }
            if (statusFilter != null) {
                ps.setInt(p++, statusFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ========================= LẤY USER THEO ID =========================
    public User getUserById(int userId) {
        String sql = "SELECT u.user_id, u.username, u.password, u.email, u.phone, "
                + "u.role_id, r.role_name, u.status, u.reset_token, u.reset_expiry "
                + "FROM [User] u "
                + "LEFT JOIN Role r ON u.role_id = r.role_id "
                + "WHERE u.user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ========================= CẬP NHẬT MẬT KHẨU =========================
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE [User] SET password = ? WHERE user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========================= BẬT / TẮT TRẠNG THÁI =========================
    public boolean toggleUserStatus(int userId) {
        String sql = "UPDATE [User] SET status = CASE WHEN status = 1 THEN 0 ELSE 1 END WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========================= HELPER: CHUYỂN RESULTSET → USER =========================
    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setRoleId(rs.getInt("role_id"));
        user.setRoleName(rs.getString("role_name"));
        user.setStatus(rs.getBoolean("status"));
        user.setResetToken(rs.getString("reset_token"));
        user.setResetExpiry(rs.getTimestamp("reset_expiry"));
        return user;
    }
}
