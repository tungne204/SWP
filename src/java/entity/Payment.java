package entity;

import java.math.BigDecimal;
import java.util.Date;

public class Payment {
    private int paymentId;
    private int appointmentId;
    private Integer discountId; // Integer wrapper to allow null values
    private BigDecimal amount;
    private String method;
    private Boolean status; // Boolean wrapper to allow null values
    private Date paymentDate;

    public Payment() {
    }

    public Payment(int paymentId, int appointmentId, Integer discountId, BigDecimal amount, String method, Boolean status, Date paymentDate) {
        this.paymentId = paymentId;
        this.appointmentId = appointmentId;
        this.discountId = discountId;
        this.amount = amount;
        this.method = method;
        this.status = status;
        this.paymentDate = paymentDate;
    }

    // Getter & Setter
    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public Integer getDiscountId() {
        return discountId;
    }

    public void setDiscountId(Integer discountId) {
        this.discountId = discountId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }
}