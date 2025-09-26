/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Quang Anh
 */
import context.DBConnection;
import entity.Appointment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.date_time, a.status,
                   p.full_name, u.phone, u.email
            FROM Appointment a
            INNER JOIN Patient p ON a.patient_id = p.patient_id
            INNER JOIN [User] u ON p.user_id = u.user_id
            WHERE a.doctor_id = ?
            ORDER BY a.date_time ASC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setDateTime(rs.getTimestamp("date_time"));
                appointment.setStatus(rs.getBoolean("status"));
                appointment.setPatientName(rs.getString("full_name"));
                appointment.setPatientPhone(rs.getString("phone"));
                appointment.setPatientEmail(rs.getString("email"));
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return appointments;
    }
    
    public List<Appointment> getAppointmentsByDoctorIdAndDate(int doctorId, Date date) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.date_time, a.status,
                   p.full_name, u.phone, u.email
            FROM Appointment a
            INNER JOIN Patient p ON a.patient_id = p.patient_id
            INNER JOIN [User] u ON p.user_id = u.user_id
            WHERE a.doctor_id = ? AND CAST(a.date_time AS DATE) = ?
            ORDER BY a.date_time ASC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setDate(2, date);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setDateTime(rs.getTimestamp("date_time"));
                appointment.setStatus(rs.getBoolean("status"));
                appointment.setPatientName(rs.getString("full_name"));
                appointment.setPatientPhone(rs.getString("phone"));
                appointment.setPatientEmail(rs.getString("email"));
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return appointments;
    }
    
    public List<Appointment> getAppointmentsByDoctorIdAndDateRange(int doctorId, Date fromDate, Date toDate) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.date_time, a.status,
                   p.full_name, u.phone, u.email
            FROM Appointment a
            INNER JOIN Patient p ON a.patient_id = p.patient_id
            INNER JOIN [User] u ON p.user_id = u.user_id
            WHERE a.doctor_id = ? AND CAST(a.date_time AS DATE) BETWEEN ? AND ?
            ORDER BY a.date_time ASC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setDate(2, fromDate);
            ps.setDate(3, toDate);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setDateTime(rs.getTimestamp("date_time"));
                appointment.setStatus(rs.getBoolean("status"));
                appointment.setPatientName(rs.getString("full_name"));
                appointment.setPatientPhone(rs.getString("phone"));
                appointment.setPatientEmail(rs.getString("email"));
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return appointments;
    }
}