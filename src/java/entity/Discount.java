package entity;

import java.math.BigDecimal;
import java.util.Date;

public class Discount {
    private int discountId;
    private String code;
    private BigDecimal percentage;
    private Date validFrom;
    private Date validTo;

    public Discount() {
    }

    public Discount(int discountId, String code, BigDecimal percentage, Date validFrom, Date validTo) {
        this.discountId = discountId;
        this.code = code;
        this.percentage = percentage;
        this.validFrom = validFrom;
        this.validTo = validTo;
    }

    // Getter & Setter
    public int getDiscountId() {
        return discountId;
    }

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public BigDecimal getPercentage() {
        return percentage;
    }

    public void setPercentage(BigDecimal percentage) {
        this.percentage = percentage;
    }

    public Date getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(Date validFrom) {
        this.validFrom = validFrom;
    }

    public Date getValidTo() {
        return validTo;
    }

    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }
}