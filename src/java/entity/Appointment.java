package entity;

import java.util.Date;

public class Appointment {
    private int appointmentId;
    private int patientId;
    private int doctorId;
    private Date dateTime;
    private boolean status; // true = Active, false = Inactive
    // Thông tin bổ sung từ join
    private String patientName;
    private String patientDob;
    private String patientAddress;
    private String patientInsurance;
    private String parentName;
    private String doctorName;
    private String doctorSpecialty;
    
    // Thông tin medical report (nếu có)
    private boolean hasMedicalReport;
    private Integer recordId;
    private String diagnosis;
    public Appointment() {
    }

    public Appointment(int appointmentId, int patientId, int doctorId, Date dateTime, boolean status) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.dateTime = dateTime;
        this.status = status;
    }

    public Appointment(int appointmentId, int patientId, int doctorId, Date dateTime, boolean status, String patientName, String patientDob, String patientAddress, String patientInsurance, String parentName, String doctorName, String doctorSpecialty, boolean hasMedicalReport, Integer recordId, String diagnosis) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.dateTime = dateTime;
        this.status = status;
        this.patientName = patientName;
        this.patientDob = patientDob;
        this.patientAddress = patientAddress;
        this.patientInsurance = patientInsurance;
        this.parentName = parentName;
        this.doctorName = doctorName;
        this.doctorSpecialty = doctorSpecialty;
        this.hasMedicalReport = hasMedicalReport;
        this.recordId = recordId;
        this.diagnosis = diagnosis;
    }
    

    // Getter & Setter
    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
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

    public Date getDateTime() {
        return dateTime;
    }

    public void setDateTime(Date dateTime) {
        this.dateTime = dateTime;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getPatientDob() {
        return patientDob;
    }

    public void setPatientDob(String patientDob) {
        this.patientDob = patientDob;
    }

    public String getPatientAddress() {
        return patientAddress;
    }

    public void setPatientAddress(String patientAddress) {
        this.patientAddress = patientAddress;
    }

    public String getPatientInsurance() {
        return patientInsurance;
    }

    public void setPatientInsurance(String patientInsurance) {
        this.patientInsurance = patientInsurance;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getDoctorSpecialty() {
        return doctorSpecialty;
    }

    public void setDoctorSpecialty(String doctorSpecialty) {
        this.doctorSpecialty = doctorSpecialty;
    }

    public boolean isHasMedicalReport() {
        return hasMedicalReport;
    }

    public void setHasMedicalReport(boolean hasMedicalReport) {
        this.hasMedicalReport = hasMedicalReport;
    }

    public Integer getRecordId() {
        return recordId;
    }

    public void setRecordId(Integer recordId) {
        this.recordId = recordId;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }
    
}