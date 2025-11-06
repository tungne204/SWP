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
        String sql = """
        SELECT a.*
        FROM Appointment a
        JOIN Doctor d ON a.doctor_id = d.doctor_id
        WHERE d.user_id = ? AND a.status = ?
        ORDER BY CASE WHEN a.status = 'Waiting' THEN 0 ELSE 1 END, a.date_time DESC
    """;
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
                    list.add(apt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả appointments theo status
    public List<Appointment> getAppointmentsByStatus(String status) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointment WHERE status = ? ORDER BY date_time DESC";

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
        String sql = "SELECT * FROM Appointment WHERE doctor_id = ? AND status = ? "
                + "ORDER BY CASE WHEN status = 'Waiting' THEN 0 ELSE 1 END, date_time DESC";

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
        String sql = "SELECT * FROM Appointment WHERE appointment_id = ?";

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
        String sql = "UPDATE Appointment SET status = ? WHERE appointment_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, appointmentId);
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
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointment WHERE patient_id = ? "
                + "ORDER BY date_time DESC";

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
}
