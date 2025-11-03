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
        private boolean paid;

        public int getRecordId() { return recordId; }
        public void setRecordId(int recordId) { this.recordId = recordId; }

        public int getAppointmentId() { return appointmentId; }
        public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

        public String getDiagnosis() { return diagnosis; }
        public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

        public boolean isPaid() { return paid; }         // boolean dùng isXxx
        public void setPaid(boolean paid) { this.paid = paid; }
    }

    public MedicalReportViewDAO(Connection c){ this.conn = c; }

    public List<Row> listAll() throws SQLException {
        String sql =
            "SELECT mr.record_id, mr.appointment_id, mr.diagnosis, " +
            "  CASE WHEN EXISTS (SELECT 1 FROM dbo.Payment p " +
            "                    WHERE p.appointment_id = mr.appointment_id AND p.status = 1) " +
            "       THEN 1 ELSE 0 END AS paid " +
            "FROM dbo.MedicalReport mr " +
            "ORDER BY mr.record_id DESC";

        List<Row> out = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()){
                Row r = new Row();
                r.setRecordId(rs.getInt("record_id"));
                r.setAppointmentId(rs.getInt("appointment_id"));
                r.setDiagnosis(rs.getString("diagnosis"));
                r.setPaid(rs.getInt("paid") == 1);
                out.add(r);
            }
        }
        return out;
    }
}
