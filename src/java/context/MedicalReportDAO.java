/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package context;


import entity.MedicalReport;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicalReportDAO extends DBContext{
       public List<MedicalReport> getAllByDoctorId(int doctorId) {
        List<MedicalReport> list = new ArrayList<>();
        String sql = "SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, " +
                    "mr.test_request, p.full_name as patient_name, u.username as doctor_name, " +
                    "a.date_time as appointment_date " +
                    "FROM MedicalReport mr " +
                    "JOIN Appointment a ON mr.appointment_id = a.appointment_id " +
                    "JOIN Patient p ON a.patient_id = p.patient_id " +
                    "JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                    "JOIN [User] u ON d.user_id = u.user_id " +
                    "WHERE d.doctor_id = ? " +
                    "ORDER BY a.date_time DESC";
        
        try (
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
    public MedicalReport getById(int recordId) {
        String sql = "SELECT mr.record_id, mr.appointment_id, mr.diagnosis, mr.prescription, " +
                    "mr.test_request, p.full_name as patient_name, u.username as doctor_name, " +
                    "a.date_time as appointment_date " +
                    "FROM MedicalReport mr " +
                    "JOIN Appointment a ON mr.appointment_id = a.appointment_id " +
                    "JOIN Patient p ON a.patient_id = p.patient_id " +
                    "JOIN Doctor d ON a.doctor_id = d.doctor_id " +
                    "JOIN [User] u ON d.user_id = u.user_id " +
                    "WHERE mr.record_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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

    // Lấy appointments chưa có medical report của doctor
    public List<Appointment> getAppointmentsWithoutReport(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, p.full_name, a.date_time " +
                    "FROM Appointment a " +
                    "JOIN Patient p ON a.patient_id = p.patient_id " +
                    "WHERE a.doctor_id = ? AND a.status = 1 " +
                    "AND NOT EXISTS (SELECT 1 FROM MedicalReport mr WHERE mr.appointment_id = a.appointment_id) " +
                    "ORDER BY a.date_time DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
    public boolean insert(MedicalReport mr) {
        String sql = "INSERT INTO MedicalReport (appointment_id, diagnosis, prescription, test_request) " +
                    "VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
    public boolean update(MedicalReport mr) {
        String sql = "UPDATE MedicalReport SET diagnosis = ?, prescription = ?, test_request = ? " +
                    "WHERE record_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
    public boolean delete(int recordId) {
        String sql = "DELETE FROM MedicalReport WHERE record_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
