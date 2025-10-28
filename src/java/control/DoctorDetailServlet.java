package control;

import dao.DoctorDAO;
import entity.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DoctorDetailServlet", urlPatterns = {"/doctorDetail"})
public class DoctorDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String doctorIdParam = request.getParameter("doctorId");
        
        if (doctorIdParam == null || doctorIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy thông tin bác sĩ");
            request.getRequestDispatcher("doctorList.jsp").forward(request, response);
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(doctorIdParam);
            
            DoctorDAO doctorDAO = new DoctorDAO();
            Doctor doctor = doctorDAO.getDoctorByIdWithUserInfo(doctorId);
            
            if (doctor == null) {
                request.setAttribute("errorMessage", "Không tìm thấy bác sĩ với ID: " + doctorId);
                request.getRequestDispatcher("doctorList.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("doctorDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID bác sĩ không hợp lệ");
            request.getRequestDispatcher("doctorList.jsp").forward(request, response);
        }
    }
}

