package dao;

import context.DBContext;
import entity.PatientQueue;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PatientQueueDAO extends DBContext {

    // Get all patients in queue ordered by priority and check-in time
    public List<PatientQueue> getAllPatientsInQueue() {
        List<PatientQueue> queue = new ArrayList<>();
        String sql = "SELECT * FROM PatientQueue ORDER BY priority DESC, check_in_time ASC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                PatientQueue patientQueue = new PatientQueue();
                patientQueue.setQueueId(rs.getInt("queue_id"));
                patientQueue.setPatientId(rs.getInt("patient_id"));
                patientQueue.setAppointmentId(rs.getObject("appointment_id", Integer.class));
                patientQueue.setQueueNumber(rs.getInt("queue_number"));
                patientQueue.setQueueType(rs.getString("queue_type"));
                patientQueue.setStatus(rs.getString("status"));
                patientQueue.setPriority(rs.getInt("priority"));
                patientQueue.setCheckInTime(rs.getTimestamp("check_in_time"));
                patientQueue.setUpdatedTime(rs.getTimestamp("updated_time"));
                queue.add(patientQueue);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return queue;
    }

    // Get patients by status
    public List<PatientQueue> getPatientsByStatus(String status) {
        List<PatientQueue> queue = new ArrayList<>();
        String sql = "SELECT * FROM PatientQueue WHERE status = ? ORDER BY priority DESC, check_in_time ASC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PatientQueue patientQueue = new PatientQueue();
                    patientQueue.setQueueId(rs.getInt("queue_id"));
                    patientQueue.setPatientId(rs.getInt("patient_id"));
                    patientQueue.setAppointmentId(rs.getObject("appointment_id", Integer.class));
                    patientQueue.setQueueNumber(rs.getInt("queue_number"));
                    patientQueue.setQueueType(rs.getString("queue_type"));
                    patientQueue.setStatus(rs.getString("status"));
                    patientQueue.setPriority(rs.getInt("priority"));
                    patientQueue.setCheckInTime(rs.getTimestamp("check_in_time"));
                    patientQueue.setUpdatedTime(rs.getTimestamp("updated_time"));
                    queue.add(patientQueue);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return queue;
    }

    // Add patient to queue
    public void addPatientToQueue(PatientQueue patientQueue) {
        String sql = "INSERT INTO PatientQueue (patient_id, appointment_id, queue_number, queue_type, status, priority, check_in_time, updated_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientQueue.getPatientId());
            ps.setObject(2, patientQueue.getAppointmentId(), java.sql.Types.INTEGER);
            ps.setInt(3, patientQueue.getQueueNumber());
            ps.setString(4, patientQueue.getQueueType());
            ps.setString(5, patientQueue.getStatus());
            ps.setInt(6, patientQueue.getPriority());
            ps.setTimestamp(7, new java.sql.Timestamp(patientQueue.getCheckInTime().getTime()));
            ps.setTimestamp(8, new java.sql.Timestamp(patientQueue.getUpdatedTime().getTime()));
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Update patient queue status
    public void updatePatientQueueStatus(int queueId, String status) {
        String sql = "UPDATE PatientQueue SET status = ?, updated_time = GETDATE() WHERE queue_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, queueId);
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Update patient queue priority
    public void updatePatientQueuePriority(int queueId, int priority) {
        String sql = "UPDATE PatientQueue SET priority = ?, updated_time = GETDATE() WHERE queue_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, priority);
            ps.setInt(2, queueId);
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Remove patient from queue
    public void removePatientFromQueue(int queueId) {
        String sql = "DELETE FROM PatientQueue WHERE queue_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, queueId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get patient queue by ID
    public PatientQueue getPatientQueueById(int queueId) {
        String sql = "SELECT * FROM PatientQueue WHERE queue_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, queueId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PatientQueue patientQueue = new PatientQueue();
                    patientQueue.setQueueId(rs.getInt("queue_id"));
                    patientQueue.setPatientId(rs.getInt("patient_id"));
                    patientQueue.setAppointmentId(rs.getObject("appointment_id", Integer.class));
                    patientQueue.setQueueNumber(rs.getInt("queue_number"));
                    patientQueue.setQueueType(rs.getString("queue_type"));
                    patientQueue.setStatus(rs.getString("status"));
                    patientQueue.setPriority(rs.getInt("priority"));
                    patientQueue.setCheckInTime(rs.getTimestamp("check_in_time"));
                    patientQueue.setUpdatedTime(rs.getTimestamp("updated_time"));
                    return patientQueue;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}