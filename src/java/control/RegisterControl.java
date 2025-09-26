package control;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "RegisterControl", urlPatterns = {"/register"})
public class RegisterControl extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("fullname");   
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        UserDAO dao = new UserDAO();

        if (!password.equals(confirm)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        if (dao.checkEmailExists(email)) {
            request.setAttribute("error", "Email already exists!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        dao.register(username, password, email, phone);

        // ✅ Thông báo thành công
        request.setAttribute("successMessage", "Register successful! Please login.");
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }
}

