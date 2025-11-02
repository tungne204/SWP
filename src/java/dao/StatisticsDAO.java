package dao;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StatisticsDAO extends DBContext {
    
    private static final Logger LOGGER = Logger.getLogger(StatisticsDAO.class.getName());
    
    // Get total number of patients
    public int getTotalPatients() {
        String sql = "SELECT COUNT(*) FROM Patient";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get total number of appointments
    public int getTotalAppointments() {
        String sql = "SELECT COUNT(*) FROM Appointment";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get total number of active appointments
    public int getActiveAppointments() {
        String sql = "SELECT COUNT(*) FROM Appointment WHERE status = 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get total revenue
    public double getTotalRevenue() {
        String sql = "SELECT SUM(amount) FROM Payment WHERE status = 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // Get monthly revenue for current year
    public double getMonthlyRevenue() {
        String sql = "SELECT SUM(amount) FROM Payment WHERE status = 1 AND MONTH(payment_date) = MONTH(GETDATE()) AND YEAR(payment_date) = YEAR(GETDATE())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // Get monthly revenue for all 12 months of current year
    public Map<Integer, Double> getMonthlyRevenueByMonth() {
        Map<Integer, Double> monthlyRevenue = new HashMap<>();
        
        // Initialize all months with 0
        for (int i = 1; i <= 12; i++) {
            monthlyRevenue.put(i, 0.0);
        }
        
        String sql = "SELECT MONTH(payment_date) as month, SUM(amount) as revenue " +
                     "FROM Payment " +
                     "WHERE status = 1 AND YEAR(payment_date) = YEAR(GETDATE()) " +
                     "GROUP BY MONTH(payment_date)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int month = rs.getInt("month");
                double revenue = rs.getDouble("revenue");
                monthlyRevenue.put(month, revenue);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return monthlyRevenue;
    }
    
    // Get appointments by status
    public List<Map<String, Object>> getAppointmentsByStatus() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT status, COUNT(*) as count FROM Appointment GROUP BY status";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("status", rs.getString("status"));
                row.put("count", rs.getInt("count"));
                result.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // Get top doctors by appointment count
    public List<Map<String, Object>> getTopDoctorsByAppointments() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT TOP 5 d.doctor_id, u.username as doctor_name, COUNT(*) as appointment_count " +
                     "FROM Appointment a " +
                     "JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                     "JOIN [User] u ON d.user_id = u.user_id " +
                     "WHERE a.status = 1 " +
                     "GROUP BY d.doctor_id, u.username " +
                     "ORDER BY appointment_count DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("doctor_id", rs.getInt("doctor_id"));
                row.put("doctor_name", rs.getString("doctor_name"));
                row.put("appointment_count", rs.getInt("appointment_count"));
                result.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // Get payment methods distribution
    public List<Map<String, Object>> getPaymentMethodDistribution() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT method, COUNT(*) as count FROM Payment GROUP BY method";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("method", rs.getString("method"));
                row.put("count", rs.getInt("count"));
                result.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // Get recent appointments count (last 30 days)
    public int getRecentAppointments() {
        String sql = "SELECT COUNT(*) FROM Appointment WHERE date_time >= DATEADD(day, -30, GETDATE())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get total number of doctors
    public int getTotalDoctors() {
        String sql = "SELECT COUNT(*) FROM Doctor";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}