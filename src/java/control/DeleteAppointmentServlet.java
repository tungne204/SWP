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

/**
 *
 *
 * URL:/Appointment-Delete
 *
 * @author Kiên
 */
@WebServlet(name = "DeleteAppointmentServlet", urlPatterns = {"/Appointment-Delete"})
public class DeleteAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("appointmentId");

        //Kiểm tra null hoặc không phải số
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "Invalid appointment ID");
            request.getRequestDispatcher("appointmentList.jsp").forward(request, response);
            return;
        }

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

            //Thực hiện xóa
            dao.deleteAppointment(appointmentId);
            
            System.out.println("Appointment deleted successfully: " + appointmentId);

            //Sau khi xóa, quay lại trang danh sách với thông báo
            response.sendRedirect(request.getContextPath() + "/Appointment-List?success=deleted");

        } catch (NumberFormatException e) {
            Logger.getLogger(DeleteAppointmentServlet.class.getName()).log(Level.SEVERE, "Invalid number format", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid appointment ID format");

        } catch (Exception ex) {
            Logger.getLogger(DeleteAppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Error deleting appointment: " + ex.getMessage());
            request.getRequestDispatcher("/receptionist/appointmentList.jsp").forward(request, response);
        }
    }
}
