package control.DoctorSideBar;

import dao.Receptionist.PatientDAO;
import entity.Receptionist.Patient;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * PatientSearchDServlet: Tìm kiếm & hiển thị danh sách bệnh nhân (có phân trang)
 * URL: /Patient-Search
 *
 * @author Kiên
 */
@WebServlet("/Patient-SearchD")
public class PatientSearchDServlet extends HttpServlet {

    private static final int RECORDS_PER_PAGE = 8;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";
        keyword = keyword.trim();

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        PatientDAO dao = new PatientDAO();
        List<Patient> list;
        int totalRecords;

        try {
            if (keyword.isBlank()) {
                totalRecords = dao.countAllPatients();
                list = dao.getPatientsByPage((page - 1) * RECORDS_PER_PAGE, RECORDS_PER_PAGE);
            } else {
                totalRecords = dao.countSearchPatients(keyword);
                list = dao.searchPatientsByPage(keyword, (page - 1) * RECORDS_PER_PAGE, RECORDS_PER_PAGE);
            }

            int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);

            request.setAttribute("keyword", keyword);
            request.setAttribute("patients", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/receptionist/doctor/PatientSearch.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải dữ liệu bệnh nhân!");
        }
    }
}
