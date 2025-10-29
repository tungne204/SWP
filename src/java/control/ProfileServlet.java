package control;

import dao.DoctorDAO;
import dao.UserDAO;
import entity.Doctor;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/viewProfile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("Login");
            return;
        }
        
        User user = (User) session.getAttribute("acc");
        
        // Lấy thông tin user đầy đủ từ database để có role name
        UserDAO userDAO = new UserDAO();
        User fullUser = userDAO.findByEmail(user.getEmail());
        if (fullUser != null) {
            // Cập nhật session với thông tin đầy đủ
            session.setAttribute("acc", fullUser);
        }
        
        // Nếu user là Doctor (role_id = 2), lấy thông tin Doctor
        if (fullUser.getRoleId() == 2) {
            DoctorDAO doctorDAO = new DoctorDAO();
            Doctor doctor = doctorDAO.getDoctorByUserId(fullUser.getUserId());
            if (doctor != null) {
                request.setAttribute("doctorInfo", doctor);
            }
        }
        
        request.getRequestDispatcher("viewProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

