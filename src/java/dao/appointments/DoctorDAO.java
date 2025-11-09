/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.appointments;

import context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import entity.appointments.Doctor;
import entity.appointments.Patient;
import entity.User;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Quang Anh
 */
// ============= DoctorDAO.java =============
public class DoctorDAO extends DBContext {

    // Lấy tất cả bác sĩ
    public List<Doctor> getAllDoctors() {
        List<Doctor> list = new ArrayList<>();
        String sql = "SELECT d.*, u.username, u.email, u.phone, u.avatar, u.status "
                + "FROM Doctor d "
                + "INNER JOIN [User] u ON d.user_id = u.user_id "
                + "WHERE u.status = 1 "
                + "ORDER BY u.username";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setUserId(rs.getInt("user_id"));
                doctor.setExperienceYears(rs.getInt("experienceYears"));
                doctor.setCertificate(rs.getString("certificate"));
                doctor.setIntroduce(rs.getString("introduce"));

                // Thông tin user
                doctor.setUsername(rs.getString("username"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setAvatar(rs.getString("avatar"));

                list.add(doctor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(DoctorDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Lấy bác sĩ theo ID
    public Doctor getDoctorById(int doctorId) {
        String sql = "SELECT d.*, u.username, u.email, u.phone, u.avatar "
                + "FROM Doctor d "
                + "INNER JOIN [User] u ON d.user_id = u.user_id "
                + "WHERE d.doctor_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setUserId(rs.getInt("user_id"));
                doctor.setExperienceYears(rs.getInt("experienceYears"));
                doctor.setCertificate(rs.getString("certificate"));
                doctor.setIntroduce(rs.getString("introduce"));

                // Thông tin user
                doctor.setUsername(rs.getString("username"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setAvatar(rs.getString("avatar"));

                return doctor;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(DoctorDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Lấy doctor_id từ user_id
    public Integer getDoctorIdByUserId(int userId) {
        String sql = "SELECT doctor_id FROM Doctor WHERE user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("doctor_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(DoctorDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
