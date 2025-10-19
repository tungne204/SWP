package dao.RolePatient;

import context.DBContext;
import entity.Parent;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Parent DAO - Handles parent database operations
 * This DAO is specifically for patient functionality to avoid conflicts
 */
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, parent.getParentname());
            ps.setString(2, parent.getIdInfo());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ParentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    public void updateParent(Parent parent) {
        String sql = "UPDATE Parent SET parentname = ?, id_info = ? WHERE parent_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, parent.getParentname());
            ps.setString(2, parent.getIdInfo());
            ps.setInt(3, parent.getParentId());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ParentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void deleteParent(int parentId) {
        String sql = "DELETE FROM Parent WHERE parent_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ParentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public boolean isParentExists(String idInfo) {
        String sql = "SELECT COUNT(*) FROM Parent WHERE id_info = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idInfo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ParentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
