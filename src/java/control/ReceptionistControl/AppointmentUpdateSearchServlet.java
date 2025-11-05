package control.ReceptionistControl;

import dao.Receptionist.AppointmentDAO;
import entity.Receptionist.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/Appointment-UpdateSearch")
public class AppointmentUpdateSearchServlet extends HttpServlet {

    private final AppointmentDAO dao = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy param id từ form (nếu có)
        String idRaw = req.getParameter("id");

        // Chưa bấm tìm (không có id) -> chỉ show form search
        if (idRaw == null) {
            req.getRequestDispatcher("/receptionist/AppointmentUpdateSearch.jsp").forward(req, resp);
            return;
        }

        // Đã bấm tìm nhưng để trống
        idRaw = idRaw.trim();
        if (idRaw.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/Appointment-UpdateSearch?error=missingId");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            // ID không hợp lệ (không phải số)
            resp.sendRedirect(req.getContextPath() + "/Appointment-UpdateSearch?error=invalidId");
            return;
        }

        // Check xem appointment có tồn tại không
        Appointment ap = dao.getAppointmentById(id);
        if (ap == null) {
            resp.sendRedirect(req.getContextPath() + "/Appointment-UpdateSearch?error=notfound");
            return;
        }

        //Tồn tại -> chuyển sang trang chi tiết lịch hẹn
        resp.sendRedirect(req.getContextPath() + "/Appointment-Detail?id=" + id);
    }
}
