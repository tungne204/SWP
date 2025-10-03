package entity;

import java.math.BigDecimal;
import java.util.Date;

public class RevenueReport {
    private int reportId;
    private int managerId;
    private Date dateFrom;
    private Date dateTo;
    private BigDecimal totalRevenue;

    public RevenueReport() {
    }

    public RevenueReport(int reportId, int managerId, Date dateFrom, Date dateTo, BigDecimal totalRevenue) {
        this.reportId = reportId;
        this.managerId = managerId;
        this.dateFrom = dateFrom;
        this.dateTo = dateTo;
        this.totalRevenue = totalRevenue;
    }

    // Getter & Setter
    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public Date getDateFrom() {
        return dateFrom;
    }

    public void setDateFrom(Date dateFrom) {
        this.dateFrom = dateFrom;
    }

    public Date getDateTo() {
        return dateTo;
    }

    public void setDateTo(Date dateTo) {
        this.dateTo = dateTo;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}