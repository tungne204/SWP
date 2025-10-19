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
 * URL: /Appointment-Status
 *
 * @author Kiên
 */
@WebServlet(name = "AppointmentStatusServlet", urlPatterns = {"/Appointment-Status"})
public class AppointmentStatusServlet extends HttpServlet {

    // Xử lý yêu cầu GET (khi truy cập trực tiếp bằng URL)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Gọi lại doPost để xử lý tương tự
        doPost(request, response);
    }

    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));

        AppointmentDAO dao = new AppointmentDAO();
        dao.updateAppointmentStatus(appointmentId, newStatus);

        // Quay lại trang danh sách sau khi cập nhật
        response.sendRedirect("Appointment-List");
    }

}
/**
 * Tạm thời để kiểu boolean ở class AppointmentDAO.java trong package dao true:
 * Confirmed (hoặc Completed) false: Pending (hoặc Canceled) sau này sửa thành
 * string vì còn nhiều trạng thái ví dụ:(Pending, Confirmed, Canceled,
 * Completed).
 *
 */
