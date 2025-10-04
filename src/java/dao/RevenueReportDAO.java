package dao;

import context.DBContext;
import entity.RevenueReport;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class RevenueReportDAO extends DBContext {

    // Create a new revenue report
    public void createRevenueReport(RevenueReport report) {
        String sql = "INSERT INTO RevenueReport (manager_id, date_from, date_to, total_revenue) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, report.getManagerId());
            ps.setDate(2, new java.sql.Date(report.getDateFrom().getTime()));
            ps.setDate(3, new java.sql.Date(report.getDateTo().getTime()));
            ps.setBigDecimal(4, report.getTotalRevenue());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get revenue report by ID
    public RevenueReport getRevenueReportById(int reportId) {
        String sql = "SELECT * FROM RevenueReport WHERE report_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RevenueReport report = new RevenueReport();
                    report.setReportId(rs.getInt("report_id"));
                    report.setManagerId(rs.getInt("manager_id"));
                    report.setDateFrom(rs.getDate("date_from"));
                    report.setDateTo(rs.getDate("date_to"));
                    report.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                    return report;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get revenue reports by manager ID
    public List<RevenueReport> getRevenueReportsByManagerId(int managerId) {
        List<RevenueReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM RevenueReport WHERE manager_id = ? ORDER BY date_from DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, managerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RevenueReport report = new RevenueReport();
                    report.setReportId(rs.getInt("report_id"));
                    report.setManagerId(rs.getInt("manager_id"));
                    report.setDateFrom(rs.getDate("date_from"));
                    report.setDateTo(rs.getDate("date_to"));
                    report.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                    reports.add(report);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }

    // Get revenue reports by date range
    public List<RevenueReport> getRevenueReportsByDateRange(java.util.Date startDate, java.util.Date endDate) {
        List<RevenueReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM RevenueReport WHERE date_from >= ? AND date_to <= ? ORDER BY date_from DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RevenueReport report = new RevenueReport();
                    report.setReportId(rs.getInt("report_id"));
                    report.setManagerId(rs.getInt("manager_id"));
                    report.setDateFrom(rs.getDate("date_from"));
                    report.setDateTo(rs.getDate("date_to"));
                    report.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                    reports.add(report);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }

    // Update total revenue in a report
    public void updateTotalRevenue(int reportId, BigDecimal totalRevenue) {
        String sql = "UPDATE RevenueReport SET total_revenue = ? WHERE report_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBigDecimal(1, totalRevenue);
            ps.setInt(2, reportId);
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}