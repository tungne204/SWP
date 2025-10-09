package control;

import dao.PatientDAO;
import entity.Patient;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/PatientSearchServlet")
public class PatientSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        PatientDAO dao = new PatientDAO();
        List<Patient> list;

//        if (keyword != null && !keyword.trim().isEmpty()) {
//            list = dao.searchPatients(keyword);
//        } else {
//            list = dao.getAllPatients();
//        }
//
//        request.setAttribute("patients", list);
//        request.setAttribute("keyword", keyword);
//        request.getRequestDispatcher("patientSearch.jsp").forward(request, response);
    }
}
