package control;

import dao.PatientDAO;
import entity.Patient;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * Servlet handles View/Search Patient 
 * function For Receptionist module in SWP
 * system - Displays the entire patient list -
 * Search by name, ID, or address
 *
 * URL: /PatientSearchServlet
 */
@WebServlet("/PatientSearchServlet")
public class PatientSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        PatientDAO dao = new PatientDAO();
        List<Patient> list;

        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = dao.searchPatients(keyword);
            } else {
                list = dao.getAllPatients();
            }

            request.setAttribute("patients", list);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("Receptionist/Search.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu bệnh nhân!");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
