package control;

import dao.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/Change_password"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User acc = (User) session.getAttribute("acc");

        if (acc == null) {
            response.sendRedirect("Login");
            return;
        }
        
        // Forward to Change_password.jsp
        request.getRequestDispatcher("Change_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User acc = (User) session.getAttribute("acc");

        if (acc == null) {
            response.sendRedirect("Login");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        UserDAO dao = new UserDAO();

        // ✅ Check old password
        if (!dao.checkPassword(acc.getEmail(), oldPassword)) {
            request.setAttribute("error", "Current password is incorrect!");
            request.getRequestDispatcher("Change_password.jsp").forward(request, response);
            return;
        }

        // ✅ Check confirm new password
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match!");
            request.getRequestDispatcher("Change_password.jsp").forward(request, response);
            return;
        }

        // ✅ Update new password
        dao.updatePassword(acc.getEmail(), newPassword);

        // ✅ Invalidate session sau khi đổi mật khẩu
        session.invalidate();

        // ✅ Forward về Change_password.jsp để hiển thị thông báo
        request.setAttribute("success", "Password updated successfully! Please login again.");
        request.getRequestDispatcher("Change_password.jsp").forward(request, response);
    }
}
