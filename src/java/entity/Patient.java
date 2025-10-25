package entity;

import java.util.Date;

public class Patient {
    private int patientId;
    private int userId;
    private String fullName;
    private Date dob;
    private String address;
    private String insuranceInfo;
    private Integer parentId; 

    // --- Các trường mở rộng cho View Profile ---
    private String parentName;         // Tên phụ huynh
    private String parentIdNumber;     // Số CMND/CCCD của phụ huynh
    private String email;              // Email bệnh nhân
    private String phone;              // Số điện thoại bệnh nhân
    private String doctorName;         // Tên bác sĩ khám
    private String doctorSpecialty;    // Chuyên khoa bác sĩ
    private String appointmentDate;    // Ngày khám (định dạng dd/MM/yyyy)
    private String appointmentTime;    // Giờ khám (định dạng HH:mm)
    private String status;             // Trạng thái lịch hẹn (Confirmed/Pending)

    // --- Constructors ---
    public Patient() {}

    public Patient(int userId, String fullName, Date dob, String address, String insuranceInfo, Integer parentId) {
        this.userId = userId;
        this.fullName = fullName;
        this.dob = dob;
        this.address = address;
        this.insuranceInfo = insuranceInfo;
        this.parentId = parentId;
    }

    public Patient(int patientId, int userId, String fullName, Date dob, String address, String insuranceInfo, Integer parentId) {
        this.patientId = patientId;
        this.userId = userId;
        this.fullName = fullName;
        this.dob = dob;
        this.address = address;
        this.insuranceInfo = insuranceInfo;
        this.parentId = parentId;
    }

    // --- Getters & Setters ---
    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getInsuranceInfo() {
        return insuranceInfo;
    }

    public void setInsuranceInfo(String insuranceInfo) {
        this.insuranceInfo = insuranceInfo;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public String getParentIdNumber() {
        return parentIdNumber;
    }

    public void setParentIdNumber(String parentIdNumber) {
        this.parentIdNumber = parentIdNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
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

    public String getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(String appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public String getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(String appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
