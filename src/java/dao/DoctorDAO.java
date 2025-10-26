package dao;

import context.DBContext;
import entity.Doctor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO extends DBContext {

    // Get doctor by ID
    public Doctor getDoctorById(int doctorId) {
        String sql = "SELECT * FROM Doctor WHERE doctor_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setUserId(rs.getInt("user_id"));
                    doctor.setSpecialty(rs.getString("specialty"));
                    return doctor;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get doctor by user ID
    public Doctor getDoctorByUserId(int userId) {
        String sql = "SELECT * FROM Doctor WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setUserId(rs.getInt("user_id"));
                    doctor.setSpecialty(rs.getString("specialty"));
                    return doctor;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all doctors
    public List<Doctor> getAllDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT * FROM Doctor";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setUserId(rs.getInt("user_id"));
                doctor.setSpecialty(rs.getString("specialty"));
                doctors.add(doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctors;
    }

    // Create a new doctor
    public void createDoctor(Doctor doctor) {
        String sql = "INSERT INTO Doctor (user_id, specialty) VALUES (?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctor.getUserId());
            ps.setString(2, doctor.getSpecialty());
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Update doctor specialty
    public void updateDoctorSpecialty(int doctorId, String specialty) {
        String sql = "UPDATE Doctor SET specialty = ? WHERE doctor_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, specialty);
            ps.setInt(2, doctorId);
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Ensure at least one default doctor exists in the database
    public void ensureDefaultDoctorExists() {
        String checkSql = "SELECT COUNT(*) FROM Doctor";
        String insertSql = "INSERT INTO Doctor (user_id, specialty) VALUES (?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql);
             ResultSet rs = checkPs.executeQuery()) {
            
            if (rs.next() && rs.getInt(1) == 0) {
                // No doctors exist, create a default one
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setInt(1, 0); // Default user_id (0 indicates system default)
                    insertPs.setString(2, "General Practice"); // Default specialty
                    insertPs.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}