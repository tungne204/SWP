package dao.Receptionist;

import entity.Receptionist.Patient;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import context.DBContext;

/**
 * DAO xử lý dữ liệu bệnh nhân cho module Receptionist - Hiển thị danh sách bệnh
 * nhân và lịch khám gần nhất - Tìm kiếm bệnh nhân theo tên hoặc ID - Phân trang
 * (paging) - Lấy chi tiết bệnh nhân theo ID
 *
 * @author Kiên
 */
public class PatientDAO extends DBContext {

    /**
     * Lấy danh sách toàn bộ bệnh nhân (không phân trang)
     */
    public List<Patient> getAllPatients() {
        List<Patient> list = new ArrayList<>();
        String sql = """
        SELECT 
            p.patient_id, 
            p.full_name, 
            p.address, 
            p.insurance_info,
            p.dob,                            
            pa.parentname AS parent_name,
            u.username AS doctor_name,
            a.date_time AS appointment_date,
            CASE WHEN a.status = 1 THEN N'Confirmed' ELSE N'Pending' END AS status,
            us.email AS email,               
            us.phone AS phone                 
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
        LEFT JOIN [User] u ON d.user_id = u.user_id       -- bác sĩ
        LEFT JOIN [User] us ON p.user_id = us.user_id     -- thông tin tài khoản bệnh nhân
        ORDER BY p.patient_id ASC
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapPatient(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Tìm kiếm bệnh nhân theo tên hoặc ID (không phân trang)
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
            u.email LIKE ? OR
            u.phone LIKE ?
        ORDER BY p.patient_id ASC
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 1; i <= 8; i++) {
                ps.setString(i, "%" + keyword + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPatient(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================================================
    // ============= THÊM PHÂN TRANG (PAGING) DƯỚI ĐÂY ===============
    // ===============================================================
    /**
     * Đếm tổng số bệnh nhân
     */
    public int countAllPatients() {
        String sql = "SELECT COUNT(*) FROM Patient";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm tổng số bệnh nhân theo keyword
     */
    public int countSearchPatients(String keyword) {
        String sql = """
            SELECT COUNT(*) FROM Patient
            WHERE full_name LIKE ? OR CAST(patient_id AS NVARCHAR) LIKE ? OR address LIKE ?
            """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy danh sách bệnh nhân có phân trang
     */
    public List<Patient> getPatientsByPage(int offset, int limit) {
        List<Patient> list = new ArrayList<>();
        String sql = """
        SELECT 
            p.patient_id, 
            p.full_name, 
            p.address, 
            p.insurance_info,
            p.dob,
            pa.parentname AS parent_name,
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
        ORDER BY p.patient_id
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPatient(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Tìm kiếm bệnh nhân có phân trang
     */
    public List<Patient> searchPatientsByPage(String keyword, int offset, int limit) {
        List<Patient> list = new ArrayList<>();
        String sql = """
        SELECT 
            p.patient_id, 
            p.full_name, 
            p.address, 
            p.insurance_info,
            p.dob,
            pa.parentname AS parent_name,
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
            p.full_name LIKE ? OR CAST(p.patient_id AS NVARCHAR) LIKE ? OR p.address LIKE ?
        ORDER BY p.patient_id
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setInt(4, offset);
            ps.setInt(5, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPatient(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * true Lấy thông tin chi tiết bệnh nhân theo ID
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
            d.experienceYears AS doctor_experienceYears,
            d.specailty AS doctor_specailty;

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

    // ===============================================================
    // ============ HÀM DÙNG CHUNG CHO TẤT CẢ CÂU TRUY VẤN ============
    // ===============================================================
    private Patient mapPatient(ResultSet rs) throws SQLException {
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
        return p;
    }

    /**
     * true Cập nhật thông tin bệnh nhân (bao gồm Patient, Parent, User)
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

}
