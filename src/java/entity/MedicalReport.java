package entity;

public class MedicalReport {
    private int recordId;
    private int appointmentId;
    private String diagnosis;
    private String prescription;
    private Boolean testRequest; // Boolean wrapper to allow null values
    private Integer consultationId; // Integer wrapper to allow null values

    public MedicalReport() {
    }

    public MedicalReport(int recordId, int appointmentId, String diagnosis, String prescription, Boolean testRequest, Integer consultationId) {
        this.recordId = recordId;
        this.appointmentId = appointmentId;
        this.diagnosis = diagnosis;
        this.prescription = prescription;
        this.testRequest = testRequest;
        this.consultationId = consultationId;
    }

    // Getter & Setter
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

    public Boolean getTestRequest() {
        return testRequest;
    }

    public void setTestRequest(Boolean testRequest) {
        this.testRequest = testRequest;
    }

    public Integer getConsultationId() {
        return consultationId;
    }

    public void setConsultationId(Integer consultationId) {
        this.consultationId = consultationId;
    }
}