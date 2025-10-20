package control.ReceptionistControl;

import dao.Receptionist.PatientDAO;
import entity.Receptionist.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

/**
 * Servlet xử lý hiển thị và cập nhật thông tin bệnh nhân
 * URL: /Update-Patient
 * 
 * @author Kiên
 */
@WebServlet("/Update-Patient")
public class UpdatePatientServlet extends HttpServlet {

    // ✅ 1. Khi người dùng bấm "Edit Profile" → hiển thị form cập nhật
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int pid = Integer.parseInt(request.getParameter("pid"));
            PatientDAO dao = new PatientDAO();
            Patient patient = dao.getPatientById(pid);

            if (patient == null) {
                request.setAttribute("error", "Không tìm thấy bệnh nhân!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/receptionist/patientUpdateProfile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    // ✅ 2. Khi người dùng bấm "Update" → lưu thông tin mới vào database
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("patientId"));
            String fullName = request.getParameter("fullName");
            String address = request.getParameter("address");
            String insurance = request.getParameter("insuranceInfo");
            String parent = request.getParameter("parentName");
            String doctor = request.getParameter("doctorName");
            String dobStr = request.getParameter("dob"); // Lấy ngày sinh từ form

            Date dob = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                dob = Date.valueOf(dobStr); // Chuyển String → java.sql.Date
            }

            //  Gọi DAO để cập nhật
            PatientDAO dao = new PatientDAO();
            dao.updatePatient(id, fullName, address, insurance, parent, doctor, dob);

            // Sau khi cập nhật → quay lại trang hồ sơ bệnh nhân
            response.sendRedirect("Patient-Profile?pid=" + id + "&success=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
