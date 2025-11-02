package dao.Receptionist;

import context.DBContext;
import entity.Receptionist.Doctor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO extends DBContext {

    /**
     * true Get doctor by ID
     *
     * @param doctorId
     * @return
     */
    public Doctor getDoctorById(int doctorId) {
        String sql = "SELECT * FROM Doctor WHERE doctor_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setUserId(rs.getInt("user_id"));
//                    doctor.setExperienceYears(rs.getString("experienceYears"));
                    return doctor;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * true Get all doctors Get all doctors with username Lấy tất cả bác sĩ
     *
     * @return
     */
    public List<Doctor> getAllDoctors() {
        List<Doctor> list = new ArrayList<>();
        String sql = """
        SELECT d.doctor_id, u.username, d.specialty
        FROM Doctor d
        JOIN [User] u ON d.user_id = u.user_id
        ORDER BY u.username
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Doctor d = new Doctor();
                d.setDoctorId(rs.getInt("doctor_id"));
                d.setUsername(rs.getString("username"));
                d.setSpecialty(rs.getString("specialty"));
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Doctor getDoctorByUserId(int userId) {
        Doctor d = null;
        String sql = "SELECT * FROM Doctor WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    d = new Doctor();
                    d.setDoctorId(rs.getInt("doctor_id"));
                    d.setUserId(rs.getInt("user_id"));
                    d.setUsername(rs.getString("name"));
                    d.setSpecialty(rs.getString("specialty"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return d;
    }

}
