package control;

import dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DeleteAppointmentServlet", urlPatterns = {"/DeleteAppointmentServlet"})
public class DeleteAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("appointmentId");

        // ✅ Kiểm tra null hoặc không phải số
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "Invalid appointment ID");
            request.getRequestDispatcher("appointmentList.jsp").forward(request, response);
            return;
        }

        try {
            int appointmentId = Integer.parseInt(idStr);
            AppointmentDAO dao = new AppointmentDAO();

            // ✅ Thực hiện xóa
            dao.deleteAppointment(appointmentId);

            // ✅ Sau khi xóa, quay lại trang danh sách với thông báo
            response.sendRedirect("ViewAppointmentServlet?success=deleted");

        } catch (NumberFormatException e) {
            Logger.getLogger(DeleteAppointmentServlet.class.getName()).log(Level.SEVERE, null, e);
            request.setAttribute("error", "Invalid appointment ID format");
            request.getRequestDispatcher("appointmentList.jsp").forward(request, response);

        } catch (Exception ex) {
            Logger.getLogger(DeleteAppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Error deleting appointment: " + ex.getMessage());
            request.getRequestDispatcher("appointmentList.jsp").forward(request, response);
        }
    }
}
