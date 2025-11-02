/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control.ReceptionistControl;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.Receptionist.AppointmentDAO;
import jakarta.servlet.*;

/**
 * Handling status change requests
 *
 * URL: /Appointment-Status
 *
 * @author Kiên
 */
@WebServlet("/Appointment-Status")
public class AppointmentStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int appointmentId = Integer.parseInt(req.getParameter("id"));
        String newStatus = req.getParameter("status");  // lấy thẳng từ dropdown

        AppointmentDAO dao = new AppointmentDAO();
        dao.updateStatus(appointmentId, newStatus);

        resp.sendRedirect("Appointment-List");
    }
}

/**
 * Tạm thời để kiểu boolean ở class AppointmentDAO.java trong package dao true:
 * Confirmed (hoặc Completed) false: Pending (hoặc Canceled) sau này sửa thành
 * string vì còn nhiều trạng thái ví dụ:(Pending, Confirmed, Canceled,
 * Completed).
 *
 */
