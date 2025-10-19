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

        response.setContentType("text/plain");
        
        try {
            String idStr = request.getParameter("appointmentId");

            // Debug: Log parameters
            System.out.println("=== DeleteAppointmentServlet Debug ===");
            System.out.println("appointmentId parameter: " + idStr);
            System.out.println("=== End Debug ===");

            // ✅ Kiểm tra null hoặc không phải số
            if (idStr == null || idStr.trim().isEmpty()) {
                System.out.println("ERROR: appointmentId is null or empty!");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Appointment ID is required");
                return;
            }

            int appointmentId = Integer.parseInt(idStr);
            AppointmentDAO dao = new AppointmentDAO();

            // ✅ Thực hiện xóa
            dao.deleteAppointment(appointmentId);
            
            System.out.println("Appointment deleted successfully: " + appointmentId);

            // ✅ Trả về success cho AJAX
            response.getWriter().write("success");

        } catch (NumberFormatException e) {
            Logger.getLogger(DeleteAppointmentServlet.class.getName()).log(Level.SEVERE, "Invalid number format", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid appointment ID format");

        } catch (Exception ex) {
            Logger.getLogger(DeleteAppointmentServlet.class.getName()).log(Level.SEVERE, "Error deleting appointment", ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error deleting appointment: " + ex.getMessage());
        }
    }
}
