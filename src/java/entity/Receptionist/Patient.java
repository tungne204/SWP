package entity.Receptionist;

import java.sql.Date;

public class Patient {

    private int patientId;
    private int userId;
    private String fullName;
    private Date dob;
    private String address;
    private String insuranceInfo;
    private int parentId;

    // === Thông tin mở rộng cho giao diện ===
    private String parentName;        // Họ tên cha/mẹ
    private String parentIdNumber;    // CCCD/CMND của cha/mẹ
    private String email;             // Email của cha/mẹ
    private String phone;             // Số điện thoại của cha/mẹ

    private String doctorName;        // Bác sĩ phụ trách
//    private String doctorCertificate;
//    private String doctorExperienceYears;
    private String doctorSpecialty;
    private String appointmentDate;   // Ngày khám
    private String appointmentTime;   // Giờ khám
    private String status;            // Trạng thái lịch hẹn

    // === Getters & Setters ===
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

//    public String getDoctorCertificate() {
//        return doctorCertificate;
//    }
//
//    public void setDoctorCertificate(String doctorCertificate) {
//        this.doctorCertificate = doctorCertificate;
//    }
//
//    public String getDoctorExperienceYears() {
//        return doctorExperienceYears;
//    }
//
//    public void setDoctorExperienceYears(String doctorExperienceYears) {
//        this.doctorExperienceYears = doctorExperienceYears;
//    }

    public String getDoctorSpecialty() {
        return doctorSpecialty;
    }

    public void setDoctorSpecialty(String doctorSpecialty) {
        this.doctorSpecialty = doctorSpecialty;
    }

}
