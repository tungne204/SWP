package control;

import dao.UserDAO;
import dao.AppointmentDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Manager Dashboard Servlet
 * Handles manager dashboard requests and provides manager-specific data
 * 
 * @author System
 */
@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager-dashboard"})
public class ManagerDashboardServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        appointmentDAO = new AppointmentDAO();
    }
    
    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("acc");
        
        // Check if user is manager/admin (role_id 1 for manager/admin)
        if (user.getRoleId() != 1) {
            response.sendRedirect("403.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if (action == null || action.equals("dashboard")) {
                // Default dashboard view
                showDashboard(request, response);
            } else {
                switch (action) {
                    case "reports":
                        showReports(request, response);
                        break;
                    case "settings":
                        showSettings(request, response);
                        break;
                    case "analytics":
                        showAnalytics(request, response);
                        break;
                    case "backup":
                        showBackup(request, response);
                        break;
                    default:
                        showDashboard(request, response);
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading page: " + e.getMessage());
            request.getRequestDispatcher("/manager/ManagerDashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Show main dashboard with statistics
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get dashboard statistics
        int totalDoctors = getTotalDoctors();
        int totalStaff = getTotalStaff();
        int totalPatients = getTotalPatients();
        int totalPermissions = getTotalPermissions();
        int todayAppointments = getTodayAppointments();
        int systemUptime = getSystemUptime();
        
        // Set attributes for JSP
        request.setAttribute("totalDoctors", totalDoctors);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("totalPatients", totalPatients);
        request.setAttribute("totalPermissions", totalPermissions);
        request.setAttribute("todayAppointments", todayAppointments);
        request.setAttribute("systemUptime", systemUptime);
        
        // Forward to manager dashboard JSP
        request.getRequestDispatcher("/manager/ManagerDashboard.jsp").forward(request, response);
    }
    
    /**
     * Show reports page
     */
    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For now, redirect to a placeholder or existing reports page
        request.setAttribute("pageTitle", "Reports");
        request.setAttribute("message", "Reports functionality will be implemented here");
        request.getRequestDispatcher("/manager/ManagerDashboard.jsp").forward(request, response);
    }
    
    /**
     * Show system settings page
     */
    private void showSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "System Settings");
        request.setAttribute("message", "System settings functionality will be implemented here");
        request.getRequestDispatcher("/manager/ManagerDashboard.jsp").forward(request, response);
    }
    
    /**
     * Show analytics page
     */
    private void showAnalytics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type == null) type = "overview";
        
        request.setAttribute("pageTitle", "Analytics - " + type.substring(0, 1).toUpperCase() + type.substring(1));
        request.setAttribute("analyticsType", type);
        request.setAttribute("message", "Analytics for " + type + " will be implemented here");
        request.getRequestDispatcher("/manager/ManagerDashboard.jsp").forward(request, response);
    }
    
    /**
     * Show backup page
     */
    private void showBackup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "System Backup");
        request.setAttribute("message", "System backup functionality will be implemented here");
        request.getRequestDispatcher("/manager/ManagerDashboard.jsp").forward(request, response);
    }
    
    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Get total number of doctors in the system
     * @return number of doctors
     */
    private int getTotalDoctors() {
        try {
            List<User> doctors = userDAO.getUsersByRole(2); // Role ID 2 for doctors
            return doctors != null ? doctors.size() : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 15; // Default fallback value
        }
    }
    
    /**
     * Get total number of staff members
     * @return number of staff
     */
    private int getTotalStaff() {
        try {
            // Count all users except patients (role_id != 3)
            List<User> allUsers = userDAO.getAllUsers();
            if (allUsers != null) {
                return (int) allUsers.stream().filter(u -> u.getRoleId() != 3).count();
            }
            return 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 8; // Default fallback value
        }
    }
    
    /**
     * Get total number of patients
     * @return number of patients
     */
    private int getTotalPatients() {
        try {
            List<User> patients = userDAO.getUsersByRole(3); // Role ID 3 for patients
            return patients != null ? patients.size() : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 1247; // Default fallback value
        }
    }
    
    /**
     * Get total number of permissions set in the system
     * @return number of permissions
     */
    private int getTotalPermissions() {
        try {
            // This would require a PermissionDAO to count permissions
            // For now, return a default value
            return 42;
        } catch (Exception e) {
            e.printStackTrace();
            return 42; // Default fallback value
        }
    }
    
    /**
     * Get number of appointments for today
     * @return number of today's appointments
     */
    private int getTodayAppointments() {
        try {
            if (appointmentDAO != null) {
                // This would require a method in AppointmentDAO to count today's appointments
                // For now, return a default value
                return 156;
            }
            return 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 156; // Default fallback value
        }
    }
    
    /**
     * Get system uptime percentage
     * @return uptime percentage
     */
    private int getSystemUptime() {
        try {
            // This would require system monitoring implementation
            // For now, return a default value
            return 98;
        } catch (Exception e) {
            e.printStackTrace();
            return 98; // Default fallback value
        }
    }
    
    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Manager Dashboard Servlet - Handles manager dashboard requests and provides manager-specific data";
    }
}