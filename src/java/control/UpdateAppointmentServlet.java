/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control;

import dao.Receptionist.AppointmentDAO;
import entity.Receptionist.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Servlet xử lý cập nhật thông tin lịch hẹn (Appointment) - Load form chỉnh sửa
 * - Lưu thay đổi xuống database
 *
 * URL: /Appointment-Update
 *
 * @author Kiên
 */
@WebServlet(name = "UpdateAppointmentServlet", urlPatterns = {"/Appointment-Update"})
public class UpdateAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");
            AppointmentDAO dao = new AppointmentDAO();

            // 1️⃣ Khi người dùng nhấn "Edit" → load dữ liệu ra form
            if ("load".equalsIgnoreCase(action)) {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                Appointment appointment = dao.getAppointmentById(appointmentId);

                if (appointment == null) {
                    request.setAttribute("error", "Appointment not found!");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }

                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("/receptionist/updateAppointment.jsp").forward(request, response);
            } //Khi người dùng nhấn "Save Changes" -> cập nhật database
            else if ("update".equalsIgnoreCase(action)) {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                int patientId = Integer.parseInt(request.getParameter("patientId"));
                int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                String dateTimeStr = request.getParameter("dateTime");
                boolean status = Boolean.parseBoolean(request.getParameter("status"));

                // Chuyển định dạng ngày giờ HTML5 về dạng Date Java
                Date dateTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(dateTimeStr);

                // Gán vào entity
                Appointment ap = new Appointment();
                ap.setAppointmentId(appointmentId);
                ap.setPatientId(patientId);
                ap.setDoctorId(doctorId);
                ap.setDateTime(dateTime);
                ap.setStatus(status);

                // Cập nhật DB
                dao.updateAppointment(ap);
                System.out.println("[INFO] Appointment updated successfully, ID=" + appointmentId);

                // Quay về danh sách
                response.sendRedirect(request.getContextPath() + "/Appointment-List");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
