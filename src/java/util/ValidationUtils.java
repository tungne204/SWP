package util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author Kiên
 */
public class ValidationUtils {

    private final Map<String, String> errors = new HashMap<>();

    public void validateNotEmpty(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            errors.put(fieldName, fieldName + " không được để trống.");
        }
    }

    public void validatePositiveId(int id, String fieldName) {
        if (id <= 0) {
            errors.put(fieldName, fieldName + " không hợp lệ.");
        }
    }

    // ✅ Đổi sang format dd/MM/yyyy HH:mm
    public void validateDateTime(String dateTime, String fieldName) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            sdf.setLenient(false);
            sdf.parse(dateTime);
        } catch (ParseException e) {
            errors.put(fieldName, fieldName + " không đúng định dạng (dd/MM/yyyy HH:mm).");
        }
    }

    // ✅ Cập nhật luôn cho phần kiểm tra tương lai
    public void validateFutureDate(String dateTime, String fieldName) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            sdf.setLenient(false);
            Date date = sdf.parse(dateTime);
            if (date.before(new Date())) {
                errors.put(fieldName, fieldName + " phải ở tương lai.");
            }
        } catch (ParseException e) {
            errors.put(fieldName, fieldName + " không hợp lệ (định dạng dd/MM/yyyy HH:mm).");
        }
    }

    public void validateInList(String value, List<String> allowed, String fieldName) {
        if (value == null || !allowed.contains(value)) {
            errors.put(fieldName, fieldName + " không hợp lệ.");
        }
    }

    public void validatePhone(String phone, String fieldName) {
        if (phone == null || phone.trim().isEmpty()) {
            errors.put(fieldName, "Bạn chưa có số điện thoại, vui lòng nhập số điện thoại.");
            return;
        }
        
        // Validate phone format: Vietnamese phone number ^0[3|5|7|8|9][0-9]{8}$
        String phoneRegex = "^0[35789][0-9]{8}$";
        if (!phone.trim().matches(phoneRegex)) {
            errors.put(fieldName, fieldName + " không hợp lệ. Số điện thoại phải có định dạng: 0[3|5|7|8|9]xxxxxxxx.");
        }
    }

    public boolean hasErrors() {
        return !errors.isEmpty();
    }

    public Map<String, String> getErrors() {
        return errors;
    }
}
