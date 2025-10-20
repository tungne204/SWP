package entity.Receptionist;
/**
 * Doctor entity
 * @author Kiên
 */
public class Doctor {

    private int doctorId;
    private int userId;
    private String specialty;
    private String username;

    public Doctor() {
    }

    public Doctor(int doctorId, int userId, String specialty) {
        this.doctorId = doctorId;
        this.userId = userId;
        this.specialty = specialty;
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

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
