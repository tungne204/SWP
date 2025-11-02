package control.PatientControl;

import dao.Receptionist.AppointmentDAO;
import entity.Receptionist.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/Appointment-Detail")
public class AppointmentDetailsServlet extends HttpServlet {

    private final AppointmentDAO dao = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = req.getParameter("id");
        if (id == null || id.isEmpty()) {
            resp.sendRedirect("Appointment-List");
            return;
        }

        try {
            Appointment appointment = dao.getAppointmentById(Integer.parseInt(id));
            if (appointment == null) {
                resp.sendRedirect("Appointment-List");
                return;
            }

            req.setAttribute("appointment", appointment);
            req.getRequestDispatcher("/receptionist/AppointmentDetail.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("Appointment-List");
        }
    }
}
