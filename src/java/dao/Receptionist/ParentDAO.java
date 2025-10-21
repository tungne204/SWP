package dao.Receptionist;

import context.DBContext;
import entity.Receptionist.Parent;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO Parent
 * @author Kiên
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
                    parent.setParentName(rs.getString("parentname"));
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
                    parent.setParentName(rs.getString("parentname"));
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

            ps.setString(1, parent.getParentName());
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
        } catch (Exception ex) {
            Logger.getLogger(ParentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    public void updateParent(Parent parent) {
        String sql = "UPDATE Parent SET parentname = ?, id_info = ? WHERE parent_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, parent.getParentName());
            ps.setString(2, parent.getIdInfo());
            ps.setInt(3, parent.getParentId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ParentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Thêm mới phục vụ cho servlet UpdateAppointmentServlet
    public Parent getParentByPatientId(int patientId) {
        String sql = """
            SELECT pa.parent_id, pa.parentname, pa.id_info
            FROM Parent pa
            JOIN Patient p ON pa.parent_id = p.parent_id
            WHERE p.patient_id = ?
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Parent parent = new Parent();
                    parent.setParentId(rs.getInt("parent_id"));
                    parent.setParentName(rs.getString("parentname"));
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

    public void updateParentByPatientId(int patientId, Parent parent) {
        String sql = """
            UPDATE Parent
            SET parentname = ?, id_info = ?
            WHERE parent_id = (SELECT parent_id FROM Patient WHERE patient_id = ?)
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, parent.getParentName());
            ps.setString(2, parent.getIdInfo());
            ps.setInt(3, patientId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ParentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
