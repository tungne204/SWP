package entity;

import java.util.Date;

public class TestResult {
    private int testId;
    private int recordId;
    private String testType;
    private String result;
    private Date date;
    private Integer consultationId; // Integer wrapper to allow null values

    public TestResult() {
    }

    public TestResult(int testId, int recordId, String testType, String result, Date date, Integer consultationId) {
        this.testId = testId;
        this.recordId = recordId;
        this.testType = testType;
        this.result = result;
        this.date = date;
        this.consultationId = consultationId;
    }

    // Getter & Setter
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

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Integer getConsultationId() {
        return consultationId;
    }

    public void setConsultationId(Integer consultationId) {
        this.consultationId = consultationId;
    }
}