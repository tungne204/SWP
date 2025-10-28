/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author Quang Anh
 */
public class Qualification {
    private int qualificationId;
    private int doctorId;
    private String degreeName;
    private String institution;
    private int yearObtained;
    private String certificateNumber;
    private String description;
    
    public Qualification() {}
    
    public Qualification(int qualificationId, int doctorId, String degreeName, 
                        String institution, int yearObtained, String certificateNumber, 
                        String description) {
        this.qualificationId = qualificationId;
        this.doctorId = doctorId;
        this.degreeName = degreeName;
        this.institution = institution;
        this.yearObtained = yearObtained;
        this.certificateNumber = certificateNumber;
        this.description = description;
    }
    
    // Getters and Setters
    public int getQualificationId() { return qualificationId; }
    public void setQualificationId(int qualificationId) { 
        this.qualificationId = qualificationId; 
    }
    
    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
    
    public String getDegreeName() { return degreeName; }
    public void setDegreeName(String degreeName) { this.degreeName = degreeName; }
    
    public String getInstitution() { return institution; }
    public void setInstitution(String institution) { this.institution = institution; }
    
    public int getYearObtained() { return yearObtained; }
    public void setYearObtained(int yearObtained) { this.yearObtained = yearObtained; }
    
    public String getCertificateNumber() { return certificateNumber; }
    public void setCertificateNumber(String certificateNumber) { 
        this.certificateNumber = certificateNumber; 
    }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
