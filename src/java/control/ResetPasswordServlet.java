package control;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/ResetPasswordServlet"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        if (token == null || token.isEmpty()) {
            response.sendRedirect("Forgot_password.jsp");
            return;
        }
        request.setAttribute("token", token);
        request.getRequestDispatcher("Reset_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // ✅ Validate password length (ít nhất 6 ký tự)
        if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.setAttribute("token", token);
            request.getRequestDispatcher("Reset_password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.setAttribute("token", token);
            request.getRequestDispatcher("Reset_password.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        String email = dao.findEmailByToken(token);
        if (email != null) {
            dao.updatePassword(email, newPassword);
            dao.clearToken(token);
            response.sendRedirect("Login.jsp?reset=success");
        } else {
            request.setAttribute("error", "Token không hợp lệ hoặc đã hết hạn!");
            request.getRequestDispatcher("Reset_password.jsp").forward(request, response);
        }
    }
}
