package dao;

import context.DBContext;
import entity.Patient;
import java.sql.Connection;
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
    public List<Patient> searchPatients(String keyword) {
        List<Patient> patients = new ArrayList<>();
        String sql = """
            SELECT * FROM Patient
            WHERE CAST(patient_id AS NVARCHAR) LIKE ?
               OR LOWER(full_name) LIKE LOWER(?)
               OR LOWER(address) LIKE LOWER(?)
            ORDER BY patient_id DESC
            """;

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

}
