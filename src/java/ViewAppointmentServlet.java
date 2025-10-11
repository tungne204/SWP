/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.AppointmentDAO;
import entity.Appointment;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.List;

/**
 * Display a list of all appointments
 * @author Kiên
 */
@WebServlet(urlPatterns={"/ViewAppointmentServlet"})
public class ViewAppointmentServlet extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AppointmentDAO dao = new AppointmentDAO();
        List<Appointment> appointments = dao.getAppointmentsByDateRange(
                new java.util.Date(System.currentTimeMillis() - 7L * 24 * 60 * 60 * 1000), // 7 ngày trước
                new java.util.Date(System.currentTimeMillis() + 7L * 24 * 60 * 60 * 1000)   // 7 ngày sau
        );

        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("appointmentList.jsp").forward(request, response);
    } 
}
