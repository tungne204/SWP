package control;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import util.EmailValidator;
import util.MailUtil;
import jakarta.mail.MessagingException;

@WebServlet(name = "RegisterControl", urlPatterns = {"/Register"})
public class RegisterControl extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is already logged in
        if (request.getSession(false) != null && request.getSession(false).getAttribute("acc") != null) {
            response.sendRedirect("Home.jsp");
            return;
        }
        
        // Forward to Register.jsp
        request.getRequestDispatcher("Register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        UserDAO dao = new UserDAO();

        // ✅ Validate email format
        if (!EmailValidator.isValidEmailFormat(email)) {
            request.setAttribute("error", "Format email đang sai!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // ✅ Validate password length (ít nhất 6 ký tự)
        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // ✅ Validate số điện thoại
        if (phone == null || !phone.matches("\\d{10}")) {
            request.setAttribute("error", "Số điện thoại phải có 10 số!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // ✅ Kiểm tra confirm password
        if (!password.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu không khớp!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // ✅ Kiểm tra email tồn tại trong database
        if (dao.checkEmailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // ✅ Tạo user với trạng thái chưa verified
        dao.registerWithEmailVerification(username, password, email, phone);
        
        // ✅ Tạo mã verification code 6 số
        String verificationCode = EmailValidator.generateVerificationCode();
        
        // ✅ Lưu verification code vào database
        dao.saveEmailVerificationCode(email, verificationCode);
        
        // ✅ Gửi email với verification code
        try {
            String emailBody = "Xin chào " + username + ",\n\n" +
                    "Cảm ơn bạn đã đăng ký tài khoản. Để hoàn tất đăng ký, vui lòng nhập mã xác thực sau:\n\n" +
                    "Mã xác thực: " + verificationCode + "\n\n" +
                    "Mã này có hiệu lực trong 15 phút.\n\n" +
                    "Trân trọng,\n" +
                    "Đội ngũ Medilab";
            
            MailUtil.sendMail(email, "Xác thực email đăng ký tài khoản Medilab", emailBody);
            
            // ✅ Lưu email vào session để verify
            HttpSession session = request.getSession();
            session.setAttribute("pendingEmail", email);
            
            // ✅ Chuyển đến trang verify email
            response.sendRedirect("VerifyEmail.jsp");
            
        } catch (MessagingException e) {
            // Nếu gửi email thất bại, xóa user đã tạo và báo lỗi
            request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            e.printStackTrace();
        }
    }
}
