package control;

import dao.ContactDAO;
import entity.Contact;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ContactManageServlet", urlPatterns = {"/manage-contacts"})
public class ContactManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("acc");
        // Check if user is receptionist (role_id = 5)
        if (user.getRoleId() != 5) {
            response.sendRedirect("403.jsp");
            return;
        }
        
        ContactDAO dao = new ContactDAO();
        List<Contact> contacts = dao.getAllContacts();
        
        request.setAttribute("contacts", contacts);
        request.getRequestDispatcher("receptionist/manage-contacts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("acc");
        // Check if user is receptionist (role_id = 5)
        if (user.getRoleId() != 5) {
            response.sendRedirect("403.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("markReviewed".equals(action)) {
            String contactIdStr = request.getParameter("contactId");
            if (contactIdStr != null && !contactIdStr.isEmpty()) {
                try {
                    int contactId = Integer.parseInt(contactIdStr);
                    ContactDAO dao = new ContactDAO();
                    boolean success = dao.updateStatus(contactId, "reviewed");
                    
                    if (success) {
                        request.setAttribute("success", "Đã đánh dấu liên hệ là đã đọc!");
                    } else {
                        request.setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái!");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID liên hệ không hợp lệ!");
                }
            }
        }
        
        // Redirect back to contact list
        response.sendRedirect("manage-contacts");
    }
}







