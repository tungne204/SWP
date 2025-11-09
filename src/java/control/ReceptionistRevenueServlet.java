package control;

import dao.StatisticsDAO;
import context.DBContext;
import entity.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ReceptionistRevenueServlet", urlPatterns = {"/receptionist/revenue"})
public class ReceptionistRevenueServlet extends HttpServlet {

    private StatisticsDAO statisticsDAO;
    private DBContext dbContext;

    @Override
    public void init() throws ServletException {
        super.init();
        statisticsDAO = new StatisticsDAO();
        dbContext = new DBContext();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is receptionist
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        // Check receptionist role (roleId = 5)
        User user = (User) session.getAttribute("acc");
        if (user.getRoleId() != 5) {
            response.sendRedirect(request.getContextPath() + "/403.jsp");
            return;
        }

        try {
            // Get revenue statistics data
            double totalRevenue = statisticsDAO.getTotalRevenue();
            double currentMonthRevenue = statisticsDAO.getMonthlyRevenue();
            Map<Integer, Double> monthlyRevenue = statisticsDAO.getMonthlyRevenueByMonth();
            List<Map<String, Object>> paymentMethods = statisticsDAO.getPaymentMethodDistribution();
            
            // Get today's revenue
            double todayRevenue = getTodayRevenue();
            
            // Get revenue by day for current month (for detailed chart)
            Map<Integer, Double> dailyRevenue = getDailyRevenueForCurrentMonth();

            // Set attributes for JSP
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("currentMonthRevenue", currentMonthRevenue);
            request.setAttribute("todayRevenue", todayRevenue);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("dailyRevenue", dailyRevenue);
            request.setAttribute("paymentMethods", paymentMethods);

            // Forward to JSP
            request.getRequestDispatcher("/receptionist/revenue-management.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu doanh thu: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/revenue-management.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET
        doGet(request, response);
    }
    
    // Get today's revenue
    private double getTodayRevenue() {
        String sql = "SELECT SUM(amount) FROM Payment WHERE status = 1 AND CAST(payment_date AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double revenue = rs.getDouble(1);
                return rs.wasNull() ? 0.0 : revenue;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // Get daily revenue for current month
    private Map<Integer, Double> getDailyRevenueForCurrentMonth() {
        Map<Integer, Double> dailyRevenue = new HashMap<>();
        
        // Initialize all days with 0 (assuming max 31 days in a month)
        for (int i = 1; i <= 31; i++) {
            dailyRevenue.put(i, 0.0);
        }
        
        String sql = "SELECT DAY(payment_date) as day, SUM(amount) as revenue " +
                     "FROM Payment " +
                     "WHERE status = 1 AND MONTH(payment_date) = MONTH(GETDATE()) AND YEAR(payment_date) = YEAR(GETDATE()) " +
                     "GROUP BY DAY(payment_date)";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int day = rs.getInt("day");
                double revenue = rs.getDouble("revenue");
                dailyRevenue.put(day, revenue);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dailyRevenue;
    }
}

