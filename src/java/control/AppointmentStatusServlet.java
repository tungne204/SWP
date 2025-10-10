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
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.AppointmentDAO;
import jakarta.servlet.*;

/**
 * Handling status change requests
 *
 * @author Kiên
 */
@WebServlet(name = "AppointmentStatusServlet", urlPatterns = {"/AppointmentStatusServlet"})
public class AppointmentStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        String newStatus = request.getParameter("status");

        AppointmentDAO dao = new AppointmentDAO();
        boolean success = dao.updateAppointmentStatus(appointmentId, newStatus);

        if (success) {
            request.setAttribute("message", "Appointment status updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update appointment status.");
        }

        // Quay lại trang danh sách sau khi cập nhật
        request.getRequestDispatcher("appointmentList.jsp").forward(request, response);
    }

}
/**
 * Tạm thời để kiểu boolean ở class AppointmentDAO.java trong package dao
 * true: Confirmed (hoặc Completed) 
 * false: Pending (hoặc Canceled)
 * sau này sửa thành
 * string vì còn nhiều trạng thái ví dụ:(Pending, Confirmed, Canceled,
 * Completed).
 *
 */
