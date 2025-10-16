package util;

import entity.Patient;
import entity.PatientQueue;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Utility class for creating JSON messages for WebSocket queue updates
 */
public class QueueUpdateUtil {
    
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    
    /**
     * Create JSON representation of a patient queue entry
     * @param patient The patient object
     * @param queue The queue object
     * @return JSON string representation
     */
    public static String createPatientQueueJson(Patient patient, PatientQueue queue) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        
        // Patient information
        json.append("\"patient\":{");
        json.append("\"id\":").append(patient.getPatientId()).append(",");
        json.append("\"fullName\":\"").append(escapeJson(patient.getFullName())).append("\",");
        json.append("\"address\":\"").append(escapeJson(patient.getAddress())).append("\"");
        json.append("},");
        
        // Queue information
        json.append("\"queue\":{");
        json.append("\"queueId\":").append(queue.getQueueId()).append(",");
        json.append("\"status\":\"").append(escapeJson(queue.getStatus())).append("\",");
        json.append("\"queueType\":\"").append(escapeJson(queue.getQueueType())).append("\",");
        json.append("\"roomNumber\":\"").append(escapeJson(queue.getRoomNumber())).append("\",");
        json.append("\"checkInTime\":\"").append(dateFormat.format(queue.getCheckInTime())).append("\",");
        json.append("\"priority\":").append(queue.getPriority());
        json.append("}");
        
        json.append("}");
        return json.toString();
    }
    
    /**
     * Create a simple status update JSON
     * @param queueId The queue ID
     * @param newStatus The new status
     * @return JSON string representation
     */
    public static String createStatusUpdateJson(int queueId, String newStatus) {
        return String.format(
            "{\"queueId\":%d,\"status:\"%s\",\"timestamp\":\"%s\"}",
            queueId, escapeJson(newStatus), dateFormat.format(new Date())
        );
    }
    
    /**
     * Create a queue statistics JSON
     * @param waitingCount Number of waiting patients
     * @param consultingCount Number of patients in consultation
     * @param totalCount Total number of patients
     * @return JSON string representation
     */
    public static String createStatsJson(int waitingCount, int consultingCount, int totalCount) {
        return String.format(
            "{\"stats\":{\"waiting\":%d,\"consulting\":%d,\"total\":%d}}",
            waitingCount, consultingCount, totalCount
        );
    }
    
    /**
     * Escape special characters in JSON strings
     * @param input The input string
     * @return Escaped string safe for JSON
     */
    private static String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}