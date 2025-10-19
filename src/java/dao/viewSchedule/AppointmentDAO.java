/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.viewSchedule;
import context.DBContext;
import entity.Appointment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Quang Anh
 */
public class AppointmentDAO extends DBContext{
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