package control.ReceptionistControl;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/Appointment-UpdateSearch")
public class AppointmentUpdateSearchServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/receptionist/AppointmentUpdateSearch.jsp").forward(req, resp);
    }
}
