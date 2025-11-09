/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.appointments;

/**
 *
 * @author Quang Anh
 */
import context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import entity.appointments.Appointment;
import entity.appointments.MedicalReport;
import entity.appointments.TestResult;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentDAO extends DBContext {

    public List<Appointment> getAppointmentsByDoctorUserIdAndStatus(int userId, String status) {
        List<Appointment> list = new ArrayList<>();

        // Nếu đang load hàng đợi WAITING: sort theo waiting_since DESC (mới vào queue đứng đầu)
        String orderBy = "Waiting".equalsIgnoreCase(status)
                ? "ORDER BY CASE WHEN a.waiting_since IS NULL THEN 1 ELSE 0 END, a.waiting_since DESC, a.date_time ASC"
                : "ORDER BY a.date_time DESC";

        String sql = """
        SELECT a.*, 
               p.full_name AS patient_name,
               u.username AS doctor_name
        FROM Appointment a
        JOIN Doctor d ON a.doctor_id = d.doctor_id
        LEFT JOIN Patient p ON a.patient_id = p.patient_id
        LEFT JOIN [User] u ON d.user_id = u.user_id
        WHERE d.user_id = ? AND a.status = ?
    """ + " " + orderBy;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment apt = new Appointment();
                    apt.setAppointmentId(rs.getInt("appointment_id"));
                    apt.setPatientId(rs.getInt("patient_id"));
                    apt.setDoctorId(rs.getInt("doctor_id"));
                    apt.setDateTime(rs.getTimestamp("date_time"));
                    apt.setStatus(rs.getString("status"));
                    apt.setPatientName(rs.getString("patient_name"));
                    apt.setDoctorName(rs.getString("doctor_name"));
                    list.add(apt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả appointments theo status
    // Lấy tất cả appointments theo status: ưu tiên lịch sắp tới trước, gần nhất lên đầu
    public List<Appointment> getAppointmentsByStatus(String status) {
        List<Appointment> list = new ArrayList<>();
        String sql
                = "SELECT a.*, "
                + "       p.full_name AS patient_name, "
                + "       u.username AS doctor_name "
                + "FROM Appointment a "
                + "LEFT JOIN Patient p ON a.patient_id = p.patient_id "
                + "LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id "
                + "LEFT JOIN [User] u ON d.user_id = u.user_id "
                + "WHERE a.status = ? "
                + "ORDER BY "
                + "  CASE WHEN a.date_time >= GETDATE() THEN 0 ELSE 1 END, "
                + // tương lai trước
                "  CASE WHEN a.date_time >= GETDATE() THEN a.date_time END ASC, "
                + // tương lai: tăng dần
                "  CASE WHEN a.date_time <  GETDATE() THEN a.date_time END DESC";   // quá khứ: giảm dần

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment apt = new Appointment();
                apt.setAppointmentId(rs.getInt("appointment_id"));
                apt.setPatientId(rs.getInt("patient_id"));
                apt.setDoctorId(rs.getInt("doctor_id"));
                apt.setDateTime(rs.getTimestamp("date_time"));
                apt.setStatus(rs.getString("status"));
                apt.setPatientName(rs.getString("patient_name"));
                apt.setDoctorName(rs.getString("doctor_name"));
                list.add(apt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Lấy appointments theo doctor và status
    public List<Appointment> getAppointmentsByDoctorAndStatus(int doctorId, String status) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, "
                + "       p.full_name AS patient_name, "
                + "       u.username AS doctor_name "
                + "FROM Appointment a "
                + "LEFT JOIN Patient p ON a.patient_id = p.patient_id "
                + "LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id "
                + "LEFT JOIN [User] u ON d.user_id = u.user_id "
                + "WHERE a.doctor_id = ? AND a.status = ? "
                + "ORDER BY CASE WHEN a.status = 'Waiting' THEN 0 ELSE 1 END, a.date_time DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment apt = new Appointment();
                apt.setAppointmentId(rs.getInt("appointment_id"));
                apt.setPatientId(rs.getInt("patient_id"));
                apt.setDoctorId(rs.getInt("doctor_id"));
                apt.setDateTime(rs.getTimestamp("date_time"));
                apt.setStatus(rs.getString("status"));
                apt.setPatientName(rs.getString("patient_name"));
                apt.setDoctorName(rs.getString("doctor_name"));
                list.add(apt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Lấy appointment theo ID
    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT a.*, "
                + "       p.full_name AS patient_name, "
                + "       u.username AS doctor_name "
                + "FROM Appointment a "
                + "LEFT JOIN Patient p ON a.patient_id = p.patient_id "
                + "LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id "
                + "LEFT JOIN [User] u ON d.user_id = u.user_id "
                + "WHERE a.appointment_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Appointment apt = new Appointment();
                apt.setAppointmentId(rs.getInt("appointment_id"));
                apt.setPatientId(rs.getInt("patient_id"));
                apt.setDoctorId(rs.getInt("doctor_id"));
                apt.setDateTime(rs.getTimestamp("date_time"));
                apt.setStatus(rs.getString("status"));
                apt.setPatientName(rs.getString("patient_name"));
                apt.setDoctorName(rs.getString("doctor_name"));
                return apt;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Cập nhật status của appointment
    public boolean updateAppointmentStatus(int appointmentId, String newStatus) {
        String sql = """
        UPDATE Appointment
        SET status = ?,
            waiting_since = CASE WHEN ? = 'Waiting' THEN GETDATE() ELSE waiting_since END
        WHERE appointment_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, newStatus); // dùng 2 lần trong CASE
            ps.setInt(3, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Tạo medical report
    public int createMedicalReport(MedicalReport report) {
        String sql = "INSERT INTO MedicalReport (appointment_id, diagnosis, prescription, "
                + "test_request, consultation_id, is_final,requested_test_type, test_requested_at, requested_by_doctor_id) VALUES (?, ?, ?, ?, ?, ?,?,?,?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql,
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, report.getAppointmentId());
            ps.setString(2, report.getDiagnosis());
            ps.setString(3, report.getPrescription());
            ps.setBoolean(4, report.isTestRequest());
            ps.setString(7, report.getRequestedTestType());                 // NEW
            if (report.getTestRequestedAt() != null) {
                ps.setTimestamp(8, report.getTestRequestedAt());
            } else {
                ps.setNull(8, Types.TIMESTAMP);  // NEW
            }
            if (report.getRequestedByDoctorId() != null) {
                ps.setInt(9, report.getRequestedByDoctorId());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
            if (report.getConsultationId() != null) {
                ps.setInt(5, report.getConsultationId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setBoolean(6, report.isFinal());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    // Cập nhật medical report
    public boolean updateMedicalReport(MedicalReport report) {
        String sql = "UPDATE MedicalReport SET diagnosis = ?, prescription = ?, "
                + "test_request = ?, is_final = ?, requested_test_type = ?, "
                + "test_requested_at = ?, requested_by_doctor_id = ? "
                + "WHERE record_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, report.getDiagnosis());
            ps.setString(2, report.getPrescription());
            ps.setBoolean(3, report.isTestRequest());
            ps.setBoolean(4, report.isFinal());

            // index 5 = requested_test_type
            ps.setString(5, report.getRequestedTestType());

            // index 6 = test_requested_at
            if (report.getTestRequestedAt() != null) {
                ps.setTimestamp(6, report.getTestRequestedAt());
            } else {
                ps.setNull(6, Types.TIMESTAMP);
            }

            // index 7 = requested_by_doctor_id
            if (report.getRequestedByDoctorId() != null) {
                ps.setInt(7, report.getRequestedByDoctorId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            // index 8 = WHERE record_id
            ps.setInt(8, report.getRecordId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Lấy medical report theo appointment ID
    public MedicalReport getMedicalReportByAppointmentId(int appointmentId) {
        String sql = "SELECT * FROM MedicalReport WHERE appointment_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                MedicalReport report = new MedicalReport();
                report.setRecordId(rs.getInt("record_id"));
                report.setAppointmentId(rs.getInt("appointment_id"));
                report.setDiagnosis(rs.getString("diagnosis"));
                report.setPrescription(rs.getString("prescription"));
                report.setTestRequest(rs.getBoolean("test_request"));
                report.setConsultationId(rs.getInt("consultation_id"));
                report.setFinal(rs.getBoolean("is_final"));
                report.setRequestedTestType(rs.getString("requested_test_type"));
                report.setTestRequestedAt(rs.getTimestamp("test_requested_at"));
                int docId = rs.getInt("requested_by_doctor_id");
                report.setRequestedByDoctorId(rs.wasNull() ? null : docId);
                return report;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Tạo test result
    public boolean createTestResult(TestResult testResult) {
        String sql = "INSERT INTO TestResult (record_id, test_type, result, date, "
                + "consultation_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testResult.getRecordId());
            ps.setString(2, testResult.getTestType());
            ps.setString(3, testResult.getResult());
            ps.setDate(4, testResult.getDate());
            if (testResult.getConsultationId() != null) {
                ps.setInt(5, testResult.getConsultationId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Lấy test results theo record ID
    public List<TestResult> getTestResultsByRecordId(int recordId) {
        List<TestResult> list = new ArrayList<>();
        String sql = "SELECT * FROM TestResult WHERE record_id = ? ORDER BY date DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TestResult test = new TestResult();
                test.setTestId(rs.getInt("test_id"));
                test.setRecordId(rs.getInt("record_id"));
                test.setTestType(rs.getString("test_type"));
                test.setResult(rs.getString("result"));
                test.setDate(rs.getDate("date"));
                test.setConsultationId(rs.getInt("consultation_id"));
                list.add(test);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Lấy appointments theo patient ID
    // Lấy appointments theo patient ID: sắp xếp "gần nhất" từ trên xuống
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql
                = "SELECT a.*, "
                + "       p.full_name AS patient_name, "
                + "       u.username AS doctor_name "
                + "FROM Appointment a "
                + "LEFT JOIN Patient p ON a.patient_id = p.patient_id "
                + "LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id "
                + "LEFT JOIN [User] u ON d.user_id = u.user_id "
                + "WHERE a.patient_id = ? "
                + "ORDER BY "
                + "  CASE WHEN a.date_time >= GETDATE() THEN 0 ELSE 1 END, "
                + // nhóm lịch tương lai trước
                "  CASE WHEN a.date_time >= GETDATE() THEN a.date_time END ASC, "
                + // tương lai: tăng dần (gần nhất trước)
                "  CASE WHEN a.date_time <  GETDATE() THEN a.date_time END DESC";   // quá khứ: giảm dần (mới nhất trước) 

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment apt = new Appointment();
                apt.setAppointmentId(rs.getInt("appointment_id"));
                apt.setPatientId(rs.getInt("patient_id"));
                apt.setDoctorId(rs.getInt("doctor_id"));
                apt.setDateTime(rs.getTimestamp("date_time"));
                apt.setStatus(rs.getString("status"));
                apt.setPatientName(rs.getString("patient_name"));
                apt.setDoctorName(rs.getString("doctor_name"));
                list.add(apt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Tạo appointment mới
    public boolean createAppointment(Appointment appointment) {
        String sql = "INSERT INTO Appointment (patient_id, doctor_id, date_time, status) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointment.getPatientId());
            ps.setInt(2, appointment.getDoctorId());
            ps.setTimestamp(3, appointment.getDateTime());
            ps.setString(4, appointment.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Kiểm tra bác sĩ có khả dụng không
    public boolean isDoctorAvailable(int doctorId, Timestamp dateTime) {
        // Kiểm tra xem bác sĩ có appointment nào trong khoảng ±30 phút không
        String sql = "SELECT COUNT(*) FROM Appointment "
                + "WHERE doctor_id = ? "
                + "AND status NOT IN ('Cancelled', 'Completed') "
                + "AND ABS(DATEDIFF(MINUTE, date_time, ?)) < 30";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setTimestamp(2, dateTime);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) == 0; // Available nếu count = 0
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Lấy appointments với search, filter và paging
    public List<Appointment> getAppointmentsWithFilter(int roleId, Integer userId, Integer patientId, 
            String searchKeyword, String statusFilter, String dateFrom, String dateTo, 
            int page, int pageSize) {
        List<Appointment> list = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.*, ");
        sql.append("       p.full_name AS patient_name, ");
        sql.append("       pu.phone AS patient_phone, ");
        sql.append("       du.username AS doctor_name ");
        sql.append("FROM Appointment a ");
        sql.append("LEFT JOIN Patient p ON a.patient_id = p.patient_id ");
        sql.append("LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id ");
        sql.append("LEFT JOIN [User] du ON d.user_id = du.user_id ");
        sql.append("LEFT JOIN [User] pu ON p.user_id = pu.user_id ");
        sql.append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        // Filter theo role
        if (roleId == 2) { // Doctor - chỉ hiển thị WAITING
            sql.append("AND d.user_id = ? ");
            params.add(userId);
            sql.append("AND a.status = 'Waiting' ");
        } else if (roleId == 3) { // Patient - hiển thị tất cả appointments của user
            // Filter theo user_id của patient để hiển thị tất cả appointments
            // (kể cả các patient mới được tạo với user_id này)
            if (userId != null) {
                sql.append("AND p.user_id = ? ");
                params.add(userId);
            } else if (patientId != null) {
                // Fallback: nếu không có userId, dùng patientId
                sql.append("AND a.patient_id = ? ");
                params.add(patientId);
            }
        } else if (roleId == 4) { // Medical Assistant - chỉ TESTING
            sql.append("AND a.status = 'Testing' ");
        } else if (roleId == 5) { // Receptionist - PENDING + CONFIRMED
            sql.append("AND a.status IN ('Pending', 'Confirmed') ");
        }
        
        // Filter theo status (bỏ qua nếu roleId == 2 vì đã force Waiting)
        if (roleId != 2 && statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equals(statusFilter)) {
            sql.append("AND a.status = ? ");
            params.add(statusFilter);
        }
        
        // Search keyword (tìm trong patient name, doctor name, appointment ID)
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND (p.full_name LIKE ? OR du.username LIKE ? OR CAST(a.appointment_id AS VARCHAR) LIKE ? OR pu.phone LIKE ?) ");
            String searchPattern = "%" + searchKeyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Filter theo date range
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append("AND CAST(a.date_time AS DATE) >= ? ");
            params.add(dateFrom);
        }
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append("AND CAST(a.date_time AS DATE) <= ? ");
            params.add(dateTo);
        }
        
        // Order by
        sql.append("ORDER BY ");
        sql.append("  CASE WHEN a.date_time >= GETDATE() THEN 0 ELSE 1 END, ");
        sql.append("  CASE WHEN a.date_time >= GETDATE() THEN a.date_time END ASC, ");
        sql.append("  CASE WHEN a.date_time < GETDATE() THEN a.date_time END DESC ");
        
        // Paging
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                }
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment apt = new Appointment();
                apt.setAppointmentId(rs.getInt("appointment_id"));
                apt.setPatientId(rs.getInt("patient_id"));
                apt.setDoctorId(rs.getInt("doctor_id"));
                apt.setDateTime(rs.getTimestamp("date_time"));
                apt.setStatus(rs.getString("status"));
                apt.setPatientName(rs.getString("patient_name"));
                apt.setPatientPhone(rs.getString("patient_phone"));
                apt.setDoctorName(rs.getString("doctor_name"));
                list.add(apt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    // Đếm tổng số appointments với filter (cho paging)
    public int countAppointmentsWithFilter(int roleId, Integer userId, Integer patientId,
            String searchKeyword, String statusFilter, String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Appointment a ");
        sql.append("LEFT JOIN Patient p ON a.patient_id = p.patient_id ");
        sql.append("LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id ");
        sql.append("LEFT JOIN [User] du ON d.user_id = du.user_id ");
        sql.append("LEFT JOIN [User] pu ON p.user_id = pu.user_id ");
        sql.append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        // Filter theo role
        if (roleId == 2) { // Doctor - chỉ hiển thị WAITING
            sql.append("AND d.user_id = ? ");
            params.add(userId);
            sql.append("AND a.status = 'Waiting' ");
        } else if (roleId == 3) { // Patient - hiển thị tất cả appointments của user
            // Filter theo user_id của patient để hiển thị tất cả appointments
            // (kể cả các patient mới được tạo với user_id này)
            if (userId != null) {
                sql.append("AND p.user_id = ? ");
                params.add(userId);
            } else if (patientId != null) {
                // Fallback: nếu không có userId, dùng patientId
                sql.append("AND a.patient_id = ? ");
                params.add(patientId);
            }
        } else if (roleId == 4) { // Medical Assistant
            sql.append("AND a.status = 'Testing' ");
        } else if (roleId == 5) { // Receptionist
            sql.append("AND a.status IN ('Pending', 'Confirmed') ");
        }
        
        // Filter theo status (bỏ qua nếu roleId == 2 vì đã force Waiting)
        if (roleId != 2 && statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equals(statusFilter)) {
            sql.append("AND a.status = ? ");
            params.add(statusFilter);
        }
        
        // Search keyword
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND (p.full_name LIKE ? OR du.username LIKE ? OR CAST(a.appointment_id AS VARCHAR) LIKE ? OR pu.phone LIKE ?) ");
            String searchPattern = "%" + searchKeyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Filter theo date range
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append("AND CAST(a.date_time AS DATE) >= ? ");
            params.add(dateFrom);
        }
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append("AND CAST(a.date_time AS DATE) <= ? ");
            params.add(dateTo);
        }
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                }
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
}
