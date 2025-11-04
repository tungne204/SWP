package control;

import dao.StatisticsDAO;
import dao.BlogDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    
    private StatisticsDAO statisticsDAO;
    private BlogDAO blogDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        statisticsDAO = new StatisticsDAO();
        blogDAO = new BlogDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        // Check admin role (roleId = 1)
        User user = (User) session.getAttribute("acc");
        if (user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/403.jsp");
            return;
        }
        
        try {
            // Get all statistics data
            int totalPatients = statisticsDAO.getTotalPatients();
            int totalDoctors = statisticsDAO.getTotalDoctors();
            int totalReceptionists = statisticsDAO.getTotalReceptionists();
            int totalMedicalAssistants = statisticsDAO.getTotalMedicalAssistants();
            int totalBlogs = blogDAO.getTotalBlogs();
            
            // Get appointment statistics
            int totalAppointments = statisticsDAO.getTotalAppointments();
            int activeAppointments = statisticsDAO.getActiveAppointments();
            int recentAppointments = statisticsDAO.getRecentAppointments();
            List<Map<String, Object>> appointmentsByStatus = statisticsDAO.getAppointmentsByStatus();
            
            // Set attributes for JSP
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("totalDoctors", totalDoctors);
            request.setAttribute("totalReceptionists", totalReceptionists);
            request.setAttribute("totalMedicalAssistants", totalMedicalAssistants);
            request.setAttribute("totalBlogs", totalBlogs);
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("activeAppointments", activeAppointments);
            request.setAttribute("recentAppointments", recentAppointments);
            request.setAttribute("appointmentsByStatus", appointmentsByStatus);
            
            // Forward to JSP
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET
        doGet(request, response);
    }
}

