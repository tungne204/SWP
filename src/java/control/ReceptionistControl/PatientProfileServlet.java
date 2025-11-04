package control.ReceptionistControl;

import dao.Receptionist.PatientDAO;
import entity.Receptionist.Patient;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/Patient-Profile")
public class PatientProfileServlet extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        User acc = (User) session.getAttribute("acc");
        // Chỉ cho lễ tân (roleId = 5) xem, muốn mở rộng thì thêm role khác ở đây
        if (acc.getRoleId() != 5) {
            req.setAttribute("errorMsg", "Bạn không có quyền xem hồ sơ bệnh nhân.");
            req.getRequestDispatcher("/receptionist/PatientList.jsp").forward(req, resp);
            return;
        }

        String idRaw = req.getParameter("id");
        int patientId;

        try {
            patientId = Integer.parseInt(idRaw);
        } catch (Exception e) {
            resp.sendRedirect("Patient-List?error=invalidId");
            return;
        }

        Patient patient = patientDAO.getPatientProfileById(patientId);

        if (patient == null) {
            resp.sendRedirect("Patient-List?error=notfound");
            return;
        }

        req.setAttribute("patient", patient);
        req.getRequestDispatcher("/receptionist/PatientProfile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
