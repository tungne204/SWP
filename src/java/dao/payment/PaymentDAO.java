/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.payment;

/**
 *
 * @author Quang Anh
 */
import entity.payment.Payment;
import java.sql.*;

public class PaymentDAO {
    private final Connection conn;
    public PaymentDAO(Connection conn){ this.conn = conn; }

    public Payment createPending(int appointmentId, String orderInfo, long amountVnd,
                                 String vnpTxnRef, String payUrl) throws SQLException {
        String sql = "INSERT INTO dbo.Payment(appointment_id, discount_id, amount, method, status, payment_date, " +
                "vnp_txn_ref, order_info, pay_url) " +
                "VALUES (?, NULL, ?, N'VNPAY', 0, NULL, ?, ?, ?);" +
                "SELECT SCOPE_IDENTITY() AS new_id;";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ps.setBigDecimal(2, new java.math.BigDecimal(amountVnd));
            ps.setString(3, vnpTxnRef);
            ps.setString(4, orderInfo);
            ps.setString(5, payUrl);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    Payment p = new Payment();
                    p.setPaymentId(id);
                    p.setAppointmentId(appointmentId);
                    p.setAmount(amountVnd);
                    p.setVnpTxnRef(vnpTxnRef);
                    p.setOrderInfo(orderInfo);
                    p.setPayUrl(payUrl);
                    p.setStatus(false);
                    return p;
                }
            }
        }
        throw new SQLException("Create pending payment failed");
    }

    public void markPaid(String vnpTxnRef, String vnpTransactionNo, String bankCode, String cardType) throws SQLException {
        String sql = "UPDATE dbo.Payment SET status = 1, paid_at = GETDATE(), payment_date = CAST(GETDATE() AS date), " +
                "vnp_transactionno = ?, vnp_bankcode = ?, vnp_cardtype = ? WHERE vnp_txn_ref = ?;";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vnpTransactionNo);
            ps.setString(2, bankCode);
            ps.setString(3, cardType);
            ps.setString(4, vnpTxnRef);
            ps.executeUpdate();
        }
    }

    public boolean existsByTxnRef(String vnpTxnRef) throws SQLException {
        String sql = "SELECT 1 FROM dbo.Payment WHERE vnp_txn_ref = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vnpTxnRef);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    /** Map record_id -> appointment_id (trả -1 nếu không thấy) */
    public int findAppointmentIdByRecordId(int recordId) throws SQLException {
        String sql = "SELECT appointment_id FROM dbo.MedicalReport WHERE record_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recordId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    /** Lấy tên bệnh nhân và đơn thuốc từ appointment_id */
    public static class PatientInfo {
        public String patientName;
        public String prescription;
    }

    public PatientInfo getPatientInfoByAppointmentId(int appointmentId) throws SQLException {
        String sql = "SELECT p.full_name AS patient_name, mr.prescription " +
                     "FROM dbo.Appointment a " +
                     "INNER JOIN dbo.Patient p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN dbo.MedicalReport mr ON a.appointment_id = mr.appointment_id " +
                     "WHERE a.appointment_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PatientInfo info = new PatientInfo();
                    info.patientName = rs.getString("patient_name");
                    info.prescription = rs.getString("prescription");
                    return info;
                }
            }
        }
        return null;
    }
}
