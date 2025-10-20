/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control;

import dao.Receptionist.AppointmentDAO;
import entity.Receptionist.Appointment;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet hiển thị danh sách lịch hẹn cho lễ tân (Receptionist) Cho phép xem
 * thông tin bệnh nhân, bác sĩ và trạng thái khám bệnh.
 *
 * URL: /Appointment-List
 *
 * @author Kiên
 */
@WebServlet("/Appointment-List")
public class ViewAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
