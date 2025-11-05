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

    //Helper method to parse datetime string
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

    // Cập nhật đầy đủ thông tin lịch hẹn + bệnh nhân + phụ huynh
    public boolean updateAppointmentFull(
            int appointmentId,
            String dateTimeStr,
            int doctorId,
            String status,
            String patientName,
            String parentName,
            String patientAddress,
            String patientEmail,
            String parentPhone) {

        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // bắt đầu transaction

            // 1. Lấy ra patient_id, parent_id, user_id từ appointment
            String selectSql = """
                SELECT p.patient_id, p.parent_id, p.user_id
                FROM Appointment a
                JOIN Patient p ON a.patient_id = p.patient_id
                WHERE a.appointment_id = ?
                """;

            int patientId = 0;
            int parentId = 0;
            int userId = 0;

            try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                ps.setInt(1, appointmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        patientId = rs.getInt("patient_id");
                        parentId = rs.getInt("parent_id");
                        userId = rs.getInt("user_id");
                    } else {
                        // không tìm thấy appointment
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 2. Cập nhật Parent (nếu có)
            if (parentId > 0) {
                String updateParent = "UPDATE Parent SET parentname = ? WHERE parent_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateParent)) {
                    ps.setString(1, parentName);
                    ps.setInt(2, parentId);
                    ps.executeUpdate();
                }
            }

            // 3. Cập nhật User (email + phone) – account của bệnh nhân
            if (userId > 0) {
                String updateUser = "UPDATE [User] SET email = ?, phone = ? WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateUser)) {
                    ps.setString(1, patientEmail);
                    ps.setString(2, parentPhone);
                    ps.setInt(3, userId);
                    ps.executeUpdate();
                }
            }

            // 4. Cập nhật Patient (tên + địa chỉ)
            String updatePatient = "UPDATE Patient SET full_name = ?, address = ? WHERE patient_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updatePatient)) {
                ps.setString(1, patientName);
                ps.setString(2, patientAddress);
                ps.setInt(3, patientId);
                ps.executeUpdate();
            }

            // 5. Parse lại datetime
            Timestamp ts = null;
            if (dateTimeStr != null && !dateTimeStr.trim().isEmpty()) {
                // dùng lại hàm parseDateTime đã có ở dưới DAO
                ts = parseDateTime(dateTimeStr);
            }

            // 6. Cập nhật Appointment
            String updateAppointment = """
                UPDATE Appointment
                SET doctor_id = ?, date_time = ?, status = ?
                WHERE appointment_id = ?
                """;

            int rows;
            try (PreparedStatement ps = conn.prepareStatement(updateAppointment)) {
                ps.setInt(1, doctorId);
                ps.setTimestamp(2, ts);
                ps.setString(3, status);
                ps.setInt(4, appointmentId);
                rows = ps.executeUpdate();
            }

            if (rows == 0) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
