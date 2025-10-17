/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package control;

import dao.viewSchedule.AppointmentDAO;
import entity.viewSchedule.Appointment;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Quang Anh
 */
@WebServlet(name="AppointmentServlet", urlPatterns={"/appointment"})
public class AppointmentServlet extends HttpServlet {
    private AppointmentDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new AppointmentDAO();
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
            out.println("<title>Servlet AppointmentServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AppointmentServlet at " + request.getContextPath () + "</h1>");
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
         String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listAppointments(request, response);
                break;
            case "by-date":
                listByDate(request, response);
                break;
            case "view":
                viewAppointment(request, response);
                break;
            case "pending":
                listPending(request, response);
                break;
            default:
                listAppointments(request, response);
                break;
        }
    } 
     private void listAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        
        if (doctorId == null) {
            doctorId = 1; // Giá trị mặc định để test
        }

        List<Appointment> appointments = dao.getAllByDoctorId(doctorId);
        request.setAttribute("appointments", appointments);
        request.setAttribute("viewType", "all");
        request.getRequestDispatcher("doctor/appointment-list.jsp").forward(request, response);
    }

    // Hiển thị appointments theo ngày
    private void listByDate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        
        if (doctorId == null) {
            doctorId = 1;
        }

        String date = request.getParameter("date");
        if (date == null || date.isEmpty()) {
            // Nếu không có date, redirect về list
            response.sendRedirect("appointment?action=list");
            return;
        }

        List<Appointment> appointments = dao.getByDoctorAndDate(doctorId, date);
        int count = dao.countByDoctorAndDate(doctorId, date);
        
        request.setAttribute("appointments", appointments);
        request.setAttribute("selectedDate", date);
        request.setAttribute("appointmentCount", count);
        request.setAttribute("viewType", "by-date");
        request.getRequestDispatcher("doctor/appointment-list.jsp").forward(request, response);
    }

    // Xem chi tiết appointment
    private void viewAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            
            Appointment appointment = dao.getById(appointmentId);
            
            if (appointment != null) {
                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("doctor/appointment-detail.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("message", "Không tìm thấy lịch hẹn!");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("appointment?action=list");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("appointment?action=list");
        }
    }

    // Hiển thị appointments chưa khám (chưa có medical report)
    private void listPending(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer doctorId = (Integer) session.getAttribute("doctorId");
        
        if (doctorId == null) {
            doctorId = 1;
        }

        List<Appointment> appointments = dao.getPendingByDoctorId(doctorId);
        request.setAttribute("appointments", appointments);
        request.setAttribute("viewType", "pending");
        request.getRequestDispatcher("doctor/appointment-list.jsp").forward(request, response);
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
