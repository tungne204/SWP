package entity;

import java.util.Date;

/**
 * DTO class để chứa thông tin đầy đủ của appointment
 * Bao gồm thông tin từ các bảng Appointment, Patient, Parent, Doctor
 */
public class AppointmentDetailDTO {
    // Thông tin từ Appointment
    private int appointmentId;
    private Date dateTime;
    private boolean status;
    
    // Thông tin từ Patient
    private int patientId;
    private String patientFullName;
    private Date patientDob;
    private String patientAddress;
    private String patientInsuranceInfo;
    
    // Thông tin từ Parent
    private int parentId;
    private String parentName;
    private String parentIdInfo;
    
    // Thông tin từ Doctor
    private int doctorId;
    private String doctorName;
    private String doctorSpecialty;
    
    // Constructor
    public AppointmentDetailDTO() {
    }
    
    // Constructor với tất cả thông tin
    public AppointmentDetailDTO(int appointmentId, Date dateTime, boolean status,
                                int patientId, String patientFullName, Date patientDob, 
                                String patientAddress, String patientInsuranceInfo,
                                int parentId, String parentName, String parentIdInfo,
                                int doctorId, String doctorName, String doctorSpecialty) {
        this.appointmentId = appointmentId;
        this.dateTime = dateTime;
        this.status = status;
        this.patientId = patientId;
        this.patientFullName = patientFullName;
        this.patientDob = patientDob;
        this.patientAddress = patientAddress;
        this.patientInsuranceInfo = patientInsuranceInfo;
        this.parentId = parentId;
        this.parentName = parentName;
        this.parentIdInfo = parentIdInfo;
        this.doctorId = doctorId;
        this.doctorName = doctorName;
        this.doctorSpecialty = doctorSpecialty;
    }
    
    // Getters and Setters
    public int getAppointmentId() {
        return appointmentId;
    }
    
    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
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
    
    public int getPatientId() {
        return patientId;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    
    public String getPatientFullName() {
        return patientFullName;
    }
    
    public void setPatientFullName(String patientFullName) {
        this.patientFullName = patientFullName;
    }
    
    public Date getPatientDob() {
        return patientDob;
    }
    
    public void setPatientDob(Date patientDob) {
        this.patientDob = patientDob;
    }
    
    public String getPatientAddress() {
        return patientAddress;
    }
    
    public void setPatientAddress(String patientAddress) {
        this.patientAddress = patientAddress;
    }
    
    public String getPatientInsuranceInfo() {
        return patientInsuranceInfo;
    }
    
    public void setPatientInsuranceInfo(String patientInsuranceInfo) {
        this.patientInsuranceInfo = patientInsuranceInfo;
    }
    
    public int getParentId() {
        return parentId;
    }
    
    public void setParentId(int parentId) {
        this.parentId = parentId;
    }
    
    public String getParentName() {
        return parentName;
    }
    
    public void setParentName(String parentName) {
        this.parentName = parentName;
    }
    
    public String getParentIdInfo() {
        return parentIdInfo;
    }
    
    public void setParentIdInfo(String parentIdInfo) {
        this.parentIdInfo = parentIdInfo;
    }
    
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
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
}
