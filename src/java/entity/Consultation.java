package entity;

import java.util.Date;

public class Consultation {
    private int consultationId;
    private int patientId;
    private int doctorId;
    private int queueId;
    private Date startTime;
    private Date endTime;
    private String status; // 'In Progress', 'Lab Requested', 'Completed'

    public Consultation() {
    }

    public Consultation(int consultationId, int patientId, int doctorId, int queueId, Date startTime, Date endTime, String status) {
        this.consultationId = consultationId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.queueId = queueId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
    }

    // Getter & Setter
    public int getConsultationId() {
        return consultationId;
    }

    public void setConsultationId(int consultationId) {
        this.consultationId = consultationId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public int getQueueId() {
        return queueId;
    }

    public void setQueueId(int queueId) {
        this.queueId = queueId;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}