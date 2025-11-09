package control;

import dao.*;
import entity.*;
import socket.PatientQueueWebSocket;
import util.QueueUpdateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "CheckinFormServlet", urlPatterns = {"/receptionist/checkin-form"})
public class CheckinFormServlet extends HttpServlet {

    private PatientQueueDAO patientQueueDAO;
    private PatientDAO patientDAO;
    private AppointmentDAO appointmentDAO;
    private ParentDAO parentDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        patientQueueDAO = new PatientQueueDAO();
        patientDAO = new PatientDAO();
        appointmentDAO = new AppointmentDAO();
        parentDAO = new ParentDAO();
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check login session
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("acc") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        // Check receptionist permission (roleId = 5)
        if (user.getRoleId() != 5) {
            response.sendRedirect(request.getContextPath() + "/403.jsp");
            return;
        }
        
        // Forward to receptionist checkin.jsp page
        request.getRequestDispatcher("/receptionist/checkin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check login session
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("acc") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        // Check receptionist permission (roleId = 5)
        if (user.getRoleId() != 5) {
            response.sendRedirect(request.getContextPath() + "/403.jsp");
            return;
        }
        
        // Handle patient registration logic
        String action = request.getParameter("action");
        
        if ("checkin".equals(action)) {
            handleCheckin(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/receptionist/checkin-form");
        }
    }
    
    private void handleCheckin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String patientType = request.getParameter("patientType"); // "walkin" or "booked"
            String patientIdStr = request.getParameter("patientId");
            int patientId;
            
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                // Handle walk-in patients without existing patient ID
                String patientName = request.getParameter("patientName");
                String parentName = request.getParameter("parentName");
                String cccd = request.getParameter("parentCccd");
                String dobStr = request.getParameter("dob");
                String addressInput = request.getParameter("address");
                String insuranceInfoInput = request.getParameter("insuranceInfo");
                
                // Validate required input
                 if (patientName == null || patientName.trim().isEmpty()) {
                     request.getSession().setAttribute("errorMessage", "Vui long nhap ho ten benh nhan");
                     response.sendRedirect(request.getContextPath() + "/receptionist/checkin-form");
                     return;
                 }
                 
                 // Validate required parent information
                 if (parentName == null || parentName.trim().isEmpty()) {
                     request.getSession().setAttribute("errorMessage", "Vui long nhap ten phu huynh");
                     response.sendRedirect(request.getContextPath() + "/receptionist/checkin-form");
                     return;
                 }
                 
                 if (cccd == null || cccd.trim().isEmpty()) {
                     request.getSession().setAttribute("errorMessage", "Vui long nhap so CCCD phu huynh");
                     response.sendRedirect(request.getContextPath() + "/receptionist/checkin-form");
                     return;
                 }
                
                // Handle parent information (now both fields are required)
                Integer parentId = null;
                Parent existingParent = parentDAO.findParentByIdInfo(cccd.trim());
                
                if (existingParent != null) {
                    // Parent already exists, use existing parent ID
                    parentId = existingParent.getParentId();
                    
                    // Update parent name if different
                    if (!parentName.trim().equals(existingParent.getParentname())) {
                        existingParent.setParentname(parentName.trim());
                        parentDAO.updateParent(existingParent);
                    }
                } else {
                    // Create a new parent record
                    Parent newParent = new Parent();
                    newParent.setParentname(parentName.trim());
                    newParent.setIdInfo(cccd.trim());
                    
                    // Save new parent and get the generated parent ID
                    parentId = parentDAO.createParent(newParent);
                    
                    // Check if parent creation was successful
                    if (parentId == -1) {
                        throw new Exception("Failed to create parent record");
                    }
                }
                
                // Check if patient already exists by name (since we removed phone)
                // For now, we'll create a new patient each time since we don't have a reliable way to match
                // Create a new patient record
                Patient newPatient = new Patient();
                newPatient.setFullName(patientName);
                // Set address
                if (addressInput != null && !addressInput.trim().isEmpty()) {
                    newPatient.setAddress(addressInput.trim());
                } else {
                    newPatient.setAddress(""); // Empty address if not provided
                }
                // Set default values for required fields
                newPatient.setUserId(0); // Use 0 to indicate no user ID
                newPatient.setInsuranceInfo(insuranceInfoInput != null ? insuranceInfoInput.trim() : "");
                newPatient.setParentId(parentId); // Set parent ID if parent was created
                // Parse DOB from form if provided, else leave null
                if (dobStr != null && !dobStr.trim().isEmpty()) {
                    try {
                        java.sql.Date sqlDob = java.sql.Date.valueOf(dobStr.trim());
                        newPatient.setDob(sqlDob);
                    } catch (IllegalArgumentException ex) {
                        // Invalid date format; keep DOB null to avoid bad data
                        newPatient.setDob(null);
                    }
                } else {
                    newPatient.setDob(null);
                }
                
                // Save new patient and get the generated patient ID
                patientId = patientDAO.createPatient(newPatient);
                
                // Check if patient creation was successful
                if (patientId == -1) {
                    throw new Exception("Failed to create patient record");
                }
            } else {
                patientId = Integer.parseInt(patientIdStr);
            }
            
