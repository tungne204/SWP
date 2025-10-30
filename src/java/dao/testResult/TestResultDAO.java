package dao.testResult;

import context.DBContext;
import entity.testResult.TestResult;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TestResultDAO extends DBContext {

    // Get all test results with patient and doctor info
    public List<TestResult> getAllTestResults() {
        List<TestResult> list = new ArrayList<>();
        String sql = "SELECT tr.test_id, tr.record_id, tr.test_type, tr.result, tr.date, " +
                     "tr.consultation_id, p.full_name as patient_name, u.username as doctor_name, " +
                     "mr.diagnosis " +
                     "FROM TestResult tr " +
                     "INNER JOIN MedicalReport mr ON tr.record_id = mr.record_id " +
                     "INNER JOIN Appointment a ON mr.appointment_id = a.appointment_id " +
                     "INNER JOIN Patient p ON a.patient_id = p.patient_id " +
                     "INNER JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                     "INNER JOIN [User] u ON d.user_id = u.user_id " +
                     "ORDER BY tr.date DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                TestResult tr = new TestResult();
                tr.setTestId(rs.getInt("test_id"));
                tr.setRecordId(rs.getInt("record_id"));
                tr.setTestType(rs.getString("test_type"));
                tr.setResult(rs.getString("result"));
                tr.setDate(rs.getDate("date"));
                tr.setConsultationId(rs.getObject("consultation_id") != null ?
                                     rs.getInt("consultation_id") : null);
                tr.setPatientName(rs.getString("patient_name"));
                tr.setDoctorName(rs.getString("doctor_name"));
                tr.setDiagnosis(rs.getString("diagnosis"));
                list.add(tr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(TestResultDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Get test result by ID
    public TestResult getTestResultById(int testId) {
        String sql = "SELECT tr.test_id, tr.record_id, tr.test_type, tr.result, tr.date, " +
                     "tr.consultation_id, p.full_name as patient_name, u.username as doctor_name, " +
                     "mr.diagnosis " +
                     "FROM TestResult tr " +
                     "INNER JOIN MedicalReport mr ON tr.record_id = mr.record_id " +
                     "INNER JOIN Appointment a ON mr.appointment_id = a.appointment_id " +
                     "INNER JOIN Patient p ON a.patient_id = p.patient_id " +
                     "INNER JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                     "INNER JOIN [User] u ON d.user_id = u.user_id " +
                     "WHERE tr.test_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TestResult tr = new TestResult();
                    tr.setTestId(rs.getInt("test_id"));
                    tr.setRecordId(rs.getInt("record_id"));
                    tr.setTestType(rs.getString("test_type"));
                    tr.setResult(rs.getString("result"));
                    tr.setDate(rs.getDate("date"));
                    tr.setConsultationId(rs.getObject("consultation_id") != null ?
                                         rs.getInt("consultation_id") : null);
                    tr.setPatientName(rs.getString("patient_name"));
                    tr.setDoctorName(rs.getString("doctor_name"));
                    tr.setDiagnosis(rs.getString("diagnosis"));
                    return tr;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(TestResultDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Get all medical reports (for dropdown in add/edit form)
    public List<MedicalReportInfo> getAllMedicalReports() {
        List<MedicalReportInfo> list = new ArrayList<>();
        String sql = "SELECT mr.record_id, p.full_name, mr.diagnosis " +
                     "FROM MedicalReport mr " +
                     "INNER JOIN Appointment a ON mr.appointment_id = a.appointment_id " +
                     "INNER JOIN Patient p ON a.patient_id = p.patient_id " +
                     "WHERE mr.test_request = 1 " +
                     "ORDER BY mr.record_id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                MedicalReportInfo info = new MedicalReportInfo();
                info.setRecordId(rs.getInt("record_id"));
                info.setPatientName(rs.getString("full_name"));
                info.setDiagnosis(rs.getString("diagnosis"));
                list.add(info);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(TestResultDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Insert new test result
    public boolean insertTestResult(TestResult testResult) {
        String sql = "INSERT INTO TestResult (record_id, test_type, result, date, consultation_id) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testResult.getRecordId());
            ps.setString(2, testResult.getTestType());
            ps.setString(3, testResult.getResult());
            ps.setDate(4, testResult.getDate());
            if (testResult.getConsultationId() != null) {
                ps.setInt(5, testResult.getConsultationId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception ex) {
            Logger.getLogger(TestResultDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Update test result
    public boolean updateTestResult(TestResult testResult) {
        String sql = "UPDATE TestResult SET record_id = ?, test_type = ?, result = ?, " +
                     "date = ?, consultation_id = ? WHERE test_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testResult.getRecordId());
            ps.setString(2, testResult.getTestType());
            ps.setString(3, testResult.getResult());
            ps.setDate(4, testResult.getDate());
            if (testResult.getConsultationId() != null) {
                ps.setInt(5, testResult.getConsultationId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, testResult.getTestId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception ex) {
            Logger.getLogger(TestResultDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Delete test result
    public boolean deleteTestResult(int testId) {
        String sql = "DELETE FROM TestResult WHERE test_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception ex) {
            Logger.getLogger(TestResultDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Inner class for medical report info
    public static class MedicalReportInfo {
        private int recordId;
        private String patientName;
        private String diagnosis;

        public int getRecordId() {
            return recordId;
        }

        public void setRecordId(int recordId) {
            this.recordId = recordId;
        }

        public String getPatientName() {
            return patientName;
        }

        public void setPatientName(String patientName) {
            this.patientName = patientName;
        }

        public String getDiagnosis() {
            return diagnosis;
        }

        public void setDiagnosis(String diagnosis) {
            this.diagnosis = diagnosis;
        }
    }
}
