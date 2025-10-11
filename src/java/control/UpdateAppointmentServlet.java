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
import java.text.SimpleDateFormat;


/**
 * Update appointment information
 * @author Kiên
 */
@WebServlet(name="UpdateAppointmentServlet", urlPatterns={"/UpdateAppointmentServlet"})
public class UpdateAppointmentServlet extends HttpServlet {
   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String dateTimeStr = request.getParameter("dateTime");
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            java.util.Date dateTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(dateTimeStr);

            Appointment appointment = new Appointment();
            appointment.setAppointmentId(appointmentId);
            appointment.setPatientId(patientId);
            appointment.setDoctorId(doctorId);
            appointment.setDateTime(dateTime);
            appointment.setStatus(status);

            AppointmentDAO dao = new AppointmentDAO();
            dao.updateAppointment(appointment);

            response.sendRedirect("ViewAppointmentServlet");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
