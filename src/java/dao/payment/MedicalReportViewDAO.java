package dao.payment;

import java.sql.*;
import java.util.*;

public class MedicalReportViewDAO {
    private final Connection conn;

    // ✅ Dùng private field + getter/setter để EL truy cập được
    public static class Row {
        private int recordId;
        private int appointmentId;
        private String diagnosis;
        private String prescription;
        private String patientName;
        private boolean paid;

        public int getRecordId() { return recordId; }
        public void setRecordId(int recordId) { this.recordId = recordId; }

        public int getAppointmentId() { return appointmentId; }
        public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

        public String getDiagnosis() { return diagnosis; }
        public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

        public String getPrescription() { return prescription; }
        public void setPrescription(String prescription) { this.prescription = prescription; }

        public String getPatientName() { return patientName; }
        public void setPatientName(String patientName) { this.patientName = patientName; }

        public boolean isPaid() { return paid; }         // boolean dùng isXxx
        public void setPaid(boolean paid) { this.paid = paid; }
    }

    public MedicalReportViewDAO(Connection c){ this.conn = c; }

    public List<Row> listAll() throws SQLException {
        String sql =
            "SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, " +
            "  p.full_name AS patient_name, " +
            "  CASE WHEN EXISTS (SELECT 1 FROM dbo.Payment pay " +
            "                    WHERE pay.appointment_id = mr.appointment_id AND pay.status = 1) " +
            "       THEN 1 ELSE 0 END AS paid " +
            "FROM dbo.MedicalReport mr " +
            "INNER JOIN dbo.Appointment a ON mr.appointment_id = a.appointment_id " +
            "INNER JOIN dbo.Patient p ON a.patient_id = p.patient_id " +
            "ORDER BY mr.record_id DESC";

        List<Row> out = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()){
                Row r = new Row();
                r.setRecordId(rs.getInt("record_id"));
                r.setAppointmentId(rs.getInt("appointment_id"));
                r.setDiagnosis(rs.getString("diagnosis"));
                r.setPrescription(rs.getString("prescription"));
                r.setPatientName(rs.getString("patient_name"));
                r.setPaid(rs.getInt("paid") == 1);
                out.add(r);
            }
        }
        return out;
    }

    /**
     * Lấy danh sách medical reports với search, filter và paging
     * @param searchKeyword từ khóa tìm kiếm (tên bệnh nhân, record ID, diagnosis, prescription)
     * @param paymentStatus trạng thái thanh toán: "all", "paid", "unpaid"
     * @param page số trang (bắt đầu từ 1)
     * @param pageSize số bản ghi mỗi trang
     * @return danh sách medical reports
     */
    public List<Row> listWithSearchFilterPaging(String searchKeyword, String paymentStatus, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, " +
            "  p.full_name AS patient_name, " +
            "  CASE WHEN EXISTS (SELECT 1 FROM dbo.Payment pay " +
            "                    WHERE pay.appointment_id = mr.appointment_id AND pay.status = 1) " +
            "       THEN 1 ELSE 0 END AS paid " +
            "FROM dbo.MedicalReport mr " +
            "INNER JOIN dbo.Appointment a ON mr.appointment_id = a.appointment_id " +
            "INNER JOIN dbo.Patient p ON a.patient_id = p.patient_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        // Search filter
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND (p.full_name LIKE ? OR CAST(mr.record_id AS VARCHAR) LIKE ? " +
                      "OR mr.diagnosis LIKE ? OR mr.prescription LIKE ?) ");
            String pattern = "%" + searchKeyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        // Payment status filter
        if (paymentStatus != null && !paymentStatus.trim().isEmpty() && !paymentStatus.equalsIgnoreCase("all")) {
            if (paymentStatus.equalsIgnoreCase("paid")) {
                sql.append("AND EXISTS (SELECT 1 FROM dbo.Payment pay " +
                          "WHERE pay.appointment_id = mr.appointment_id AND pay.status = 1) ");
            } else if (paymentStatus.equalsIgnoreCase("unpaid")) {
                sql.append("AND NOT EXISTS (SELECT 1 FROM dbo.Payment pay " +
                          "WHERE pay.appointment_id = mr.appointment_id AND pay.status = 1) ");
            }
        }

        sql.append("ORDER BY mr.record_id DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<Row> out = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    ps.setString(paramIndex++, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(paramIndex++, (Integer) param);
                }
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Row r = new Row();
                    r.setRecordId(rs.getInt("record_id"));
                    r.setAppointmentId(rs.getInt("appointment_id"));
                    r.setDiagnosis(rs.getString("diagnosis"));
                    r.setPrescription(rs.getString("prescription"));
                    r.setPatientName(rs.getString("patient_name"));
                    r.setPaid(rs.getInt("paid") == 1);
                    out.add(r);
                }
            }
        }
        return out;
    }

    /**
     * Đếm tổng số bản ghi thỏa điều kiện search và filter (dùng cho paging)
     */
    public int getTotalCount(String searchKeyword, String paymentStatus) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) AS total " +
            "FROM dbo.MedicalReport mr " +
            "INNER JOIN dbo.Appointment a ON mr.appointment_id = a.appointment_id " +
            "INNER JOIN dbo.Patient p ON a.patient_id = p.patient_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        // Search filter
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND (p.full_name LIKE ? OR CAST(mr.record_id AS VARCHAR) LIKE ? " +
                      "OR mr.diagnosis LIKE ? OR mr.prescription LIKE ?) ");
            String pattern = "%" + searchKeyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        // Payment status filter
        if (paymentStatus != null && !paymentStatus.trim().isEmpty() && !paymentStatus.equalsIgnoreCase("all")) {
            if (paymentStatus.equalsIgnoreCase("paid")) {
                sql.append("AND EXISTS (SELECT 1 FROM dbo.Payment pay " +
                          "WHERE pay.appointment_id = mr.appointment_id AND pay.status = 1) ");
            } else if (paymentStatus.equalsIgnoreCase("unpaid")) {
                sql.append("AND NOT EXISTS (SELECT 1 FROM dbo.Payment pay " +
                          "WHERE pay.appointment_id = mr.appointment_id AND pay.status = 1) ");
            }
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    ps.setString(paramIndex++, (String) param);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }
}
