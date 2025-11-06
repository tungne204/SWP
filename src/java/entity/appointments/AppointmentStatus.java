/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.appointments;

/**
 *
 * @author Quang Anh
 */
public enum AppointmentStatus {
    PENDING("Pending"),           // Chờ xác nhận
    CONFIRMED("Confirmed"),       // Đã xác nhận
    WAITING("Waiting"),           // Đang chờ khám (sau checkin)
    IN_PROGRESS("In Progress"),   // Đang khám
    TESTING("Testing"),           // Đang xét nghiệm
    COMPLETED("Completed"),       // Đã hoàn thành
    CANCELLED("Cancelled");       // Đã hủy
    
    private final String value;
    
    AppointmentStatus(String value) {
        this.value = value;
    }
    
    public String getValue() {
        return value;
    }
    
    public static AppointmentStatus fromString(String text) {
        for (AppointmentStatus status : AppointmentStatus.values()) {
            if (status.value.equalsIgnoreCase(text)) {
                return status;
            }
        }
        return null;
    }
}