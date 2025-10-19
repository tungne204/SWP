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
import java.util.Date;

/**
 * Update appointment information
 *
 * @author Kiên
 *
 * URL: /Appointment-Update
 */
@WebServlet(name = "UpdateAppointmentServlet", urlPatterns = {"/Appointment-Update"})
public class UpdateAppointmentServlet extends HttpServlet {

    //Khi user gửi GET (hoặc gõ URL trực tiếp) → tự động gọi lại doPost()
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    //Xử lý chính trong doPost
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Kiểm tra hành động người dùng gửi
            String action = request.getParameter("action");

            AppointmentDAO dao = new AppointmentDAO();

            if ("load".equals(action)) {
                // Gửi form "Edit" → load dữ liệu lên form
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                Appointment appointment = dao.getAppointmentById(appointmentId);
                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("/receptionist/updateAppointment.jsp").forward(request, response);

            } else if ("update".equals(action)) {
                // Gửi form "Save Changes" → cập nhật DB
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                int patientId = Integer.parseInt(request.getParameter("patientId"));
                int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                String dateTimeStr = request.getParameter("dateTime");
                boolean status = Boolean.parseBoolean(request.getParameter("status"));

                Date dateTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(dateTimeStr);

                Appointment appointment = new Appointment();
                appointment.setAppointmentId(appointmentId);
                appointment.setPatientId(patientId);
                appointment.setDoctorId(doctorId);
                appointment.setDateTime(dateTime);
                appointment.setStatus(status);
                dao.updateAppointment(appointment);
                System.out.println(">>> [DEBUG] Update success for ID=" + appointmentId);
                response.sendRedirect(request.getContextPath() + "/Appointment-List");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
} 