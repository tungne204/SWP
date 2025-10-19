/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.setPermission;

import context.DBContext;
import java.sql.*;
import java.util.*;
import entity.setPermission.User;
import entity.Role;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO extends DBContext {

    // Lấy danh sách người dùng cùng role
     public List<User> getAllUsersWithRole() {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.user_id, u.username, u.email, u.role_id, r.role_name
            FROM [User] u
            JOIN [Role] r ON u.role_id = r.role_id
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
             Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
         }

        return list;
    }

    // ✅ Lấy tất cả các vai trò (role)
    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM [Role]";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Role r = new Role();
                r.setRoleId(rs.getInt("role_id"));
                r.setRoleName(rs.getString("role_name"));
                list.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
             Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
         }

        return list;
    }

    // ✅ Cập nhật role cho user
    public void updateUserRole(int userId, int roleId) {
        String sql = "UPDATE [User] SET role_id = ? WHERE user_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
             Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
         }
    }
}