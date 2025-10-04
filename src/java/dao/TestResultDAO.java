package dao;

import context.DBContext;
import entity.TestResult;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TestResultDAO extends DBContext {

    // Get test result by ID
    public TestResult getTestResultById(int testId) {
        String sql = "SELECT * FROM TestResult WHERE test_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TestResult testResult = new TestResult();
                    testResult.setTestId(rs.getInt("test_id"));
                    testResult.setRecordId(rs.getInt("record_id"));
                    testResult.setTestType(rs.getString("test_type"));
                    testResult.setResult(rs.getString("result"));
                    testResult.setDate(rs.getDate("date"));
                    testResult.setConsultationId(rs.getObject("consultation_id", Integer.class));
                    return testResult;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get test results by record ID
    public List<TestResult> getTestResultsByRecordId(int recordId) {
        List<TestResult> testResults = new ArrayList<>();
        String sql = "SELECT * FROM TestResult WHERE record_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, recordId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TestResult testResult = new TestResult();
                    testResult.setTestId(rs.getInt("test_id"));
                    testResult.setRecordId(rs.getInt("record_id"));
                    testResult.setTestType(rs.getString("test_type"));
                    testResult.setResult(rs.getString("result"));
                    testResult.setDate(rs.getDate("date"));
                    testResult.setConsultationId(rs.getObject("consultation_id", Integer.class));
                    testResults.add(testResult);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return testResults;
    }

    // Get test results by consultation ID
    public List<TestResult> getTestResultsByConsultationId(int consultationId) {
        List<TestResult> testResults = new ArrayList<>();
        String sql = "SELECT * FROM TestResult WHERE consultation_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, consultationId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TestResult testResult = new TestResult();
                    testResult.setTestId(rs.getInt("test_id"));
                    testResult.setRecordId(rs.getInt("record_id"));
                    testResult.setTestType(rs.getString("test_type"));
                    testResult.setResult(rs.getString("result"));
                    testResult.setDate(rs.getDate("date"));
                    testResult.setConsultationId(rs.getObject("consultation_id", Integer.class));
                    testResults.add(testResult);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return testResults;
    }

    // Create a new test result
    public void createTestResult(TestResult testResult) {
        String sql = "INSERT INTO TestResult (record_id, test_type, result, date, consultation_id) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testResult.getRecordId());
            ps.setString(2, testResult.getTestType());
            ps.setString(3, testResult.getResult());
            ps.setDate(4, testResult.getDate() != null ? new java.sql.Date(testResult.getDate().getTime()) : null);
            ps.setObject(5, testResult.getConsultationId(), java.sql.Types.INTEGER);
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update test result
    public void updateTestResult(TestResult testResult) {
        String sql = "UPDATE TestResult SET test_type = ?, result = ?, date = ?, consultation_id = ? WHERE test_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, testResult.getTestType());
            ps.setString(2, testResult.getResult());
            ps.setDate(3, testResult.getDate() != null ? new java.sql.Date(testResult.getDate().getTime()) : null);
            ps.setObject(4, testResult.getConsultationId(), java.sql.Types.INTEGER);
            ps.setInt(5, testResult.getTestId());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete test result by ID
    public void deleteTestResult(int testId) {
        String sql = "DELETE FROM TestResult WHERE test_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}