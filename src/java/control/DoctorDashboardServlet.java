/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package control;

import dao.AppointmentDAO;
import dao.MedicalReportDAO;
import dao.TestResultDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Quang Anh
 */
@WebServlet(name="DoctorDashboardServlet", urlPatterns={"/doctor-dashboard"})
public class DoctorDashboardServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private MedicalReportDAO medicalReportDAO;
    private TestResultDAO testResultDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        medicalReportDAO = new MedicalReportDAO();
        testResultDAO = new TestResultDAO();
    }
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DoctorDashboardServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DoctorDashboardServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        
        // Default doctor ID for testing
        if (doctorId == null) {
            doctorId = 1;
        }

        // Get today's date
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date());

        try {
            // Statistics for cards
            int todayAppointments = appointmentDAO.countByDoctorAndDate(doctorId, today);
            int pendingPatients = appointmentDAO.getPendingByDoctorId(doctorId).size();
            
            // Count medical reports this week (simplified: last 7 days)
            int weeklyReports = medicalReportDAO.getAllByDoctorId(doctorId).size(); // Simplified
            
            // Count pending tests (reports with test_request = true but no test results yet)
            int pendingTests = countPendingTests(doctorId);
            
            // Monthly statistics
            int monthlyPatients = appointmentDAO.getAllByDoctorId(doctorId).size(); // Simplified
            int monthlyReports = medicalReportDAO.getAllByDoctorId(doctorId).size();
            int monthlyTests = testResultDAO.getAllByDoctorId(doctorId).size();
            
            // Completed appointments today
            int completedToday = todayAppointments - pendingPatients;

            // Set attributes
            request.setAttribute("todayAppointments", todayAppointments);
            request.setAttribute("pendingPatients", pendingPatients);
            request.setAttribute("weeklyReports", weeklyReports);
            request.setAttribute("pendingTests", pendingTests);
            request.setAttribute("monthlyPatients", monthlyPatients);
            request.setAttribute("monthlyReports", monthlyReports);
            request.setAttribute("monthlyTests", monthlyTests);
            request.setAttribute("completedToday", Math.max(0, completedToday));

            // Forward to JSP
            request.getRequestDispatcher("doctor/doctorDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Set default values on error
            request.setAttribute("todayAppointments", 0);
            request.setAttribute("pendingPatients", 0);
            request.setAttribute("weeklyReports", 0);
            request.setAttribute("pendingTests", 0);
            request.getRequestDispatcher("doctorDashboard.jsp").forward(request, response);
        }
    }

    // Helper method to count pending tests
    private int countPendingTests(int doctorId) {
        try {
            // Get all medical reports of doctor with test_request = true
            // Then count how many don't have test results yet
            int count = 0;
            var reports = medicalReportDAO.getAllByDoctorId(doctorId);
            for (var report : reports) {
                if (report.isTestRequest()) {
                    // Check if this record has test results
                    int testCount = testResultDAO.countByRecordId(report.getRecordId());
                    if (testCount == 0) {
                        count++;
                    }
                }
            }
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    
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
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
