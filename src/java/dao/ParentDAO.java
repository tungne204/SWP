package dao;

import context.DBContext;
import entity.Parent;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ParentDAO extends DBContext {

    public Parent getParentById(int parentId) {
        String sql = "SELECT * FROM Parent WHERE parent_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Parent parent = new Parent();
                    parent.setParentId(rs.getInt("parent_id"));
                    parent.setParentname(rs.getString("parentname"));
                    parent.setIdInfo(rs.getString("id_info"));
                    return parent;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ParentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public Parent findParentByIdInfo(String idInfo) {
        String sql = "SELECT * FROM Parent WHERE id_info = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idInfo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Parent parent = new Parent();
                    parent.setParentId(rs.getInt("parent_id"));
                    parent.setParentname(rs.getString("parentname"));
                    parent.setIdInfo(rs.getString("id_info"));
                    return parent;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ParentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public int createParent(Parent parent) {
    String sql = "INSERT INTO Parent (parentname, id_info) VALUES (?, ?)";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {

        ps.setString(1, parent.getParentname());
        ps.setString(2, parent.getIdInfo());

        int rows = ps.executeUpdate();
        System.out.println("Inserted parent rows = " + rows);

        try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
            if (generatedKeys.next()) {
                int newId = generatedKeys.getInt(1);
                System.out.println("Generated parent_id = " + newId);
                return newId;
            } else {
                System.out.println("No generated keys returned for Parent!");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }   catch (Exception ex) {
            Logger.getLogger(ParentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    return -1;
}

    

}

