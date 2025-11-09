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

public class TestResult {
    private int testId;
    private int recordId;
    private String testType;
    private String result;
    private Date date;
    private Integer consultationId;
    
    // Constructor
    public TestResult() {}
    
    // Getters and Setters
    public int getTestId() { return testId; }
    public void setTestId(int testId) { this.testId = testId; }
    
    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }
    
    public String getTestType() { return testType; }
    public void setTestType(String testType) { this.testType = testType; }
    
    public String getResult() { return result; }
    public void setResult(String result) { this.result = result; }
    
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    
    public Integer getConsultationId() { return consultationId; }
    public void setConsultationId(Integer consultationId) { 
        this.consultationId = consultationId; 
    }
}