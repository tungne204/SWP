package control.ReceptionistControl;

import dao.Receptionist.PatientDAO;
import entity.Receptionist.Patient;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/Patient-Profile")
public class PatientProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        // Không có id → quay lại màn search
        if (id == null || id.isEmpty()) {
            response.sendRedirect("Patient-Search");
            return;
        }

        try {
            int patientId = Integer.parseInt(id);
            PatientDAO dao = new PatientDAO();
            Patient patient = dao.getPatientById(patientId);

            if (patient == null) {
                // KHÔNG forward sang /error.jsp nữa
                request.setAttribute("error", "Không tìm thấy bệnh nhân với ID: " + id);
                request.getRequestDispatcher("/receptionist/PatientProfile.jsp").forward(request, response);
                return;
            }

            // Có dữ liệu → show lên JSP
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/receptionist/PatientProfile.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // id không phải số
            request.setAttribute("error", "ID bệnh nhân không hợp lệ!");
            request.getRequestDispatcher("/receptionist/PatientProfile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // Lỗi DB, lỗi SQL, lỗi DAO → vẫn đẩy về profile.jsp
            request.setAttribute("error", "Lỗi khi tải thông tin bệnh nhân: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/PatientProfile.jsp").forward(request, response);
        }
    }
}
