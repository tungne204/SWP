package dao.Receptionist;

import context.DBContext;
import entity.Receptionist.Appointment;
import entity.Receptionist.Doctor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentDAO extends DBContext {

    //Lấy danh sách lịch hẹn (Receptionist)-Appointment-List
    public List<Appointment> getAppointments(String keyword, String status, String sort, int page, int pageSize) {
        List<Appointment> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT a.appointment_id, p.full_name AS patientName, p.address AS patientAddress, 
                   p.insurance_info AS patientInsurance, u.username AS doctorName, 
                   d.experienceYears AS doctorExperienceYears, a.date_time AS dateTime, a.status
            FROM Appointment a
            JOIN Patient p ON a.patient_id = p.patient_id
            JOIN Doctor d ON a.doctor_id = d.doctor_id
            JOIN [User] u ON d.user_id = u.user_id
            WHERE 1=1
        """);

        // 🔍 Search
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (p.full_name LIKE ? OR u.username LIKE ? OR p.address LIKE ?)");
        }

        // ⚙️ Filter theo status (NVARCHAR)
        if (status != null && !status.equals("all")) {
            sql.append(" AND a.status = ?");
        }

        // 🔽 Sort
        // 🔽 Sort
        if (sort == null || sort.isEmpty()) {
            sort = "date_desc"; // tránh lỗi NullPointerException
        }

        switch (sort) {
            case "date_asc" ->
                sql.append(" ORDER BY a.date_time ASC");
            case "today" ->
                sql.append(" AND CAST(a.date_time AS DATE) = CAST(GETDATE() AS DATE) ORDER BY a.date_time DESC");
            default ->
                sql.append(" ORDER BY a.date_time DESC");
        }

        // 📄 Paging
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }

            if (status != null && !status.equals("all")) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment a = new Appointment();
                    a.setAppointmentId(rs.getInt("appointment_id"));
                    a.setPatientName(rs.getString("patientName"));
                    a.setPatientAddress(rs.getString("patientAddress"));
                    a.setPatientInsurance(rs.getString("patientInsurance"));
                    a.setDoctorName(rs.getString("doctorName"));
                    a.setDoctorExperienceYears(rs.getInt("doctorExperienceYears"));
                    a.setDateTime(rs.getTimestamp("dateTime"));
                    a.setStatus(rs.getString("status"));
                    list.add(a);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy danh sách theo Doctor ID-Appointment-List
    public List<Appointment> getAppointmentsByDoctorId(int doctorId, String keyword, String status, String sort, int page, int pageSize) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT a.appointment_id, p.full_name AS patientName, a.date_time AS dateTime, a.status
            FROM Appointment a
            JOIN Patient p ON a.patient_id = p.patient_id
            WHERE a.doctor_id = ?
        """);

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND p.full_name LIKE ?");
        }

        if (status != null && !status.equals("all")) {
            sql.append(" AND a.status = ?");
        }

        sql.append(" ORDER BY a.date_time DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, doctorId);

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }
            if (status != null && !status.equals("all")) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment a = new Appointment();
                    a.setAppointmentId(rs.getInt("appointment_id"));
                    a.setPatientName(rs.getString("patientName"));
                    a.setDateTime(rs.getTimestamp("dateTime"));
                    a.setStatus(rs.getString("status"));
                    list.add(a);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //Lấy danh sách theo Patient ID-Appointment-List
    public List<Appointment> getAppointmentsByPatientId(
            int patientId, String keyword, String status, String sort, int page, int pageSize) {

        List<Appointment> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT 
            a.appointment_id,
            a.date_time,
            a.status,
            p.full_name AS patientName,
            p.address AS patientAddress,
            p.insurance_info AS patientInsurance,
            d.doctor_id,
            uD.username AS doctorName,
            d.experienceYears AS doctorExperienceYears
        FROM dbo.Appointment a
        JOIN dbo.Patient p ON a.patient_id = p.patient_id
        JOIN dbo.Doctor d ON a.doctor_id = d.doctor_id
        JOIN dbo.[User] uD ON d.user_id = uD.user_id
        WHERE a.patient_id = ?
    """);

        // ✅ Tìm kiếm theo keyword
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("""
            AND (
                p.full_name LIKE ? OR
                uD.username LIKE ? OR
                p.address LIKE ? OR
                p.insurance_info LIKE ?
            )
        """);
        }

        // ✅ Lọc theo status (ignore case)
        if (status != null && !status.equalsIgnoreCase("all")) {
            sql.append(" AND LOWER(a.status) = LOWER(?) ");
        }

        // ✅ Sắp xếp (sort)
        switch (sort == null ? "" : sort) {
            case "date_asc" ->
                sql.append(" ORDER BY a.date_time ASC ");
            case "today" ->
                sql.append(" AND CAST(a.date_time AS DATE) = CAST(GETDATE() AS DATE) ORDER BY a.date_time ASC ");
            default ->
                sql.append(" ORDER BY a.date_time DESC ");
        }

        // ✅ Phân trang
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, patientId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(index++, kw);
                ps.setString(index++, kw);
                ps.setString(index++, kw);
                ps.setString(index++, kw);
            }

            if (status != null && !status.equalsIgnoreCase("all")) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment a = new Appointment();
                    a.setAppointmentId(rs.getInt("appointment_id"));
                    a.setDateTime(rs.getTimestamp("date_time"));
                    a.setStatus(rs.getString("status"));
                    a.setPatientName(rs.getString("patientName"));
                    a.setPatientAddress(rs.getString("patientAddress"));
                    a.setPatientInsurance(rs.getString("patientInsurance"));
                    a.setDoctorName(rs.getString("doctorName"));
                    a.setDoctorExperienceYears(rs.getInt("doctorExperienceYears"));
                    list.add(a);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Appointment> getAppointmentsByUserId(int userId, String keyword, String status, String sort, int page, int pageSize) {
        List<Appointment> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT a.appointment_id, uD.username AS doctorName, a.date_time AS dateTime, a.status
        FROM Appointment a
        JOIN Doctor d ON a.doctor_id = d.doctor_id
        JOIN [User] uD ON d.user_id = uD.user_id
        JOIN Patient p ON a.patient_id = p.patient_id
        JOIN [User] uP ON p.user_id = uP.user_id
        WHERE uP.user_id = ?
    """);

        if (status != null && !status.equals("all")) {
            sql.append(" AND a.status = ?");
        }

        sql.append(" ORDER BY a.date_time DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, userId);

            if (status != null && !status.equals("all")) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment a = new Appointment();
                    a.setAppointmentId(rs.getInt("appointment_id"));
                    a.setDoctorName(rs.getString("doctorName"));
                    a.setDateTime(rs.getTimestamp("dateTime"));
                    a.setStatus(rs.getString("status"));
                    list.add(a);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Đếm tổng số bản ghi (phục vụ paging)-Appointment-List
    public int countAppointments(String keyword, String status, String role, int userId) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) FROM Appointment a
            JOIN Patient p ON a.patient_id = p.patient_id
            JOIN Doctor d ON a.doctor_id = d.doctor_id
            JOIN [User] u ON d.user_id = u.user_id
            WHERE 1=1
        """);

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (p.full_name LIKE ? OR u.username LIKE ?)");
        }

        if (status != null && !status.equals("all")) {
            sql.append(" AND a.status = ?");
        }

        if ("Doctor".equalsIgnoreCase(role)) {
            sql.append(" AND d.user_id = ?");
        } else if ("Patient".equalsIgnoreCase(role)) {
            sql.append(" AND p.user_id = ?");
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (status != null && !status.equals("all")) {
                ps.setString(index++, status);
            }
            if ("Doctor".equalsIgnoreCase(role) || "Patient".equalsIgnoreCase(role)) {
                ps.setInt(index, userId);
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
    //Lấy patientId từ userId (dành cho Patient role)-Appointment-List

    public int getPatientIdByUserId(int userId) {
        String sql = """
        SELECT patient_id
        FROM Patient
        WHERE user_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("patient_id");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0; // Không tìm thấy
    }

    //Cập nhật trạng thái của lịch hẹn (dùng cho Receptionist / Doctor / Patient/ Appointment-Status)
    public boolean updateStatus(int appointmentId, String newStatus) {
        String sql = """
        UPDATE Appointment
        SET status = ?
        WHERE appointment_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);   // status là NVARCHAR
            ps.setInt(2, appointmentId);  // id của lịch hẹn cần cập nhật

            int rows = ps.executeUpdate();
            return rows > 0; // ✅ Trả về true nếu cập nhật thành công

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false; // ❌ Có lỗi xảy ra
    }

    //Lấy chi tiết lịch hẹn theo ID (dành cho trang AppointmentDetail.jsp)
    public Appointment getAppointmentById(int appointmentId) {
        String sql = """
        SELECT 
            a.appointment_id, 
            a.date_time, 
            a.status,

            p.full_name AS patientName,
            p.address AS patientAddress,
            p.insurance_info AS patientInsurance,
            pa.parentname AS parentName,
            uP.email AS patientEmail,
            uP.phone AS parentPhone,  

            d.doctor_id,
            uD.username AS doctorName,
            d.experienceYears AS doctorExperienceYears

        FROM dbo.Appointment a
        JOIN dbo.Patient p ON a.patient_id = p.patient_id
        LEFT JOIN dbo.Parent pa ON p.parent_id = pa.parent_id
        JOIN dbo.Doctor d ON a.doctor_id = d.doctor_id
        JOIN dbo.[User] uD ON d.user_id = uD.user_id
        JOIN dbo.[User] uP ON p.user_id = uP.user_id
        WHERE a.appointment_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Appointment a = new Appointment();
                    a.setAppointmentId(rs.getInt("appointment_id"));
                    a.setDateTime(rs.getTimestamp("date_time"));
                    a.setStatus(rs.getString("status"));
                    a.setPatientName(rs.getString("patientName"));
                    a.setPatientAddress(rs.getString("patientAddress"));
                    a.setPatientInsurance(rs.getString("patientInsurance"));
                    a.setParentName(rs.getString("parentName"));
                    a.setPatientEmail(rs.getString("patientEmail"));
                    a.setParentPhone(rs.getString("parentPhone"));
                    a.setDoctorName(rs.getString("doctorName"));
                    a.setDoctorExperienceYears(rs.getInt("doctorExperienceYears"));
                    return a;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
