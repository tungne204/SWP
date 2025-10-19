package dao;

import context.DBContext;
import entity.Appointment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO extends DBContext {

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

    // Get appointments by doctor ID
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM Appointment WHERE doctor_id = ? ORDER BY date_time DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);

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

    // Get appointments by date range
    public List<Appointment> getAppointmentsByDateRange(java.util.Date startDate, java.util.Date endDate) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM Appointment WHERE date_time BETWEEN ? AND ? ORDER BY date_time ASC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, new java.sql.Timestamp(startDate.getTime()));
            ps.setTimestamp(2, new java.sql.Timestamp(endDate.getTime()));

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

    // Create a new appointment
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

    // Update appointment status
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

    // Update appointment date and time
    public void updateAppointmentDateTime(int appointmentId, java.util.Date dateTime) {
        String sql = "UPDATE Appointment SET date_time = ? WHERE appointment_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, new java.sql.Timestamp(dateTime.getTime()));
            ps.setInt(2, appointmentId);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointment";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setDateTime(rs.getTimestamp("date_time"));
                a.setStatus(rs.getBoolean("status"));
                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Update appointment details (patient, doctor, date_time)
     *
     * @param appointment
     * @throws Exception
     */
    public void updateAppointment(Appointment a) throws Exception {
        String sql = "UPDATE Appointment SET patient_id = ?, doctor_id = ?, date_time = ?, status = ? WHERE appointment_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, a.getPatientId());
            ps.setInt(2, a.getDoctorId());
            ps.setTimestamp(3, new java.sql.Timestamp(a.getDateTime().getTime()));
            ps.setBoolean(4, a.isStatus());
            ps.setInt(5, a.getAppointmentId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
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
    public List<Appointment> getAllByDoctorId(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.patient_id, a.doctor_id, a.date_time, a.status, " +
                    "p.full_name as patient_name, p.dob as patient_dob, " +
                    "p.address as patient_address, p.insurance_info, " +
                    "pa.parentname as parent_name, " +
                    "u.username as doctor_name, d.specialty as doctor_specialty, " +
                    "mr.record_id, mr.diagnosis " +
                    "FROM Appointment a " +
                    "JOIN Patient p ON a.patient_id = p.patient_id " +
                    "LEFT JOIN Parent pa ON p.parent_id = pa.parent_id " +
                    "JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                    "JOIN [User] u ON d.user_id = u.user_id " +
                    "LEFT JOIN MedicalReport mr ON a.appointment_id = mr.appointment_id " +
                    "WHERE a.doctor_id = ? " +
                    "ORDER BY a.date_time DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment apt = new Appointment();
                apt.setAppointmentId(rs.getInt("appointment_id"));
                apt.setPatientId(rs.getInt("patient_id"));
                apt.setDoctorId(rs.getInt("doctor_id"));
                apt.setDateTime(rs.getTimestamp("date_time"));
                apt.setStatus(rs.getBoolean("status"));
                
                apt.setPatientName(rs.getString("patient_name"));
                apt.setPatientDob(rs.getString("patient_dob"));
                apt.setPatientAddress(rs.getString("patient_address"));
                apt.setPatientInsurance(rs.getString("insurance_info"));
                apt.setParentName(rs.getString("parent_name"));
                apt.setDoctorName(rs.getString("doctor_name"));
                apt.setDoctorSpecialty(rs.getString("doctor_specialty"));
                
                // Check medical report
                int recordId = rs.getInt("record_id");
                apt.setHasMedicalReport(!rs.wasNull());
                apt.setRecordId(rs.wasNull() ? null : recordId);
                apt.setDiagnosis(rs.getString("diagnosis"));
                
                list.add(apt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy appointments theo ngày
    public List<Appointment> getByDoctorAndDate(int doctorId, String date) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.patient_id, a.doctor_id, a.date_time, a.status, " +
                    "p.full_name as patient_name, p.dob as patient_dob, " +
                    "p.address as patient_address, p.insurance_info, " +
                    "pa.parentname as parent_name, " +
                    "u.username as doctor_name, d.specialty as doctor_specialty, " +
                    "mr.record_id, mr.diagnosis " +
                    "FROM Appointment a " +
                    "JOIN Patient p ON a.patient_id = p.patient_id " +
                    "LEFT JOIN Parent pa ON p.parent_id = pa.parent_id " +
                    "JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                    "JOIN [User] u ON d.user_id = u.user_id " +
                    "LEFT JOIN MedicalReport mr ON a.appointment_id = mr.appointment_id " +
                    "WHERE a.doctor_id = ? AND CAST(a.date_time AS DATE) = ? " +
                    "ORDER BY a.date_time ASC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment apt = new Appointment();
                apt.setAppointmentId(rs.getInt("appointment_id"));
                apt.setPatientId(rs.getInt("patient_id"));
                apt.setDoctorId(rs.getInt("doctor_id"));
                apt.setDateTime(rs.getTimestamp("date_time"));
                apt.setStatus(rs.getBoolean("status"));
                
                apt.setPatientName(rs.getString("patient_name"));
                apt.setPatientDob(rs.getString("patient_dob"));
                apt.setPatientAddress(rs.getString("patient_address"));
                apt.setPatientInsurance(rs.getString("insurance_info"));
                apt.setParentName(rs.getString("parent_name"));
                apt.setDoctorName(rs.getString("doctor_name"));
                apt.setDoctorSpecialty(rs.getString("doctor_specialty"));
                
                int recordId = rs.getInt("record_id");
                apt.setHasMedicalReport(!rs.wasNull());
                apt.setRecordId(rs.wasNull() ? null : recordId);
                apt.setDiagnosis(rs.getString("diagnosis"));
                
                list.add(apt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy appointment theo ID
    public Appointment getById(int appointmentId) {
        String sql = "SELECT a.appointment_id, a.patient_id, a.doctor_id, a.date_time, a.status, " +
                    "p.full_name as patient_name, p.dob as patient_dob, " +
                    "p.address as patient_address, p.insurance_info, " +
                    "pa.parentname as parent_name, " +
                    "u.username as doctor_name, d.specialty as doctor_specialty, " +
                    "mr.record_id, mr.diagnosis " +
                    "FROM Appointment a " +
                    "JOIN Patient p ON a.patient_id = p.patient_id " +
                    "LEFT JOIN Parent pa ON p.parent_id = pa.parent_id " +
                    "JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                    "JOIN [User] u ON d.user_id = u.user_id " +
                    "LEFT JOIN MedicalReport mr ON a.appointment_id = mr.appointment_id " +
                    "WHERE a.appointment_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Appointment apt = new Appointment();
                apt.setAppointmentId(rs.getInt("appointment_id"));
                apt.setPatientId(rs.getInt("patient_id"));
                apt.setDoctorId(rs.getInt("doctor_id"));
                apt.setDateTime(rs.getTimestamp("date_time"));
                apt.setStatus(rs.getBoolean("status"));
                
                apt.setPatientName(rs.getString("patient_name"));
                apt.setPatientDob(rs.getString("patient_dob"));
                apt.setPatientAddress(rs.getString("patient_address"));
                apt.setPatientInsurance(rs.getString("insurance_info"));
                apt.setParentName(rs.getString("parent_name"));
                apt.setDoctorName(rs.getString("doctor_name"));
                apt.setDoctorSpecialty(rs.getString("doctor_specialty"));
                
                int recordId = rs.getInt("record_id");
                apt.setHasMedicalReport(!rs.wasNull());
                apt.setRecordId(rs.wasNull() ? null : recordId);
                apt.setDiagnosis(rs.getString("diagnosis"));
                
                return apt;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Đếm appointments theo ngày
    public int countByDoctorAndDate(int doctorId, String date) {
        String sql = "SELECT COUNT(*) as total FROM Appointment " +
                    "WHERE doctor_id = ? AND CAST(date_time AS DATE) = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy appointments chưa khám (chưa có medical report)
    public List<Appointment> getPendingByDoctorId(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.patient_id, a.doctor_id, a.date_time, a.status, " +
                    "p.full_name as patient_name, p.dob as patient_dob, " +
                    "p.address as patient_address, p.insurance_info, " +
                    "pa.parentname as parent_name, " +
                    "u.username as doctor_name, d.specialty as doctor_specialty " +
                    "FROM Appointment a " +
                    "JOIN Patient p ON a.patient_id = p.patient_id " +
                    "LEFT JOIN Parent pa ON p.parent_id = pa.parent_id " +
                    "JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                    "JOIN [User] u ON d.user_id = u.user_id " +
                    "WHERE a.doctor_id = ? AND a.status = 1 " +
                    "AND NOT EXISTS (SELECT 1 FROM MedicalReport mr WHERE mr.appointment_id = a.appointment_id) " +
                    "ORDER BY a.date_time ASC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment apt = new Appointment();
                apt.setAppointmentId(rs.getInt("appointment_id"));
                apt.setPatientId(rs.getInt("patient_id"));
                apt.setDoctorId(rs.getInt("doctor_id"));
                apt.setDateTime(rs.getTimestamp("date_time"));
                apt.setStatus(rs.getBoolean("status"));
                
                apt.setPatientName(rs.getString("patient_name"));
                apt.setPatientDob(rs.getString("patient_dob"));
                apt.setPatientAddress(rs.getString("patient_address"));
                apt.setPatientInsurance(rs.getString("insurance_info"));
                apt.setParentName(rs.getString("parent_name"));
                apt.setDoctorName(rs.getString("doctor_name"));
                apt.setDoctorSpecialty(rs.getString("doctor_specialty"));
                
                apt.setHasMedicalReport(false);
                
                list.add(apt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