            // Check if patient is already in queue today
             if (patientQueueDAO.isPatientInQueueToday(patientId)) {
                 // Patient is already in queue today, redirect with message
                 request.getSession().setAttribute("errorMessage", "Benh nhan da o trong hang cho.");
                 response.sendRedirect(request.getContextPath() + "/receptionist/checkin-form");
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
            
            Date checkInTime = new Date();
            int priority = 0;
            Integer appointmentId = null;
            
            // If this is a booked patient, get appointment ID and calculate priority
            if ("booked".equals(patientType)) {
                String appointmentIdStr = request.getParameter("appointmentId");
                if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty()) {
                    appointmentId = Integer.parseInt(appointmentIdStr);
                    patientQueue.setAppointmentId(appointmentId);
                    
                    // Get appointment details to check appointment time
                    Appointment appointment = appointmentDAO.getById(appointmentId);
                    if (appointment != null && appointment.getDateTime() != null) {
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
                    
                    // Update appointment status to "Confirmed"
                    appointmentDAO.updateAppointmentStatus(appointmentId, "Confirmed");
                }
            } else {
                // For walk-in patients, create a new appointment
                // Get doctor ID from request, or use first available doctor as default
                String doctorIdStr = request.getParameter("doctorId");
                int doctorId;
                
                if (doctorIdStr != null && !doctorIdStr.trim().isEmpty()) {
                    doctorId = Integer.parseInt(doctorIdStr);
                } else {
                    // Get first available doctor as default
                    List<entity.Doctor> doctors = doctorDAO.getAllDoctors();
                    if (doctors == null || doctors.isEmpty()) {
                        throw new Exception("Khong co bac si nao trong he thong. Vui long them bac si truoc khi check-in.");
                    }
                    doctorId = doctors.get(0).getDoctorId();
                }
                
                // Verify doctor exists
                entity.Doctor doctor = doctorDAO.getDoctorById(doctorId);
                if (doctor == null) {
                    throw new Exception("Bac si khong ton tai trong he thong.");
                }
                
                // Create new appointment for walk-in patient
                Appointment newAppointment = new Appointment();
                newAppointment.setPatientId(patientId);
                newAppointment.setDoctorId(doctorId);
                newAppointment.setDateTime(checkInTime); // Use current time as appointment time
                newAppointment.setStatus("Confirmed"); // Set status as Confirmed for walk-in patients
                
                // Create appointment in database and get the generated appointment ID
                appointmentId = appointmentDAO.createAppointmentWithStatus(newAppointment);
                
                if (appointmentId == -1) {
                    throw new Exception("Khong the tao appointment cho benh nhan walk-in.");
                }
                
                // Link appointment to queue entry
                patientQueue.setAppointmentId(appointmentId);
            }
            
            patientQueue.setQueueNumber(nextQueueNumber);
            patientQueue.setQueueType("booked".equals(patientType) ? "Booked" : "Walk-in");
            patientQueue.setStatus("Waiting");
            patientQueue.setPriority(priority);
            patientQueue.setCheckInTime(checkInTime);
            patientQueue.setUpdatedTime(new Date());
            
            // Add patient to queue
            patientQueueDAO.addPatientToQueue(patientQueue);
            
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
             String priorityMessage = "";
             if ("booked".equals(patientType)) {
                 if (priority == 1) {
                     priorityMessage = " (Da dat lich - Uu tien cao)";
                 } else {
                     priorityMessage = " (Da dat lich)";
                 }
             } else {
                 priorityMessage = " (Truc tiep)";
             }
             request.getSession().setAttribute("successMessage", 
                 "Dang ky thanh cong cho benh nhan: " + patient.getFullName() + 
                 " - So thu tu: " + nextQueueNumber + priorityMessage);
            
            // Redirect to waiting screen
            response.sendRedirect(request.getContextPath() + "/patient-queue?action=view");
        } catch (Exception e) {
             e.printStackTrace();
             request.getSession().setAttribute("errorMessage", "Co loi xay ra khi dang ky benh nhan: " + e.getMessage());
             response.sendRedirect(request.getContextPath() + "/receptionist/checkin-form");
         }
    }
}