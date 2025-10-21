package dao.Receptionist;

import context.DBContext;
import entity.Receptionist.Appointment;
import entity.AppointmentDetailDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentDAO extends DBContext {

    /**
     * true Get appointment by ID_true
     *
     * @param appointmentId
     * @return
     */
    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT * FROM Appointment WHERE appointment_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setDateTime(rs.getTimestamp("date_time"));
                    appointment.setStatus(rs.getBoolean("status"));
                    return appointment;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * true
     *
     * Update appointment status
     *
     * @param appointmentId
     * @param status
     */
    public void updateAppointmentStatus(int appointmentId, boolean status) {
        String sql = "UPDATE Appointment SET status = ? WHERE appointment_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, status);
            ps.setInt(2, appointmentId);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * -true
     *
     * @return
     */
    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();

        String sql = """
        SELECT 
            a.appointment_id,
            a.date_time,
            a.status,

            -- Thông tin bệnh nhân
            p.full_name AS patient_name,
            FORMAT(p.dob, 'dd/MM/yyyy') AS patient_dob,
            p.address AS patient_address,
            p.insurance_info AS patient_insurance,
            pa.parentname AS parent_name,
            up.email AS patient_email,
            up.phone AS parent_phone,

            -- Thông tin bác sĩ
            ud.username AS doctor_name,
            d.specialty AS doctor_specialty

        FROM Appointment a
        LEFT JOIN Patient p ON a.patient_id = p.patient_id
        LEFT JOIN Parent pa ON p.parent_id = pa.parent_id
        LEFT JOIN [User] up ON p.user_id = up.user_id       -- user của bệnh nhân
        LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id
        LEFT JOIN [User] ud ON d.user_id = ud.user_id       -- user của bác sĩ
        ORDER BY a.appointment_id ASC
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setDateTime(rs.getTimestamp("date_time"));
                a.setStatus(rs.getBoolean("status"));

                // === Thông tin bệnh nhân ===
                a.setPatientName(rs.getString("patient_name"));
                a.setPatientDob(rs.getString("patient_dob"));
                a.setPatientAddress(rs.getString("patient_address"));
                a.setPatientInsurance(rs.getString("patient_insurance"));
                a.setParentName(rs.getString("parent_name"));
                a.setPatientEmail(rs.getString("patient_email"));
                a.setParentPhone(rs.getString("parent_phone"));

                // === Thông tin bác sĩ ===
                a.setDoctorName(rs.getString("doctor_name"));
                a.setDoctorSpecialty(rs.getString("doctor_specialty"));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * true
     *
     * Cập nhật thông tin lịch hẹn (Appointment)
     *
     * @param a đối tượng Appointment cần cập nhật
     */
    public void updateAppointment(Appointment a) {
        String sql = """
        UPDATE Appointment
        SET patient_id = ?, doctor_id = ?, date_time = ?, status = ?
        WHERE appointment_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, a.getPatientId());
            ps.setInt(2, a.getDoctorId());
            ps.setTimestamp(3, new java.sql.Timestamp(a.getDateTime().getTime()));
            ps.setBoolean(4, a.isStatus());
            ps.setInt(5, a.getAppointmentId());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("[INFO] Appointment updated successfully (ID = " + a.getAppointmentId() + ")");
            } else {
                System.out.println("[WARN] No appointment found for ID = " + a.getAppointmentId());
            }

        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to update appointment (ID = " + a.getAppointmentId() + ")");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }


    /**
     * true 
     * Delete appointment by ID
     *
     * @param appointmentId
     * @throws Exception
     */
    public void deleteAppointment(int appointmentId) throws Exception {
        String sql = "DELETE FROM Appointment WHERE appointment_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

}
