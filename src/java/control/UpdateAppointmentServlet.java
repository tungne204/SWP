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

        response.setContentType("text/plain");
        
        try {
            // Get parameters with validation
            String appointmentIdStr = request.getParameter("appointmentId");
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String dateTimeStr = request.getParameter("dateTime");
            
            // Validate required parameters
            if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Appointment ID is required");
                return;
            }
            
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Patient ID is required");
                return;
            }
            
            if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Doctor ID is required");
                return;
            }
            
            if (dateTimeStr == null || dateTimeStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Date and time is required");
                return;
            }
            
            // Parse parameters
            int appointmentId = Integer.parseInt(appointmentIdStr);
            int patientId = Integer.parseInt(patientIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            
            // Parse datetime
            java.util.Date dateTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(dateTimeStr);
            
            // Validate datetime is in the future
            if (dateTime.before(new java.util.Date())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Appointment date must be in the future");
                return;
            }

            // Create appointment object (without status - patients can't change status)
            entity.Appointment appointment = new entity.Appointment();
            appointment.setAppointmentId(appointmentId);
            appointment.setPatientId(patientId);
            appointment.setDoctorId(doctorId);
            appointment.setDateTime(dateTime);
            // Don't set status - keep existing status

            // Update appointment
            dao.AppointmentDAO dao = new dao.AppointmentDAO();
            dao.updateAppointment(appointment);
            
            // If no exception thrown, update was successful
            response.getWriter().write("success");

        } catch (NumberFormatException e) {
            System.err.println("NumberFormatException in UpdateAppointmentServlet: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid number format");
        } catch (java.text.ParseException e) {
            System.err.println("ParseException in UpdateAppointmentServlet: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid date format");
        } catch (Exception e) {
            System.err.println("Exception in UpdateAppointmentServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Internal server error: " + e.getMessage());
        }
    }
}
