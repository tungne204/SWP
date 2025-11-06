/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.appointments;

/**
 *
 * @author Quang Anh
 */
import context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import entity.appointments.Patient;
import entity.appointments.Doctor;
import entity.User;
import java.util.logging.Level;
import java.util.logging.Logger;


// ============= PatientDAO.java =============
public class PatientDAO extends DBContext {
    public Integer createPatientMinimalIfAbsent(int userId) {
    String checkSql = "SELECT patient_id FROM Patient WHERE user_id = ?";
    String insertSql = "INSERT INTO Patient (user_id, full_name) VALUES (?, N'')";

    try (Connection conn = getConnection()) {
        try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

    
    // Lấy patient theo user_id
    public Patient getPatientByUserId(int userId) {
        String sql = "SELECT * FROM Patient WHERE user_id = ?";
        
        try ( Connection conn = getConnection(); 
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setDob(rs.getDate("dob"));
                patient.setAddress(rs.getString("address"));
                patient.setInsuranceInfo(rs.getString("insurance_info"));
                patient.setParentId(rs.getInt("parent_id"));
                return patient;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(PatientDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    // Lấy patient theo patient_id
    public Patient getPatientById(int patientId) {
        String sql = "SELECT * FROM Patient WHERE patient_id = ?";
        
        try (Connection conn = getConnection(); 
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setDob(rs.getDate("dob"));
                patient.setAddress(rs.getString("address"));
                patient.setInsuranceInfo(rs.getString("insurance_info"));
                patient.setParentId(rs.getInt("parent_id"));
                return patient;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(PatientDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    // Lấy patient với thông tin user
    public Patient getPatientWithUserInfo(int patientId) {
        String sql = "SELECT p.*, u.username, u.email, u.phone, u.avatar " +
                    "FROM Patient p " +
                    "LEFT JOIN [User] u ON p.user_id = u.user_id " +
                    "WHERE p.patient_id = ?";
        
        try (Connection conn = getConnection(); 
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setDob(rs.getDate("dob"));
                patient.setAddress(rs.getString("address"));
                patient.setInsuranceInfo(rs.getString("insurance_info"));
                patient.setParentId(rs.getInt("parent_id"));
                
                // Thêm thông tin user nếu có
                if (rs.getObject("user_id") != null) {
                    patient.setEmail(rs.getString("email"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setUsername(rs.getString("username"));
                }
                
                return patient;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(PatientDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
