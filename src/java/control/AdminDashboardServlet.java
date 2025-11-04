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
            // Get all statistics data with default values
            int totalPatients = 0;
            int totalDoctors = 0;
            int totalReceptionists = 0;
            int totalMedicalAssistants = 0;
            int totalBlogs = 0;
            int totalAppointments = 0;
            int activeAppointments = 0;
            int recentAppointments = 0;
            List<Map<String, Object>> appointmentsByStatus = new java.util.ArrayList<>();
            
            try {
                totalPatients = statisticsDAO.getTotalPatients();
            } catch (Exception e) {
                System.err.println("Error getting totalPatients: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                totalDoctors = statisticsDAO.getTotalDoctors();
            } catch (Exception e) {
                System.err.println("Error getting totalDoctors: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                totalReceptionists = statisticsDAO.getTotalReceptionists();
            } catch (Exception e) {
                System.err.println("Error getting totalReceptionists: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                totalMedicalAssistants = statisticsDAO.getTotalMedicalAssistants();
            } catch (Exception e) {
                System.err.println("Error getting totalMedicalAssistants: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                totalBlogs = blogDAO.getTotalBlogs();
            } catch (Exception e) {
                System.err.println("Error getting totalBlogs: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                totalAppointments = statisticsDAO.getTotalAppointments();
            } catch (Exception e) {
                System.err.println("Error getting totalAppointments: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                activeAppointments = statisticsDAO.getActiveAppointments();
            } catch (Exception e) {
                System.err.println("Error getting activeAppointments: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                recentAppointments = statisticsDAO.getRecentAppointments();
            } catch (Exception e) {
                System.err.println("Error getting recentAppointments: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                appointmentsByStatus = statisticsDAO.getAppointmentsByStatus();
                if (appointmentsByStatus == null) {
                    appointmentsByStatus = new java.util.ArrayList<>();
                }
            } catch (Exception e) {
                System.err.println("Error getting appointmentsByStatus: " + e.getMessage());
                e.printStackTrace();
            }
            
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
            System.err.println("Fatal error in AdminDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Set default values even on error
            request.setAttribute("totalPatients", 0);
            request.setAttribute("totalDoctors", 0);
            request.setAttribute("totalReceptionists", 0);
            request.setAttribute("totalMedicalAssistants", 0);
            request.setAttribute("totalBlogs", 0);
            request.setAttribute("totalAppointments", 0);
            request.setAttribute("activeAppointments", 0);
            request.setAttribute("recentAppointments", 0);
            request.setAttribute("appointmentsByStatus", new java.util.ArrayList<>());
            request.setAttribute("error", "Error loading dashboard: " + e.getMessage());
            
            try {
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard");
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET
        doGet(request, response);
    }
}

