package dao;

import context.DBContext;
import entity.Discount;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DiscountDAO extends DBContext {
    
    private static final Logger LOGGER = Logger.getLogger(DiscountDAO.class.getName());

    // Get discount by ID
    public Discount getDiscountById(int discountId) {
        String sql = "SELECT * FROM Discount WHERE discount_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, discountId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDiscount(rs);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting discount by ID: " + discountId, e);
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
                    return mapResultSetToDiscount(rs);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting discount by code: " + code, e);
        }
        return null;
    }

    // Get all discounts
    public List<Discount> getAllDiscounts() {
        List<Discount> discounts = new ArrayList<>();
        String sql = "SELECT * FROM Discount ORDER BY discount_id DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                discounts.add(mapResultSetToDiscount(rs));
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting all discounts", e);
        }
        return discounts;
    }

    // Get all discounts with pagination and search
    public List<Discount> getAllDiscounts(String searchKeyword, String sortOrder, int page, int pageSize) {
        List<Discount> discounts = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM (");
        sql.append("  SELECT *, ROW_NUMBER() OVER (ORDER BY ");
        sql.append("    CASE WHEN ? = 'ASC' THEN discount_id END ASC,");
        sql.append("    CASE WHEN ? = 'DESC' THEN discount_id END DESC");
        sql.append("  ) as row_num FROM Discount");
        sql.append("  WHERE 1=1");
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND code LIKE ?");
        }
        
        sql.append(") AS numbered WHERE row_num BETWEEN ? AND ?");
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            ps.setString(paramIndex++, sortOrder);
            ps.setString(paramIndex++, sortOrder);
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchKeyword.trim() + "%");
            }
            
            int offset = (page - 1) * pageSize + 1;
            int limit = page * pageSize;
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    discounts.add(mapResultSetToDiscount(rs));
                }
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting discounts with pagination", e);
        }
        
        return discounts;
    }

    // Get total count of discounts for pagination
    public int getTotalDiscounts(String searchKeyword) {
        String sql = "SELECT COUNT(*) FROM Discount WHERE 1=1";
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql += " AND code LIKE ?";
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                ps.setString(1, "%" + searchKeyword.trim() + "%");
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting total discounts count", e);
        }
        
        return 0;
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
                    discounts.add(mapResultSetToDiscount(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting valid discounts by date", e);
        }
        return discounts;
    }

    // Get active discounts (currently valid)
    public List<Discount> getActiveDiscounts() {
        List<Discount> discounts = new ArrayList<>();
        String sql = "SELECT * FROM Discount WHERE (valid_from IS NULL OR valid_from <= GETDATE()) " +
                    "AND (valid_to IS NULL OR valid_to >= GETDATE()) ORDER BY discount_id";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                discounts.add(mapResultSetToDiscount(rs));
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting active discounts", e);
        }
        
        return discounts;
    }

    // Get discounts expiring soon (within 7 days)
    public List<Discount> getExpiringSoonDiscounts() {
        List<Discount> discounts = new ArrayList<>();
        String sql = "SELECT * FROM Discount WHERE valid_to IS NOT NULL " +
                    "AND valid_to >= GETDATE() " +
                    "AND valid_to <= DATEADD(day, 7, GETDATE()) " +
                    "ORDER BY valid_to ASC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                discounts.add(mapResultSetToDiscount(rs));
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting expiring soon discounts", e);
        }
        
        return discounts;
    }

    // Check if discount code exists (for validation)
    public boolean isDiscountCodeExists(String code, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM Discount WHERE code = ?";
        if (excludeId != null) {
            sql += " AND discount_id != ?";
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, code);
            if (excludeId != null) {
                ps.setInt(2, excludeId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking if discount code exists: " + code, e);
        }
        
        return false;
    }

    // Create a new discount
    public boolean createDiscount(Discount discount) {
        String sql = "INSERT INTO Discount (code, percentage, valid_from, valid_to) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, discount.getCode());
            ps.setBigDecimal(2, discount.getPercentage());
            
            if (discount.getValidFrom() != null) {
                ps.setTimestamp(3, new Timestamp(discount.getValidFrom().getTime()));
            } else {
                ps.setNull(3, java.sql.Types.TIMESTAMP);
            }
            
            if (discount.getValidTo() != null) {
                ps.setTimestamp(4, new Timestamp(discount.getValidTo().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.TIMESTAMP);
            }
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating discount", e);
            return false;
        }
    }

    // Update discount
    public boolean updateDiscount(Discount discount) {
        String sql = "UPDATE Discount SET code = ?, percentage = ?, valid_from = ?, valid_to = ? WHERE discount_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, discount.getCode());
            ps.setBigDecimal(2, discount.getPercentage());
            
            if (discount.getValidFrom() != null) {
                ps.setTimestamp(3, new Timestamp(discount.getValidFrom().getTime()));
            } else {
                ps.setNull(3, java.sql.Types.TIMESTAMP);
            }
            
            if (discount.getValidTo() != null) {
                ps.setTimestamp(4, new Timestamp(discount.getValidTo().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.TIMESTAMP);
            }
            
            ps.setInt(5, discount.getDiscountId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating discount", e);
            return false;
        }
    }

    // Delete discount by ID
    public boolean deleteDiscount(int discountId) {
        String sql = "DELETE FROM Discount WHERE discount_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, discountId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting discount", e);
            return false;
        }
    }

    // Map ResultSet to Discount object
    private Discount mapResultSetToDiscount(ResultSet rs) throws SQLException {
        Discount discount = new Discount();
        
        discount.setDiscountId(rs.getInt("discount_id"));
        discount.setCode(rs.getString("code"));
        discount.setPercentage(rs.getBigDecimal("percentage"));
        
        Timestamp validFrom = rs.getTimestamp("valid_from");
        if (validFrom != null) {
            discount.setValidFrom(new Date(validFrom.getTime()));
        }
        
        Timestamp validTo = rs.getTimestamp("valid_to");
        if (validTo != null) {
            discount.setValidTo(new Date(validTo.getTime()));
        }
        
        return discount;
    }
}