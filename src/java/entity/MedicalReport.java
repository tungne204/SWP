package entity;

public class MedicalReport {
    private int recordId;
    private int appointmentId;
    private String diagnosis;
    private String prescription;
    private boolean testRequest;
    
    // Thông tin bổ sung từ join
    private String patientName;
    private String doctorName;
    private String appointmentDate;

    public MedicalReport() {
    }

    public MedicalReport(int recordId, int appointmentId, String diagnosis, 
                        String prescription, boolean testRequest) {
        this.recordId = recordId;
        this.appointmentId = appointmentId;
        this.diagnosis = diagnosis;
        this.prescription = prescription;
        this.testRequest = testRequest;
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

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(String appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    @Override
    public String toString() {
        return "MedicalReport{" +
                "recordId=" + recordId +
                ", appointmentId=" + appointmentId +
                ", diagnosis='" + diagnosis + '\'' +
                ", prescription='" + prescription + '\'' +
                ", testRequest=" + testRequest +
                '}';
    }
}