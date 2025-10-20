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

@WebServlet(name = "LoginControl", urlPatterns = {"/Login"})
public class LoginControl extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is already logged in
        if (request.getSession(false) != null && request.getSession(false).getAttribute("acc") != null) {
            response.sendRedirect("Home.jsp");
            return;
        }
        
        // Forward to Login.jsp
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("acc", user);

            // Chuyển hướng theo role
            switch (user.getRoleId()) {
                case 1: // Admin
                    response.sendRedirect("adminDashboard.jsp");
                    break;
                case 2: // Doctor
                    response.sendRedirect("doctorDashboard.jsp");
                    break;
                case 3: // Patient
                    response.sendRedirect("Home.jsp");
                    break;
                case 4: // MedicalAssistant
                    response.sendRedirect("medicalAssistantDashboard.jsp");
                    break;
                case 5: // Receptionist
                    response.sendRedirect("receptionDashboard.jsp");
                    break;
                default:
                    response.sendRedirect("Home.jsp");
                    break;
            }
        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}
