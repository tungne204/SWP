package config;

/**
 * Cấu hình Google OAuth
 * 
 * HƯỚNG DẪN SỬ DỤNG:
 * 1. Thay thế YOUR_GOOGLE_CLIENT_ID bằng Client ID thực tế từ Google Console
 * 2. Không commit file này vào repository public
 * 3. Sử dụng environment variables cho production
 */
public class GoogleConfig {
    
    // Thay thế bằng Google Client ID thực tế
    // Format: xxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com
    public static final String GOOGLE_CLIENT_ID = "867492876203-ob2295sjlm6fi4kbbgvq128c09422q71.apps.googleusercontent.com";
    
    // Có thể thêm các cấu hình khác ở đây
    public static final String GOOGLE_REDIRECT_URI = "/SWP01/Login.jsp";
    
    /**
     * Kiểm tra xem Google OAuth đã được cấu hình chưa
     * @return true nếu đã cấu hình, false nếu chưa
     */
    public static boolean isConfigured() {
        return !GOOGLE_CLIENT_ID.equals("YOUR_GOOGLE_CLIENT_ID") 
               && !GOOGLE_CLIENT_ID.isEmpty();
    }
    
    /**
     * Lấy Google Client ID từ environment variable hoặc config
     * Ưu tiên environment variable cho production
     */
    public static String getClientId() {
        String envClientId = System.getenv("GOOGLE_CLIENT_ID");
        if (envClientId != null && !envClientId.isEmpty()) {
            return envClientId;
        }
        return GOOGLE_CLIENT_ID;
    }
}
