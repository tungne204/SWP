package dao.Receptionist;

import context.DBContext;
import entity.Receptionist.Appointment;
import entity.Receptionist.Doctor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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

    // Get all doctors
    public List<Doctor> getAllDoctors() {
        List<Doctor> list = new ArrayList<>();
        String sql = """
        SELECT d.doctor_id, u.username, d.introduce, d.experienceYears
        FROM Doctor d
        JOIN [User] u ON d.user_id = u.user_id
        ORDER BY u.username
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Doctor d = new Doctor();
                d.setDoctorId(rs.getInt("doctor_id"));
                d.setUsername(rs.getString("username"));
                d.setIntroduce(rs.getString("introduce"));
                d.setExperienceYears(rs.getString("experienceYears"));
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Create appointment with patient and parent info
    public boolean createAppointment(String patientName, String patientDob, String parentName, String patientAddress, String insuranceInfo,
                                     String patientEmail, String parentPhone, String dateTimeStr,
                                     int doctorId, String status) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Create or find Parent
            int parentId = getOrCreateParent(conn, parentName, parentPhone);
            
            // 2. Create or find User for patient's email
            int userId = getOrCreateUser(conn, patientEmail, parentPhone);
            
            // 3. Create Patient
            int patientId = createOrFindPatient(conn, patientName, patientDob, patientAddress, insuranceInfo, userId, parentId);
            
            // 4. Parse datetime
            Timestamp appointmentDateTime = parseDateTime(dateTimeStr);
            
            // 5. Create Appointment
            String sql = """
                INSERT INTO Appointment (patient_id, doctor_id, date_time, status)
                VALUES (?, ?, ?, ?)
            """;
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, patientId);
                ps.setInt(2, doctorId);
                ps.setTimestamp(3, appointmentDateTime);
                ps.setString(4, status);
                
                int rows = ps.executeUpdate();
                
                if (rows > 0) {
                    conn.commit(); // Commit transaction
                    return true;
                } else {
                    conn.rollback(); // Rollback on failure
                    return false;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Helper method to get or create Parent
    private int getOrCreateParent(Connection conn, String parentName, String parentPhone) throws SQLException {
        // Try to find existing parent by name and phone
        String findSql = """
            SELECT TOP 1 parent_id FROM Parent p
            JOIN Patient pa ON p.parent_id = pa.parent_id
            JOIN [User] u ON pa.user_id = u.user_id
            WHERE p.parentname = ? AND u.phone = ?
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setString(1, parentName);
            ps.setString(2, parentPhone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("parent_id");
                }
            }
        }
        
        // Create new parent
        String insertSql = "INSERT INTO Parent (parentname, id_info) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, parentName);
            ps.setString(2, parentPhone); // Use phone as id_info
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        
        throw new SQLException("Failed to create parent");
    }

    // Helper method to get or create User
    private int getOrCreateUser(Connection conn, String email, String phone) throws SQLException {
        // Try to find existing user by email
        String findSql = "SELECT user_id FROM [User] WHERE email = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        }
        
        // Create new user
        String insertSql = """
            INSERT INTO [User] (username, password, email, phone, role_id, status)
            VALUES (?, ?, ?, ?, 3, 1)
        """;
        try (PreparedStatement ps = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email); // Use email as username
            ps.setString(2, "password"); // Default password
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        
        throw new SQLException("Failed to create user");
    }

    // Helper method to create or find Patient
    private int createOrFindPatient(Connection conn, String patientName, String patientDob, String patientAddress, String insuranceInfo,
                                   int userId, int parentId) throws SQLException {
        // Try to find existing patient by name and parent
        String findSql = """
            SELECT TOP 1 patient_id FROM Patient
            WHERE full_name = ? AND parent_id = ?
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setString(1, patientName);
            ps.setInt(2, parentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("patient_id");
                }
            }
        }
        
        // Create new patient
        String insertSql = """
            INSERT INTO Patient (user_id, full_name, dob, address, insurance_info, parent_id)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        try (PreparedStatement ps = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setObject(1, userId > 0 ? userId : null, java.sql.Types.INTEGER);
            ps.setString(2, patientName);
            // Parse DOB string to Date
            if (patientDob != null && !patientDob.trim().isEmpty()) {
                try {
                    java.sql.Date dobDate = java.sql.Date.valueOf(patientDob);
                    ps.setDate(3, dobDate);
                } catch (IllegalArgumentException e) {
                    ps.setDate(3, null); // Set null if invalid date
                }
            } else {
                ps.setDate(3, null);
            }
            ps.setString(4, patientAddress);
            ps.setString(5, insuranceInfo != null ? insuranceInfo : "");
            ps.setInt(6, parentId);
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        
        throw new SQLException("Failed to create patient");
    }

    // Helper method to parse datetime string
    private Timestamp parseDateTime(String dateTimeStr) throws ParseException {
        // Try multiple date formats
        String[] formats = {
            "dd/MM/yyyy HH:mm",
            "dd-MM-yyyy HH:mm",
            "yyyy-MM-dd HH:mm",
            "dd/MM/yyyy HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss"
        };
        
        for (String format : formats) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(format);
                return new Timestamp(sdf.parse(dateTimeStr).getTime());
            } catch (ParseException e) {
                // Try next format
            }
        }
        
        throw new ParseException("Unable to parse datetime: " + dateTimeStr, 0);
    }

}
