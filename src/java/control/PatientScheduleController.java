/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package control;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import entity.Appointment;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.sql.Date;
import java.util.List;

/**
 *
 * @author Quang Anh
 */
public class PatientScheduleController extends HttpServlet {
   private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
    }
    
    private int getDoctorIdByUserId(int userId) {
        return doctorDAO.getDoctorIdByUserId(userId);
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PatientScheduleController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PatientScheduleController at " + request.getContextPath () + "</h1>");
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
        User user = (User) session.getAttribute("acc");
        
        // Check if user is logged in and is a doctor
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get doctorId from Doctor table using user_id
        int doctorId = getDoctorIdByUserId(user.getUserId());
        
        String filterType = request.getParameter("filter");
        String dateParam = request.getParameter("date");
        String fromDateParam = request.getParameter("fromDate");
        String toDateParam = request.getParameter("toDate");
        
        List<Appointment> appointments;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        try {
            if ("date".equals(filterType) && dateParam != null && !dateParam.isEmpty()) {
                // Filter by specific date
                Date filterDate = new Date(sdf.parse(dateParam).getTime());
                appointments = appointmentDAO.getAppointmentsByDoctorIdAndDate(doctorId, filterDate);
                request.setAttribute("selectedDate", dateParam);
            } else if ("range".equals(filterType) && fromDateParam != null && 
                      toDateParam != null && !fromDateParam.isEmpty() && !toDateParam.isEmpty()) {
                // Filter by date range
                Date fromDate = new Date(sdf.parse(fromDateParam).getTime());
                Date toDate = new Date(sdf.parse(toDateParam).getTime());
                appointments = appointmentDAO.getAppointmentsByDoctorIdAndDateRange(doctorId, fromDate, toDate);
                request.setAttribute("selectedFromDate", fromDateParam);
                request.setAttribute("selectedToDate", toDateParam);
            } else {
                // Show all appointments
                appointments = appointmentDAO.getAppointmentsByDoctorId(doctorId);
            }
        } catch (ParseException e) {
            e.printStackTrace();
            appointments = appointmentDAO.getAppointmentsByDoctorId(doctorId);
            request.setAttribute("error", "Invalid date format. Showing all appointments.");
        }
        
        request.setAttribute("appointments", appointments);
        request.setAttribute("currentFilter", filterType);
        
        request.getRequestDispatcher("/patient-schedule.jsp")
                .forward(request, response);
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
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
