package dao.RolePatient;

import context.DBContext;
import entity.Patient;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Patient DAO - Handles patient database operations
 * This DAO is specifically for patient functionality to avoid conflicts
 */
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
        String sql = "SELECT * FROM Patient WHERE user_id = ? ORDER BY patient_id DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                Patient patient = null;
                if (rs.next()) {
                    patient = new Patient();
                    patient.setPatientId(rs.getInt("patient_id"));
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setFullName(rs.getString("full_name"));
                    patient.setDob(rs.getDate("dob"));
                    patient.setAddress(rs.getString("address"));
                    patient.setInsuranceInfo(rs.getString("insurance_info"));
                    patient.setParentId(rs.getObject("parent_id", Integer.class));
                }
                return patient;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all patients by user ID (in case user has multiple patients)
    public List<Patient> getAllPatientsByUserId(int userId) {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM Patient WHERE user_id = ? ORDER BY patient_id DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patients;
    }

    // Create new patient
    public int createPatient(Patient patient) {
        String sql = "INSERT INTO Patient (user_id, full_name, dob, address, insurance_info, parent_id) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, patient.getUserId());
            ps.setString(2, patient.getFullName());
            ps.setDate(3, new java.sql.Date(patient.getDob().getTime()));
            ps.setString(4, patient.getAddress());
            ps.setString(5, patient.getInsuranceInfo());
            ps.setObject(6, patient.getParentId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
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

    // Update patient
    public void updatePatient(Patient patient) {
        String sql = "UPDATE Patient SET full_name = ?, dob = ?, address = ?, insurance_info = ?, parent_id = ? WHERE patient_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patient.getFullName());
            ps.setDate(2, new java.sql.Date(patient.getDob().getTime()));
            ps.setString(3, patient.getAddress());
            ps.setString(4, patient.getInsuranceInfo());
            ps.setObject(5, patient.getParentId());
            ps.setInt(6, patient.getPatientId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Delete patient
    public void deletePatient(int patientId) {
        String sql = "DELETE FROM Patient WHERE patient_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Check if patient exists by user ID
    public boolean isPatientExists(int userId) {
        String sql = "SELECT COUNT(*) FROM Patient WHERE user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get patient count by user ID
    public int getPatientCountByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM Patient WHERE user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

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

    // Search patients by name
    public List<Patient> searchPatientsByName(String name) {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM Patient WHERE full_name LIKE ? ORDER BY full_name";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + name + "%");

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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patients;
    }
}
