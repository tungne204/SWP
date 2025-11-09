/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.appointments;

import java.sql.Timestamp;

/**
 *
 * @author Quang Anh
 */
public class MedicalReport {

    private int recordId;
    private int appointmentId;
    private String diagnosis;
    private String prescription;
    private boolean testRequest;
    private Integer consultationId;
    private boolean isFinal;
    private String requestedTestType;   // + getter/setter
    private java.sql.Timestamp testRequestedAt;  // optional
    private Integer requestedByDoctorId;

    // Constructor
    public MedicalReport() {
    }

    public boolean isIsFinal() {
        return isFinal;
    }

    public void setIsFinal(boolean isFinal) {
        this.isFinal = isFinal;
    }

    public String getRequestedTestType() {
        return requestedTestType;
    }

    public void setRequestedTestType(String requestedTestType) {
        this.requestedTestType = requestedTestType;
    }

    public Timestamp getTestRequestedAt() {
        return testRequestedAt;
    }

    public void setTestRequestedAt(Timestamp testRequestedAt) {
        this.testRequestedAt = testRequestedAt;
    }

    public Integer getRequestedByDoctorId() {
        return requestedByDoctorId;
    }

    public void setRequestedByDoctorId(Integer requestedByDoctorId) {
        this.requestedByDoctorId = requestedByDoctorId;
    }

    
    // Getters and Setters
    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getPrescription() {
        return prescription;
    }

    public void setPrescription(String prescription) {
        this.prescription = prescription;
    }

    public boolean isTestRequest() {
        return testRequest;
    }

    public void setTestRequest(boolean testRequest) {
        this.testRequest = testRequest;
    }

    public Integer getConsultationId() {
        return consultationId;
    }

    public void setConsultationId(Integer consultationId) {
        this.consultationId = consultationId;
    }

    public boolean isFinal() {
        return isFinal;
    }

    public void setFinal(boolean isFinal) {
        this.isFinal = isFinal;
    }
}
