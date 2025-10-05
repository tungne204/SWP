package dao;

import context.DBContext;
import entity.Payment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO extends DBContext {

    // Create a new payment
    public void createPayment(Payment payment) {
        String sql = "INSERT INTO Payment (appointment_id, discount_id, amount, method, status, payment_date) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, payment.getAppointmentId());
            ps.setObject(2, payment.getDiscountId(), java.sql.Types.INTEGER);
            ps.setBigDecimal(3, payment.getAmount());
            ps.setString(4, payment.getMethod());
            ps.setObject(5, payment.getStatus(), java.sql.Types.BOOLEAN);
            ps.setDate(6, payment.getPaymentDate() != null ? new java.sql.Date(payment.getPaymentDate().getTime()) : null);
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Update payment status
    public void updatePaymentStatus(int paymentId, boolean status) {
        String sql = "UPDATE Payment SET status = ? WHERE payment_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, status);
            ps.setInt(2, paymentId);
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get payment by ID
    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT * FROM Payment WHERE payment_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, paymentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentId(rs.getInt("payment_id"));
                    payment.setAppointmentId(rs.getInt("appointment_id"));
                    payment.setDiscountId(rs.getObject("discount_id", Integer.class));
                    payment.setAmount(rs.getBigDecimal("amount"));
                    payment.setMethod(rs.getString("method"));
                    payment.setStatus(rs.getObject("status", Boolean.class));
                    payment.setPaymentDate(rs.getDate("payment_date"));
                    return payment;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get payments by appointment ID
    public List<Payment> getPaymentsByAppointmentId(int appointmentId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM Payment WHERE appointment_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, appointmentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentId(rs.getInt("payment_id"));
                    payment.setAppointmentId(rs.getInt("appointment_id"));
                    payment.setDiscountId(rs.getObject("discount_id", Integer.class));
                    payment.setAmount(rs.getBigDecimal("amount"));
                    payment.setMethod(rs.getString("method"));
                    payment.setStatus(rs.getObject("status", Boolean.class));
                    payment.setPaymentDate(rs.getDate("payment_date"));
                    payments.add(payment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payments;
    }

    // Get payments by status
    public List<Payment> getPaymentsByStatus(boolean status) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM Payment WHERE status = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentId(rs.getInt("payment_id"));
                    payment.setAppointmentId(rs.getInt("appointment_id"));
                    payment.setDiscountId(rs.getObject("discount_id", Integer.class));
                    payment.setAmount(rs.getBigDecimal("amount"));
                    payment.setMethod(rs.getString("method"));
                    payment.setStatus(rs.getObject("status", Boolean.class));
                    payment.setPaymentDate(rs.getDate("payment_date"));
                    payments.add(payment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payments;
    }

    // Get total revenue for a date range
    public BigDecimal getTotalRevenue(java.util.Date startDate, java.util.Date endDate) {
        String sql = "SELECT SUM(amount) as total_revenue FROM Payment WHERE payment_date BETWEEN ? AND ? AND status = 1";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("total_revenue") != null ? rs.getBigDecimal("total_revenue") : BigDecimal.ZERO;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
}