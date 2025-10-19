package control.PatientControl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

// Imports for Patient functionality
import dao.RolePatient.DoctorDAO;
import dao.RolePatient.ParentDAO;
import dao.RolePatient.PatientDAO;
import dao.RolePatient.PatientAppointmentDAO;
import entity.AppointmentDetailDTO;
import entity.Doctor;
import entity.Parent;
import entity.Patient;
import entity.User;

/**
 * Patient Appointment Servlet - Handles all patient-related appointment operations
 * This servlet is specifically for patient functionality to avoid conflicts
 */
@WebServlet(name = "PatientAppointmentServlet", urlPatterns = {"/patient-appointment"})
public class PatientAppointmentServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("acc");
        
        // Only allow patients (role_id = 3)
        if (user.getRoleId() != 3) {
            response.sendRedirect("403.jsp");
            return;
        }
        
        handlePatientPost(request, response, user);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("acc");
        
        // Only allow patients (role_id = 3)
        if (user.getRoleId() != 3) {
            response.sendRedirect("403.jsp");
            return;
        }
        
        handlePatientGet(request, response, user);
    }
    
    // ========== PATIENT FUNCTIONALITY ==========
    private void handlePatientPost(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin từ form
            String parentName = request.getParameter("parentName");
            String parentId = request.getParameter("parentId");
            String childName = request.getParameter("childName");
            String childDobStr = request.getParameter("childDob");
            String appointmentDateStr = request.getParameter("appointmentDate");
            String appointmentTimeStr = request.getParameter("appointmentTime");
            String address = request.getParameter("address");
            String insuranceInfo = request.getParameter("insuranceInfo");
            String doctorIdStr = request.getParameter("doctorId");
            
            // Validate input
            if (parentName == null || parentName.trim().isEmpty() ||
                parentId == null || parentId.trim().isEmpty() ||
                childName == null || childName.trim().isEmpty() ||
                childDobStr == null || childDobStr.trim().isEmpty() ||
                appointmentDateStr == null || appointmentDateStr.trim().isEmpty() ||
                appointmentTimeStr == null || appointmentTimeStr.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                insuranceInfo == null || insuranceInfo.trim().isEmpty() ||
                doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc!");
                request.getRequestDispatcher("Home.jsp").forward(request, response);
                return;
            }
            
            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date childDob = dateFormat.parse(childDobStr);
            Date appointmentDate = dateFormat.parse(appointmentDateStr);
            
            // Combine date and time for appointment
            String dateTimeStr = appointmentDateStr + " " + appointmentTimeStr;
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date appointmentDateTime = dateTimeFormat.parse(dateTimeStr);
            Timestamp appointmentTimestamp = new Timestamp(appointmentDateTime.getTime());
            
            // Check if appointment is in the future
            if (appointmentDateTime.before(new Date())) {
                request.setAttribute("error", "Ngày giờ hẹn phải trong tương lai!");
                request.getRequestDispatcher("Home.jsp").forward(request, response);
                return;
            }
            
            // Validate time slot (8h-11h and 13h-16h, only full hours)
            String[] validTimes = {"08:00", "09:00", "10:00", "11:00", "13:00", "14:00", "15:00", "16:00"};
            boolean isValidTime = false;
            for (String timeSlot : validTimes) {
                if (appointmentTimeStr.equals(timeSlot)) {
                    isValidTime = true;
                    break;
                }
            }
            
            if (!isValidTime) {
                request.setAttribute("error", "Giờ khám chỉ được chọn từ 8h-11h và 13h-16h, chỉ giờ chẵn!");
                request.getRequestDispatcher("Home.jsp").forward(request, response);
                return;
            }
            
            // Get doctor
            int doctorId = Integer.parseInt(doctorIdStr);
            DoctorDAO doctorDAO = new DoctorDAO();
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            if (doctor == null) {
                request.setAttribute("error", "Bác sĩ không tồn tại!");
                request.getRequestDispatcher("Home.jsp").forward(request, response);
                return;
            }
            
            // Create or find parent
            ParentDAO parentDAO = new ParentDAO();
            Parent parent = parentDAO.findParentByIdInfo(parentId);
            
            if (parent == null) {
                // Create new parent
                parent = new Parent();
                parent.setParentname(parentName);
                parent.setIdInfo(parentId);
                int parentIdGenerated = parentDAO.createParent(parent);
                if (parentIdGenerated == -1) {
                    request.setAttribute("error", "Có lỗi xảy ra khi tạo thông tin phụ huynh!");
                    request.getRequestDispatcher("Home.jsp").forward(request, response);
                    return;
                }
                parent.setParentId(parentIdGenerated);
            }
            
            // Create patient for the child
            PatientDAO patientDAO = new PatientDAO();
            Patient patient = new Patient();
            patient.setUserId(user.getUserId()); // Link to logged-in user
            patient.setFullName(childName);
            patient.setDob(childDob);
            patient.setAddress(address);
            patient.setInsuranceInfo(insuranceInfo);
            patient.setParentId(parent.getParentId());
            
            int patientId = patientDAO.createPatient(patient);
            if (patientId == -1) {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo thông tin bệnh nhân!");
                request.getRequestDispatcher("Home.jsp").forward(request, response);
                return;
            }
            
            // Create appointment
            PatientAppointmentDAO appointmentDAO = new PatientAppointmentDAO();
            entity.Appointment appointment = new entity.Appointment();
            appointment.setPatientId(patientId);
            appointment.setDoctorId(doctorId);
            appointment.setDateTime(appointmentTimestamp);
            appointment.setStatus(true); // Active
            
            appointmentDAO.createAppointment(appointment);
            
            request.setAttribute("success", "Đặt lịch hẹn thành công! Chúng tôi sẽ liên hệ lại với bạn.");
            
        } catch (ParseException e) {
            request.setAttribute("error", "Định dạng ngày giờ không hợp lệ!");
            e.printStackTrace();
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID bác sĩ không hợp lệ!");
            e.printStackTrace();
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
        }
        
        try {
            request.getRequestDispatcher("Home.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Home.jsp");
        }
    }
    
    private void handlePatientGet(HttpServletRequest request, HttpServletResponse response, User user)
        throws ServletException, IOException {

        String action = request.getParameter("action");
        PatientAppointmentDAO appointmentDAO = new PatientAppointmentDAO();

        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                entity.Appointment appointment = appointmentDAO.getAppointmentById(id);
                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("/patient/editAppointment.jsp").forward(request, response);
                return;
            }

            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                appointmentDAO.deleteAppointment(id);
                response.sendRedirect("patient-appointment"); // load lại danh sách
                return;
            }

            // --- mặc định: xem danh sách ---
            List<AppointmentDetailDTO> appointmentDetails = appointmentDAO.getDetailedAppointmentsByUserId(user.getUserId());
            request.setAttribute("appointmentDetails", appointmentDetails);

            if (appointmentDetails.isEmpty()) {
                request.setAttribute("error", "Bạn chưa có lịch hẹn nào!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách lịch hẹn: " + e.getMessage());
        }

        request.getRequestDispatcher("/patient/viewAppointment_new.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Patient Appointment Servlet - Handles patient appointment operations";
    }
}
