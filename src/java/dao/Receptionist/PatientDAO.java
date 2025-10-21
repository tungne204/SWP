/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.Receptionist;

/**
 * DAO xử lý dữ liệu bệnh nhân cho module Receptionist - Hiển thị danh sách bệnh
 * nhân và lịch khám gần nhất - Tìm kiếm bệnh nhân theo tên hoặc ID - Lấy chi
 * tiết bệnh nhân theo ID
 *
 * @author Kiên
 */
import entity.Receptionist.Patient;
import entity.Receptionist.Parent;
import entity.Receptionist.User;
import entity.Receptionist.Doctor;
import entity.Receptionist.Appointment;
import entity.Receptionist.Role;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import context.DBContext;

public class PatientDAO extends DBContext {

    /**
     * Lấy danh sách toàn bộ bệnh nhân cùng thông tin lịch hẹn mới nhất
     */
    public List<Patient> getAllPatients() {
        List<Patient> list = new ArrayList<>();
        String sql = """
            SELECT 
                p.patient_id, 
                p.full_name, 
                p.address, 
                p.insurance_info,
                p.dob,                            -- Thêm ngày sinh
                pa.parentname AS parent_name,
                u.username AS doctor_name,
                a.date_time AS appointment_date,
                CASE WHEN a.status = 1 THEN N'Đã khám' ELSE N'Chưa khám' END AS status
            FROM Patient p
            LEFT JOIN Parent pa ON p.parent_id = pa.parent_id
            LEFT JOIN Appointment a 
                ON a.appointment_id = (
                    SELECT TOP 1 appointment_id 
                    FROM Appointment 
                    WHERE patient_id = p.patient_id 
                    ORDER BY date_time DESC
                )
            LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id
            LEFT JOIN [User] u ON d.user_id = u.user_id
            ORDER BY p.patient_id ASC
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Patient p = new Patient();
                p.setPatientId(rs.getInt("patient_id"));
                p.setFullName(rs.getString("full_name"));
                p.setAddress(rs.getString("address"));
                p.setInsuranceInfo(rs.getString("insurance_info"));
                p.setDob(rs.getDate("dob")); // Thêm dob
                p.setParentName(rs.getString("parent_name"));
                p.setDoctorName(rs.getString("doctor_name"));
                p.setAppointmentDate(rs.getString("appointment_date"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Tìm kiếm bệnh nhân theo tên hoặc ID (cũng chỉ lấy lịch khám mới nhất)
     */
    public List<Patient> searchPatients(String keyword) {
        List<Patient> list = new ArrayList<>();

        String sql = """
        SELECT 
            p.patient_id, 
            p.full_name, 
            p.address, 
            p.insurance_info,
            p.dob,
            pa.parentname AS parent_name,
            pa.id_info AS parent_id,
            u.email,
            u.phone,
            a.date_time AS appointment_date,
            CASE WHEN a.status = 1 THEN N'Confirmed' ELSE N'Pending' END AS status
        FROM Patient p
        LEFT JOIN Parent pa ON p.parent_id = pa.parent_id
        LEFT JOIN [User] u ON p.user_id = u.user_id
        LEFT JOIN Appointment a 
            ON a.appointment_id = (
                SELECT TOP 1 appointment_id 
                FROM Appointment 
                WHERE patient_id = p.patient_id 
                ORDER BY date_time DESC
            )
        WHERE 
            p.full_name LIKE ? OR
            CAST(p.patient_id AS NVARCHAR) LIKE ? OR
            p.address LIKE ? OR
            p.insurance_info LIKE ? OR
            CONVERT(NVARCHAR, p.dob, 23) LIKE ? OR
            pa.parentname LIKE ? OR
            pa.id_info LIKE ? OR
            u.email LIKE ? OR
            u.phone LIKE ?
        ORDER BY p.patient_id ASC
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 1; i <= 9; i++) {
                ps.setString(i, "%" + keyword + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Patient p = new Patient();
                p.setPatientId(rs.getInt("patient_id"));
                p.setFullName(rs.getString("full_name"));
                p.setAddress(rs.getString("address"));
                p.setInsuranceInfo(rs.getString("insurance_info"));
                p.setDob(rs.getDate("dob"));
                p.setParentName(rs.getString("parent_name"));
                p.setEmail(rs.getString("email"));
                p.setPhone(rs.getString("phone"));
                p.setAppointmentDate(rs.getString("appointment_date"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy thông tin chi tiết bệnh nhân theo ID
     *
     * @param id ID bệnh nhân
     * @return đối tượng Patient chứa thông tin chi tiết
     */
    public Patient getPatientById(int id) {
        Patient p = null;

        String sql = """
        SELECT 
            p.patient_id,
            p.user_id,
            p.full_name,
            p.dob,
            p.address,
            p.insurance_info,
            p.parent_id,

            pa.parentname AS parent_name,
            pa.id_info AS parent_id_number,

            uParent.email AS email,
            uParent.phone AS phone,

            uDoctor.username AS doctor_name,
            d.specialty AS doctor_specialty,

            FORMAT(a.date_time, 'dd/MM/yyyy') AS appointment_date,
            FORMAT(a.date_time, 'HH:mm') AS appointment_time,

            CASE WHEN a.status = 1 THEN N'Confirmed' ELSE N'Pending' END AS status
        FROM Patient p
        LEFT JOIN Parent pa ON p.parent_id = pa.parent_id
        LEFT JOIN [User] uParent ON p.user_id = uParent.user_id
        LEFT JOIN Appointment a ON p.patient_id = a.patient_id
        LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id
        LEFT JOIN [User] uDoctor ON d.user_id = uDoctor.user_id
        WHERE p.patient_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Patient();
                    p.setPatientId(rs.getInt("patient_id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setFullName(rs.getString("full_name"));
                    p.setDob(rs.getDate("dob"));
                    p.setAddress(rs.getString("address"));
                    p.setInsuranceInfo(rs.getString("insurance_info"));
                    p.setParentId(rs.getInt("parent_id"));

                    p.setParentName(rs.getString("parent_name"));
                    p.setParentIdNumber(rs.getString("parent_id_number"));
                    p.setEmail(rs.getString("email"));
                    p.setPhone(rs.getString("phone"));

                    p.setDoctorName(rs.getString("doctor_name"));
                    p.setDoctorSpecialty(rs.getString("doctor_specialty"));
                    p.setAppointmentDate(rs.getString("appointment_date"));
                    p.setAppointmentTime(rs.getString("appointment_time"));
                    p.setStatus(rs.getString("status"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return p;
    }

    /**
     * Cập nhật thông tin bệnh nhân (bao gồm Patient, Parent, User)
     */
    public void updatePatient(Patient p) {
        String sqlPatient = """
        UPDATE Patient
        SET full_name = ?, address = ?, insurance_info = ?, dob = ?
        WHERE patient_id = ?
    """;

        String sqlParent = """
        UPDATE Parent
        SET parentname = ?, id_info = ?
        WHERE parent_id = (
            SELECT parent_id FROM Patient WHERE patient_id = ?
        )
    """;

        String sqlUser = """
        UPDATE [User]
        SET email = ?, phone = ?
        WHERE user_id = (
            SELECT user_id FROM Patient WHERE patient_id = ?
        )
    """;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu transaction

            try (PreparedStatement ps1 = conn.prepareStatement(sqlPatient); PreparedStatement ps2 = conn.prepareStatement(sqlParent); PreparedStatement ps3 = conn.prepareStatement(sqlUser)) {

                // === 1. Cập nhật bảng Patient ===
                ps1.setString(1, p.getFullName());
                ps1.setString(2, p.getAddress());
                ps1.setString(3, p.getInsuranceInfo());
                ps1.setDate(4, p.getDob());
                ps1.setInt(5, p.getPatientId());
                ps1.executeUpdate();

                // === 2. Cập nhật bảng Parent ===
                ps2.setString(1, p.getParentName());
                ps2.setString(2, p.getParentIdNumber());
                ps2.setInt(3, p.getPatientId());
                ps2.executeUpdate();

                // === 3. Cập nhật bảng User ===
                ps3.setString(1, p.getEmail());
                ps3.setString(2, p.getPhone());
                ps3.setInt(3, p.getPatientId());
                ps3.executeUpdate();

                conn.commit(); // Xác nhận tất cả thay đổi
            } catch (Exception e) {
                conn.rollback(); // Nếu lỗi → rollback toàn bộ
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getUserIdByPatientId(int patientId) {
        String sql = "SELECT user_id FROM Patient WHERE patient_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // nếu không tìm thấy
    }

}
