package entity;

public class MedicalReport {
    private int recordId;
    private int appointmentId;
    private String diagnosis;
    // Prescription có thể null khi còn Draft
    private String prescription;
    private boolean testRequest;

    // NEW: Trạng thái chốt đơn (false = Draft, true = Final)
    private boolean isFinal;

    // Thông tin bổ sung từ join để hiển thị
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
        this.isFinal = false; // mặc định tạo mới là Draft
    }

    // Getters & Setters
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

    // NEW
    public boolean isFinal() {
        return isFinal;
    }

    // NEW
    public void setFinal(boolean aFinal) {
        isFinal = aFinal;
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
                ", isFinal=" + isFinal +
                '}';
    }
}
