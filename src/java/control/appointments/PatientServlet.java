package control.appointments;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import entity.User;
import entity.appointments.Appointment;
import entity.appointments.AppointmentStatus;
import entity.appointments.Doctor;
import entity.appointments.Patient;
import dao.appointments.AppointmentDAO;
import dao.appointments.PatientDAO;
import dao.appointments.DoctorDAO;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "PatientServlet", urlPatterns = {"/patient"})
public class PatientServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("acc");

        // Kiểm tra đăng nhập và role
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        if (acc.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showMyAppointments(acc.getUserId(), request, response);
        } else if (pathInfo.equals("/create")) {
            showCreateForm(request, response);
        } else if (pathInfo.startsWith("/detail/")) {
            String[] parts = pathInfo.split("/");
            int appointmentId = Integer.parseInt(parts[2]);
            showAppointmentDetail(appointmentId, acc.getUserId(), request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("acc");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        if (acc.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");
        int userId = acc.getUserId();

        if ("create".equals(action)) {
            createAppointment(userId, request, response);
        } else if ("cancel".equals(action)) {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            cancelAppointment(appointmentId, userId, request, response);
        }
    }

    // Hiển thị danh sách lịch hẹn
    private void showMyAppointments(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Patient patient = patientDAO.getPatientByUserId(userId);

        if (patient != null) {
            List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(patient.getPatientId());
            request.setAttribute("appointments", appointments);
            request.setAttribute("patient", patient);
        }

        request.setAttribute("pageTitle", "My Appointments");
        request.getRequestDispatcher("/views/patient/my-appointments.jsp").forward(request, response);
    }

    // Hiển thị form tạo mới
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/views/patient/create-appointment.jsp").forward(request, response);
    }

    // Tạo lịch hẹn
    private void createAppointment(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Patient patient = patientDAO.getPatientByUserId(userId);
            if (patient == null) {
                Integer pid = patientDAO.createPatientMinimalIfAbsent(userId);
                if (pid != null) {
                    patient = patientDAO.getPatientByUserId(userId);
                }
            }
            if (patient == null) {
                sessionMessage(request, "Patient profile not found! Please complete your profile.", "error");
                response.sendRedirect(request.getContextPath() + "/patient");
                return;
            }

            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String appointmentDate = request.getParameter("appointmentDate");
            String appointmentTime = request.getParameter("appointmentTime");
            String reason = request.getParameter("reason");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date parsedDate = sdf.parse(appointmentDate + " " + appointmentTime);
            Timestamp appointmentDateTime = new Timestamp(parsedDate.getTime());

            if (appointmentDateTime.before(new Timestamp(System.currentTimeMillis()))) {
                sessionMessage(request, "Appointment date must be in the future!", "error");
                response.sendRedirect(request.getContextPath() + "/patient/create");
                return;
            }

            boolean isAvailable = appointmentDAO.isDoctorAvailable(doctorId, appointmentDateTime);
            if (!isAvailable) {
                sessionMessage(request, "Doctor is not available at this time. Please choose another time!", "warning");
                response.sendRedirect(request.getContextPath() + "/patient/create");
                return;
            }

            Appointment appointment = new Appointment();
            appointment.setPatientId(patient.getPatientId());
            appointment.setDoctorId(doctorId);
            appointment.setDateTime(appointmentDateTime);
            appointment.setStatus(AppointmentStatus.PENDING.getValue());

            boolean success = appointmentDAO.createAppointment(appointment);

            if (success) {
                sessionMessage(request, "Appointment created successfully! Waiting for receptionist confirmation.", "success");
                response.sendRedirect(request.getContextPath() + "/patient");
            } else {
                sessionMessage(request, "Failed to create appointment!", "error");
                response.sendRedirect(request.getContextPath() + "/patient/create");
            }

        } catch (ParseException e) {
            sessionMessage(request, "Invalid date format!", "error");
            response.sendRedirect(request.getContextPath() + "/patient/create");
        } catch (Exception e) {
            e.printStackTrace();
            sessionMessage(request, "An error occurred: " + e.getMessage(), "error");
            response.sendRedirect(request.getContextPath() + "/patient/create");
        }
    }

    // Chi tiết lịch hẹn
    private void showAppointmentDetail(int appointmentId, int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

        if (appointment != null) {
            Patient patient = patientDAO.getPatientByUserId(userId);
            if (patient != null && patient.getPatientId() == appointment.getPatientId()) {
                Doctor doctor = doctorDAO.getDoctorById(appointment.getDoctorId());
                request.setAttribute("appointment", appointment);
                request.setAttribute("doctor", doctor);

                if (!appointment.getStatus().equals(AppointmentStatus.PENDING.getValue())
                        && !appointment.getStatus().equals(AppointmentStatus.CONFIRMED.getValue())) {
                    var medicalReport = appointmentDAO.getMedicalReportByAppointmentId(appointmentId);
                    request.setAttribute("medicalReport", medicalReport);
                }

                request.getRequestDispatcher("/views/patient/appointment-detail.jsp").forward(request, response);
                return;
            }
        }

        sessionMessage(request, "Appointment not found or access denied!", "error");
        response.sendRedirect(request.getContextPath() + "/patient");
    }

    // Hủy lịch hẹn
    private void cancelAppointment(int appointmentId, int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

        if (appointment != null) {
            Patient patient = patientDAO.getPatientByUserId(userId);
            if (patient != null && patient.getPatientId() == appointment.getPatientId()) {
                if (appointment.getStatus().equals(AppointmentStatus.PENDING.getValue())
                        || appointment.getStatus().equals(AppointmentStatus.CONFIRMED.getValue())) {

                    boolean success = appointmentDAO.updateAppointmentStatus(
                            appointmentId, AppointmentStatus.CANCELLED.getValue());

                    if (success) {
                        sessionMessage(request, "Appointment cancelled successfully!", "success");
                    } else {
                        sessionMessage(request, "Failed to cancel appointment!", "error");
                    }
                } else {
                    sessionMessage(request, "Cannot cancel appointment in current status!", "error");
                }
            } else {
                sessionMessage(request, "Access denied!", "error");
            }
        }

        response.sendRedirect(request.getContextPath() + "/patient");
    }

    private void sessionMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("message", message);
        request.getSession().setAttribute("messageType", type);
    }

    @Override
    public String getServletInfo() {
        return "PatientServlet integrated with LoginControl session (acc)";
    }
}
