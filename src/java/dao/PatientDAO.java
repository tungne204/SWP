package dao;

import context.DBContext;
import entity.Patient;
import entity.Parent;
import entity.Appointment;
import entity.Doctor;
import entity.User;
import entity.Role;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO extends DBContext {

    // Get patient by ID
    public Patient getPatientById(int patientId) {
        String sql = "SELECT * FROM Patient WHERE patient_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setPatientId(rs.getInt("patient_id"));
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setFullName(rs.getString("full_name"));
                    patient.setDob(rs.getDate("dob"));
                    patient.setAddress(rs.getString("address"));
                    patient.setInsuranceInfo(rs.getString("insurance_info"));
                    patient.setParentId(rs.getObject("parent_id", Integer.class));
                    return patient;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get patient by user ID
    public Patient getPatientByUserId(int userId) {
        String sql = "SELECT * FROM Patient WHERE user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setPatientId(rs.getInt("patient_id"));
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setFullName(rs.getString("full_name"));
                    patient.setDob(rs.getDate("dob"));
                    patient.setAddress(rs.getString("address"));
                    patient.setInsuranceInfo(rs.getString("insurance_info"));
                    patient.setParentId(rs.getObject("parent_id", Integer.class));
                    return patient;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all patients
    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM Patient";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setDob(rs.getDate("dob"));
                patient.setAddress(rs.getString("address"));
                patient.setInsuranceInfo(rs.getString("insurance_info"));
                patient.setParentId(rs.getObject("parent_id", Integer.class));
                patients.add(patient);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patients;
    }

    // Find existing patient by name and phone number (stored in address field)
    public Patient findPatientByNameAndPhone(String fullName, String phoneNumber) {
        String sql = "SELECT * FROM Patient WHERE full_name = ? AND address = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, phoneNumber);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setPatientId(rs.getInt("patient_id"));
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setFullName(rs.getString("full_name"));
                    patient.setDob(rs.getDate("dob"));
                    patient.setAddress(rs.getString("address"));
                    patient.setInsuranceInfo(rs.getString("insurance_info"));
                    patient.setParentId(rs.getObject("parent_id", Integer.class));
                    return patient;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Create a new patient
    public int createPatient(Patient patient) {
        String sql = "INSERT INTO Patient (user_id, full_name, dob, address, insurance_info, parent_id) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setObject(1, patient.getUserId() > 0 ? patient.getUserId() : null, java.sql.Types.INTEGER);
            ps.setString(2, patient.getFullName());
            ps.setDate(3, patient.getDob() != null ? new java.sql.Date(patient.getDob().getTime()) : null);
            ps.setString(4, patient.getAddress());
            ps.setString(5, patient.getInsuranceInfo());
            ps.setObject(6, patient.getParentId(), java.sql.Types.INTEGER);

            ps.executeUpdate();

            // Get the generated patient ID
            try (var generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Return -1 if failed to create patient
    }

    // Update patient information
    public void updatePatient(Patient patient) {
        String sql = "UPDATE Patient SET full_name = ?, dob = ?, address = ?, insurance_info = ?, parent_id = ? WHERE patient_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patient.getFullName());
            ps.setDate(2, patient.getDob() != null ? new java.sql.Date(patient.getDob().getTime()) : null);
            ps.setString(3, patient.getAddress());
            ps.setString(4, patient.getInsuranceInfo());
            ps.setObject(5, patient.getParentId(), java.sql.Types.INTEGER);
            ps.setInt(6, patient.getPatientId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // Search patients by name, ID, or address

    public List<Patient> searchPatients(String keyword) throws Exception {
        List<Patient> patients = new ArrayList<>();

        String sql
                = "SELECT * FROM Patient "
                + "WHERE CAST(patient_id AS NVARCHAR) LIKE ? "
                + "OR LOWER(full_name) LIKE LOWER(?) "
                + "OR LOWER(address) LIKE LOWER(?) "
                + "ORDER BY patient_id DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            String likeKeyword = "%" + keyword + "%";
            ps.setString(1, likeKeyword);
            ps.setString(2, likeKeyword);
            ps.setString(3, likeKeyword);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Patient patient = new Patient();
                    patient.setPatientId(rs.getInt("patient_id"));
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setFullName(rs.getString("full_name"));
                    patient.setDob(rs.getDate("dob"));
                    patient.setAddress(rs.getString("address"));
                    patient.setInsuranceInfo(rs.getString("insurance_info"));
                    patient.setParentId(rs.getObject("parent_id", Integer.class));
                    patients.add(patient);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return patients;
    }

    /**
     * Lấy thông tin bệnh nhân theo user_id (dùng cho chức năng View Profile)
     */
    /**
     * Lấy thông tin bệnh nhân theo user_id (dùng cho chức năng View Profile)
     */
    public Patient getPatientByUserID2(int userId) {
        Patient p = null;

        String sql = """
        SELECT 
            p.patient_id,
            p.user_id,
            p.full_name,
            p.dob,
            p.address,
            p.insurance_info,
            pa.parentname AS parent_name,
            pa.id_info AS parent_id_number,                
            u.email,
            u.phone,
            u2.username AS doctor_name,
            d.specialty AS doctor_specialty,               
            FORMAT(a.date_time, 'dd/MM/yyyy') AS appointment_date,
            FORMAT(a.date_time, 'HH:mm') AS appointment_time,  
            CASE WHEN a.status = 1 THEN N'Confirmed' ELSE N'Pending' END AS status
        FROM Patient p
        LEFT JOIN Parent pa ON p.parent_id = pa.parent_id
        LEFT JOIN [User] u ON p.user_id = u.user_id          -- thông tin user của bệnh nhân
        LEFT JOIN Appointment a 
            ON a.appointment_id = (
                SELECT TOP 1 appointment_id 
                FROM Appointment 
                WHERE patient_id = p.patient_id 
                ORDER BY date_time DESC
            )
        LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id
        LEFT JOIN [User] u2 ON d.user_id = u2.user_id        -- bác sĩ
        WHERE p.user_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Patient();
                    p.setPatientId(rs.getInt("patient_id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setFullName(rs.getString("full_name"));
                    p.setDob(rs.getDate("dob"));
                    p.setAddress(rs.getString("address"));
                    p.setInsuranceInfo(rs.getString("insurance_info"));
                    p.setParentName(rs.getString("parent_name"));
                    p.setParentIdNumber(rs.getString("parent_id_number"));
                    p.setEmail(rs.getString("email"));
                    p.setPhone(rs.getString("phone"));
                    p.setDoctorName(rs.getString("doctor_name"));
                    p.setDoctorSpecialty(rs.getString("doctor_specialty"));
                    p.setAppointmentDate(rs.getString("appointment_date"));
                    p.setAppointmentTime(rs.getString("appointment_time"));
                    p.setStatus(rs.getString("status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return p;
    }

    /**
     * true Lấy thông tin chi tiết bệnh nhân theo ID
     *
     * @param id ID bệnh nhân
     * @return đối tượng Patient chứa thông tin chi tiết
     */
    public Patient getPatientById2(int id) {
        entity.Patient p = null;

        String sql = """
        SELECT 
            p.patient_id,
            p.user_id,
            p.full_name,
            p.dob,
            p.address,
            p.insurance_info,
            p.parent_id,

            pa.parentname AS parent_name,
            pa.id_info AS parent_id_number,

            uParent.email AS email,
            uParent.phone AS phone,

            uDoctor.username AS doctor_name,
            d.specialty AS doctor_specialty,

            FORMAT(a.date_time, 'dd/MM/yyyy') AS appointment_date,
            FORMAT(a.date_time, 'HH:mm') AS appointment_time,

            CASE WHEN a.status = 1 THEN N'Confirmed' ELSE N'Pending' END AS status
        FROM Patient p
        LEFT JOIN Parent pa ON p.parent_id = pa.parent_id
        LEFT JOIN [User] uParent ON p.user_id = uParent.user_id
        LEFT JOIN Appointment a ON p.patient_id = a.patient_id
        LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id
        LEFT JOIN [User] uDoctor ON d.user_id = uDoctor.user_id
        WHERE p.patient_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new entity.Patient();
                    p.setPatientId(rs.getInt("patient_id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setFullName(rs.getString("full_name"));
                    p.setDob(rs.getDate("dob"));
                    p.setAddress(rs.getString("address"));
                    p.setInsuranceInfo(rs.getString("insurance_info"));
                    p.setParentId(rs.getInt("parent_id"));

                    p.setParentName(rs.getString("parent_name"));
                    p.setParentIdNumber(rs.getString("parent_id_number"));
                    p.setEmail(rs.getString("email"));
                    p.setPhone(rs.getString("phone"));

                    p.setDoctorName(rs.getString("doctor_name"));
                    p.setDoctorSpecialty(rs.getString("doctor_specialty"));
                    p.setAppointmentDate(rs.getString("appointment_date"));
                    p.setAppointmentTime(rs.getString("appointment_time"));
                    p.setStatus(rs.getString("status"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return p;
    }

    /**
     * true Cập nhật thông tin bệnh nhân (bao gồm Patient, Parent, User)
     */
    public void updatePatient2(Patient p) {
        String sqlPatient = """
        UPDATE Patient
        SET full_name = ?, address = ?, insurance_info = ?, dob = ?
        WHERE patient_id = ?
    """;

        String sqlParent = """
        UPDATE Parent
        SET parentname = ?, id_info = ?
        WHERE parent_id = (
            SELECT parent_id FROM Patient WHERE patient_id = ?
        )
    """;

        String sqlUser = """
        UPDATE [User]
        SET email = ?, phone = ?
        WHERE user_id = (
            SELECT user_id FROM Patient WHERE patient_id = ?
        )
    """;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu transaction

            try (PreparedStatement ps1 = conn.prepareStatement(sqlPatient); PreparedStatement ps2 = conn.prepareStatement(sqlParent); PreparedStatement ps3 = conn.prepareStatement(sqlUser)) {

                // === 1. Cập nhật bảng Patient ===
                ps1.setString(1, p.getFullName());
                ps1.setString(2, p.getAddress());
                ps1.setString(3, p.getInsuranceInfo());
                ps1.setDate(4, (Date) p.getDob());
                ps1.setInt(5, p.getPatientId());
                ps1.executeUpdate();

                // === 2. Cập nhật bảng Parent ===
                ps2.setString(1, p.getParentName());
                ps2.setString(2, p.getParentIdNumber());
                ps2.setInt(3, p.getPatientId());
                ps2.executeUpdate();

                // === 3. Cập nhật bảng User ===
                ps3.setString(1, p.getEmail());
                ps3.setString(2, p.getPhone());
                ps3.setInt(3, p.getPatientId());
                ps3.executeUpdate();

                conn.commit(); // Xác nhận tất cả thay đổi
            } catch (Exception e) {
                conn.rollback(); // Nếu lỗi → rollback toàn bộ
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
