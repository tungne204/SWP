package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.DoctorDAO;
import entity.Doctor;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "DoctorListServlet", urlPatterns = {"/doctors"})
public class DoctorListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            DoctorDAO doctorDAO = new DoctorDAO();
            List<Doctor> doctors = doctorDAO.getAllDoctors();

            StringBuilder json = new StringBuilder();
            json.append("[");

            for (int i = 0; i < doctors.size(); i++) {
                Doctor doctor = doctors.get(i);
                json.append("{");
                json.append("\"doctorId\":").append(doctor.getDoctorId()).append(",");
                json.append("\"userId\":").append(doctor.getUserId()).append(",");
                json.append("\"username\":\"").append(doctor.getUsername()).append("\",");
                json.append("\"specialty\":\"").append(doctor.getSpecialty() != null ? doctor.getSpecialty() : "").append("\"");
                json.append("}");

                if (i < doctors.size() - 1) {
                    json.append(",");
                }
            }

            json.append("]");

            PrintWriter out = response.getWriter();
            out.print(json.toString());
            out.flush();

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\": \"Có lỗi xảy ra khi tải danh sách bác sĩ\"}");
            out.flush();
        }
    }
}

