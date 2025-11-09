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
        String sql = "SELECT p.patient_id, p.user_id, p.full_name, p.dob, p.address, p.insurance_info, p.parent_id, "
                + "u.username, u.email, u.phone, pa.parentname "
                + "FROM Patient p "
                + "LEFT JOIN [User] u ON p.user_id = u.user_id "
                + "LEFT JOIN Parent pa ON p.parent_id = pa.parent_id "
                + "WHERE p.user_id = ?";

        try (Connection conn = getConnection();
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
                patient.setParentId(rs.getObject("parent_id") != null ? rs.getInt("parent_id") : null);
                patient.setUsername(rs.getString("username"));
                patient.setEmail(rs.getString("email"));
                patient.setPhone(rs.getString("phone"));
                patient.setParentName(rs.getString("parentname"));
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
        String sql = "SELECT p.*, u.username, u.email, u.phone, u.avatar, pa.parentname "
                + "FROM Patient p "
                + "LEFT JOIN [User] u ON p.user_id = u.user_id "
                + "LEFT JOIN Parent pa ON p.parent_id = pa.parent_id "
                + "WHERE p.patient_id = ?";
        
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
                patient.setParentName(rs.getString("parentname"));
                
                return patient;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(PatientDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public Patient savePatientDetails(Patient patient, String fullName, Date dob, String address,
                                      String insuranceInfo, String parentName, String phone) throws SQLException {
        if (patient == null) {
            throw new IllegalArgumentException("Patient entity must not be null");
        }

        String updatePatientSql = "UPDATE Patient SET full_name = ?, dob = ?, address = ?, insurance_info = ?, parent_id = ? WHERE patient_id = ?";
        String updateParentSql = "UPDATE Parent SET parentname = ? WHERE parent_id = ?";
        String insertParentSql = "INSERT INTO Parent (parentname) VALUES (?)";
        String updateUserSql = "UPDATE [User] SET phone = ? WHERE user_id = ?";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            Integer parentId = patient.getParentId();
            boolean hasParentName = parentName != null && !parentName.trim().isEmpty();

            if (hasParentName) {
                if (parentId != null && parentId > 0) {
                    try (PreparedStatement ps = conn.prepareStatement(updateParentSql)) {
                        ps.setString(1, parentName.trim());
                        ps.setInt(2, parentId);
                        ps.executeUpdate();
                    }
                } else {
                    try (PreparedStatement ps = conn.prepareStatement(insertParentSql, Statement.RETURN_GENERATED_KEYS)) {
                        ps.setString(1, parentName.trim());
                        ps.executeUpdate();
                        try (ResultSet generated = ps.getGeneratedKeys()) {
                            if (generated.next()) {
                                parentId = generated.getInt(1);
                            }
                        }
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(updatePatientSql)) {
                ps.setString(1, fullName);
                if (dob != null) {
                    ps.setDate(2, dob);
                } else {
                    ps.setNull(2, Types.DATE);
                }
                ps.setString(3, address);
                if (insuranceInfo != null && !insuranceInfo.trim().isEmpty()) {
                    ps.setString(4, insuranceInfo.trim());
                } else {
                    ps.setNull(4, Types.NVARCHAR);
                }
                if (parentId != null && parentId > 0) {
                    ps.setInt(5, parentId);
                } else {
                    ps.setNull(5, Types.INTEGER);
                }
                ps.setInt(6, patient.getPatientId());
                ps.executeUpdate();
            }

            if (phone != null && !phone.trim().isEmpty() && patient.getUserId() != null) {
                try (PreparedStatement ps = conn.prepareStatement(updateUserSql)) {
                    ps.setString(1, phone.trim());
                    ps.setInt(2, patient.getUserId());
                    ps.executeUpdate();
                }
            }

            conn.commit();

            patient.setFullName(fullName);
            patient.setDob(dob);
            patient.setAddress(address);
            patient.setInsuranceInfo(insuranceInfo != null && !insuranceInfo.trim().isEmpty() ? insuranceInfo.trim() : null);
            patient.setParentId(parentId);
            patient.setParentName(hasParentName ? parentName.trim() : null);
            if (phone != null && !phone.trim().isEmpty()) {
                patient.setPhone(phone.trim());
            }
            return patient;
        } catch (SQLException ex) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            throw ex;
        } catch (Exception ex) {
            Logger.getLogger(PatientDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }
    
    /**
     * Tìm patient đã tồn tại dựa trên fullName, dob, và phone
     * Nếu không tìm thấy, tạo patient mới
     * @param fullName Tên bệnh nhân
     * @param dob Ngày sinh
     * @param phone Số điện thoại
     * @param address Địa chỉ
     * @param insuranceInfo Thông tin bảo hiểm
     * @param parentName Tên phụ huynh/người giám hộ
     * @param userId User ID của người đặt (có thể null)
     * @return Patient ID của patient đã tồn tại hoặc mới tạo
     */
    public Integer findOrCreatePatient(String fullName, Date dob, String phone, String address,
                                       String insuranceInfo, String parentName, Integer userId) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // Tìm patient đã tồn tại với thông tin khớp
            // Tìm theo fullName, dob, và address (hoặc phone từ User table nếu có)
            String findSql = "SELECT TOP 1 p.patient_id FROM Patient p "
                    + "LEFT JOIN [User] u ON p.user_id = u.user_id "
                    + "WHERE p.full_name = ? AND p.dob = ? "
                    + "AND (p.address = ? OR (u.phone = ? AND u.phone IS NOT NULL))";
            
            Integer patientId = null;
            Integer existingUserId = null;
            try (PreparedStatement ps = conn.prepareStatement(findSql)) {
                ps.setString(1, fullName);
                if (dob != null) {
                    ps.setDate(2, dob);
                } else {
                    ps.setNull(2, Types.DATE);
                }
                ps.setString(3, address);
                ps.setString(4, phone);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        patientId = rs.getInt("patient_id");
                    }
                }
            }
            
            // Nếu tìm thấy patient đã tồn tại, kiểm tra và cập nhật user_id nếu cần
            if (patientId != null && userId != null && userId > 0) {
                String checkUserIdSql = "SELECT user_id FROM Patient WHERE patient_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(checkUserIdSql)) {
                    ps.setInt(1, patientId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            Object userIdObj = rs.getObject("user_id");
                            if (userIdObj == null) {
                                // Patient chưa có user_id, cập nhật
                                String updateUserIdSql = "UPDATE Patient SET user_id = ? WHERE patient_id = ?";
                                try (PreparedStatement updatePs = conn.prepareStatement(updateUserIdSql)) {
                                    updatePs.setInt(1, userId);
                                    updatePs.setInt(2, patientId);
                                    updatePs.executeUpdate();
                                }
                            }
                        }
                    }
                }
            }
            
            // Nếu không tìm thấy, tạo patient mới
            if (patientId == null) {
                Integer parentId = null;
                
                // Tạo parent nếu có parentName
                if (parentName != null && !parentName.trim().isEmpty()) {
                    String insertParentSql = "INSERT INTO Parent (parentname) VALUES (?)";
                    try (PreparedStatement ps = conn.prepareStatement(insertParentSql, Statement.RETURN_GENERATED_KEYS)) {
                        ps.setString(1, parentName.trim());
                        ps.executeUpdate();
                        try (ResultSet generated = ps.getGeneratedKeys()) {
                            if (generated.next()) {
                                parentId = generated.getInt(1);
                            }
                        }
                    }
                }
                
                // Tạo patient mới
                String insertPatientSql = "INSERT INTO Patient (user_id, full_name, dob, address, insurance_info, parent_id) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertPatientSql, Statement.RETURN_GENERATED_KEYS)) {
                    if (userId != null && userId > 0) {
                        ps.setInt(1, userId);
                    } else {
                        ps.setNull(1, Types.INTEGER);
                    }
                    ps.setString(2, fullName);
                    if (dob != null) {
                        ps.setDate(3, dob);
                    } else {
                        ps.setNull(3, Types.DATE);
                    }
                    ps.setString(4, address);
                    if (insuranceInfo != null && !insuranceInfo.trim().isEmpty()) {
                        ps.setString(5, insuranceInfo.trim());
                    } else {
                        ps.setNull(5, Types.NVARCHAR);
                    }
                    if (parentId != null) {
                        ps.setInt(6, parentId);
                    } else {
                        ps.setNull(6, Types.INTEGER);
                    }
                    ps.executeUpdate();
                    try (ResultSet generated = ps.getGeneratedKeys()) {
                        if (generated.next()) {
                            patientId = generated.getInt(1);
                        }
                    }
                }
                
                // Cập nhật phone trong User table nếu có userId và phone
                if (userId != null && userId > 0 && phone != null && !phone.trim().isEmpty()) {
                    String updateUserSql = "UPDATE [User] SET phone = ? WHERE user_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(updateUserSql)) {
                        ps.setString(1, phone.trim());
                        ps.setInt(2, userId);
                        ps.executeUpdate();
                    }
                }
            }
            
            conn.commit();
            return patientId;
            
        } catch (SQLException ex) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            ex.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(PatientDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }
    
    /**
     * Kiểm tra số điện thoại đã tồn tại trong database chưa (trừ user hiện tại)
     * @param phone Số điện thoại cần kiểm tra
     * @param excludeUserId User ID cần loại trừ (thường là user hiện tại)
     * @return true nếu số điện thoại đã tồn tại (của user khác), false nếu chưa hoặc là của user hiện tại
     */
    public boolean isPhoneExists(String phone, Integer excludeUserId) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM [User] WHERE phone = ?";
        if (excludeUserId != null && excludeUserId > 0) {
            sql += " AND user_id != ?";
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone.trim());
            if (excludeUserId != null && excludeUserId > 0) {
                ps.setInt(2, excludeUserId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(PatientDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
