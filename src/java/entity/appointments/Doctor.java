/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.appointments;

/**
 *
 * @author Quang Anh
 */
public class Doctor {

    private int doctorId;
    private int userId;
    private Integer experienceYears;
    private String certificate;
    private String introduce;

    // Thông tin bổ sung từ User table
    private String username;
    private String email;
    private String phone;
    private String avatar;

    // Constructor
    public Doctor() {
    }

    public Doctor(int doctorId, int userId, Integer experienceYears, String certificate, String introduce, String username, String email, String phone, String avatar) {
        this.doctorId = doctorId;
        this.userId = userId;
        this.experienceYears = experienceYears;
        this.certificate = certificate;
        this.introduce = introduce;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.avatar = avatar;
    }

    // Getters and Setters
    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getExperienceYears() {
        return experienceYears;
    }

    public void setExperienceYears(Integer experienceYears) {
        this.experienceYears = experienceYears;
    }

    public String getCertificate() {
        return certificate;
    }

    public void setCertificate(String certificate) {
        this.certificate = certificate;
    }

    public String getIntroduce() {
        return introduce;
    }

    public void setIntroduce(String introduce) {
        this.introduce = introduce;
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

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
}
