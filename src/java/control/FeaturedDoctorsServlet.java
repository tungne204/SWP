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

@WebServlet(name = "FeaturedDoctorsServlet", urlPatterns = {"/featuredDoctors"})
public class FeaturedDoctorsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Enable CORS
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            DoctorDAO doctorDAO = new DoctorDAO();
            List<Doctor> featuredDoctors = doctorDAO.getFeaturedDoctors(3);
            
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < featuredDoctors.size(); i++) {
            Doctor d = featuredDoctors.get(i);
            json.append("{");
            json.append("\"doctorId\":").append(d.getDoctorId()).append(",");
            json.append("\"username\":\"").append(escapeJson(d.getUsername())).append("\",");
            json.append("\"avatar\":\"").append(escapeJson(d.getAvatar())).append("\",");
            json.append("\"experienceYears\":").append(d.getExperienceYears());
            json.append("}");
            if (i < featuredDoctors.size() - 1) json.append(",");
        }
        json.append("]");
            
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}

