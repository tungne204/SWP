package control;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

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

        // ✅ Validate số điện thoại
        if (phone == null || !phone.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // ✅ Kiểm tra confirm password
        if (!password.equals(confirm)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // ✅ Kiểm tra email tồn tại
        if (dao.checkEmailExists(email)) {
            request.setAttribute("error", "Email already exists!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // ✅ Đăng ký user mới
        dao.register(username, password, email, phone);

        // ✅ Thông báo thành công và chuyển về Login
        request.setAttribute("successMessage", "Register successful! Please login.");
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }
}
