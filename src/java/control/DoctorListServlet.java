package control;

import dao.DoctorDAO;
import entity.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DoctorListServlet", urlPatterns = {"/doctorList"})
public class DoctorListServlet extends HttpServlet {

    private static final int DOCTORS_PER_PAGE = 4;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String searchName = request.getParameter("searchName");
        String sortOrder = request.getParameter("sortOrder"); // "asc" or "desc"
        
        // Get page number
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        DoctorDAO doctorDAO = new DoctorDAO();
        
        // Get total count
        int totalDoctors = doctorDAO.getTotalDoctors(searchName);
        int totalPages = (int) Math.ceil((double) totalDoctors / DOCTORS_PER_PAGE);
        
        // Get doctors for current page
        List<Doctor> doctors = doctorDAO.getAllDoctorsWithPagination(searchName, sortOrder, page, DOCTORS_PER_PAGE);
        
        request.setAttribute("doctors", doctors);
        request.setAttribute("searchName", searchName != null ? searchName : "");
        request.setAttribute("sortOrder", sortOrder != null ? sortOrder : "");
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalDoctors", totalDoctors);
        
        request.getRequestDispatcher("doctorList.jsp").forward(request, response);
    }
}
