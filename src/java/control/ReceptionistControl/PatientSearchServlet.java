package control;

import dao.Receptionist.PatientDAO;
import entity.Receptionist.Patient;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * PatientSearchServlet:
 * Xử lý chức năng xem và tìm kiếm bệnh nhân (Receptionist module)
 * 
 * - URL: /Patient-Search
 *
 * @author Kiên
 */
@WebServlet("/Patient-Search")
public class PatientSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Gọi lại doPost để tránh trùng logic
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        keyword = (keyword != null) ? keyword.trim() : "";

        PatientDAO dao = new PatientDAO();
        List<Patient> list;

        try {
            if (keyword.isEmpty()) {
                // Không nhập gì → hiển thị toàn bộ danh sách
                list = dao.getAllPatients();
            } else {
                // Có nhập từ khóa → tìm kiếm
                list = dao.searchPatients(keyword);

                // Nếu không tìm thấy → hiển thị thông báo
                if (list == null || list.isEmpty()) {
                    list = dao.getAllPatients();
                    request.setAttribute("warning", "Không tìm thấy bệnh nhân cho từ khóa \"" + keyword + "\".");
                    keyword = ""; // reset ô input
                }
            }

            // Gửi dữ liệu sang JSP
            request.setAttribute("keyword", keyword);
            request.setAttribute("patients", list);
            request.getRequestDispatcher("/receptionist/PatientSearch.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải dữ liệu bệnh nhân!");
        }
    }
}
