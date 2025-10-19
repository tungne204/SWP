/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control;

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
@WebServlet(name = "ViewAppointmentServlet", urlPatterns = {"/ViewAppointmentServlet"})
public class ViewAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Ngăn trình duyệt cache trang cũ
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try {
            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> list = dao.getAllAppointments();

            request.setAttribute("appointments", list);
            request.getRequestDispatcher("/receptionist/appointmentList.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
