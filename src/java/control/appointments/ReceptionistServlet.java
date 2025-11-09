package control.appointments;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import dao.appointments.AppointmentDAO;
import entity.User;
import entity.appointments.Appointment;
import entity.appointments.AppointmentStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ReceptionistServlet", urlPatterns = {"/receptionist/*"})
public class ReceptionistServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("acc");

        // ✅ Kiểm tra đăng nhập
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        // ✅ Kiểm tra quyền (roleId = 5: Receptionist)
        if (acc.getRoleId() != 5) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showPendingAppointments(request, response);
        } else if (pathInfo.equals("/confirmed")) {
            showConfirmedAppointments(request, response);
        } else {
            // Không hợp lệ -> quay về trang chính
            response.sendRedirect(request.getContextPath() + "/receptionist");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("acc");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        if (acc.getRoleId() != 5) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");
        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

        switch (action) {
            case "confirm":
                confirmAppointment(appointmentId, request, response);
                break;
            case "checkin":
                checkinAppointment(appointmentId, request, response);
                break;
            default:
                sessionMessage(request, "Invalid action!", "error");
                response.sendRedirect(request.getContextPath() + "/receptionist");
                break;
        }
    }

    // ========== CÁC HÀM NGHIỆP VỤ ==========

    // Hiển thị danh sách các lịch hẹn đang chờ xác nhận
    private void showPendingAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Appointment> pendingList = appointmentDAO.getAppointmentsByStatus(
                AppointmentStatus.PENDING.getValue());

        request.setAttribute("appointments", pendingList);
        request.setAttribute("pageTitle", "Appointments Pending Confirmation");
        request.getRequestDispatcher("/views/receptionist/pending-appointments.jsp")
                .forward(request, response);
    }

    // Hiển thị danh sách các lịch hẹn đã được xác nhận
    private void showConfirmedAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Appointment> confirmedList = appointmentDAO.getAppointmentsByStatus(
                AppointmentStatus.CONFIRMED.getValue());

        request.setAttribute("appointments", confirmedList);
        request.setAttribute("pageTitle", "Confirmed Appointments");
        request.getRequestDispatcher("/views/receptionist/confirmed-appointments.jsp")
                .forward(request, response);
    }

    // ✅ Xác nhận appointment (Pending → Confirmed)
    private void confirmAppointment(int appointmentId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean success = appointmentDAO.updateAppointmentStatus(
                appointmentId, AppointmentStatus.CONFIRMED.getValue());

        if (success) {
            sessionMessage(request, "Appointment confirmed successfully!", "success");
        } else {
            sessionMessage(request, "Failed to confirm appointment!", "error");
        }

        response.sendRedirect(request.getContextPath() + "/receptionist");
    }

    // ✅ Check-in (Confirmed → Waiting)
    private void checkinAppointment(int appointmentId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean success = appointmentDAO.updateAppointmentStatus(
                appointmentId, AppointmentStatus.WAITING.getValue());

        if (success) {
            sessionMessage(request, "Patient checked in successfully!", "success");
        } else {
            sessionMessage(request, "Failed to check in patient!", "error");
        }

        response.sendRedirect(request.getContextPath() + "/receptionist/confirmed");
    }

    // ✅ Hàm tiện ích để set thông báo session
    private void sessionMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("message", message);
        request.getSession().setAttribute("messageType", type);
    }

    @Override
    public String getServletInfo() {
        return "ReceptionistServlet integrated with LoginControl session (acc)";
    }
}
