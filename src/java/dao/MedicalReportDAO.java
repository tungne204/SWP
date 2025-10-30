/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import context.DBContext;
import entity.MedicalReport;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicalReportDAO extends DBContext {

    public int getPatientIdByUserId(int userId) throws Exception {
        String sql = "SELECT patient_id FROM Patient WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("patient_id");
            }
        }
        return -1;
    }

    public List<MedicalReport> searchAndFilterByPatient(int patientId, String keyword, String filterType, int offset, int pageSize) throws Exception {
        List<MedicalReport> list = new ArrayList<>();
        String sql = """
        SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, mr.test_request,
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

        if ("hasTest".equals(filterType)) {
            sql += " AND mr.test_request = 1";
        } else if ("noTest".equals(filterType)) {
            sql += " AND mr.test_request = 0";
        }

        sql += " ORDER BY a.date_time DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, patientId);
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
                ps.setString(idx++, "%" + keyword + "%");
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        }
        return list;
    }

    public int countFilteredReportsByPatient(int patientId, String keyword, String filterType) throws Exception {
        String sql = "SELECT COUNT(*) FROM MedicalReport mr "
                + "JOIN Appointment a ON mr.appointment_id = a.appointment_id "
                + "JOIN Patient p ON a.patient_id = p.patient_id WHERE p.patient_id = ?";
        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (p.full_name LIKE ? OR a.date_time LIKE ?)";
        }
        if ("hasTest".equals(filterType)) {
            sql += " AND mr.test_request = 1";
        } else if ("noTest".equals(filterType)) {
            sql += " AND mr.test_request = 0";
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, patientId);
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
                ps.setString(idx, "%" + keyword + "%");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Hàm tiện ích chuyển ResultSet → MedicalReport
     */
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
        return mr;
    }

    public List<MedicalReport> searchAndFilter(
            int doctorId, String keyword, String filterType, int offset, int limit) throws Exception {

        List<MedicalReport> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription,
               mr.test_request, p.full_name AS patient_name, u.username AS doctor_name,
               a.date_time AS appointment_date
        FROM MedicalReport mr
        JOIN Appointment a ON mr.appointment_id = a.appointment_id
        JOIN Patient p ON a.patient_id = p.patient_id
        JOIN Doctor d ON a.doctor_id = d.doctor_id
        JOIN [User] u ON d.user_id = u.user_id
        WHERE d.doctor_id = ?
    """);

        // --- Điều kiện tìm kiếm ---
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.full_name LIKE ? OR CONVERT(VARCHAR(10), a.date_time, 120) LIKE ?) ");
        }

        // --- Điều kiện lọc ---
        if (filterType != null && !filterType.equals("all")) {
            if (filterType.equals("hasTest")) {
                sql.append(" AND mr.test_request = 1 ");
            } else if (filterType.equals("noTest")) {
                sql.append(" AND mr.test_request = 0 ");
            }
        }

        sql.append(" ORDER BY a.date_time DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, doctorId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(index++, like);
                ps.setString(index++, like);
            }

            ps.setInt(index++, offset);
            ps.setInt(index, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
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

        if (filterType != null && !filterType.equals("all")) {
            if (filterType.equals("hasTest")) {
                sql.append(" AND mr.test_request = 1 ");
            } else if (filterType.equals("noTest")) {
                sql.append(" AND mr.test_request = 0 ");
            }
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, doctorId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(index++, like);
                ps.setString(index++, like);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Lấy doctor_id từ user_id
    public int getDoctorIdByUserId(int userId) throws Exception {
        String sql = "SELECT doctor_id FROM Doctor WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("doctor_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Không tìm thấy
    }

    public List<MedicalReport> getAllByDoctorId(int doctorId) throws Exception {
        List<MedicalReport> list = new ArrayList<>();
        String sql = "SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, "
                + "mr.test_request, p.full_name as patient_name, u.username as doctor_name, "
                + "a.date_time as appointment_date "
                + "FROM MedicalReport mr "
                + "JOIN Appointment a ON mr.appointment_id = a.appointment_id "
                + "JOIN Patient p ON a.patient_id = p.patient_id "
                + "JOIN Doctor d ON a.doctor_id = d.doctor_id "
                + "JOIN [User] u ON d.user_id = u.user_id "
                + "WHERE d.doctor_id = ? "
                + "ORDER BY a.date_time DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MedicalReport mr = new MedicalReport();
                mr.setRecordId(rs.getInt("record_id"));
                mr.setAppointmentId(rs.getInt("appointment_id"));
                mr.setDiagnosis(rs.getString("diagnosis"));
                mr.setPrescription(rs.getString("prescription"));
                mr.setTestRequest(rs.getBoolean("test_request"));
                mr.setPatientName(rs.getString("patient_name"));
                mr.setDoctorName(rs.getString("doctor_name"));
                mr.setAppointmentDate(rs.getString("appointment_date"));
                list.add(mr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy medical report theo ID
    public MedicalReport getById(int recordId) throws Exception {
        String sql = "SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, "
                + "mr.test_request, p.full_name as patient_name, u.username as doctor_name, "
                + "a.date_time as appointment_date "
                + "FROM MedicalReport mr "
                + "JOIN Appointment a ON mr.appointment_id = a.appointment_id "
                + "JOIN Patient p ON a.patient_id = p.patient_id "
                + "JOIN Doctor d ON a.doctor_id = d.doctor_id "
                + "JOIN [User] u ON d.user_id = u.user_id "
                + "WHERE mr.record_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                MedicalReport mr = new MedicalReport();
                mr.setRecordId(rs.getInt("record_id"));
                mr.setAppointmentId(rs.getInt("appointment_id"));
                mr.setDiagnosis(rs.getString("diagnosis"));
                mr.setPrescription(rs.getString("prescription"));
                mr.setTestRequest(rs.getBoolean("test_request"));
                mr.setPatientName(rs.getString("patient_name"));
                mr.setDoctorName(rs.getString("doctor_name"));
                mr.setAppointmentDate(rs.getString("appointment_date"));
                return mr;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy medical report theo appointment ID
    public MedicalReport getByAppointmentId(int appointmentId) throws Exception {
        String sql = "SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, "
                + "mr.test_request, p.full_name as patient_name, u.username as doctor_name, "
                + "a.date_time as appointment_date "
                + "FROM MedicalReport mr "
                + "JOIN Appointment a ON mr.appointment_id = a.appointment_id "
                + "JOIN Patient p ON a.patient_id = p.patient_id "
                + "JOIN Doctor d ON a.doctor_id = d.doctor_id "
                + "JOIN [User] u ON d.user_id = u.user_id "
                + "WHERE mr.appointment_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                MedicalReport mr = new MedicalReport();
                mr.setRecordId(rs.getInt("record_id"));
                mr.setAppointmentId(rs.getInt("appointment_id"));
                mr.setDiagnosis(rs.getString("diagnosis"));
                mr.setPrescription(rs.getString("prescription"));
                mr.setTestRequest(rs.getBoolean("test_request"));
                mr.setPatientName(rs.getString("patient_name"));
                mr.setDoctorName(rs.getString("doctor_name"));
                mr.setAppointmentDate(rs.getString("appointment_date"));
                return mr;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy appointments chưa có medical report của doctor
    public List<Appointment> getAppointmentsWithoutReport(int doctorId) throws Exception {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, p.full_name, a.date_time "
                + "FROM Appointment a "
                + "JOIN Patient p ON a.patient_id = p.patient_id "
                + "WHERE a.doctor_id = ? AND a.status = 1 "
                + "AND NOT EXISTS (SELECT 1 FROM MedicalReport mr WHERE mr.appointment_id = a.appointment_id) "
                + "ORDER BY a.date_time DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment apt = new Appointment();
                apt.setAppointmentId(rs.getInt("appointment_id"));
                apt.setPatientName(rs.getString("full_name"));
                apt.setDateTime(rs.getTimestamp("date_time"));
                list.add(apt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm medical report mới
    public boolean insert(MedicalReport mr) throws Exception {
        String sql = "INSERT INTO MedicalReport (appointment_id, diagnosis, prescription, test_request) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, mr.getAppointmentId());
            ps.setString(2, mr.getDiagnosis());
            ps.setString(3, mr.getPrescription());
            ps.setBoolean(4, mr.isTestRequest());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật medical report
    public boolean update(MedicalReport mr) throws Exception {
        String sql = "UPDATE MedicalReport SET diagnosis = ?, prescription = ?, test_request = ? "
                + "WHERE record_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, mr.getDiagnosis());
            ps.setString(2, mr.getPrescription());
            ps.setBoolean(3, mr.isTestRequest());
            ps.setInt(4, mr.getRecordId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa medical report
    public boolean delete(int recordId) throws Exception {
        String sql = "DELETE FROM MedicalReport WHERE record_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, recordId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Inner class cho Appointment
    public static class Appointment {

        private int appointmentId;
        private String patientName;
        private Timestamp dateTime;

        public int getAppointmentId() {
            return appointmentId;
        }

        public void setAppointmentId(int appointmentId) {
            this.appointmentId = appointmentId;
        }

        public String getPatientName() {
            return patientName;
        }

        public void setPatientName(String patientName) {
            this.patientName = patientName;
        }

        public Timestamp getDateTime() {
            return dateTime;
        }

        public void setDateTime(Timestamp dateTime) {
            this.dateTime = dateTime;
        }
    }
}
