/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control.ReceptionistControl;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * ReceptionistDashboardServlet: - Là servlet chính của module Receptionist -
 * Dùng để điều hướng đến trang Dashboard giao diện chính
 *
 * URL: /Receptionist-Dashboard
 *
 * @author Kiên
 */
@WebServlet(name = "ReceptionistDashboardServlet", urlPatterns = {"/Receptionist-Dashboard"})
public class ReceptionistDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/receptionist/ReceptionistDashboard.jsp").forward(request, response);

    }
}
