package dao.RolePatient;

import context.DBContext;
import entity.Appointment;
import entity.AppointmentDetailDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Patient Appointment DAO - Handles patient appointment database operations
 * This DAO is specifically for patient functionality to avoid conflicts
 */
public class PatientAppointmentDAO extends DBContext {

    // Get appointment by ID
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

    // Get appointments by patient ID
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM Appointment WHERE patient_id = ? ORDER BY date_time DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setDateTime(rs.getTimestamp("date_time"));
                    appointment.setStatus(rs.getBoolean("status"));
                    appointments.add(appointment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }

    // Create new appointment
    public void createAppointment(Appointment appointment) {
        String sql = "INSERT INTO Appointment (patient_id, doctor_id, date_time, status) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointment.getPatientId());
            ps.setInt(2, appointment.getDoctorId());
              ps.setTimestamp(3, new java.sql.Timestamp(appointment.getDateTime().getTime()));
            ps.setBoolean(4, appointment.isStatus());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Update appointment
    public void updateAppointment(Appointment appointment) {
        String sql = "UPDATE Appointment SET patient_id = ?, doctor_id = ?, date_time = ?, status = ? WHERE appointment_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointment.getPatientId());
            ps.setInt(2, appointment.getDoctorId());
             ps.setTimestamp(3, new java.sql.Timestamp(appointment.getDateTime().getTime()));
            ps.setBoolean(4, appointment.isStatus());
            ps.setInt(5, appointment.getAppointmentId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Delete appointment
    public void deleteAppointment(int appointmentId) {
        String sql = "DELETE FROM Appointment WHERE appointment_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get detailed appointments by user ID (for patient view)
    public List<AppointmentDetailDTO> getDetailedAppointmentsByUserId(int userId) {
        List<AppointmentDetailDTO> appointments = new ArrayList<>();
        String sql = "SELECT " +
                "a.appointment_id, " +
                "a.patient_id, " +
                "a.doctor_id, " +
                "a.date_time, " +
                "a.status, " +
                "p.full_name as patient_full_name, " +
                "p.dob as patient_dob, " +
                "p.address as patient_address, " +
                "p.insurance_info as patient_insurance_info, " +
                "p.parent_id, " +
                "pr.parentname as parent_name, " +
                "pr.id_info as parent_id_info, " +
                "u.username as doctor_name, " +
                "d.specialty as doctor_specialty " +
                "FROM Appointment a " +
                "JOIN Patient p ON a.patient_id = p.patient_id " +
                "LEFT JOIN Parent pr ON p.parent_id = pr.parent_id " +
                "JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                "JOIN [User] u ON d.user_id = u.user_id " +
                "WHERE p.user_id = ? " +
                "ORDER BY a.date_time DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AppointmentDetailDTO dto = new AppointmentDetailDTO();
                    dto.setAppointmentId(rs.getInt("appointment_id"));
                    dto.setPatientId(rs.getInt("patient_id"));
                    dto.setDoctorId(rs.getInt("doctor_id"));
                    dto.setDateTime(rs.getTimestamp("date_time"));
                    dto.setStatus(rs.getBoolean("status"));
                    dto.setPatientFullName(rs.getString("patient_full_name"));
                    dto.setPatientDob(rs.getDate("patient_dob"));
                    dto.setPatientAddress(rs.getString("patient_address"));
                    dto.setPatientInsuranceInfo(rs.getString("patient_insurance_info"));
                    dto.setParentId(rs.getInt("parent_id"));
                    dto.setParentName(rs.getString("parent_name"));
                    dto.setParentIdInfo(rs.getString("parent_id_info"));
                    dto.setDoctorName(rs.getString("doctor_name"));
                    dto.setDoctorSpecialty(rs.getString("doctor_specialty"));
                    appointments.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }

    // Check if appointment exists for a patient at a specific time
    public boolean isAppointmentExists(int patientId, java.sql.Timestamp dateTime) {
        String sql = "SELECT COUNT(*) FROM Appointment WHERE patient_id = ? AND date_time = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ps.setTimestamp(2, dateTime);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get appointment count by patient ID
    public int getAppointmentCountByPatientId(int patientId) {
        String sql = "SELECT COUNT(*) FROM Appointment WHERE patient_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);

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
}
