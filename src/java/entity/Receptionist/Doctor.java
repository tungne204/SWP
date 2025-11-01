package entity.Receptionist;

/**
 * Doctor entity
 *
 * @author Kiên
 */
public class Doctor {

    private int doctorId;
    private int userId;
    private String certificate;
    private String experienceYears;
    private String username;

    public Doctor() {
    }

    public Doctor(int doctorId, int userId, String specialty) {
        this.doctorId = doctorId;
        this.userId = userId;
        this.certificate = certificate;
        this.experienceYears = experienceYears;
    }

    // Getter & Setter
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

    public String getCertificate() {
        return certificate;
    }

    public void setCertificate(String certificate) {
        this.certificate = certificate;
    }

    public String getExperienceYears() {
        return experienceYears;
    }

    public void setExperienceYears(String experienceYears) {
        this.experienceYears = experienceYears;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
