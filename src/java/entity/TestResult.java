package entity;

import java.util.Date;

public class TestResult {
    private int testId;
    private int recordId;
    private String testType;
    private String result;
    private String date;
    private Integer consultationId; // Cột mới - nullable
    
    // Thông tin bổ sung từ join
    private String patientName;
    private String diagnosis;

    public TestResult() {
    }

    public TestResult(int testId, int recordId, String testType, String result, String date) {
        this.testId = testId;
        this.recordId = recordId;
        this.testType = testType;
        this.result = result;
        this.date = date;
    }

    // Getters and Setters
    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public String getTestType() {
        return testType;
    }

    public void setTestType(String testType) {
        this.testType = testType;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public Integer getConsultationId() {
        return consultationId;
    }

    public void setConsultationId(Integer consultationId) {
        this.consultationId = consultationId;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    @Override
    public String toString() {
        return "TestResult{" +
                "testId=" + testId +
                ", recordId=" + recordId +
                ", testType='" + testType + '\'' +
                ", result='" + result + '\'' +
                ", date='" + date + '\'' +
                ", consultationId=" + consultationId +
                '}';
    }
}