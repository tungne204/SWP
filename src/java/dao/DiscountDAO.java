package dao;

import context.DBContext;
import entity.Discount;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class DiscountDAO extends DBContext {

    // Get discount by ID
    public Discount getDiscountById(int discountId) {
        String sql = "SELECT * FROM Discount WHERE discount_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, discountId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Discount discount = new Discount();
                    discount.setDiscountId(rs.getInt("discount_id"));
                    discount.setCode(rs.getString("code"));
                    discount.setPercentage(rs.getBigDecimal("percentage"));
                    discount.setValidFrom(rs.getDate("valid_from"));
                    discount.setValidTo(rs.getDate("valid_to"));
                    return discount;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get discount by code
    public Discount getDiscountByCode(String code) {
        String sql = "SELECT * FROM Discount WHERE code = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, code);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Discount discount = new Discount();
                    discount.setDiscountId(rs.getInt("discount_id"));
                    discount.setCode(rs.getString("code"));
                    discount.setPercentage(rs.getBigDecimal("percentage"));
                    discount.setValidFrom(rs.getDate("valid_from"));
                    discount.setValidTo(rs.getDate("valid_to"));
                    return discount;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all discounts
    public List<Discount> getAllDiscounts() {
        List<Discount> discounts = new ArrayList<>();
        String sql = "SELECT * FROM Discount";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Discount discount = new Discount();
                discount.setDiscountId(rs.getInt("discount_id"));
                discount.setCode(rs.getString("code"));
                discount.setPercentage(rs.getBigDecimal("percentage"));
                discount.setValidFrom(rs.getDate("valid_from"));
                discount.setValidTo(rs.getDate("valid_to"));
                discounts.add(discount);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discounts;
    }

    // Get valid discounts by date
    public List<Discount> getValidDiscountsByDate(java.util.Date date) {
        List<Discount> discounts = new ArrayList<>();
        String sql = "SELECT * FROM Discount WHERE valid_from <= ? AND valid_to >= ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDate(1, new java.sql.Date(date.getTime()));
            ps.setDate(2, new java.sql.Date(date.getTime()));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Discount discount = new Discount();
                    discount.setDiscountId(rs.getInt("discount_id"));
                    discount.setCode(rs.getString("code"));
                    discount.setPercentage(rs.getBigDecimal("percentage"));
                    discount.setValidFrom(rs.getDate("valid_from"));
                    discount.setValidTo(rs.getDate("valid_to"));
                    discounts.add(discount);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discounts;
    }

    // Create a new discount
    public void createDiscount(Discount discount) {
        String sql = "INSERT INTO Discount (code, percentage, valid_from, valid_to) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, discount.getCode());
            ps.setBigDecimal(2, discount.getPercentage());
            ps.setDate(3, discount.getValidFrom() != null ? new java.sql.Date(discount.getValidFrom().getTime()) : null);
            ps.setDate(4, discount.getValidTo() != null ? new java.sql.Date(discount.getValidTo().getTime()) : null);
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update discount
    public void updateDiscount(Discount discount) {
        String sql = "UPDATE Discount SET code = ?, percentage = ?, valid_from = ?, valid_to = ? WHERE discount_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, discount.getCode());
            ps.setBigDecimal(2, discount.getPercentage());
            ps.setDate(3, discount.getValidFrom() != null ? new java.sql.Date(discount.getValidFrom().getTime()) : null);
            ps.setDate(4, discount.getValidTo() != null ? new java.sql.Date(discount.getValidTo().getTime()) : null);
            ps.setInt(5, discount.getDiscountId());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete discount by ID
    public void deleteDiscount(int discountId) {
        String sql = "DELETE FROM Discount WHERE discount_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, discountId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}