package control;

import dao.DoctorDAO;
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

@WebServlet(name = "ProfileUpdateServlet", urlPatterns = {"/editProfile"})
public class ProfileUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Kiểm tra session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("acc") == null) {
                out.print("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
                return;
            }
            
            User user = (User) session.getAttribute("acc");
            
            // Lấy parameters
            String username = request.getParameter("username");
            String phone = request.getParameter("phone");
            
            // Debug logging (có thể xóa sau)
            System.out.println("Username received: " + username);
            System.out.println("Phone received: " + phone);
            
            // Validate username
            if (username == null || username.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Tên đăng nhập không được để trống\"}");
                return;
            }
            
            username = username.trim();
            
            // Validate phone (optional but must be 10 digits if provided)
            if (phone != null && !phone.trim().isEmpty()) {
                String cleanPhone = phone.trim().replaceAll("[^0-9]", "");
                if (cleanPhone.isEmpty()) {
                    phone = null; // Phone is empty after cleaning
                } else if (cleanPhone.length() != 10) {
                    out.print("{\"success\":false,\"message\":\"Số điện thoại phải có đúng 10 số\"}");
                    return;
                } else {
                    phone = cleanPhone;
                }
            } else {
                phone = null;
            }
            
            // Update database
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updateUserProfile(user.getUserId(), username, phone);
            
            // If user is Doctor, update Doctor info
            if (success && user.getRoleId() == 2) {
                DoctorDAO doctorDAO = new DoctorDAO();
                
                // Update experienceYears
                String expYearsStr = request.getParameter("experienceYears");
                if (expYearsStr != null && !expYearsStr.isEmpty()) {
                    try {
                        int experienceYears = Integer.parseInt(expYearsStr);
                        // Only update experienceYears, not certificate (certificate is uploaded separately)
                        doctorDAO.updateDoctorExperience(user.getUserId(), experienceYears);
                    } catch (NumberFormatException e) {
                        // Invalid number, skip
                    }
                }
                
                // Update introduce
                String introduce = request.getParameter("introduce");
                if (introduce != null) {
                    doctorDAO.updateDoctorIntroduce(user.getUserId(), introduce);
                }
            }
            
            if (success) {
                // Update session
                user.setUsername(username);
                user.setPhone(phone);
                session.setAttribute("acc", user);
                
                out.print("{\"success\":true,\"message\":\"Cập nhật hồ sơ thành công\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Lỗi máy chủ: " + e.getMessage() + "\"}");
        }
        
        out.flush();
    }
}
