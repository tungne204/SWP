package dao.Receptionist;

import context.DBContext;
import entity.Receptionist.Appointment;
import entity.Receptionist.Doctor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentDAO extends DBContext {

    private static final Logger logger = Logger.getLogger(AppointmentDAO.class.getName());

    /**
     * true Get appointment by ID_true
     *
     * @param appointmentId
     * @return
     */
    public Appointment getAppointmentById(int id) {
        String sql = """
            SELECT 
                a.appointment_id,
                p.full_name AS patient_name,
                pa.parentname AS parent_name,
                p.address,
                p.insurance_info,
                u_patient.phone,
                u_patient.email,
                u_doctor.username AS doctor_name,
                d.specialty,
                a.date_time,
                a.status
            FROM Appointment a
            JOIN Patient p ON a.patient_id = p.patient_id
            LEFT JOIN Parent pa ON p.parent_id = pa.parent_id
            LEFT JOIN [User] u_patient ON p.user_id = u_patient.user_id
            JOIN Doctor d ON a.doctor_id = d.doctor_id
            JOIN [User] u_doctor ON d.user_id = u_doctor.user_id
            WHERE a.appointment_id = ?
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientName(rs.getString("patient_name"));
                a.setParentName(rs.getString("parent_name"));
                a.setPatientAddress(rs.getString("address"));
                a.setPatientInsurance(rs.getString("insurance_info"));
                a.setParentPhone(rs.getString("phone"));
                a.setPatientEmail(rs.getString("email"));
                a.setDoctorName(rs.getString("doctor_name"));
                a.setDoctorSpecialty(rs.getString("specialty"));
                a.setDateTime(rs.getTimestamp("date_time"));
                a.setStatus(rs.getString("status"));
                return a;
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi lấy appointment ID=" + id, e);
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
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
                a.setStatus(rs.getString("status"));

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
//                a.setDoctorExperienceYears(rs.getString("doctor_experienceYears"));
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
            ps.setString(4, a.getStatus());
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
     * true Delete appointment by ID
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

    public List<Appointment> getAppointments(String keyword, String statusFilter, String sort, int page, int pageSize) {
        List<Appointment> list = new ArrayList<>();
        String sql = """
        SELECT 
            a.appointment_id,
            p.full_name AS patient_name,
            pa.parentname AS parent_name,
            p.address,
            p.insurance_info,
            u_patient.phone,
            u_patient.email,
            u_doctor.username AS doctor_name,
            d.specialty,
            a.date_time,
            a.status
        FROM Appointment a
        JOIN Patient p ON a.patient_id = p.patient_id
        LEFT JOIN Parent pa ON p.parent_id = pa.parent_id
        LEFT JOIN [User] u_patient ON p.user_id = u_patient.user_id
        JOIN Doctor d ON a.doctor_id = d.doctor_id
        JOIN [User] u_doctor ON d.user_id = u_doctor.user_id
        WHERE 1=1
    """;

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (p.full_name LIKE ? OR u_doctor.username LIKE ? OR pa.parentname LIKE ?)";
        }
        if (statusFilter != null && !statusFilter.equals("all")) {
            sql += " AND a.status = ?";
        }
        if (sort != null) {
            if (sort.equals("date_asc")) {
                sql += " ORDER BY a.date_time ASC";
            } else if (sort.equals("today")) {
                sql += " AND CAST(a.date_time AS DATE) = CAST(GETDATE() AS DATE) ORDER BY a.date_time ASC";
            } else {
                sql += " ORDER BY a.date_time DESC";
            }
        } else {
            sql += " ORDER BY a.date_time DESC";
        }

        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (statusFilter != null && !statusFilter.equals("all")) {
                ps.setString(index++, statusFilter);
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientName(rs.getString("patient_name"));
                a.setParentName(rs.getString("parent_name"));
                a.setPatientAddress(rs.getString("address"));
                a.setPatientInsurance(rs.getString("insurance_info"));
                a.setParentPhone(rs.getString("phone"));
                a.setPatientEmail(rs.getString("email"));
                a.setDoctorName(rs.getString("doctor_name"));
                a.setDoctorSpecialty(rs.getString("specialty"));
                a.setDateTime(rs.getTimestamp("date_time"));
                a.setStatus(rs.getString("status"));
                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateStatus(int appointmentId, String newStatus) {
        String sql = "UPDATE Appointment SET status = ? WHERE appointment_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, appointmentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AppointmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * true Get all doctors Get all doctors with username Lấy tất cả bác sĩ
     *
     * @return
     */
    public List<Doctor> getAllDoctors() {
        List<Doctor> list = new ArrayList<>();
        String sql = """
        SELECT d.doctor_id, u.username, d.specialty
        FROM Doctor d
        JOIN [User] u ON d.user_id = u.user_id
        ORDER BY u.username
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Doctor d = new Doctor();
                d.setDoctorId(rs.getInt("doctor_id"));
                d.setUsername(rs.getString("username"));
                d.setSpecialty(rs.getString("specialty"));
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateAppointment(int id, String dateTime, int doctorId, String status) {
        String sql = """
        UPDATE Appointment
        SET date_time = ?, doctor_id = ?, status = ?
        WHERE appointment_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dateTime);
            ps.setInt(2, doctorId);
            ps.setString(3, status);
            ps.setInt(4, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Appointment> getAppointmentsByDoctorId(int doctorId, String keyword, String statusFilter, String sort, int page, int pageSize) {
        List<Appointment> list = new ArrayList<>();
        String sql = """
        SELECT 
            a.appointment_id,
            p.full_name AS patient_name,
            pa.parentname AS parent_name,
            p.address,
            p.insurance_info,
            u_patient.phone,
            u_patient.email,
            u_doctor.username AS doctor_name,
            d.specialty,
            a.date_time,
            a.status
        FROM Appointment a
        JOIN Patient p ON a.patient_id = p.patient_id
        LEFT JOIN Parent pa ON p.parent_id = pa.parent_id
        LEFT JOIN [User] u_patient ON p.user_id = u_patient.user_id
        JOIN Doctor d ON a.doctor_id = d.doctor_id
        JOIN [User] u_doctor ON d.user_id = u_doctor.user_id
        WHERE a.doctor_id = ?
    """;

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (p.full_name LIKE ? OR u_doctor.username LIKE ? OR pa.parentname LIKE ?)";
        }
        if (statusFilter != null && !statusFilter.equals("all")) {
            sql += " AND a.status = ?";
        }
        if (sort != null) {
            if (sort.equals("date_asc")) {
                sql += " ORDER BY a.date_time ASC";
            } else {
                sql += " ORDER BY a.date_time DESC";
            }
        } else {
            sql += " ORDER BY a.date_time DESC";
        }

        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;
            ps.setInt(index++, doctorId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (statusFilter != null && !statusFilter.equals("all")) {
                ps.setString(index++, statusFilter);
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientName(rs.getString("patient_name"));
                a.setParentName(rs.getString("parent_name"));
                a.setPatientAddress(rs.getString("address"));
                a.setPatientInsurance(rs.getString("insurance_info"));
                a.setParentPhone(rs.getString("phone"));
                a.setPatientEmail(rs.getString("email"));
                a.setDoctorName(rs.getString("doctor_name"));
                a.setDoctorSpecialty(rs.getString("specialty"));
                a.setDateTime(rs.getTimestamp("date_time"));
                a.setStatus(rs.getString("status"));
                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Doctor getDoctorByUserId(int userId) {
        Doctor d = null;
        String sql = "SELECT * FROM Doctor WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    d = new Doctor();
                    d.setDoctorId(rs.getInt("doctor_id"));
                    d.setUserId(rs.getInt("user_id"));
                    d.setUsername(rs.getString("name"));
                    d.setSpecialty(rs.getString("specialty"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return d;
    }

    public List<Appointment> getAppointmentsByUserId(int userId, String keyword, String status, String sort, int page, int pageSize) {
        List<Appointment> list = new ArrayList<>();
        String sql = """
        SELECT a.*, p.full_name AS patientName, d.name AS doctorName, d.specialty AS doctorSpecialty
        FROM Appointment a
        JOIN Patient p ON a.patient_id = p.patient_id
        JOIN Doctor d ON a.doctor_id = d.doctor_id
        JOIN [User] u ON p.user_id = u.user_id
        WHERE u.user_id = ?
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientName(rs.getString("patientName"));
                a.setDoctorName(rs.getString("doctorName"));
                a.setDoctorSpecialty(rs.getString("doctorSpecialty"));
                a.setDateTime(rs.getTimestamp("date_time"));
                a.setStatus(rs.getString("status"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
