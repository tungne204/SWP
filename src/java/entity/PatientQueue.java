package entity;

import java.util.Date;

public class PatientQueue {
    private int queueId;
    private int patientId;
    private Integer appointmentId; // Integer wrapper to allow null values
    private int queueNumber;
    private String queueType; // 'Walk-in' or 'Booked'
    private String status; // 'Waiting', 'In Consultation', 'Awaiting Lab Results', 'Ready for Follow-up', 'Completed'
    private int priority; // For prioritization rules
    private String roomNumber; // Consultation room number (e.g., "Room 1", "Room 2")
    private Date checkInTime;
    private Date updatedTime;

    public PatientQueue() {
    }

    public PatientQueue(int queueId, int patientId, Integer appointmentId, int queueNumber, String queueType, String status, int priority, String roomNumber, Date checkInTime, Date updatedTime) {
        this.queueId = queueId;
        this.patientId = patientId;
        this.appointmentId = appointmentId;
        this.queueNumber = queueNumber;
        this.queueType = queueType;
        this.status = status;
        this.priority = priority;
        this.roomNumber = roomNumber;
        this.checkInTime = checkInTime;
        this.updatedTime = updatedTime;
    }

    // Getter & Setter
    public int getQueueId() {
        return queueId;
    }

    public void setQueueId(int queueId) {
        this.queueId = queueId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public Integer getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Integer appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getQueueNumber() {
        return queueNumber;
    }

    public void setQueueNumber(int queueNumber) {
        this.queueNumber = queueNumber;
    }

    public String getQueueType() {
        return queueType;
    }

    public void setQueueType(String queueType) {
        this.queueType = queueType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public Date getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Date checkInTime) {
        this.checkInTime = checkInTime;
    }

    public Date getUpdatedTime() {
        return updatedTime;
    }

    public void setUpdatedTime(Date updatedTime) {
        this.updatedTime = updatedTime;
    }
}