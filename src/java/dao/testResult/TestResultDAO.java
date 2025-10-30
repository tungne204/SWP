package dao.testResult;

import context.DBContext;
import entity.testResult.TestResult;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TestResultDAO extends DBContext {
    public List<String> getDistinctTestTypes() {
    List<String> testTypes = new ArrayList<>();
    String sql = "SELECT DISTINCT test_type FROM TestResult ORDER BY test_type";

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            testTypes.add(rs.getString("test_type"));
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }   catch (Exception ex) {
            Logger.getLogger(TestResultDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

    return testTypes;
}


    public List<TestResult> getTestResults(String searchQuery, String testTypeFilter, int page, int pageSize) {
        List<TestResult> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT tr.test_id, tr.record_id, tr.test_type, tr.result, tr.date, ")
                .append("tr.consultation_id, p.full_name AS patient_name, u.username AS doctor_name, ")
                .append("mr.diagnosis ")
                .append("FROM TestResult tr ")
                .append("INNER JOIN MedicalReport mr ON tr.record_id = mr.record_id ")
                .append("INNER JOIN Appointment a ON mr.appointment_id = a.appointment_id ")
                .append("INNER JOIN Patient p ON a.patient_id = p.patient_id ")
                .append("INNER JOIN Doctor d ON a.doctor_id = d.doctor_id ")
                .append("INNER JOIN [User] u ON d.user_id = u.user_id ")
                .append("WHERE 1=1 ");

        // Search condition
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (p.full_name LIKE ? OR tr.test_type LIKE ? OR tr.result LIKE ?) ");
        }

        // Filter condition
        if (testTypeFilter != null && !testTypeFilter.trim().isEmpty() && !testTypeFilter.equalsIgnoreCase("All")) {
            sql.append("AND tr.test_type = ? ");
        }

        sql.append("ORDER BY tr.date DESC ")
                .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // Search params
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String searchPattern = "%" + searchQuery.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            // Filter param
            if (testTypeFilter != null && !testTypeFilter.trim().isEmpty() && !testTypeFilter.equalsIgnoreCase("All")) {
                ps.setString(paramIndex++, testTypeFilter.trim());
            }

            // Paging params
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TestResult tr = new TestResult();
                    tr.setTestId(rs.getInt("test_id"));
                    tr.setRecordId(rs.getInt("record_id"));
                    tr.setTestType(rs.getString("test_type"));
                    tr.setResult(rs.getString("result"));
                    tr.setDate(rs.getDate("date"));
                    tr.setConsultationId(rs.getObject("consultation_id") != null ? rs.getInt("consultation_id") : null);
                    tr.setPatientName(rs.getString("patient_name"));
                    tr.setDoctorName(rs.getString("doctor_name"));
                    tr.setDiagnosis(rs.getString("diagnosis"));
                    list.add(tr);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(TestResultDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    // Get total count for pagination
    public int getTotalCount(String searchQuery, String testTypeFilter) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) AS total ")
                .append("FROM TestResult tr ")
                .append("INNER JOIN MedicalReport mr ON tr.record_id = mr.record_id ")
                .append("INNER JOIN Appointment a ON mr.appointment_id = a.appointment_id ")
                .append("INNER JOIN Patient p ON a.patient_id = p.patient_id ")
                .append("WHERE 1=1 ");

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (p.full_name LIKE ? OR tr.test_type LIKE ? OR tr.result LIKE ?) ");
        }

        if (testTypeFilter != null && !testTypeFilter.trim().isEmpty() && !testTypeFilter.equalsIgnoreCase("All")) {
            sql.append("AND tr.test_type = ? ");
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String searchPattern = "%" + searchQuery.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            if (testTypeFilter != null && !testTypeFilter.trim().isEmpty() && !testTypeFilter.equalsIgnoreCase("All")) {
                ps.setString(paramIndex++, testTypeFilter.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(TestResultDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return 0;
    }

    // Get all test results (deprecated - use getTestResults instead)
    @Deprecated
    public List<TestResult> getAllTestResults() {
        // Gọi hàm mới với mặc định hiển thị 10 kết quả đầu tiên
        return getTestResults(null, null, 1, 10);
    }

    // Get test result by ID
    public TestResult getTestResultById(int testId) {
        String sql = "SELECT tr.test_id, tr.record_id, tr.test_type, tr.result, tr.date, "
                + "tr.consultation_id, p.full_name as patient_name, u.username as doctor_name, "
                + "mr.diagnosis "
                + "FROM TestResult tr "
                + "INNER JOIN MedicalReport mr ON tr.record_id = mr.record_id "
                + "INNER JOIN Appointment a ON mr.appointment_id = a.appointment_id "
                + "INNER JOIN Patient p ON a.patient_id = p.patient_id "
                + "INNER JOIN Doctor d ON a.doctor_id = d.doctor_id "
                + "INNER JOIN [User] u ON d.user_id = u.user_id "
                + "WHERE tr.test_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, testId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TestResult tr = new TestResult();
                    tr.setTestId(rs.getInt("test_id"));
                    tr.setRecordId(rs.getInt("record_id"));
                    tr.setTestType(rs.getString("test_type"));
                    tr.setResult(rs.getString("result"));
                    tr.setDate(rs.getDate("date"));
                    tr.setConsultationId(rs.getObject("consultation_id") != null
                            ? rs.getInt("consultation_id") : null);
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
        String sql = "SELECT mr.record_id, p.full_name, mr.diagnosis "
                + "FROM MedicalReport mr "
                + "INNER JOIN Appointment a ON mr.appointment_id = a.appointment_id "
                + "INNER JOIN Patient p ON a.patient_id = p.patient_id "
                + "WHERE mr.test_request = 1 "
                + "ORDER BY mr.record_id DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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
        String sql = "INSERT INTO TestResult (record_id, test_type, result, date, consultation_id) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        String sql = "UPDATE TestResult SET record_id = ?, test_type = ?, result = ?, "
                + "date = ?, consultation_id = ? WHERE test_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
