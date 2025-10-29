package dao;

import context.DBContext;
import entity.Parent;
import entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ParentDAO extends DBContext {

    /**
     * Check if a user exists in the Parent table by matching username
     * @param user The user to check
     * @return Parent object if found, null otherwise
     */
    public Parent getParentByUser(User user) {
        String sql = "SELECT p.* FROM Parent p " +
                    "INNER JOIN [User] u ON p.parentname = u.username " +
                    "WHERE u.user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, user.getUserId());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Parent parent = new Parent();
                    parent.setParentId(rs.getInt("parent_id"));
                    parent.setParentname(rs.getString("parentname"));
                    parent.setIdInfo(rs.getString("id_info"));
                    return parent;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Insert a new parent into the Parent table
     * @param user The user to create a parent record for
     * @return The generated parent_id, or -1 if failed
     */
    public int insertParent(User user) {
        String sql = "INSERT INTO Parent (parentname, id_info) VALUES (?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail()); // Using email as id_info
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Get or create parent_id for a given user
     * This method checks if the user exists in Parent table, 
     * if not, it inserts them and returns the parent_id
     * @param user The user to get/create parent_id for
     * @return parent_id if successful, -1 if failed
     */
    public int getOrCreateParentId(User user) {
        // First, check if parent already exists
        Parent existingParent = getParentByUser(user);
        
        if (existingParent != null) {
            return existingParent.getParentId();
        }
        
        // If not found, insert new parent
        return insertParent(user);
    }

    /**
     * Get parent by parent_id
     * @param parentId The parent ID to search for
     * @return Parent object if found, null otherwise
     */
    public Parent getParentById(int parentId) {
        String sql = "SELECT * FROM Parent WHERE parent_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find parent by ID info (identity number)
     * @param idInfo The ID info to search for
     * @return Parent object if found, null otherwise
     */
    public Parent findParentByIdInfo(String idInfo) {
        String sql = "SELECT * FROM Parent WHERE id_info = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Update parent information
     * @param parent The parent object with updated information
     */
    public void updateParent(Parent parent) {
        String sql = "UPDATE Parent SET parentname = ?, id_info = ? WHERE parent_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, parent.getParentname());
            ps.setString(2, parent.getIdInfo());
            ps.setInt(3, parent.getParentId());
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Create a new parent
     * @param parent The parent object to create
     * @return The generated parent_id, or -1 if failed
     */
    public int createParent(Parent parent) {
        String sql = "INSERT INTO Parent (parentname, id_info) VALUES (?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, parent.getParentname());
            ps.setString(2, parent.getIdInfo());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
}