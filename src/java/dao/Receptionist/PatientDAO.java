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

    // ================== SELECT CƠ BẢN ==================
    // Lấy đủ cho JSP: patientId, fullName, dob, address, insuranceInfo, email, phone
    // Đồng thời lấy luôn thông tin phụ huynh để sau này em xem chi tiết không phải viết lại
    private static final String BASE_SELECT = """
        SELECT
            p.patient_id,
            p.user_id,
            p.full_name,
            p.dob,
            p.[address],
            p.insurance_info,
            pa.parentname AS parent_name,
            u.email,
            u.phone,
            u.[status]   AS user_status
        FROM [dbo].[Patient] p
        LEFT JOIN [dbo].[User]   u  ON p.user_id = u.user_id
        LEFT JOIN [dbo].[Parent] pa ON p.parent_id = pa.parent_id
    """;

    // ================== ĐẾM TẤT CẢ ==================
    private static final String SQL_COUNT_ALL = """
        SELECT COUNT(*) FROM [dbo].[Patient]
    """;

    // ================== LẤY THEO TRANG (KHÔNG FILTER) ==================
    private static final String SQL_GET_BY_PAGE = BASE_SELECT + """
        ORDER BY p.patient_id
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

    // ================== ĐẾM KHI TÌM KIẾM ==================
    // Tìm theo: tên, mã BN, địa chỉ, bệnh nền, email, phone
    private static final String SQL_COUNT_SEARCH = """
        SELECT COUNT(*)
        FROM [dbo].[Patient] p
        LEFT JOIN [dbo].[User] u ON p.user_id = u.user_id
        WHERE
              p.full_name LIKE ?
           OR CAST(p.patient_id AS NVARCHAR(50)) LIKE ?
           OR p.[address] LIKE ?
           OR p.insurance_info LIKE ?
           OR u.email LIKE ?
           OR u.phone LIKE ?
    """;

    // ================== TÌM KIẾM THEO TRANG ==================
    private static final String SQL_SEARCH_BY_PAGE = BASE_SELECT + """
        WHERE
              p.full_name LIKE ?
           OR CAST(p.patient_id AS NVARCHAR(50)) LIKE ?
           OR p.[address] LIKE ?
           OR p.insurance_info LIKE ?
           OR u.email LIKE ?
           OR u.phone LIKE ?
        ORDER BY p.patient_id
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

    // =================================================================
    // 1. Đếm tất cả bệnh nhân
    // =================================================================
    public int countAllPatients() throws Exception {
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(SQL_COUNT_ALL); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // =================================================================
    // 2. Lấy danh sách bệnh nhân theo trang (không keyword)
    // =================================================================
    public List<Patient> getPatientsByPage(int offset, int pageSize) throws Exception {
        List<Patient> list = new ArrayList<>();

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(SQL_GET_BY_PAGE)) {

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToPatient(rs));
                }
            }
        }

        return list;
    }

    // =================================================================
    // 3. Đếm kết quả khi tìm kiếm theo keyword
    // =================================================================
    public int countSearchPatients(String keyword) throws Exception {
        String like = "%" + keyword + "%";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(SQL_COUNT_SEARCH)) {

            // 6 chỗ LIKE giống nhau
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, like);
            ps.setString(5, like);
            ps.setString(6, like);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    // =================================================================
    // 4. Tìm kiếm theo trang
    // =================================================================
    public List<Patient> searchPatientsByPage(String keyword, int offset, int pageSize) throws Exception {
        List<Patient> list = new ArrayList<>();
        String like = "%" + keyword + "%";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(SQL_SEARCH_BY_PAGE)) {

            // 6 điều kiện LIKE
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, like);
            ps.setString(5, like);
            ps.setString(6, like);

            // phân trang
            ps.setInt(7, offset);
            ps.setInt(8, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToPatient(rs));
                }
            }
        }

        return list;
    }

    // =================================================================
    // 5. Map ResultSet -> entity.Receptionist.Patient
    // =================================================================
    private Patient mapRowToPatient(ResultSet rs) throws SQLException {
        Patient p = new Patient();

        p.setPatientId(rs.getInt("patient_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setFullName(rs.getString("full_name"));
        p.setDob(rs.getDate("dob"));
        p.setAddress(rs.getString("address"));
        p.setInsuranceInfo(rs.getString("insurance_info"));

        // từ bảng Parent
        p.setParentName(rs.getString("parent_name"));

        // từ bảng User
        p.setEmail(rs.getString("email"));
        p.setPhone(rs.getString("phone"));

        // status đã đổi sang NVARCHAR → set luôn
        p.setStatus(rs.getString("user_status"));

        // các field mở rộng khác trong entity nhưng query này chưa lấy được
        // để tránh NullPointer ở JSP khác thì set default = null:
        p.setDoctorName(null);
        p.setDoctorExperienceYears(null);
        p.setDoctorIntroduce(null);
        p.setDoctorCertificate(null);
        p.setAppointmentDate(null);
        p.setAppointmentTime(null);

        return p;
    }

    public Patient getPatientById(int patientId) throws Exception {
        // dùng OUTER APPLY để lấy lịch hẹn gần nhất của đúng bệnh nhân này
        String sql = """
        SELECT
            p.patient_id,
            p.user_id,
            p.full_name,
            p.dob,
            p.[address],
            p.insurance_info,
            p.parent_id,

            -- phụ huynh
            pa.parentname AS parent_name,

            -- account của bệnh nhân (thực chất là phụ huynh đăng ký)
            u.email,
            u.phone,
            u.[status] AS user_status,

            -- lịch hẹn mới nhất (có thể null)
            ap.appointment_id,
            CONVERT(varchar(10), ap.date_time, 120) AS appointment_date, -- yyyy-MM-dd
            CONVERT(varchar(5),  ap.date_time, 108) AS appointment_time, -- HH:mm
            CASE 
                WHEN ap.status = 1 THEN N'Confirmed'
                WHEN ap.status = 0 THEN N'Pending'
                ELSE N'Unknown'
            END AS appointment_status,

            -- bác sĩ của lịch hẹn
            d.doctor_id,
            ud.username AS doctor_name,
            d.experienceYears AS doctor_experience_years,
            d.introduce       AS doctor_introduce,
            d.certificate     AS doctor_certificate

        FROM [dbo].[Patient] p
        LEFT JOIN [dbo].[Parent] pa ON p.parent_id = pa.parent_id
        LEFT JOIN [dbo].[User]   u  ON p.user_id   = u.user_id

        OUTER APPLY (
            SELECT TOP 1 a.*
            FROM [dbo].[Appointment] a
            WHERE a.patient_id = p.patient_id
            ORDER BY a.date_time DESC
        ) ap

        LEFT JOIN [dbo].[Doctor] d ON ap.doctor_id = d.doctor_id
        LEFT JOIN [dbo].[User]   ud ON d.user_id   = ud.user_id

        WHERE p.patient_id = ?
        """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, patientId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient p = new Patient();

                    // ====== từ bảng Patient ======
                    p.setPatientId(rs.getInt("patient_id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setFullName(rs.getString("full_name"));
                    p.setDob(rs.getDate("dob"));
                    p.setAddress(rs.getString("address"));
                    p.setInsuranceInfo(rs.getString("insurance_info"));
                    p.setParentId(rs.getInt("parent_id"));

                    // ====== phụ huynh (chỉ tên, KHÔNG CCCD) ======
                    p.setParentName(rs.getString("parent_name"));
                    p.setParentIdNumber(null); // KHÔNG show CCCD

                    // ====== account / liên hệ ======
                    p.setEmail(rs.getString("email"));
                    p.setPhone(rs.getString("phone"));

                    // ====== lịch hẹn mới nhất ======
                    p.setAppointmentDate(rs.getString("appointment_date"));  // có thể null
                    p.setAppointmentTime(rs.getString("appointment_time"));  // có thể null

                    // JSP của em đang dùng ${patient.status} để check Confirmed/Pending
                    // nên ở trang profile anh cho status = status của lịch hẹn
                    p.setStatus(rs.getString("appointment_status"));

                    // ====== bác sĩ ======
                    p.setDoctorName(rs.getString("doctor_name"));
                    // experienceYears trong DB là int, trong entity là String → convert nhẹ
                    int exp = rs.getInt("doctor_experience_years");
                    if (rs.wasNull()) {
                        p.setDoctorExperienceYears(null);
                    } else {
                        p.setDoctorExperienceYears(String.valueOf(exp));
                    }
                    p.setDoctorIntroduce(rs.getString("doctor_introduce"));
                    p.setDoctorCertificate(rs.getString("doctor_certificate"));

                    return p;
                }
            }
        }

        return null;
    }

}
