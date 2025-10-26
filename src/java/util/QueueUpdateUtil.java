package util;

import entity.Patient;
import entity.Parent;
import entity.PatientQueue;

/**
 * Utility class for creating JSON updates for patient queue WebSocket
 */
public class QueueUpdateUtil {
    
    /**
     * Escape special characters for JSON string values
     */
    private static String escapeJson(String value) {
        if (value == null) return "null";
        return "\"" + value.replace("\\", "\\\\")
                          .replace("\"", "\\\"")
                          .replace("\n", "\\n")
                          .replace("\r", "\\r")
                          .replace("\t", "\\t") + "\"";
    }
    
    /**
     * Create JSON string for patient queue data (without parent)
     * @param patient Patient information
     * @param patientQueue Queue information
     * @return JSON string representation
     */
    public static String createPatientQueueJson(Patient patient, PatientQueue patientQueue) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        
        // Patient data
        json.append("\"patient\":{");
        json.append("\"patientId\":").append(patient.getPatientId()).append(",");
        json.append("\"fullName\":").append(escapeJson(patient.getFullName())).append(",");
        json.append("\"phoneNumber\":").append(escapeJson(patient.getPhone())).append(",");
        json.append("\"dateOfBirth\":").append(escapeJson(patient.getDob() != null ? patient.getDob().toString() : null));
        json.append("},");
        
        // Queue data
        json.append("\"queue\":{");
        json.append("\"queueId\":").append(patientQueue.getQueueId()).append(",");
        json.append("\"patientId\":").append(patientQueue.getPatientId()).append(",");
        json.append("\"status\":").append(escapeJson(patientQueue.getStatus())).append(",");
        json.append("\"checkInTime\":").append(escapeJson(patientQueue.getCheckInTime() != null ? patientQueue.getCheckInTime().toString() : null)).append(",");
        json.append("\"queueNumber\":").append(patientQueue.getQueueNumber());
        json.append("}");
        
        json.append("}");
        return json.toString();
    }
    
    /**
     * Create JSON string for patient queue data (with parent)
     * @param patient Patient information
     * @param patientQueue Queue information
     * @param parent Parent information (can be null)
     * @return JSON string representation
     */
    public static String createPatientQueueJson(Patient patient, PatientQueue patientQueue, Parent parent) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        
        // Patient data
        json.append("\"patient\":{");
        json.append("\"patientId\":").append(patient.getPatientId()).append(",");
        json.append("\"fullName\":").append(escapeJson(patient.getFullName())).append(",");
        json.append("\"phoneNumber\":").append(escapeJson(patient.getPhone())).append(",");
        json.append("\"dateOfBirth\":").append(escapeJson(patient.getDob() != null ? patient.getDob().toString() : null));
        json.append("},");
        
        // Queue data
        json.append("\"queue\":{");
        json.append("\"queueId\":").append(patientQueue.getQueueId()).append(",");
        json.append("\"patientId\":").append(patientQueue.getPatientId()).append(",");
        json.append("\"status\":").append(escapeJson(patientQueue.getStatus())).append(",");
        json.append("\"checkInTime\":").append(escapeJson(patientQueue.getCheckInTime() != null ? patientQueue.getCheckInTime().toString() : null)).append(",");
        json.append("\"queueNumber\":").append(patientQueue.getQueueNumber());
        json.append("}");
        
        // Parent data (if provided)
        if (parent != null) {
            json.append(",\"parent\":{");
            json.append("\"parentId\":").append(parent.getParentId()).append(",");
            json.append("\"parentName\":").append(escapeJson(parent.getParentname())).append(",");
            json.append("\"idInfo\":").append(escapeJson(parent.getIdInfo()));
            json.append("}");
        }
        
        json.append("}");
        return json.toString();
    }
    
    /**
     * Create JSON string for simple queue update
     * @param queueId Queue ID
     * @param status New status
     * @return JSON string representation
     */
    public static String createQueueStatusJson(int queueId, String status) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"queueId\":").append(queueId).append(",");
        json.append("\"status\":").append(escapeJson(status)).append(",");
        json.append("\"timestamp\":").append(System.currentTimeMillis());
        json.append("}");
        return json.toString();
    }
}