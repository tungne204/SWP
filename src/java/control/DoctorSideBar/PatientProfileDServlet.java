/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control.DoctorSideBar;

import dao.Receptionist.PatientDAO;
import entity.Receptionist.Patient;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Hiển thị thông tin chi tiết bệnh nhân
 * URL: /Patient-Profile
 *
 * @author Kiên
 */
@WebServlet("/Patient-ProfileD")
public class PatientProfileDServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendRedirect("Patient-SearchD");
            return;
        }

        try {
            PatientDAO dao = new PatientDAO();
            Patient patient = dao.getPatientById(Integer.parseInt(id));

            if (patient == null) {
                request.setAttribute("error", "Không tìm thấy bệnh nhân ID: " + id);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/receptionist/doctor/PatientProfile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải thông tin bệnh nhân!");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
}
