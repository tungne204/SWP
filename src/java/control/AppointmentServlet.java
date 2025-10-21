package control;

import dao.AppointmentDAO;
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

// Imports for Patient functionality (your code)
import dao.DoctorDAO;
import dao.ParentDAO;
import dao.PatientDAO;
import entity.Appointment;
import entity.AppointmentDetailDTO;
import entity.Doctor;
import entity.Parent;
import entity.Patient;
import entity.User;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AppointmentServlet", urlPatterns = {"/appointment"})
public class AppointmentServlet extends HttpServlet {
    
    // DAO for Doctor functionality
    private dao.viewSchedule.AppointmentDAO doctorDao;
    private AppointmentDAO dao;

    @Override
    public void init() throws ServletException {
        doctorDao = new dao.viewSchedule.AppointmentDAO();
        dao = new AppointmentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("acc");
        
        // Route based on user role
        if (user.getRoleId() == 3) { // Patient role - your functionality
            handlePatientPost(request, response, user);
        } else if (user.getRoleId() == 2) { // Doctor role - other person's functionality
            handleDoctorPost(request, response, user);
        } else {
            response.sendRedirect("403.jsp");
        }
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
        
        // Route based on user role
        if (user.getRoleId() == 3) { // Patient role - your functionality
            handlePatientGet(request, response, user);
        } else if (user.getRoleId() == 2) { // Doctor role - other person's functionality
            handleDoctorGet(request, response, user);
        } else {
            response.sendRedirect("403.jsp");
        }
    }
    
    // ========== PATIENT FUNCTIONALITY (Your code) ==========
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
            dao.AppointmentDAO appointmentDAO = new dao.AppointmentDAO();
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
    dao.AppointmentDAO appointmentDAO = new dao.AppointmentDAO();

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
            response.sendRedirect("appointment"); // load lại danh sách
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

    
    // ========== DOCTOR FUNCTIONALITY (Other person's code) ==========
    private void handleDoctorPost(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Doctor POST functionality - currently just calls processRequest
        processRequest(request, response);
    }
    
    private void handleDoctorGet(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("acc") : null;
            
            // Nếu chưa đăng nhập -> quay về trang Login
            if (currentUser == null) {
                response.sendRedirect("Login");
                return;
            }
            
            // Nếu không phải bác sĩ -> từ chối truy cập
            if (currentUser.getRoleId() != 2) {
                response.sendRedirect("403.jsp");
                return;
            }
            
            // Lấy doctorId theo user đang đăng nhập
            int userId = currentUser.getUserId();
            int doctorId = dao.getDoctorIdByUserId(userId); // hàm bạn đã có sẵn trong DAO
            
            String action = request.getParameter("action");
            if (action == null) {
                action = "list";
            }
            
            switch (action) {
                case "list":
                    listAppointments(request, response, doctorId);
                    break;
                case "by-date":
                    listByDate(request, response, doctorId);
                    break;
                case "view":
                    viewAppointment(request, response, doctorId);
                    break;
                case "pending":
                    listPending(request, response, doctorId);
                    break;
                default:
                    listAppointments(request, response, doctorId);
                    break;
            }
        } catch (Exception ex) {
            Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    // Doctor methods (from other person's code)
    private void listAppointments(HttpServletRequest request, HttpServletResponse response, int doctorId)
            throws ServletException, IOException {

        List<Appointment> appointments = dao.getAllByDoctorId(doctorId);
        request.setAttribute("appointments", appointments);
        request.setAttribute("viewType", "all");
        request.getRequestDispatcher("doctor/appointment-list.jsp").forward(request, response);
    }

    // ✅ Hiển thị appointments theo ngày
    private void listByDate(HttpServletRequest request, HttpServletResponse response, int doctorId)
            throws ServletException, IOException {

        String date = request.getParameter("date");
        if (date == null || date.isEmpty()) {
            response.sendRedirect("appointment?action=list");
            return;
        }

        List<Appointment> appointments = dao.getByDoctorAndDate(doctorId, date);
        int count = dao.countByDoctorAndDate(doctorId, date);

        request.setAttribute("appointments", appointments);
        request.setAttribute("selectedDate", date);
        request.setAttribute("appointmentCount", count);
        request.setAttribute("viewType", "by-date");
        request.getRequestDispatcher("doctor/appointment-list.jsp").forward(request, response);
    }

    // ✅ Xem chi tiết appointment (chỉ xem được lịch của chính mình)
    private void viewAppointment(HttpServletRequest request, HttpServletResponse response, int doctorId)
            throws ServletException, IOException {

        try {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            Appointment appointment = dao.getById(appointmentId);

            // Kiểm tra quyền truy cập
            if (appointment == null || appointment.getDoctorId() != doctorId) {
                request.getSession().setAttribute("message", "Bạn không có quyền xem lịch hẹn này!");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("appointment?action=list");
                return;
            }

            request.setAttribute("appointment", appointment);
            request.getRequestDispatcher("doctor/appointment-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("appointment?action=list");
        }
    }

    // ✅ Hiển thị appointments chưa khám (chưa có medical report)
    private void listPending(HttpServletRequest request, HttpServletResponse response, int doctorId)
            throws ServletException, IOException {

        List<Appointment> appointments = dao.getPendingByDoctorId(doctorId);
        request.setAttribute("appointments", appointments);
        request.setAttribute("viewType", "pending");
        request.getRequestDispatcher("doctor/appointment-list.jsp").forward(request, response);
    }
    
    // ========== COMMON METHODS ==========
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AppointmentServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AppointmentServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    public String getServletInfo() {
        return "Combined Appointment Servlet for both Patient and Doctor functionality";
    }
}