// Lấy danh sách lịch hẹn theo user_id của Patient (Appointment-List cho Patient)

    public List<Appointment> getAppointmentsByPatientUserId(
            int userId, String keyword, String status, String sort, int page, int pageSize) {

        List<Appointment> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT a.appointment_id,
               p.full_name      AS patientName,
               p.address        AS patientAddress,
               p.insurance_info AS patientInsurance,
               u.username       AS doctorName,
               d.experienceYears AS doctorExperienceYears,
               a.date_time      AS dateTime,
               a.status
        FROM Appointment a
        JOIN Patient p ON a.patient_id = p.patient_id
        JOIN Doctor d  ON a.doctor_id = d.doctor_id
        JOIN [User] u  ON d.user_id = u.user_id
        WHERE p.user_id = ?
    """);

        // Search
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (p.full_name LIKE ? OR u.username LIKE ? OR p.address LIKE ?)");
        }

        // ⚙️ Filter theo status
        if (status != null && !"all".equals(status)) {
            sql.append(" AND a.status = ?");
        }

        // 🔽 Sort
        if (sort == null || sort.isEmpty()) {
            sort = "date_desc";
        }

        switch (sort) {
            case "date_asc" ->
                sql.append(" ORDER BY a.date_time ASC");
            case "today" -> {
                sql.append(" AND CAST(a.date_time AS DATE) = CAST(GETDATE() AS DATE)");
                sql.append(" ORDER BY a.date_time DESC");
            }
            default ->
                sql.append(" ORDER BY a.date_time DESC");
        }

        // Paging
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;

            // user_id của Patient
            ps.setInt(index++, userId);

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }

            if (status != null && !"all".equals(status)) {
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

    // Tạo lịch hẹn mới cho Patient (theo user_id + thông tin form)
    public boolean createAppointmentWithPatientInfo(
            int userId,
            String patientName,
            java.time.LocalDate patientDob,
            String patientAddress,
            String insuranceInfo,
            String parentName,
            String parentPhone,
            int doctorId,
            java.sql.Timestamp appointmentDateTime,
            String status) {

        java.sql.Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            int patientId = 0;
            int parentId = 0;

            // 1. Tìm patient hiện có theo user_id
            String findSql = "SELECT patient_id, parent_id FROM Patient WHERE user_id = ?";
            try (java.sql.PreparedStatement ps = conn.prepareStatement(findSql)) {
                ps.setInt(1, userId);
                try (java.sql.ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        patientId = rs.getInt("patient_id");
                        parentId = rs.getInt("parent_id");
                    }
                }
            }

            // 2. Nếu chưa có patient -> tạo mới Parent + Patient
            if (patientId == 0) {
                // 2.1 insert Parent
                String insertParent = "INSERT INTO Parent (parentname, id_info) VALUES (?, ?)";
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        insertParent, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, parentName);
                    ps.setString(2, null);
                    ps.executeUpdate();
                    try (java.sql.ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            parentId = rs.getInt(1);
                        }
                    }
                }

                // 2.2 insert Patient
                String insertPatient = """
                    INSERT INTO Patient (user_id, full_name, dob, address, insurance_info, parent_id)
                    VALUES (?, ?, ?, ?, ?, ?)
                    """;
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        insertPatient, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, userId);
                    ps.setString(2, patientName);
                    ps.setDate(3, patientDob != null ? java.sql.Date.valueOf(patientDob) : null);
                    ps.setString(4, patientAddress);
                    ps.setString(5, insuranceInfo);
                    ps.setInt(6, parentId);
                    ps.executeUpdate();
                    try (java.sql.ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            patientId = rs.getInt(1);
                        }
                    }
                }
            } else {
                // 3. Nếu đã có patient -> cập nhật Parent + Patient
                if (parentId > 0) {
                    String updateParent = "UPDATE Parent SET parentname = ? WHERE parent_id = ?";
                    try (java.sql.PreparedStatement ps = conn.prepareStatement(updateParent)) {
                        ps.setString(1, parentName);
                        ps.setInt(2, parentId);
                        ps.executeUpdate();
                    }
                }

                String updatePatient = """
                    UPDATE Patient
                    SET full_name = ?, dob = ?, address = ?, insurance_info = ?
                    WHERE patient_id = ?
                    """;
                try (java.sql.PreparedStatement ps = conn.prepareStatement(updatePatient)) {
                    ps.setString(1, patientName);
                    ps.setDate(2, patientDob != null ? java.sql.Date.valueOf(patientDob) : null);
                    ps.setString(3, patientAddress);
                    ps.setString(4, insuranceInfo);
                    ps.setInt(5, patientId);
                    ps.executeUpdate();
                }
            }

            // 4. Cập nhật phone của User (email dùng email login nên không đổi)
            String updateUser = "UPDATE [User] SET phone = ? WHERE user_id = ?";
            try (java.sql.PreparedStatement ps = conn.prepareStatement(updateUser)) {
                ps.setString(1, parentPhone);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            // 5. Insert Appointment mới
            String insertAppointment = """
                INSERT INTO Appointment (patient_id, doctor_id, date_time, status)
                VALUES (?, ?, ?, ?)
                """;
            try (java.sql.PreparedStatement ps = conn.prepareStatement(insertAppointment)) {
                ps.setInt(1, patientId);
                ps.setInt(2, doctorId);
                ps.setTimestamp(3, appointmentDateTime);
                ps.setString(4, status);
                ps.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (java.sql.SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (java.sql.SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }



    // Create new appointment with patient and parent information
    public boolean createAppointment(String patientName, String parentName, String patientAddress,
                                   String patientEmail, String parentPhone, String dateTimeStr,
                                   int doctorId, String status) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction

            // First, create or find user for patient
            int userId = createOrFindUser(conn, patientEmail, parentPhone);
            if (userId == -1) {
                conn.rollback();
                return false;
            }

            // Create or find parent
            int parentId = createOrFindParent(conn, parentName, parentPhone);
            if (parentId == -1) {
                conn.rollback();
                return false;
            }

            // Create patient
            int patientId = createPatient(conn, userId, patientName, patientAddress, parentId);
            if (patientId == -1) {
                conn.rollback();
                return false;
            }

            // Create appointment
            String appointmentSql = """
                INSERT INTO Appointment (patient_id, doctor_id, date_time, status)
                VALUES (?, ?, ?, ?)
            """;

            try (PreparedStatement ps = conn.prepareStatement(appointmentSql)) {
                ps.setInt(1, patientId);
                ps.setInt(2, doctorId);
                ps.setString(3, dateTimeStr);
                ps.setString(4, status);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Helper method to create or find user
    private int createOrFindUser(Connection conn, String email, String phone) throws SQLException {
        // First try to find existing user by email
        String findSql = "SELECT user_id FROM [User] WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        }

        // Create new user if not found
        String insertSql = """
            INSERT INTO [User] (username, password, email, phone, role_id, status)
            VALUES (?, 'defaultpass', ?, ?, 4, 1)
        """;
        try (PreparedStatement ps = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email); // Use email as username
            ps.setString(2, email);
            ps.setString(3, phone);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    // Helper method to create or find parent
    private int createOrFindParent(Connection conn, String parentName, String parentPhone) throws SQLException {
        // Try to find existing parent by phone
        String findSql = "SELECT parent_id FROM Parent WHERE parentname = ? AND phone = ?";
        try (PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setString(1, parentName);
            ps.setString(2, parentPhone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("parent_id");
                }
            }
        }

        // Create new parent if not found
        String insertSql = "INSERT INTO Parent (parentname, phone) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, parentName);
            ps.setString(2, parentPhone);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    // Helper method to create patient
    private int createPatient(Connection conn, int userId, String patientName, String patientAddress, int parentId) throws SQLException {
        String insertSql = """
            INSERT INTO Patient (user_id, full_name, address, parent_id)
            VALUES (?, ?, ?, ?)
        """;
        try (PreparedStatement ps = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, patientName);
            ps.setString(3, patientAddress);
            ps.setInt(4, parentId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    // Helper method to update patient information
    private void updatePatientInfo(Connection conn, int appointmentId, String patientName, String patientAddress) throws SQLException {
        String sql = """
            UPDATE Patient 
            SET full_name = ?, address = ?
            WHERE patient_id = (SELECT patient_id FROM Appointment WHERE appointment_id = ?)
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientName);
            ps.setString(2, patientAddress);
            ps.setInt(3, appointmentId);
            ps.executeUpdate();
        }
    }

    // Helper method to update parent information
    private void updateParentInfo(Connection conn, int appointmentId, String parentName, String parentPhone) throws SQLException {
        String sql = """
            UPDATE Parent 
            SET parentname = ?, phone = ?
            WHERE parent_id = (
                SELECT p.parent_id 
                FROM Patient p 
                JOIN Appointment a ON p.patient_id = a.patient_id 
                WHERE a.appointment_id = ?
            )
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, parentName);
            ps.setString(2, parentPhone);
            ps.setInt(3, appointmentId);
            ps.executeUpdate();
        }
    }

    // Helper method to update user email
    private void updateUserEmail(Connection conn, int appointmentId, String patientEmail) throws SQLException {
        String sql = """
            UPDATE [User] 
            SET email = ?
            WHERE user_id = (
                SELECT p.user_id 
                FROM Patient p
                JOIN Appointment a ON p.patient_id = a.patient_id
                WHERE a.appointment_id = ?
            )
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientEmail);
            ps.setInt(2, appointmentId);
            ps.executeUpdate();
        }
    }

    // Delete appointment by ID
    public boolean deleteAppointment(int appointmentId) {
        String sql = "DELETE FROM Appointment WHERE appointment_id = ?";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, appointmentId);
            int rowsAffected = ps.executeUpdate();
            
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
