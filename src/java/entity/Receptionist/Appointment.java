package entity.Receptionist;

import java.util.Date;

/**
 * Entity Appointment - Kết hợp dữ liệu từ Appointment, Patient, User, Doctor,
 * Parent, MedicalReport
 *
 * @author Kiên
 */
public class Appointment {

    private int appointmentId;
    private int patientId;
    private int doctorId;
    private Date dateTime;
    private boolean status; // true = Active, false = Inactive

    // --- Thông tin bệnh nhân ---
    private String patientName;
    private String patientDob;
    private String patientAddress;
    private String patientInsurance;
    private String parentName;
    private String patientEmail;
    private String parentPhone;

    // --- Thông tin bác sĩ ---
    private String doctorName;
    private String doctorCertificate;
    private String doctorExperienceYears;

    public Appointment() {
    }

    public Appointment(int appointmentId, int patientId, int doctorId, Date dateTime, boolean status) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.dateTime = dateTime;
        this.status = status;
    }

    public Appointment(int appointmentId, int patientId, int doctorId, Date dateTime, boolean status,
            String patientName, String patientDob, String patientAddress, String patientInsurance,
            String parentName, String patientEmail, String parentPhone,
            String doctorName, String doctorCertificate, String doctorExperienceYears,
            boolean hasMedicalReport, Integer recordId, String diagnosis) {

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
        this.patientEmail = patientEmail;
        this.parentPhone = parentPhone;
        this.doctorName = doctorName;
        this.doctorCertificate = doctorCertificate;
        this.doctorExperienceYears = doctorExperienceYears;
    }

    // --- Getter & Setter ---
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

    public String getPatientEmail() {
        return patientEmail;
    }

    public void setPatientEmail(String patientEmail) {
        this.patientEmail = patientEmail;
    }

    public String getParentPhone() {
        return parentPhone;
    }

    public void setParentPhone(String parentPhone) {
        this.parentPhone = parentPhone;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getDoctorCertificate() {
        return doctorCertificate;
    }

    public void setDoctorCertificate(String doctorCertificate) {
        this.doctorCertificate = doctorCertificate;
    }

    public String getDoctorExperienceYears() {
        return doctorExperienceYears;
    }

    public void setDoctorExperienceYears(String doctorExperienceYears) {
        this.doctorExperienceYears = doctorExperienceYears;
    }

}
