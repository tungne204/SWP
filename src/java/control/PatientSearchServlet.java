package control;

import dao.PatientDAO;
import entity.Patient;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * Servlet handles View/Search Patient function For Receptionist module in SWP
 * system - Displays the entire patient list - Search by name, ID, or address
 *
 * URL: /PatientSearchServlet
 *
 * @author Kiên
 */
@WebServlet("/Patient-Search")
public class PatientSearchServlet extends HttpServlet {
    // Khi người dùng gõ trực tiếp URL (GET)

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang danh sách Patient và tìm kiếm Patient
        PatientDAO dao = new PatientDAO();
        List<Patient> list = dao.getAllPatients();   // <-- Lấy toàn bộ danh sách bệnh nhân
        request.setAttribute("patients", list);
        request.getRequestDispatcher("/Receptionist/Search.jsp").forward(request, response);
        request.getRequestDispatcher("/Receptionist/Search.jsp").forward(request, response);
    }

    // Khi người dùng nhấn "Search" tránh làm lộ thông tin nhạy cảm(Sensitive data) của khách hàng lên thanh URL (POST)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");

        // ✅ Kiểm tra nếu người dùng chưa nhập gì
        if (keyword == null || keyword.trim().isEmpty()) {
            request.getRequestDispatcher("/Receptionist/Search.jsp").forward(request, response);
            return; // dừng xử lý luôn
        }

        PatientDAO dao = new PatientDAO();
        List<Patient> list;

        try {
            list = dao.searchPatients(keyword);

            request.setAttribute("patients", list);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/Receptionist/Search.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu bệnh nhân!");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

}
