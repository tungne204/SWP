package control;

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
            
            // Validate username
            if (username == null || username.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Tên người dùng không được để trống\"}");
                return;
            }
            
            // Validate phone (optional)
            if (phone != null && !phone.trim().isEmpty()) {
                String cleanPhone = phone.trim().replaceAll("[^0-9]", "");
                if (cleanPhone.length() != 10) {
                    out.print("{\"success\":false,\"message\":\"Số điện thoại phải có đúng 10 chữ số\"}");
                    return;
                }
                phone = cleanPhone;
            }
            
            // Update database
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updateUserProfile(user.getUserId(), username.trim(), phone);
            
            if (success) {
                // Update session
                user.setUsername(username.trim());
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
