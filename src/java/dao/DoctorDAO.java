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
    
    // Ensure at least one doctor exists in the database
    public void ensureDefaultDoctorExists() {
        List<Doctor> doctors = getAllDoctors();
        if (doctors.isEmpty()) {
            // Create a default user for the doctor
            String userSql = "INSERT INTO [User] (username, password, email, phone, role_id, status) VALUES (?, ?, ?, ?, 2, 1)";
            String doctorSql = "INSERT INTO Doctor (user_id, specialty) VALUES (?, ?)";
            
            try (Connection conn = getConnection()) {
                // Insert default user
                try (PreparedStatement userPs = conn.prepareStatement(userSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    userPs.setString(1, "default_doctor");
                    userPs.setString(2, "password123");
                    userPs.setString(3, "doctor@hospital.com");
                    userPs.setString(4, "0123456789");
                    
                    userPs.executeUpdate();
                    
                    // Get the generated user ID
                    try (var generatedKeys = userPs.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            int userId = generatedKeys.getInt(1);
                            
                            // Insert doctor record
                            try (PreparedStatement doctorPs = conn.prepareStatement(doctorSql)) {
                                doctorPs.setInt(1, userId);
                                doctorPs.setString(2, "General Medicine");
                                doctorPs.executeUpdate();
                                
                                System.out.println("Default doctor created successfully with user_id: " + userId);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("Failed to create default doctor: " + e.getMessage());
            }
        }
    }
}