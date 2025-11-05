package dao;

import context.DBContext;
import entity.Contact;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ContactDAO extends DBContext {

    // Insert a new contact message
    public boolean insertContact(String fullName, String email, String subject, String message) {
        String sql = "INSERT INTO [Contact] (full_name, email, subject, message, created_at, status) VALUES (?, ?, ?, ?, GETDATE(), N'pending')";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, message);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all contacts
    public List<Contact> getAllContacts() {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM [Contact] ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Contact contact = new Contact();
                contact.setContactId(rs.getInt("contact_id"));
                contact.setFullName(rs.getString("full_name"));
                contact.setEmail(rs.getString("email"));
                contact.setSubject(rs.getString("subject"));
                contact.setMessage(rs.getString("message"));
                contact.setCreatedAt(rs.getTimestamp("created_at"));
                contact.setStatus(rs.getString("status"));
                contacts.add(contact);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ContactDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return contacts;
    }

    // Get contact by ID
    public Contact getContactById(int contactId) {
        String sql = "SELECT * FROM [Contact] WHERE contact_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, contactId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contact contact = new Contact();
                    contact.setContactId(rs.getInt("contact_id"));
                    contact.setFullName(rs.getString("full_name"));
                    contact.setEmail(rs.getString("email"));
                    contact.setSubject(rs.getString("subject"));
                    contact.setMessage(rs.getString("message"));
                    contact.setCreatedAt(rs.getTimestamp("created_at"));
                    contact.setStatus(rs.getString("status"));
                    return contact;
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }

    // Update contact status to reviewed
    public boolean updateStatus(int contactId, String status) {
        String sql = "UPDATE [Contact] SET status = ? WHERE contact_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, contactId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get count of pending contacts
    public int getPendingCount() {
        String sql = "SELECT COUNT(*) as count FROM [Contact] WHERE status = N'pending'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}



