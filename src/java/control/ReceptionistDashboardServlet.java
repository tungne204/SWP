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
import jakarta.servlet.http.HttpSession;

/**
 * ReceptionistDashboardServlet: - Là servlet chính của module Receptionist -
 * Chuyển hướng đến trang dashboard giao diện chính
 *
 * @author Kiên
 *
 * URL: /Receptionist-Dashboard
 *
 */
@WebServlet(name = "ReceptionistDashboardServlet", urlPatterns = {"/Receptionist-Dashboard"})
public class ReceptionistDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }

    // Chuyển tất cả POST về GET để tránh lỗi
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/receptionist/ReceptionistDashboard.jsp").forward(request, response);
// Sau này khi có Auth Filter thì mở đoạn dưới ra:
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("userRole") == null
//                || !"Receptionist".equals(session.getAttribute("userRole"))) {
//            response.sendRedirect("Login.jsp");
//            return;
//        }
//
//        // Mặc định hiển thị trang PatientSearch đầu tiên
//        request.setAttribute("page", "PatientSearch.jsp");
//        request.getRequestDispatcher("/receptionist/ReceptionistDashboard.jsp").forward(request, response);
    }
}
