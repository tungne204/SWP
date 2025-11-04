package dao.Receptionist;

import entity.Receptionist.Patient;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import context.DBContext;
import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 * DAO xử lý dữ liệu bệnh nhân cho module Receptionist - Hiển thị danh sách bệnh
 * nhân và lịch khám gần nhất - Tìm kiếm bệnh nhân theo tên hoặc ID - Phân trang
 * (paging) - Lấy chi tiết bệnh nhân theo ID
 *
 * @author Kiên
 */
public class PatientDAO extends DBContext {

    // Tìm kiếm bệnh nhân theo nhiều tiêu chí + phân trang
    public List<Patient> searchPatients(
            String keyword,
            String filterName,
            String filterAddress,
            String filterInsurance,
            String filterPhone,
            int page,
            int pageSize) {

        List<Patient> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT p.patient_id,
                   p.full_name,
                   p.dob,
                   p.address,
                   p.insurance_info,
                   u.email,
                   u.phone
            FROM Patient p
            JOIN [User] u ON p.user_id = u.user_id
            WHERE 1 = 1
        """);

        // keyword: tên hoặc mã bệnh nhân
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (p.full_name LIKE ? OR CAST(p.patient_id AS NVARCHAR(50)) LIKE ?)");
        }

        if (filterName != null && !filterName.isEmpty()) {
            sql.append(" AND p.full_name LIKE ?");
        }
        if (filterAddress != null && !filterAddress.isEmpty()) {
            sql.append(" AND p.address LIKE ?");
        }
        if (filterInsurance != null && !filterInsurance.isEmpty()) {
            sql.append(" AND p.insurance_info LIKE ?");
        }
        if (filterPhone != null && !filterPhone.isEmpty()) {
            sql.append(" AND u.phone LIKE ?");
        }

        sql.append(" ORDER BY p.patient_id ASC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;
            String like;

            if (keyword != null && !keyword.isEmpty()) {
                like = "%" + keyword + "%";
                ps.setString(index++, like); // full_name
                ps.setString(index++, like); // patient_id
            }
            if (filterName != null && !filterName.isEmpty()) {
                like = "%" + filterName + "%";
                ps.setString(index++, like);
            }
            if (filterAddress != null && !filterAddress.isEmpty()) {
                like = "%" + filterAddress + "%";
                ps.setString(index++, like);
            }
            if (filterInsurance != null && !filterInsurance.isEmpty()) {
                like = "%" + filterInsurance + "%";
                ps.setString(index++, like);
            }
            if (filterPhone != null && !filterPhone.isEmpty()) {
                like = "%" + filterPhone + "%";
                ps.setString(index++, like);
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Patient p = new Patient();
                    p.setPatientId(rs.getInt("patient_id"));
                    p.setFullName(rs.getString("full_name"));
                    p.setDob(rs.getDate("dob"));
                    p.setAddress(rs.getString("address"));
                    p.setInsuranceInfo(rs.getString("insurance_info"));
                    p.setEmail(rs.getString("email"));
                    p.setPhone(rs.getString("phone"));
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Đếm tổng số bản ghi thỏa filter (phân trang)
    public int countPatients(
            String keyword,
            String filterName,
            String filterAddress,
            String filterInsurance,
            String filterPhone) {

        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM Patient p
            JOIN [User] u ON p.user_id = u.user_id
            WHERE 1 = 1
        """);

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (p.full_name LIKE ? OR CAST(p.patient_id AS NVARCHAR(50)) LIKE ?)");
        }
        if (filterName != null && !filterName.isEmpty()) {
            sql.append(" AND p.full_name LIKE ?");
        }
        if (filterAddress != null && !filterAddress.isEmpty()) {
            sql.append(" AND p.address LIKE ?");
        }
        if (filterInsurance != null && !filterInsurance.isEmpty()) {
            sql.append(" AND p.insurance_info LIKE ?");
        }
        if (filterPhone != null && !filterPhone.isEmpty()) {
            sql.append(" AND u.phone LIKE ?");
        }

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;
            String like;

            if (keyword != null && !keyword.isEmpty()) {
                like = "%" + keyword + "%";
                ps.setString(index++, like);
                ps.setString(index++, like);
            }
            if (filterName != null && !filterName.isEmpty()) {
                like = "%" + filterName + "%";
                ps.setString(index++, like);
            }
            if (filterAddress != null && !filterAddress.isEmpty()) {
                like = "%" + filterAddress + "%";
                ps.setString(index++, like);
            }
            if (filterInsurance != null && !filterInsurance.isEmpty()) {
                like = "%" + filterInsurance + "%";
                ps.setString(index++, like);
            }
            if (filterPhone != null && !filterPhone.isEmpty()) {
                like = "%" + filterPhone + "%";
                ps.setString(index++, like);
            }

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
    // ===================== PROFILE =====================

    /**
     * Lấy hồ sơ bệnh nhân + appointment gần nhất + bác sĩ + phụ huynh
     */
    public Patient getPatientProfileById(int patientId) {
        String sql = """
            SELECT TOP 1
                   p.patient_id,
                   p.user_id,
                   p.full_name,
                   p.dob,
                   p.address,
                   p.insurance_info,
                   p.parent_id,

                   pa.parentname,
                   pa.id_info,

                   u.email,
                   u.phone,

                   a.status,
                   a.date_time,

                   d.experienceYears AS doctorExperienceYears,
                   du.username AS doctor_name
            FROM Patient p
            LEFT JOIN Parent pa       ON p.parent_id = pa.parent_id
            LEFT JOIN [User] u        ON p.user_id   = u.user_id
            LEFT JOIN Appointment a   ON a.patient_id = p.patient_id
            LEFT JOIN Doctor d        ON a.doctor_id  = d.doctor_id
            LEFT JOIN [User] du       ON d.user_id    = du.user_id
            WHERE p.patient_id = ?
            ORDER BY a.date_time DESC
            """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, patientId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient p = new Patient();

                    // --- Thông tin bệnh nhân ---
                    p.setPatientId(rs.getInt("patient_id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setFullName(rs.getString("full_name"));
                    p.setDob(rs.getDate("dob"));
                    p.setAddress(rs.getString("address"));
                    p.setInsuranceInfo(rs.getString("insurance_info"));
                    p.setParentId(rs.getInt("parent_id"));

                    // --- Phụ huynh ---
                    p.setParentName(rs.getString("parentname"));
                    p.setParentIdNumber(rs.getString("id_info"));

                    // --- Liên lạc ---
                    p.setEmail(rs.getString("email"));
                    p.setPhone(rs.getString("phone"));

                    // --- Lịch hẹn gần nhất ---
                    Timestamp ts = rs.getTimestamp("date_time");
                    if (ts != null) {
                        LocalDateTime dt = ts.toLocalDateTime();
                        p.setAppointmentDate(dt.toLocalDate().toString()); // yyyy-MM-dd
                        p.setAppointmentTime(dt.toLocalTime().toString()); // HH:mm:ss
                    }

                    // --- Status: map từ DB -> String cho JSP dùng ${patient.status} ---
                    Object statusObj = rs.getObject("status");
                    String statusStr;
                    if (statusObj == null) {
                        statusStr = "Pending";              // mặc định nếu null
                    } else if (statusObj instanceof Boolean) {
                        // Nếu cột là bit
                        statusStr = ((Boolean) statusObj) ? "Confirmed" : "Cancelled";
                    } else {
                        // Nếu sau này bạn đổi sang NVARCHAR('Confirmed', 'Pending',...)
                        statusStr = statusObj.toString();
                    }
                    p.setStatus(statusStr);

                    // --- Bác sĩ ---
                    p.setDoctorName(rs.getString("doctor_name"));
                    // experienceYears là INT, entity dùng String -> convert
                    int expYears = rs.getInt("doctorExperienceYears");
                    if (!rs.wasNull()) {
                        p.setDoctorExperienceYears(String.valueOf(expYears));
                    }

                    return p;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    // ====== UPDATE patient + parent + user (email/phone) ======

    public boolean updatePatientProfile(Patient p) {
        String sqlUpdatePatient = """
            UPDATE Patient
            SET full_name = ?, dob = ?, address = ?, insurance_info = ?
            WHERE patient_id = ?
        """;

        String sqlUpdateParent = """
            UPDATE Parent
            SET parentname = ?
            WHERE parent_id = ?
        """;

        String sqlUpdateUser = """
            UPDATE [User]
            SET email = ?, phone = ?
            WHERE user_id = ?
        """;

        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement ps1 = con.prepareStatement(sqlUpdatePatient)) {
                ps1.setString(1, p.getFullName());
                ps1.setDate(2, p.getDob());        // có thể null
                ps1.setString(3, p.getAddress());
                ps1.setString(4, p.getInsuranceInfo());
                ps1.setInt(5, p.getPatientId());
                ps1.executeUpdate();
            }

            // Parent (nếu có)
            if (p.getParentId() > 0) {
                try (PreparedStatement ps2 = con.prepareStatement(sqlUpdateParent)) {
                    ps2.setString(1, p.getParentName());
                    ps2.setInt(2, p.getParentId());
                    ps2.executeUpdate();
                }
            }

            // User (email/phone) nếu có user_id
            if (p.getUserId() > 0) {
                try (PreparedStatement ps3 = con.prepareStatement(sqlUpdateUser)) {
                    ps3.setString(1, p.getEmail());
                    ps3.setString(2, p.getPhone());
                    ps3.setInt(3, p.getUserId());
                    ps3.executeUpdate();
                }
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    // (Optional) check email đã tồn tại cho user khác chưa – dùng nếu muốn validate trùng email
    public boolean isEmailUsedByAnotherUser(String email, int currentUserId) {
        String sql = """
            SELECT COUNT(*)
            FROM [User]
            WHERE email = ? AND user_id <> ?
        """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, currentUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
