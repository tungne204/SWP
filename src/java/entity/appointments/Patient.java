/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.appointments;

/**
 *
 * @author Quang Anh
 */
import java.sql.Date;

public class Patient {

    private int patientId;
    private Integer userId;
    private String fullName;
    private Date dob;
    private String address;
    private String insuranceInfo;
    private Integer parentId;

    // Thông tin bổ sung từ User table
    private String username;
    private String email;
    private String phone;

    // Constructor
    public Patient() {
    }

    public Patient(int patientId, Integer userId, String fullName, Date dob, String address, String insuranceInfo, Integer parentId, String username, String email, String phone) {
        this.patientId = patientId;
        this.userId = userId;
        this.fullName = fullName;
        this.dob = dob;
        this.address = address;
        this.insuranceInfo = insuranceInfo;
        this.parentId = parentId;
        this.username = username;
        this.email = email;
        this.phone = phone;
    }

    // Getters and Setters
    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
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

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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
}
