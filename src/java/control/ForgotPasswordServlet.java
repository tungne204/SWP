package control;

import dao.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/ForgotPasswordServlet"})
public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        UserDAO dao = new UserDAO();
        User user = dao.findByEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống!");
            request.getRequestDispatcher("Forgot_password.jsp").forward(request, response);
            return;
        }

        // Sinh token
        String token = generateToken();
        dao.saveResetToken(email, token);
        

        // Link reset
        String resetLink = request.getScheme() + "://" + request.getServerName() + ":" + 
                           request.getServerPort() + request.getContextPath() + 
                           "/ResetPasswordServlet?token=" + token;

        try {
            util.MailUtil.sendMail(email, "Password Reset", 
                "Xin chào " + user.getUsername() + ",\n\n" +
                "Bạn vừa yêu cầu đặt lại mật khẩu. Nhấn vào link sau để đặt lại mật khẩu:\n" +
                resetLink + "\n\n" +
                "Liên kết có hiệu lực trong 30 phút.\n\n" +
                "Nếu không phải bạn, vui lòng bỏ qua email này.");
            request.setAttribute("message", "Một email xác nhận đã được gửi đến " + email);
        } catch (Exception e) {
            request.setAttribute("error", "Không thể gửi email: " + e.getMessage());
        }

        request.getRequestDispatcher("Forgot_password.jsp").forward(request, response);
    }

    private String generateToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[32];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
