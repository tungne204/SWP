package control;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "VerifyEmailServlet", urlPatterns = {"/VerifyEmail"})
public class VerifyEmailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is already logged in
        if (request.getSession(false) != null && request.getSession(false).getAttribute("acc") != null) {
            response.sendRedirect("Home.jsp");
            return;
        }
        
        // Check if there's a pending email in session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pendingEmail") == null) {
            // No pending email, redirect to register
            response.sendRedirect("Register");
            return;
        }
        
        // Forward to VerifyEmail.jsp
        request.getRequestDispatcher("VerifyEmail.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String code = request.getParameter("verificationCode");
        HttpSession session = request.getSession(false);
        
        // Check if there's a pending email in session
        if (session == null || session.getAttribute("pendingEmail") == null) {
            request.setAttribute("error", "Session expired. Please register again.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }
        
        String email = (String) session.getAttribute("pendingEmail");
        UserDAO dao = new UserDAO();
        
        // Validate verification code - trim whitespace
        if (code == null || code.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the verification code.");
            request.getRequestDispatcher("VerifyEmail.jsp").forward(request, response);
            return;
        }
        
        // Trim code to remove any whitespace
        code = code.trim();
        
        // Check if code is valid
        if (dao.verifyEmailCode(email, code)) {
            // Mark email as verified and activate user account
            dao.completeEmailVerification(email);
            
            // Clear pending email from session
            session.removeAttribute("pendingEmail");
            
            // Set success flag in request to show success message
            request.setAttribute("verified", "true");
            request.setAttribute("successMessage", "Email verified successfully! Please click the button below to go to login page.");
            
            // Forward back to VerifyEmail.jsp to show success message
            request.getRequestDispatcher("VerifyEmail.jsp").forward(request, response);
            
        } else {
            request.setAttribute("error", "Invalid or expired verification code!");
            request.getRequestDispatcher("VerifyEmail.jsp").forward(request, response);
        }
    }
}

