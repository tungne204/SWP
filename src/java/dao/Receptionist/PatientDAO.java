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
                p.dob,                            -- Thêm ngày sinh
                pa.parentname AS parent_name,
                u.username AS doctor_name,
                a.date_time AS appointment_date,
                CASE WHEN a.status = 1 THEN N'Comfired' ELSE N'Pending' END AS status
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
            WHERE p.full_name LIKE ? OR CAST(p.patient_id AS NVARCHAR) LIKE ?
            ORDER BY p.patient_id ASC
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

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
        p.full_name AS patient_name,
        p.dob,
        p.address,
        p.insurance_info,
        pa.parentname AS parent_name,
        pa.id_info AS parent_id_number,
        uParent.email AS email,
        uParent.phone AS phone,
        uDoctor.username AS doctor_name,
        FORMAT(a.date_time, 'dd/MM/yyyy') AS appointment_date,
        FORMAT(a.date_time, 'HH:mm') AS appointment_time,
        CASE WHEN a.status = 1 THEN N'Comfirmed' ELSE N'Pending' END AS status
    FROM Patient p
    LEFT JOIN Parent pa ON p.parent_id = pa.parent_id
    LEFT JOIN [User] uParent ON p.user_id = uParent.user_id
    LEFT JOIN Appointment a ON p.patient_id = a.patient_id
    LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id
    LEFT JOIN [User] uDoctor ON d.user_id = uDoctor.user_id
    WHERE p.patient_id = ?
""";


    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                p = new Patient();
                p.setPatientId(rs.getInt("patient_id"));
                p.setFullName(rs.getString("patient_name"));
                p.setDob(rs.getDate("dob"));
                p.setAddress(rs.getString("address"));
                p.setInsuranceInfo(rs.getString("insurance_info"));
                p.setParentName(rs.getString("parent_name"));
                p.setParentIdNumber(rs.getString("parent_id_number"));
                p.setEmail(rs.getString("email"));
                p.setPhone(rs.getString("phone"));
                p.setDoctorName(rs.getString("doctor_name"));
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
     * Cập nhật thông tin bệnh nhân ( bao gồm ngày sinh)
     */
    public void updatePatient(int id, String name, String address, String insurance, String parent, String doctor, Date dob) {
        String sql = """
        UPDATE Patient
        SET full_name = ?, address = ?, insurance_info = ?, dob = ?
        WHERE patient_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, insurance);
            ps.setDate(4, dob);
            ps.setInt(5, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
