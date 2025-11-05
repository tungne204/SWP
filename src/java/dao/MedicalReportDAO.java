package dao;

import context.DBContext;
import entity.MedicalReport;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicalReportDAO extends DBContext {

    // ================== Helpers ==================
    private MedicalReport mapResultSet(ResultSet rs) throws SQLException {
        MedicalReport mr = new MedicalReport();
        mr.setRecordId(rs.getInt("record_id"));
        mr.setAppointmentId(rs.getInt("appointment_id"));
        mr.setDiagnosis(rs.getString("diagnosis"));
        mr.setPrescription(rs.getString("prescription"));
        mr.setTestRequest(rs.getBoolean("test_request"));
        mr.setPatientName(rs.getString("patient_name"));
        mr.setDoctorName(rs.getString("doctor_name"));
        mr.setAppointmentDate(rs.getString("appointment_date"));
        try { mr.setFinal(rs.getBoolean("is_final")); } catch (SQLException ignore) {}
        return mr;
    }

    public int getDoctorIdByUserId(int userId) throws Exception {
        String sql = "SELECT doctor_id FROM Doctor WHERE user_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        }
    }

    public int getPatientIdByUserId(int userId) throws Exception {
        String sql = "SELECT patient_id FROM Patient WHERE user_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        }
    }

    // ================== Query lists ==================
    public List<MedicalReport> searchAndFilter(int doctorId, String keyword, String filterType, int offset, int limit) throws Exception {
        List<MedicalReport> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription,
                   mr.test_request, mr.is_final,
                   p.full_name AS patient_name, u.username AS doctor_name,
                   a.date_time AS appointment_date
            FROM MedicalReport mr
            JOIN Appointment a ON mr.appointment_id = a.appointment_id
            JOIN Patient p ON a.patient_id = p.patient_id
            JOIN Doctor d ON a.doctor_id = d.doctor_id
            JOIN [User] u ON d.user_id = u.user_id
            WHERE d.doctor_id = ?
        """);
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.full_name LIKE ? OR CONVERT(VARCHAR(10), a.date_time, 120) LIKE ?) ");
        }
        if (filterType != null && !"all".equals(filterType)) {
            if ("hasTest".equals(filterType)) sql.append(" AND mr.test_request = 1 ");
            else if ("noTest".equals(filterType)) sql.append(" AND mr.test_request = 0 ");
        }
        sql.append(" ORDER BY a.date_time DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql.toString())) {
            int i = 1;
            ps.setInt(i++, doctorId);
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(i++, like);
                ps.setString(i++, like);
            }
            ps.setInt(i++, offset);
            ps.setInt(i,   limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        }
        return list;
    }

    public int countFilteredReports(int doctorId, String keyword, String filterType) throws Exception {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) FROM MedicalReport mr
            JOIN Appointment a ON mr.appointment_id = a.appointment_id
            JOIN Patient p ON a.patient_id = p.patient_id
            JOIN Doctor d ON a.doctor_id = d.doctor_id
            WHERE d.doctor_id = ?
        """);
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.full_name LIKE ? OR CONVERT(VARCHAR(10), a.date_time, 120) LIKE ?) ");
        }
        if (filterType != null && !"all".equals(filterType)) {
            if ("hasTest".equals(filterType)) sql.append(" AND mr.test_request = 1 ");
            else if ("noTest".equals(filterType)) sql.append(" AND mr.test_request = 0 ");
        }

        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql.toString())) {
            int i = 1;
            ps.setInt(i++, doctorId);
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(i++, like);
                ps.setString(i++, like);
            }
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getInt(1) : 0; }
        }
    }

    public List<MedicalReport> searchAndFilterByPatient(int patientId, String keyword, String filterType, int offset, int pageSize) throws Exception {
        List<MedicalReport> list = new ArrayList<>();
        String sql = """
            SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, mr.test_request, mr.is_final,
                   p.full_name AS patient_name, u.username AS doctor_name, a.date_time AS appointment_date
            FROM MedicalReport mr
            JOIN Appointment a ON mr.appointment_id = a.appointment_id
            JOIN Patient p ON a.patient_id = p.patient_id
            JOIN Doctor d ON a.doctor_id = d.doctor_id
            JOIN [User] u ON d.user_id = u.user_id
            WHERE p.patient_id = ?
        """;
        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (p.full_name LIKE ? OR a.date_time LIKE ?)";
        }
        if ("hasTest".equals(filterType)) sql += " AND mr.test_request = 1";
        else if ("noTest".equals(filterType)) sql += " AND mr.test_request = 0";

        sql += " ORDER BY a.date_time DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            int i = 1;
            ps.setInt(i++, patientId);
            if (keyword != null && !keyword.isEmpty()) {
                String like = "%" + keyword + "%";
                ps.setString(i++, like);
                ps.setString(i++, like);
            }
            ps.setInt(i++, offset);
            ps.setInt(i, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        }
        return list;
    }

    public int countFilteredReportsByPatient(int patientId, String keyword, String filterType) throws Exception {
        String sql = """
            SELECT COUNT(*) FROM MedicalReport mr
            JOIN Appointment a ON mr.appointment_id = a.appointment_id
            JOIN Patient p ON a.patient_id = p.patient_id
            WHERE p.patient_id = ?
        """;
        if (keyword != null && !keyword.isEmpty()) sql += " AND (p.full_name LIKE ? OR a.date_time LIKE ?)";
        if ("hasTest".equals(filterType)) sql += " AND mr.test_request = 1";
        else if ("noTest".equals(filterType)) sql += " AND mr.test_request = 0";

        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            int i = 1;
            ps.setInt(i++, patientId);
            if (keyword != null && !keyword.isEmpty()) {
                String like = "%" + keyword + "%";
                ps.setString(i++, like);
                ps.setString(i++, like);
            }
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getInt(1) : 0; }
        }
    }

    public List<MedicalReport> getAllByDoctorId(int doctorId) throws Exception {
        List<MedicalReport> list = new ArrayList<>();
        String sql = """
            SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, mr.test_request, mr.is_final,
                   p.full_name as patient_name, u.username as doctor_name, a.date_time as appointment_date
            FROM MedicalReport mr
            JOIN Appointment a ON mr.appointment_id = a.appointment_id
            JOIN Patient p ON a.patient_id = p.patient_id
            JOIN Doctor d ON a.doctor_id = d.doctor_id
            JOIN [User] u ON d.user_id = u.user_id
            WHERE d.doctor_id = ?
            ORDER BY a.date_time DESC
        """;

        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        }
        return list;
    }

    public MedicalReport getById(int recordId) throws Exception {
        String sql = """
            SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, mr.test_request, mr.is_final,
                   p.full_name as patient_name, u.username as doctor_name, a.date_time as appointment_date
            FROM MedicalReport mr
            JOIN Appointment a ON mr.appointment_id = a.appointment_id
            JOIN Patient p ON a.patient_id = p.patient_id
            JOIN Doctor d ON a.doctor_id = d.doctor_id
            JOIN [User] u ON d.user_id = u.user_id
            WHERE mr.record_id = ?
        """;
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recordId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapResultSet(rs) : null;
            }
        }
    }

    public MedicalReport getByAppointmentId(int appointmentId) throws Exception {
        String sql = """
            SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, mr.test_request, mr.is_final,
                   p.full_name as patient_name, u.username as doctor_name, a.date_time as appointment_date
            FROM MedicalReport mr
            JOIN Appointment a ON mr.appointment_id = a.appointment_id
            JOIN Patient p ON a.patient_id = p.patient_id
            JOIN Doctor d ON a.doctor_id = d.doctor_id
            JOIN [User] u ON d.user_id = u.user_id
            WHERE mr.appointment_id = ?
        """;
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapResultSet(rs) : null;
            }
        }
    }

    // ============== Core business: Draft & Finalize ==============
    public boolean hasTestResults(int recordId) throws Exception {
        String sql = "SELECT 1 FROM dbo.TestResult WHERE record_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recordId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    public boolean insert(MedicalReport mr) throws Exception {
        String sql = "INSERT INTO MedicalReport (appointment_id, diagnosis, prescription, test_request, is_final) VALUES (?, ?, ?, ?, 0)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, mr.getAppointmentId());
            ps.setString(2, mr.getDiagnosis());
            ps.setString(3, mr.getPrescription()); // có thể null
            ps.setBoolean(4, mr.isTestRequest());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(MedicalReport mr) throws Exception {
        if (mr.isFinal()) {
            // Muốn finalize => phải có test result
            if (!hasTestResults(mr.getRecordId())) return false;
        }
        String sql = "UPDATE MedicalReport SET diagnosis = ?, prescription = ?, test_request = ?, is_final = ? WHERE record_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, mr.getDiagnosis());
            ps.setString(2, mr.getPrescription()); // có thể null ở Draft
            ps.setBoolean(3, mr.isTestRequest());
            ps.setBoolean(4, mr.isFinal());
            ps.setInt(5, mr.getRecordId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int recordId) throws Exception {
        String sql = "DELETE FROM MedicalReport WHERE record_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recordId);
            return ps.executeUpdate() > 0;
        }
    }

    // ============== Appointments for "Add" (chưa có report) ==============
    public static class Appointment {
        private int appointmentId;
        private String patientName;
        private Timestamp dateTime;
        public int getAppointmentId() { return appointmentId; }
        public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }
        public String getPatientName() { return patientName; }
        public void setPatientName(String patientName) { this.patientName = patientName; }
        public Timestamp getDateTime() { return dateTime; }
        public void setDateTime(Timestamp dateTime) { this.dateTime = dateTime; }
    }

    public List<Appointment> getAppointmentsWithoutReport(int doctorId) throws Exception {
        List<Appointment> list = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, p.full_name AS patient_name, a.date_time
            FROM   dbo.Appointment a
            JOIN   dbo.Patient     p  ON p.patient_id = a.patient_id
            LEFT   JOIN dbo.MedicalReport mr ON mr.appointment_id = a.appointment_id
            WHERE  a.doctor_id = ?
              AND  mr.record_id IS NULL
              AND  a.status IN (N'Confirmed', N'Completed')
            ORDER BY a.date_time DESC
        """;
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment apt = new Appointment();
                    apt.setAppointmentId(rs.getInt("appointment_id"));
                    apt.setPatientName(rs.getString("patient_name"));
                    apt.setDateTime(rs.getTimestamp("date_time"));
                    list.add(apt);
                }
            }
        }
        return list;
    }
}
