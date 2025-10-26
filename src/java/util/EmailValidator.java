package util;

import java.util.regex.Pattern;

public class EmailValidator {
    
    // Regular expression for email validation
    private static final String EMAIL_PATTERN = 
        "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" +
        "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
    
    private static final Pattern pattern = Pattern.compile(EMAIL_PATTERN);
    
    /**
     * Validate email format
     */
    public static boolean isValidEmailFormat(String email) {
        if (email == null || email.isEmpty()) {
            return false;
        }
        return pattern.matcher(email).matches();
    }
    
    /**
     * Generate a random 6-digit verification code
     */
    public static String generateVerificationCode() {
        int code = (int) (Math.random() * 900000) + 100000; // Generates 100000-999999
        return String.valueOf(code);
    }
}

