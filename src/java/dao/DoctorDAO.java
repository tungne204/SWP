/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import context.DBConnection;
import java.sql.*;
/**
 *
 * @author Quang Anh
 */
public class DoctorDAO {
     public int getDoctorIdByUserId(int userId) {
        int doctorId = -1;
        String sql = "SELECT doctor_id FROM Doctor WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                doctorId = rs.getInt("doctor_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return doctorId;
    }
    
    public String getDoctorSpecialtyByUserId(int userId) {
        String specialty = null;
        String sql = "SELECT specialty FROM Doctor WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                specialty = rs.getString("specialty");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return specialty;
    }
}
