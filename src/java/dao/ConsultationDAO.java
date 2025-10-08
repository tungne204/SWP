package dao;

import context.DBContext;
import entity.Consultation;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ConsultationDAO extends DBContext {

    // Create a new consultation
    public void createConsultation(Consultation consultation) throws Exception {
        String sql = "INSERT INTO Consultation (patient_id, doctor_id, queue_id, start_time, end_time, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, consultation.getPatientId());
            ps.setInt(2, consultation.getDoctorId());
            ps.setInt(3, consultation.getQueueId());
            ps.setTimestamp(4, consultation.getStartTime() != null ? new java.sql.Timestamp(consultation.getStartTime().getTime()) : null);
            ps.setTimestamp(5, consultation.getEndTime() != null ? new java.sql.Timestamp(consultation.getEndTime().getTime()) : null);
            ps.setString(6, consultation.getStatus());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update consultation status
    public void updateConsultationStatus(int consultationId, String status) throws Exception {
        String sql = "UPDATE Consultation SET status = ? WHERE consultation_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, consultationId);
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update consultation end time
    public void updateConsultationEndTime(int consultationId, java.util.Date endTime) {
        String sql = "UPDATE Consultation SET end_time = ?, status = 'Completed' WHERE consultation_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setTimestamp(1, new java.sql.Timestamp(endTime.getTime()));
            ps.setInt(2, consultationId);
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get consultation by ID
    public Consultation getConsultationById(int consultationId) {
        String sql = "SELECT * FROM Consultation WHERE consultation_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, consultationId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Consultation consultation = new Consultation();
                    consultation.setConsultationId(rs.getInt("consultation_id"));
                    consultation.setPatientId(rs.getInt("patient_id"));
                    consultation.setDoctorId(rs.getInt("doctor_id"));
                    consultation.setQueueId(rs.getInt("queue_id"));
                    consultation.setStartTime(rs.getTimestamp("start_time"));
                    consultation.setEndTime(rs.getTimestamp("end_time"));
                    consultation.setStatus(rs.getString("status"));
                    return consultation;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get consultations by doctor ID
    public List<Consultation> getConsultationsByDoctorId(int doctorId) {
        List<Consultation> consultations = new ArrayList<>();
        String sql = "SELECT * FROM Consultation WHERE doctor_id = ? ORDER BY start_time DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Consultation consultation = new Consultation();
                    consultation.setConsultationId(rs.getInt("consultation_id"));
                    consultation.setPatientId(rs.getInt("patient_id"));
                    consultation.setDoctorId(rs.getInt("doctor_id"));
                    consultation.setQueueId(rs.getInt("queue_id"));
                    consultation.setStartTime(rs.getTimestamp("start_time"));
                    consultation.setEndTime(rs.getTimestamp("end_time"));
                    consultation.setStatus(rs.getString("status"));
                    consultations.add(consultation);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return consultations;
    }

    // Get consultations by patient ID
    public List<Consultation> getConsultationsByPatientId(int patientId) {
        List<Consultation> consultations = new ArrayList<>();
        String sql = "SELECT * FROM Consultation WHERE patient_id = ? ORDER BY start_time DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Consultation consultation = new Consultation();
                    consultation.setConsultationId(rs.getInt("consultation_id"));
                    consultation.setPatientId(rs.getInt("patient_id"));
                    consultation.setDoctorId(rs.getInt("doctor_id"));
                    consultation.setQueueId(rs.getInt("queue_id"));
                    consultation.setStartTime(rs.getTimestamp("start_time"));
                    consultation.setEndTime(rs.getTimestamp("end_time"));
                    consultation.setStatus(rs.getString("status"));
                    consultations.add(consultation);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return consultations;
    }

    // Get consultations by status
    public List<Consultation> getConsultationsByStatus(String status) {
        List<Consultation> consultations = new ArrayList<>();
        String sql = "SELECT * FROM Consultation WHERE status = ? ORDER BY start_time DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Consultation consultation = new Consultation();
                    consultation.setConsultationId(rs.getInt("consultation_id"));
                    consultation.setPatientId(rs.getInt("patient_id"));
                    consultation.setDoctorId(rs.getInt("doctor_id"));
                    consultation.setQueueId(rs.getInt("queue_id"));
                    consultation.setStartTime(rs.getTimestamp("start_time"));
                    consultation.setEndTime(rs.getTimestamp("end_time"));
                    consultation.setStatus(rs.getString("status"));
                    consultations.add(consultation);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return consultations;
    }
}