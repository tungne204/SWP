/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control.ReceptionistControl;

import dao.Receptionist.DoctorDAO;
import dao.Receptionist.AppointmentDAO;
import dao.Receptionist.PatientDAO;
import dao.Receptionist.ParentDAO;
import dao.Receptionist.UserDAO;
import entity.Receptionist.Appointment;
import entity.Receptionist.Patient;
import entity.Receptionist.Parent;
import entity.Receptionist.Doctor;
import entity.Receptionist.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Servlet xử lý cập nhật thông tin lịch hẹn (Appointment) - Load form chỉnh sửa
 * - Lưu thay đổi xuống database
 *
 * URL: /Appointment-Update
 *
 * @author Kiên
 */
@WebServlet(name = "UpdateAppointmentServlet", urlPatterns = {"/Appointment-Update"})
public class UpdateAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            PatientDAO patientDAO = new PatientDAO();
            ParentDAO parentDAO = new ParentDAO();
            DoctorDAO doctorDAO = new DoctorDAO();
            UserDAO userDAO = new UserDAO();
            
            // LOAD FORM (EDIT)
            if ("load".equalsIgnoreCase(action)) {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
                if (appointment == null) {
                    request.setAttribute("errorMessage", "Không tìm thấy lịch hẹn!");
                    request.getRequestDispatcher("/receptionist/appointmentList.jsp").forward(request, response);
                    return;
                }

                // Lấy thông tin bệnh nhân & người giám hộ
                Patient patient = patientDAO.getPatientById(appointment.getPatientId());
                Parent parent = parentDAO.getParentByPatientId(appointment.getPatientId());
                User user = userDAO.getUserByPatientId(appointment.getPatientId());
                
                //  Lấy danh sách bác sĩ
                List<Doctor> doctors = doctorDAO.getAllDoctors();
                request.setAttribute("doctors", doctors);
                
                // Gửi dữ liệu sang JSP
                request.setAttribute("appointment", appointment);
                request.setAttribute("patient", patient);
                request.setAttribute("parent", parent);
                request.setAttribute("user", user);
                
                // Forward về form update
                request.getRequestDispatcher("/receptionist/updateAppointment.jsp").forward(request, response);
                return;
            }

            //CONFIRM UPDATE
            if ("update".equalsIgnoreCase(action)) {

                // === Lấy dữ liệu từ form ===
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                int doctorId = Integer.parseInt(request.getParameter("doctorId"));

                String appointmentDate = request.getParameter("appointmentDate");
                String appointmentTime = request.getParameter("appointmentTime");
                Date dateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(appointmentDate + " " + appointmentTime);

                boolean status = false;
                String statusParam = request.getParameter("status");
                if (statusParam != null) {
                    status = Boolean.parseBoolean(statusParam);
                }

                // === Patient info ===
                String fullName = request.getParameter("fullName");
                String dobStr = request.getParameter("dob");
                java.sql.Date dob = null;

                if (dobStr != null && !dobStr.isEmpty()) {
                    java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
                    dob = new java.sql.Date(utilDate.getTime());
                }

                String address = request.getParameter("address");
                String insuranceInfo = request.getParameter("insuranceInfo");

                // === Parent info ===
                String parentName = request.getParameter("parentName");
                String parentIdInfo = request.getParameter("parentId");
                String parentEmail = request.getParameter("parentEmail");
                 
                // === Lấy patientId gốc từ DB ===
                Appointment oldAp = appointmentDAO.getAppointmentById(appointmentId);
                if (oldAp == null) {
                    request.setAttribute("errorMessage", "Không tìm thấy dữ liệu lịch hẹn!");
                    request.getRequestDispatcher("/receptionist/appointmentList.jsp").forward(request, response);
                    return;
                }
                int patientId = oldAp.getPatientId();

                // === Cập nhật Appointment ===
                Appointment ap = new Appointment();
                ap.setAppointmentId(appointmentId);
                ap.setPatientId(patientId);
                ap.setDoctorId(doctorId);
                ap.setDateTime(dateTime);
                ap.setStatus(status);
                appointmentDAO.updateAppointment(ap);

                // === Cập nhật Patient ===
                Patient patient = new Patient();
                patient.setPatientId(patientId);
                patient.setFullName(fullName);
                patient.setDob(dob);
                patient.setAddress(address);
                patient.setInsuranceInfo(insuranceInfo);
                patientDAO.updatePatient(patient);

                // === Cập nhật Parent ===
                Parent parent = new Parent();
                parent.setParentName(parentName);
                parent.setIdInfo(parentIdInfo);
                parentDAO.updateParentByPatientId(patientId, parent);
                
                // === Cập nhật Email (User table) ===
                int userId = patientDAO.getUserIdByPatientId(patientId);
                User user = new User();
                user.setUserId(userId);
                user.setEmail(parentEmail);
                userDAO.updateEmail(user);
                
                log("[INFO] Appointment updated successfully, ID=" + appointmentId);

                // Quay lại danh sách sau khi update
                response.sendRedirect(request.getContextPath() + "/Appointment-List");
            }

        } catch (Exception e) {
            log("❌ Lỗi tại UpdateAppointmentServlet: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Không thể tải danh sách lịch hẹn. Vui lòng thử lại sau!");
            request.getRequestDispatcher("/receptionist/appointmentList.jsp").forward(request, response);
        }
    }
}
