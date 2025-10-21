/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import context.DBContext;
import entity.TestResult;
import java.sql.*;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class TestResultDAO extends DBContext {
    // 🔹 Lấy doctor_id từ user_id (đặt trong cùng DAO)
    public int getDoctorIdByUserId(int userId) throws Exception {
        String sql = "SELECT doctor_id FROM Doctor WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("doctor_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Không tìm thấy
    }

    // Lấy tất cả test results của một medical record
    public List<TestResult> getByRecordId(int recordId) {
        List<TestResult> list = new ArrayList<>();
        String sql = "SELECT tr.test_id, tr.record_id, tr.test_type, tr.result, tr.date, " +
                    "tr.consultation_id, p.full_name as patient_name, mr.diagnosis " +
                    "FROM TestResult tr " +
                    "JOIN MedicalReport mr ON tr.record_id = mr.record_id " +
                    "JOIN Appointment a ON mr.appointment_id = a.appointment_id " +
                    "JOIN Patient p ON a.patient_id = p.patient_id " +
                    "WHERE tr.record_id = ? " +
                    "ORDER BY tr.date DESC, tr.test_id ASC";
        
        try (Connection conn = getConnection();  // try-with-resources
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                TestResult tr = new TestResult();
                tr.setTestId(rs.getInt("test_id"));
                tr.setRecordId(rs.getInt("record_id"));
                tr.setTestType(rs.getString("test_type"));
                tr.setResult(rs.getString("result"));
                tr.setDate(rs.getString("date"));
                
                int consultationId = rs.getInt("consultation_id");
                tr.setConsultationId(rs.wasNull() ? null : consultationId);
                
                tr.setPatientName(rs.getString("patient_name"));
                tr.setDiagnosis(rs.getString("diagnosis"));
                list.add(tr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả test results của một doctor
    public List<TestResult> getAllByDoctorId(int doctorId) {
        List<TestResult> list = new ArrayList<>();
        String sql = "SELECT tr.test_id, tr.record_id, tr.test_type, tr.result, tr.date, " +
                    "tr.consultation_id, p.full_name as patient_name, mr.diagnosis " +
                    "FROM TestResult tr " +
                    "JOIN MedicalReport mr ON tr.record_id = mr.record_id " +
                    "JOIN Appointment a ON mr.appointment_id = a.appointment_id " +
                    "JOIN Patient p ON a.patient_id = p.patient_id " +
                    "JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                    "WHERE d.doctor_id = ? " +
                    "ORDER BY tr.date DESC, tr.test_id DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                TestResult tr = new TestResult();
                tr.setTestId(rs.getInt("test_id"));
                tr.setRecordId(rs.getInt("record_id"));
                tr.setTestType(rs.getString("test_type"));
                tr.setResult(rs.getString("result"));
                tr.setDate(rs.getString("date"));
                
                int consultationId = rs.getInt("consultation_id");
                tr.setConsultationId(rs.wasNull() ? null : consultationId);
                
                tr.setPatientName(rs.getString("patient_name"));
                tr.setDiagnosis(rs.getString("diagnosis"));
                list.add(tr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy một test result theo ID
    public TestResult getById(int testId) {
        String sql = "SELECT tr.test_id, tr.record_id, tr.test_type, tr.result, tr.date, " +
                    "tr.consultation_id, p.full_name as patient_name, mr.diagnosis " +
                    "FROM TestResult tr " +
                    "JOIN MedicalReport mr ON tr.record_id = mr.record_id " +
                    "JOIN Appointment a ON mr.appointment_id = a.appointment_id " +
                    "JOIN Patient p ON a.patient_id = p.patient_id " +
                    "WHERE tr.test_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                TestResult tr = new TestResult();
                tr.setTestId(rs.getInt("test_id"));
                tr.setRecordId(rs.getInt("record_id"));
                tr.setTestType(rs.getString("test_type"));
                tr.setResult(rs.getString("result"));
                tr.setDate(rs.getString("date"));
                
                int consultationId = rs.getInt("consultation_id");
                tr.setConsultationId(rs.wasNull() ? null : consultationId);
                
                tr.setPatientName(rs.getString("patient_name"));
                tr.setDiagnosis(rs.getString("diagnosis"));
                return tr;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Kiểm tra medical report có yêu cầu xét nghiệm không
    public boolean hasTestRequest(int recordId) {
        String sql = "SELECT test_request FROM MedicalReport WHERE record_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBoolean("test_request");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Count test results for a record
    public int countByRecordId(int recordId) {
        String sql = "SELECT COUNT(*) as total FROM TestResult WHERE record_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy test results theo consultation_id
    public List<TestResult> getByConsultationId(int consultationId) {
        List<TestResult> list = new ArrayList<>();
        String sql = "SELECT tr.test_id, tr.record_id, tr.test_type, tr.result, tr.date, " +
                    "tr.consultation_id, p.full_name as patient_name, mr.diagnosis " +
                    "FROM TestResult tr " +
                    "LEFT JOIN MedicalReport mr ON tr.record_id = mr.record_id " +
                    "LEFT JOIN Appointment a ON mr.appointment_id = a.appointment_id " +
                    "LEFT JOIN Patient p ON a.patient_id = p.patient_id " +
                    "WHERE tr.consultation_id = ? " +
                    "ORDER BY tr.date DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, consultationId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                TestResult tr = new TestResult();
                tr.setTestId(rs.getInt("test_id"));
                tr.setRecordId(rs.getInt("record_id"));
                tr.setTestType(rs.getString("test_type"));
                tr.setResult(rs.getString("result"));
                tr.setDate(rs.getString("date"));
                tr.setConsultationId(rs.getInt("consultation_id"));
                tr.setPatientName(rs.getString("patient_name"));
                tr.setDiagnosis(rs.getString("diagnosis"));
                list.add(tr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tạo mới test result
    public boolean createTestResult(TestResult testResult) {
        String sql = "INSERT INTO TestResult (record_id, test_type, result, date, consultation_id) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testResult.getRecordId());
            ps.setString(2, testResult.getTestType());
            ps.setString(3, testResult.getResult());
            ps.setString(4, testResult.getDate());
            
            if (testResult.getConsultationId() != null) {
                ps.setInt(5, testResult.getConsultationId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}