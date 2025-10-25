package control.PatientControl;

import dao.PatientDAO;
import entity.Patient;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet hiển thị thông tin chi tiết bệnh nhân (View Profile)
 * URL: /View-Profile
 * @author Kiên
 */
@WebServlet(name = "ViewProfileServlet", urlPatterns = {"/View-Profile"})
public class ViewProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        User user = (User) session.getAttribute("acc");

        // Chỉ cho phép bệnh nhân (role_id = 3)
        if (user.getRoleId() != 3) {
            response.sendRedirect("403.jsp");
            return;
        }

        handleViewProfile(request, response, user);
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

        if (user.getRoleId() != 3) {
            response.sendRedirect("403.jsp");
            return;
        }

        handleViewProfile(request, response, user);
    }

    /**
     * Hàm xử lý chính để hiển thị hồ sơ bệnh nhân
     */
    private void handleViewProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        try {
            int userId = user.getUserId();
            PatientDAO dao = new PatientDAO();
            Patient patient = dao.getPatientByUserID2(userId);

            if (patient == null) {
                request.setAttribute("error", "Không tìm thấy hồ sơ bệnh nhân!");
                request.getRequestDispatcher("Home.jsp").forward(request, response);
                return;
            }

            //Gửi dữ liệu sang JSP
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/patient/viewProfile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải hồ sơ bệnh nhân: " + e.getMessage());
            request.getRequestDispatcher("Home.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet hiển thị hồ sơ bệnh nhân (View Profile)";
    }
}
