package control;

import dao.StatisticsDAO;
import entity.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ManagerStatisticsServlet", urlPatterns = {"/manager/statistics"})
public class ManagerStatisticsServlet extends HttpServlet {

    private StatisticsDAO statisticsDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        statisticsDAO = new StatisticsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is admin/manager
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        // Check admin/manager role (roleId = 1)
        User user = (User) session.getAttribute("acc");
        if (user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/403.jsp");
            return;
        }

        try {
            // Get all statistics data
            int totalPatients = statisticsDAO.getTotalPatients();
            int totalAppointments = statisticsDAO.getTotalAppointments();
            int activeAppointments = statisticsDAO.getActiveAppointments();
            int totalDoctors = statisticsDAO.getTotalDoctors();
            int recentAppointments = statisticsDAO.getRecentAppointments();
            double totalRevenue = statisticsDAO.getTotalRevenue();
            double currentMonthRevenue = statisticsDAO.getMonthlyRevenue();
            Map<Integer, Double> monthlyRevenue = statisticsDAO.getMonthlyRevenueByMonth();
            
            List<Map<String, Object>> appointmentsByStatus = statisticsDAO.getAppointmentsByStatus();
            List<Map<String, Object>> topDoctors = statisticsDAO.getTopDoctorsByAppointments();
            List<Map<String, Object>> paymentMethods = statisticsDAO.getPaymentMethodDistribution();

            // Set attributes for JSP
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("activeAppointments", activeAppointments);
            request.setAttribute("totalDoctors", totalDoctors);
            request.setAttribute("recentAppointments", recentAppointments);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("currentMonthRevenue", currentMonthRevenue);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("appointmentsByStatus", appointmentsByStatus);
            request.setAttribute("topDoctors", topDoctors);
            request.setAttribute("paymentMethods", paymentMethods);

            // Forward to JSP
            request.getRequestDispatcher("/admin/statistics-report.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading statistics: " + e.getMessage());
            request.getRequestDispatcher("/admin/statistics-report.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET
        doGet(request, response);
    }
}