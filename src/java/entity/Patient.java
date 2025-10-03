package entity;

import java.util.Date;

public class Patient {
    private int patientId;
    private int userId;
    private String fullName;
    private Date dob;
    private String address;
    private String insuranceInfo;
    private Integer parentId; // Integer wrapper to allow null values

    public Patient() {
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

    // Getter & Setter
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
}