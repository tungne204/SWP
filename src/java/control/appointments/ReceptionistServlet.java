package control.appointments;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Date;
import dao.appointments.AppointmentDAO;
import dao.PatientQueueDAO;
import dao.PatientDAO;
import dao.ParentDAO;
import entity.User;
import entity.appointments.Appointment;
import entity.appointments.AppointmentStatus;
import entity.PatientQueue;
import entity.Patient;
import entity.Parent;
import socket.PatientQueueWebSocket;
import util.QueueUpdateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ReceptionistServlet", urlPatterns = {"/receptionist", "/receptionist/", "/receptionist/confirmed"})
public class ReceptionistServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private dao.AppointmentDAO mainAppointmentDAO;
    private PatientQueueDAO patientQueueDAO;
    private PatientDAO patientDAO;
    private ParentDAO parentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        mainAppointmentDAO = new dao.AppointmentDAO();
        patientQueueDAO = new PatientQueueDAO();
        patientDAO = new PatientDAO();
        parentDAO = new ParentDAO();
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
        String requestURI = request.getRequestURI();
        
        // With specific URL patterns, pathInfo will be:
        // - null for "/receptionist" or "/receptionist/"
        // - "/confirmed" for "/receptionist/confirmed"
        
        // Always show confirmed appointments for this servlet
        // (since we only handle /receptionist, /receptionist/, and /receptionist/confirmed)
        showConfirmedAppointments(request, response);
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

    // Hiển thị danh sách các lịch hẹn đã được xác nhận với search, filter và paging
    private void showConfirmedAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy các tham số từ request
        String searchKeyword = request.getParameter("search");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        
        // Paging parameters
        int page = 1;
        int pageSize = 10; // Số records mỗi trang
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        // Lấy user từ session
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("acc");
        Integer userId = acc != null ? acc.getUserId() : null;
        
        // Chỉ hiển thị CONFIRMED appointments
        String statusFilter = AppointmentStatus.CONFIRMED.getValue();
        
        // Lấy danh sách appointments với filter và paging
        List<Appointment> confirmedList = appointmentDAO.getAppointmentsWithFilter(
                5, // roleId = 5 (Receptionist)
                userId,
                null, // patientId
                searchKeyword,
                statusFilter, // Chỉ lấy CONFIRMED
                dateFrom,
                dateTo,
                page,
                pageSize
        );
        
        // Đếm tổng số records để tính pagination
        int totalRecords = appointmentDAO.countAppointmentsWithFilter(
                5, // roleId = 5 (Receptionist)
                userId,
                null, // patientId
                searchKeyword,
                statusFilter, // Chỉ đếm CONFIRMED
                dateFrom,
                dateTo
        );
        
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Set attributes cho JSP
        request.setAttribute("appointments", confirmedList);
        request.setAttribute("pageTitle", "Confirmed Appointments");
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("searchKeyword", searchKeyword != null ? searchKeyword : "");
        request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
        request.setAttribute("dateTo", dateTo != null ? dateTo : "");
        
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

    // ✅ Check-in (Confirmed → Waiting) and add to queue
    private void checkinAppointment(int appointmentId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get appointment details using main AppointmentDAO to get patientId and dateTime
            entity.Appointment appointment = mainAppointmentDAO.getById(appointmentId);
            if (appointment == null) {
                sessionMessage(request, "Khong tim thay lich hen!", "error");
                response.sendRedirect(request.getContextPath() + "/receptionist");
                return;
            }

            int patientId = appointment.getPatientId();

            // Check if patient is already in queue today
            if (patientQueueDAO.isPatientInQueueToday(patientId)) {
                sessionMessage(request, "Benh nhan da o trong hang cho hom nay!", "error");
                response.sendRedirect(request.getContextPath() + "/receptionist");
                return;
            }

            // Get the highest queue number to assign next number
            List<PatientQueue> allQueue = patientQueueDAO.getAllPatientsInQueue();
            int nextQueueNumber = 1;
            if (!allQueue.isEmpty()) {
                nextQueueNumber = allQueue.get(0).getQueueNumber() + 1;
                for (PatientQueue pq : allQueue) {
                    if (pq.getQueueNumber() >= nextQueueNumber) {
                        nextQueueNumber = pq.getQueueNumber() + 1;
                    }
                }
            }

            // Create new patient queue entry
            PatientQueue patientQueue = new PatientQueue();
            patientQueue.setPatientId(patientId);
            patientQueue.setAppointmentId(appointmentId);

            Date checkInTime = new Date();
            int priority = 0;

            // Calculate priority based on appointment time
            if (appointment.getDateTime() != null) {
                Date appointmentTime = appointment.getDateTime();
                long timeDifference = appointmentTime.getTime() - checkInTime.getTime();
                long minutesDifference = timeDifference / (60 * 1000); // Convert to minutes

                // Only give priority if check-in is within 30 minutes before appointment time
                // and not after appointment time
                if (minutesDifference >= 0 && minutesDifference <= 30) {
                    priority = 1; // High priority
                } else {
                    priority = 0; // Normal priority (too early or too late)
                }
            }

            patientQueue.setQueueNumber(nextQueueNumber);
            patientQueue.setQueueType("Booked"); // This is a booked appointment
            patientQueue.setStatus("Waiting");
            patientQueue.setPriority(priority);
            patientQueue.setCheckInTime(checkInTime);
            patientQueue.setUpdatedTime(new Date());

            // Add patient to queue first
            try {
                patientQueueDAO.addPatientToQueue(patientQueue);
            } catch (Exception e) {
                sessionMessage(request, "Khong the them benh nhan vao hang cho: " + e.getMessage(), "error");
                response.sendRedirect(request.getContextPath() + "/receptionist");
                return;
            }

            // Update appointment status to "Waiting" after successfully adding to queue
            boolean success = appointmentDAO.updateAppointmentStatus(
                    appointmentId, AppointmentStatus.WAITING.getValue());

            if (!success) {
                sessionMessage(request, "Da them vao hang cho nhung khong the cap nhat trang thai appointment!", "error");
                response.sendRedirect(request.getContextPath() + "/receptionist");
                return;
            }

            // Broadcast WebSocket update for new patient in queue
            try {
                Patient patient = patientDAO.getPatientById(patientId);
                Parent parent = null;
                if (patient.getParentId() != null) {
                    parent = parentDAO.getParentById(patient.getParentId());
                }
                String patientJson = QueueUpdateUtil.createPatientQueueJson(patient, patientQueue, parent);
                PatientQueueWebSocket.broadcastQueueUpdate("patient_added", patientJson);
            } catch (Exception e) {
                System.err.println("Error broadcasting WebSocket update: " + e.getMessage());
            }

            // Set success message
            Patient patient = patientDAO.getPatientById(patientId);
            String priorityMessage = priority == 1 ? " (Uu tien cao)" : "";
            sessionMessage(request, 
                "Da them benh nhan vao hang cho: " + patient.getFullName() + 
                " - So thu tu: " + nextQueueNumber + priorityMessage, 
                "success");

        } catch (Exception e) {
            e.printStackTrace();
            sessionMessage(request, "Co loi xay ra khi check-in: " + e.getMessage(), "error");
        }

        response.sendRedirect(request.getContextPath() + "/receptionist");
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
