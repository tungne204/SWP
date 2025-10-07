package control;

import dao.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/ChangePasswordServlet"})

public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User acc = (User) session.getAttribute("acc");

        if (acc == null) {
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        User loggedInUser = (User) session.getAttribute("acc");
        String email = loggedInUser.getEmail();

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        UserDAO dao = new UserDAO();

        // ✅ Check old password
        if (!dao.checkPassword(acc.getEmail(), oldPassword)) {
            request.setAttribute("error", "Current password is incorrect!");
        // Basic validations
        if (oldPassword == null || newPassword == null || confirmPassword == null
                || oldPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            request.getRequestDispatcher("Change_password.jsp").forward(request, response);
            return;
        }

        // ✅ Check confirm new password
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match!");
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("Change_password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("Change_password.jsp").forward(request, response);
            return;
        }

        if (newPassword.equals(oldPassword)) {
            request.setAttribute("error", "Mật khẩu mới không được trùng mật khẩu cũ.");
            request.getRequestDispatcher("Change_password.jsp").forward(request, response);
            return;
        }

        // ✅ Update new password
        dao.updatePassword(acc.getEmail(), newPassword);
        request.setAttribute("success", "Password updated successfully!");
        UserDAO userDAO = new UserDAO();

        // Verify old password
        boolean isOldPasswordCorrect = userDAO.checkPassword(email, oldPassword);
        if (!isOldPasswordCorrect) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            request.getRequestDispatcher("Change_password.jsp").forward(request, response);
            return;
        }

        // Update to new password
        userDAO.updatePassword(email, newPassword);

        // Keep session user in sync if it stores password
        try {
            if (loggedInUser.getPassword() != null) {
                loggedInUser.setPassword(newPassword);
                session.setAttribute("acc", loggedInUser);
            }
        } catch (Exception ignored) {
            // If entity doesn't expose password setters, safely ignore
        }

        request.setAttribute("success", "Cập nhật mật khẩu thành công.");
        request.getRequestDispatcher("Change_password.jsp").forward(request, response);
    }
}


