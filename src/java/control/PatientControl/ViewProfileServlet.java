/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control.PatientControl;

/*
 * Servlet hiển thị thông tin chi tiết bệnh nhân (View Profile)
 * URL: /View-Profile
 */
import dao.Receptionist.PatientDAO;
import entity.Receptionist.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ViewProfileServlet", urlPatterns = {"/View-Profile"})
public class ViewProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy ID bệnh nhân từ URL: /View-Profile?id=123
            String idRaw = request.getParameter("id");
            if (idRaw == null) {
                request.setAttribute("error", "Patient ID is missing!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            int id = Integer.parseInt(idRaw);

            // Gọi DAO lấy thông tin bệnh nhân
            PatientDAO dao = new PatientDAO();
            Patient patient = dao.getPatientById(id);

            if (patient == null) {
                request.setAttribute("error", "Patient not found!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Gửi dữ liệu sang JSP
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/patient/viewProfile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading patient profile.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
