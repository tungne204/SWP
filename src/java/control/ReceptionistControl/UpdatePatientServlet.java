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
 * Servlet xử lý hiển thị và cập nhật thông tin bệnh nhân URL: /Update-Patient
 *
 * @author Kiên
 */
@WebServlet("/Update-Patient")
public class UpdatePatientServlet extends HttpServlet {

    // 1. Khi người dùng bấm "Edit Profile" -> hiển thị form cập nhật
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
                // Nếu không tìm thấy bệnh nhân -> quay lại View Profile với thông báo lỗi
                response.sendRedirect("Patient-Profile?pid=" + pid + "&error=notfound");
                return;
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/receptionist/patientUpdateProfile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Patient-Profile?error=true");
        }
    }

    // 2. Khi người dùng bấm "Update" -> lưu thông tin mới vào database
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            //Lấy dữ liệu từ form
            int id = Integer.parseInt(request.getParameter("patientId"));
            String fullName = request.getParameter("fullName");
            String address = request.getParameter("address");
            String insurance = request.getParameter("insuranceInfo");
            String dobStr = request.getParameter("dob");
            String parentName = request.getParameter("parentName");
            String parentIdNumber = request.getParameter("parentIdNumber");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            Date dob = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                dob = Date.valueOf(dobStr);
            }
            // Gán vào đối tượng Patient
            Patient p = new Patient();
            p.setPatientId(id);
            p.setFullName(fullName);
            p.setAddress(address);
            p.setInsuranceInfo(insurance);
            p.setDob(dob);
            p.setParentName(parentName);
            p.setParentIdNumber(parentIdNumber);
            p.setEmail(email);
            p.setPhone(phone);

            //  Gọi DAO để cập nhật
            PatientDAO dao = new PatientDAO();
            dao.updatePatient(p);

            // Sau khi cập nhật -> quay lại trang hồ sơ bệnh nhân
            response.sendRedirect("Patient-Profile?pid=" + id + "&success=true");

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi thì quay lại trang profile và hiển thị thông báo lỗi
            String pid = request.getParameter("patientId");
            response.sendRedirect("Patient-Profile?pid=" + pid + "&error=true");
        }
    }
}
