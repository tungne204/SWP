package control;

import dao.ContactDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ContactServlet", urlPatterns = {"/contact", "/contact-submit"})
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to contact form page
        request.getRequestDispatcher("Contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        
        // Validate input
        String error = null;
        if (fullName == null || fullName.trim().isEmpty()) {
            error = "Vui lòng nhập họ tên!";
        } else if (email == null || email.trim().isEmpty()) {
            error = "Vui lòng nhập email!";
        } else if (message == null || message.trim().isEmpty()) {
            error = "Vui lòng nhập nội dung liên hệ!";
        }
        
        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("subject", subject);
            request.setAttribute("message", message);
            request.getRequestDispatcher("Contact.jsp").forward(request, response);
            return;
        }
        
        // Insert into database
        ContactDAO dao = new ContactDAO();
        boolean success = dao.insertContact(fullName.trim(), email.trim(), 
                                            subject != null ? subject.trim() : null, 
                                            message.trim());
        
        if (success) {
            request.setAttribute("success", "Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất có thể.");
            request.getRequestDispatcher("Contact.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi gửi liên hệ. Vui lòng thử lại!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("subject", subject);
            request.setAttribute("message", message);
            request.getRequestDispatcher("Contact.jsp").forward(request, response);
        }
    }
}



