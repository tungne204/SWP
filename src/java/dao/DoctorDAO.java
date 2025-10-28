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
                    // Bảng Doctor không có cột specialty
                    doctor.setSpecialty("");
                    // Handle nullable experienceYears
                    int expYears = rs.getInt("experienceYears");
                    boolean wasNull = rs.wasNull();
                    doctor.setExperienceYears(wasNull ? 0 : expYears);
                    // Handle nullable certificate
                    String cert = rs.getString("certificate");
                    doctor.setCertificate(cert != null ? cert : "");
                    // Handle nullable introduce
                    String intro = rs.getString("introduce");
                    doctor.setIntroduce(intro != null ? intro : "");
                    
                    return doctor;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get doctor by doctor ID with full user info
    public Doctor getDoctorByIdWithUserInfo(int doctorId) {
        String sql = """
            SELECT d.doctor_id, d.user_id, d.experienceYears, d.certificate, d.introduce,
                   u.username, u.email, u.phone, u.avatar
            FROM Doctor d
            JOIN [User] u ON d.user_id = u.user_id
            WHERE d.doctor_id = ?
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setUserId(rs.getInt("user_id"));
                    doctor.setUsername(rs.getString("username"));
                    doctor.setEmail(rs.getString("email"));
                    doctor.setPhone(rs.getString("phone"));
                    
                    // Handle nullable experienceYears
                    int expYears = rs.getInt("experienceYears");
                    doctor.setExperienceYears(rs.wasNull() ? 0 : expYears);
                    
                    // Handle nullable certificate and introduce
                    String cert = rs.getString("certificate");
                    doctor.setCertificate(cert != null ? cert : "");
                    
                    String intro = rs.getString("introduce");
                    doctor.setIntroduce(intro != null ? intro : "");
                    
                    // Set avatar path
                    String avatar = rs.getString("avatar");
                    if (avatar != null && !avatar.isEmpty()) {
                        doctor.setAvatar(avatar);
                    } else {
                        doctor.setAvatar("assets/img/default-avatar.png");
                    }
                    
                    return doctor;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all doctors with user info
    public List<Doctor> getAllDoctors() {
        return getAllDoctors(null, null);
    }
    
    // Get total count of doctors
    public int getTotalDoctors(String searchName) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM Doctor d
            JOIN [User] u ON d.user_id = u.user_id
            WHERE u.status = 1
        """);
        
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND u.username LIKE ?");
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            if (searchName != null && !searchName.trim().isEmpty()) {
                ps.setString(1, "%" + searchName.trim() + "%");
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get all doctors with search and sort
    public List<Doctor> getAllDoctors(String searchName, String sortOrder) {
        List<Doctor> doctors = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT d.doctor_id, d.user_id, d.experienceYears, d.certificate, d.introduce,
                   u.username, u.avatar
            FROM Doctor d
            JOIN [User] u ON d.user_id = u.user_id
            WHERE u.status = 1
        """);
        
        // Add search condition
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND u.username LIKE ?");
        }
        
        // Add sort order
        sql.append(" ORDER BY d.experienceYears");
        if ("asc".equalsIgnoreCase(sortOrder)) {
            sql.append(" ASC");
        } else if ("desc".equalsIgnoreCase(sortOrder)) {
            sql.append(" DESC");
        } else {
            sql.append(" ASC"); // default asc
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Set search parameter if provided
            if (searchName != null && !searchName.trim().isEmpty()) {
                ps.setString(1, "%" + searchName.trim() + "%");
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setUserId(rs.getInt("user_id"));
                    doctor.setUsername(rs.getString("username"));
                    
                    // Handle nullable experienceYears
                    int expYears = rs.getInt("experienceYears");
                    doctor.setExperienceYears(rs.wasNull() ? 0 : expYears);
                    
                    // Handle nullable certificate and introduce
                    String cert = rs.getString("certificate");
                    doctor.setCertificate(cert != null ? cert : "");
                    
                    String intro = rs.getString("introduce");
                    doctor.setIntroduce(intro != null ? intro : "");
                    
                    // Set avatar path
                    String avatar = rs.getString("avatar");
                    if (avatar != null && !avatar.isEmpty()) {
                        doctor.setAvatar(avatar);
                    } else {
                        doctor.setAvatar("assets/img/default-avatar.png");
                    }
                    
                    doctors.add(doctor);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctors;
    }
    
    // Get doctors with pagination
    public List<Doctor> getAllDoctorsWithPagination(String searchName, String sortOrder, int page, int pageSize) {
        List<Doctor> doctors = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder("""
            SELECT d.doctor_id, d.user_id, d.experienceYears, d.certificate, d.introduce,
                   u.username, u.avatar
            FROM Doctor d
            JOIN [User] u ON d.user_id = u.user_id
            WHERE u.status = 1
        """);
        
        // Add search condition
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND u.username LIKE ?");
        }
        
        // Add sort order
        sql.append(" ORDER BY d.experienceYears");
        if ("asc".equalsIgnoreCase(sortOrder)) {
            sql.append(" ASC");
        } else if ("desc".equalsIgnoreCase(sortOrder)) {
            sql.append(" DESC");
        } else {
            sql.append(" ASC"); // default asc
        }
        
        // Add pagination for SQL Server
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            // Set search parameter if provided
            if (searchName != null && !searchName.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchName.trim() + "%");
            }
            
            // Set pagination parameters
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setUserId(rs.getInt("user_id"));
                    doctor.setUsername(rs.getString("username"));
                    
                    // Handle nullable experienceYears
                    int expYears = rs.getInt("experienceYears");
                    doctor.setExperienceYears(rs.wasNull() ? 0 : expYears);
                    
                    // Handle nullable certificate and introduce
                    String cert = rs.getString("certificate");
                    doctor.setCertificate(cert != null ? cert : "");
                    
                    String intro = rs.getString("introduce");
                    doctor.setIntroduce(intro != null ? intro : "");
                    
                    // Set avatar path
                    String avatar = rs.getString("avatar");
                    if (avatar != null && !avatar.isEmpty()) {
                        doctor.setAvatar(avatar);
                    } else {
                        doctor.setAvatar("assets/img/default-avatar.png");
                    }
                    
                    doctors.add(doctor);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctors;
    }
    
    // Get featured doctors (top N by experience)
    public List<Doctor> getFeaturedDoctors(int limit) {
        List<Doctor> doctors = new ArrayList<>();
        String sql = """
            SELECT TOP (?) d.doctor_id, d.user_id, d.experienceYears, d.certificate, d.introduce,
                   u.username, u.avatar
            FROM Doctor d
            JOIN [User] u ON d.user_id = u.user_id
            WHERE u.status = 1 AND d.experienceYears > 0
            ORDER BY d.experienceYears DESC
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setUserId(rs.getInt("user_id"));
                    doctor.setUsername(rs.getString("username"));
                    
                    int expYears = rs.getInt("experienceYears");
                    doctor.setExperienceYears(rs.wasNull() ? 0 : expYears);
                    
                    String cert = rs.getString("certificate");
                    doctor.setCertificate(cert != null ? cert : "");
                    
                    String intro = rs.getString("introduce");
                    doctor.setIntroduce(intro != null ? intro : "");
                    
                    String avatar = rs.getString("avatar");
                    if (avatar != null && !avatar.isEmpty()) {
                        doctor.setAvatar(avatar);
                    } else {
                        doctor.setAvatar("assets/img/default-avatar.png");
                    }
                    
                    doctors.add(doctor);
                }
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
    
    // Update doctor certificate
    public boolean updateDoctorCertificate(int userId, String certificatePath) {
        String sql = "UPDATE Doctor SET certificate = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, certificatePath);
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update doctor experience years only (not certificate)
    public boolean updateDoctorExperience(int userId, int experienceYears) {
        String sql = "UPDATE Doctor SET experienceYears = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceYears);
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update doctor introduce only
    public boolean updateDoctorIntroduce(int userId, String introduce) {
        String sql = "UPDATE Doctor SET introduce = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, introduce != null ? introduce : "");
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update doctor experience years and certificate
    public boolean updateDoctorInfo(int userId, int experienceYears, String certificate) {
        String sql = "UPDATE Doctor SET experienceYears = ?, certificate = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceYears);
            ps.setString(2, certificate != null ? certificate : "");
            ps.setInt(3, userId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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