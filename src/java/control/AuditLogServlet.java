package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "AuditLogServlet", urlPatterns = {"/audit-logs"})
public class AuditLogServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listAuditLogs(request, response);
                break;
            case "view":
                viewAuditLog(request, response);
                break;
            case "export":
                exportAuditLogs(request, response);
                break;
            default:
                listAuditLogs(request, response);
                break;
        }
    }
    
    private void listAuditLogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // For now, create sample audit log data
            // In a real implementation, this would come from a database
            List<AuditLogEntry> auditLogs = getSampleAuditLogs();
            
            request.setAttribute("auditLogs", auditLogs);
            request.getRequestDispatcher("AuditLogs.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving audit logs");
        }
    }
    
    private void viewAuditLog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String logId = request.getParameter("id");
            // In a real implementation, retrieve specific log entry from database
            AuditLogEntry logEntry = getSampleAuditLogById(logId);
            
            request.setAttribute("logEntry", logEntry);
            request.getRequestDispatcher("AuditLogView.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving audit log");
        }
    }
    
    private void exportAuditLogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"audit_logs.csv\"");
            
            // Sample CSV export
            response.getWriter().println("ID,User,Action,Timestamp,IP Address,Details");
            List<AuditLogEntry> logs = getSampleAuditLogs();
            for (AuditLogEntry log : logs) {
                response.getWriter().printf("%s,%s,%s,%s,%s,%s%n",
                    log.getId(), log.getUser(), log.getAction(), 
                    log.getTimestamp(), log.getIpAddress(), log.getDetails());
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error exporting audit logs");
        }
    }
    
    // Sample data methods - replace with actual database operations
    private List<AuditLogEntry> getSampleAuditLogs() {
        List<AuditLogEntry> logs = new ArrayList<>();
        logs.add(new AuditLogEntry("1", "admin", "LOGIN", new Date(), "192.168.1.100", "Successful login"));
        logs.add(new AuditLogEntry("2", "manager", "CREATE_USER", new Date(), "192.168.1.101", "Created new doctor account"));
        logs.add(new AuditLogEntry("3", "admin", "UPDATE_PERMISSION", new Date(), "192.168.1.100", "Updated user permissions"));
        logs.add(new AuditLogEntry("4", "doctor1", "VIEW_PATIENT", new Date(), "192.168.1.102", "Accessed patient record #123"));
        logs.add(new AuditLogEntry("5", "manager", "DELETE_USER", new Date(), "192.168.1.101", "Deleted inactive user account"));
        return logs;
    }
    
    private AuditLogEntry getSampleAuditLogById(String id) {
        List<AuditLogEntry> logs = getSampleAuditLogs();
        return logs.stream()
                .filter(log -> log.getId().equals(id))
                .findFirst()
                .orElse(null);
    }
    
    // Inner class for audit log entries
    public static class AuditLogEntry {
        private String id;
        private String user;
        private String action;
        private Date timestamp;
        private String ipAddress;
        private String details;
        
        public AuditLogEntry(String id, String user, String action, Date timestamp, String ipAddress, String details) {
            this.id = id;
            this.user = user;
            this.action = action;
            this.timestamp = timestamp;
            this.ipAddress = ipAddress;
            this.details = details;
        }
        
        // Getters
        public String getId() { return id; }
        public String getUser() { return user; }
        public String getAction() { return action; }
        public Date getTimestamp() { return timestamp; }
        public String getIpAddress() { return ipAddress; }
        public String getDetails() { return details; }
        
        // Setters
        public void setId(String id) { this.id = id; }
        public void setUser(String user) { this.user = user; }
        public void setAction(String action) { this.action = action; }
        public void setTimestamp(Date timestamp) { this.timestamp = timestamp; }
        public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
        public void setDetails(String details) { this.details = details; }
    }
    
    @Override
    public String getServletInfo() {
        return "Audit Log Servlet";
    }
}