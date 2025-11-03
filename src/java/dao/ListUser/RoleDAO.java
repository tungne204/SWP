/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.ListUser;

import context.DBContext;
import entity.ListUser.Role;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Quang Anh
 */
public class RoleDAO extends DBContext{
    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT role_id, role_name FROM Role ORDER BY role_name";

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
    // NEW: lấy danh sách role theo tên (IN ...)
    public List<Role> getRolesByNames(List<String> names) {
        List<Role> list = new ArrayList<>();
        if (names == null || names.isEmpty()) return list;

        String placeholders = String.join(",", java.util.Collections.nCopies(names.size(), "?"));
        String sql = "SELECT role_id, role_name FROM Role WHERE role_name IN (" + placeholders + ") ORDER BY role_name";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            int i = 1;
            for (String n : names) ps.setString(i++, n);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Role r = new Role();
                    r.setRoleId(rs.getInt(1));
                    r.setRoleName(rs.getString(2));
                    list.add(r);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Lấy role theo ID
    public Role getRoleById(int roleId) {
        String sql = "SELECT role_id, role_name FROM Role WHERE role_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    return role;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
