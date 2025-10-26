package control;

import config.GoogleConfig;
import dao.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

@WebServlet(name = "GoogleOAuthCallback", urlPatterns = {"/google-oauth-callback"})
public class GoogleOAuthCallback extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Đọc dữ liệu JSON từ request
            StringBuilder jsonBuffer = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                jsonBuffer.append(line);
            }
            
            // Parse JSON (đơn giản hóa, trong thực tế nên dùng thư viện JSON)
            String jsonData = jsonBuffer.toString();
            String email = extractValue(jsonData, "email");
            String name = extractValue(jsonData, "name");
            String picture = extractValue(jsonData, "picture");
            String credential = extractValue(jsonData, "credential");
            
            // Verify Google token (trong thực tế nên verify token)
            if (email == null || email.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Invalid Google token\"}");
                return;
            }
            
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);
            
            if (user == null) {
                // Tạo user mới nếu chưa tồn tại
                String username = name != null ? name : email.split("@")[0];
                String randomPassword = generateRandomPassword();
                
                userDAO.registerGoogleUser(username, randomPassword, email, null, picture);
                user = userDAO.findByEmail(email);
            } else {
                // Cập nhật avatar nếu user đã tồn tại nhưng chưa có avatar
                if ((user.getAvatar() == null || user.getAvatar().isEmpty()) && picture != null && !picture.isEmpty()) {
                    userDAO.updateUserAvatar(user.getUserId(), picture);
                    user.setAvatar(picture);
                }
            }
            
            if (user != null && user.isStatus()) {
                // Tạo session
                HttpSession session = request.getSession();
                session.setAttribute("acc", user);
                
                // Xác định redirect URL dựa trên role
                String redirectUrl = getRedirectUrl(user.getRoleId());
                
                out.print("{\"success\": true, \"redirectUrl\": \"" + redirectUrl + "\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Tài khoản bị vô hiệu hóa\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }
    
    private String extractValue(String json, String key) {
        String pattern = "\"" + key + "\"\\s*:\\s*\"([^\"]+)\"";
        java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
        java.util.regex.Matcher m = p.matcher(json);
        if (m.find()) {
            return m.group(1);
        }
        return null;
    }
    
    private String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random random = new Random();
        StringBuilder password = new StringBuilder();
        for (int i = 0; i < 12; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        return password.toString();
    }
    
    private String getRedirectUrl(int roleId) {
        switch (roleId) {
            case 1: // Admin
                return "adminDashboard.jsp";
            case 2: // Doctor
                return "doctorDashboard.jsp";
            case 3: // Patient
                return "Home.jsp";
            case 4: // MedicalAssistant
                return "medicalAssistantDashboard.jsp";
            case 5: // Receptionist
                return "receptionDashboard.jsp";
            default:
                return "Home.jsp";
        }
    }
}
