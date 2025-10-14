package control;

import dao.*;
import entity.*;
import socket.PatientQueueWebSocket;
import util.QueueUpdateUtil;

import java.io.IOException;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "PatientQueueController", urlPatterns = {"/patient-queue"})
public class PatientQueueController extends HttpServlet {

    private PatientQueueDAO patientQueueDAO;
    private PatientDAO patientDAO;
    private AppointmentDAO appointmentDAO;
    private ConsultationDAO consultationDAO;
    private TestResultDAO testResultDAO;
    private QueueConfigurationDAO queueConfigDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        patientQueueDAO = new PatientQueueDAO();
        patientDAO = new PatientDAO();
        appointmentDAO = new AppointmentDAO();
        consultationDAO = new ConsultationDAO();
        testResultDAO = new TestResultDAO();
        queueConfigDAO = new QueueConfigurationDAO();
        doctorDAO = new DoctorDAO();
        
        // Ensure at least one doctor exists in the database
        doctorDAO.ensureDefaultDoctorExists();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "view":
                viewWaitingScreen(request, response);
                break;
            case "public-view":
                viewPublicWaitingScreen(request, response);
                break;
            case "consultation":
                viewConsultation(request, response);
                break;
            default:
                viewWaitingScreen(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "checkin";
        }

        switch (action) {
            case "checkin":
                processPatientCheckin(request, response);
                break;
            case "startConsultation":
                startConsultation(request, response);
                break;
            case "markReady":
                markReadyForExamination(request, response);
                break;
            case "requestLabTest":
                requestLabTest(request, response);
                break;
            case "completeLabTest":
                completeLabTest(request, response);
                break;
            case "completeVisit":
                completeVisit(request, response);
                break;
            default:
                viewWaitingScreen(request, response);
                break;
        }
    }

    // View the waiting screen with all patients in queue
    private void viewWaitingScreen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get all patients in queue ordered by priority and check-in time
            List<PatientQueue> queue = patientQueueDAO.getAllPatientsInQueue();
            
            // Get patient details for each queue entry
            List<Map<String, Object>> queueDetails = new ArrayList<>();
            for (PatientQueue pq : queue) {
                Map<String, Object> details = new HashMap<>();
                details.put("queue", pq);
                
                // Get patient information
                Patient patient = patientDAO.getPatientById(pq.getPatientId());
                details.put("patient", patient);
                
                // Get appointment information if exists
                if (pq.getAppointmentId() != null) {
                    Appointment appointment = appointmentDAO.getAppointmentById(pq.getAppointmentId());
                    details.put("appointment", appointment);
                }
                
                queueDetails.add(details);
            }
            
            request.setAttribute("queueDetails", queueDetails);
            request.getRequestDispatcher("/patient-queue/waiting-screen.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    // View the public waiting screen with all patients in queue (no authentication required)
    private void viewPublicWaitingScreen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get all patients in queue ordered by priority and check-in time
            List<PatientQueue> queue = patientQueueDAO.getAllPatientsInQueue();
            
            // Get patient details for each queue entry
            List<Map<String, Object>> queueDetails = new ArrayList<>();
            for (PatientQueue pq : queue) {
                Map<String, Object> details = new HashMap<>();
                details.put("queue", pq);
                
                // Get patient information
                Patient patient = patientDAO.getPatientById(pq.getPatientId());
                details.put("patient", patient);
                
                // Get appointment information if exists
                if (pq.getAppointmentId() != null) {
                    Appointment appointment = appointmentDAO.getAppointmentById(pq.getAppointmentId());
                    details.put("appointment", appointment);
                }
                
                queueDetails.add(details);
            }
            
            request.setAttribute("queueDetails", queueDetails);
            request.getRequestDispatcher("/patient-queue/public-waiting-screen.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }


    // View consultation details
    private void viewConsultation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int queueId = Integer.parseInt(request.getParameter("queueId"));
            
            // Get patient queue information
            PatientQueue patientQueue = patientQueueDAO.getPatientQueueById(queueId);
            request.setAttribute("patientQueue", patientQueue);
            
            // Get patient information
            Patient patient = patientDAO.getPatientById(patientQueue.getPatientId());
            request.setAttribute("patient", patient);
            
            // Get appointment information if exists
            if (patientQueue.getAppointmentId() != null) {
                Appointment appointment = appointmentDAO.getAppointmentById(patientQueue.getAppointmentId());
                request.setAttribute("appointment", appointment);
            }
            
            // Get consultation information for this specific queue entry
            Consultation consultation = consultationDAO.getConsultationByQueueId(queueId);
            if (consultation != null) {
                request.setAttribute("consultation", consultation);
            }
            
            request.getRequestDispatcher("/patient-queue/consultation.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    // Process patient check-in (walk-in or pre-booked)
    private void processPatientCheckin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String patientType = request.getParameter("patientType"); // "walkin" or "booked"
            String patientIdStr = request.getParameter("patientId");
            int patientId;
            
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                // Handle walk-in patients without existing patient ID
                String patientName = request.getParameter("patientName");
                String patientPhone = request.getParameter("patientPhone");
                String dobStr = request.getParameter("dob");
                String addressInput = request.getParameter("address");
                String insuranceInfoInput = request.getParameter("insuranceInfo");
                
                // Check if patient already exists by name and phone
                Patient existingPatient = patientDAO.findPatientByNameAndPhone(patientName, patientPhone);
                
                if (existingPatient != null) {
                    // Patient already exists, use existing patient ID
                    patientId = existingPatient.getPatientId();
                } else {
                    // Create a new patient record
                    Patient newPatient = new Patient();
                    newPatient.setFullName(patientName);
                    // Prefer actual address input; fallback to parent phone for legacy matching
                    if (addressInput != null && !addressInput.trim().isEmpty()) {
                        newPatient.setAddress(addressInput.trim());
                    } else {
                        newPatient.setAddress(patientPhone); // legacy: store phone in address if no address provided
                    }
                    // Set default values for required fields
                    newPatient.setUserId(0); // Use 0 to indicate no user ID
                    newPatient.setInsuranceInfo(insuranceInfoInput != null ? insuranceInfoInput.trim() : "");
                    newPatient.setParentId(null); // No parent
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
                }
            } else {
                patientId = Integer.parseInt(patientIdStr);
            }
            
            // Check if patient is already in queue today
            if (patientQueueDAO.isPatientInQueueToday(patientId)) {
                // Patient is already in queue today, redirect with message
                request.getSession().setAttribute("errorMessage", "Benh nhan da o trong hang cho.");
                response.sendRedirect(request.getContextPath() +"/patient-queue/checkin-form.jsp");
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
            
            // If this is a booked patient, get appointment ID
            if ("booked".equals(patientType)) {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                patientQueue.setAppointmentId(appointmentId);
                
                // Update appointment status to active
                appointmentDAO.updateAppointmentStatus(appointmentId, true);
            }
            
            patientQueue.setQueueNumber(nextQueueNumber);
            patientQueue.setQueueType("booked".equals(patientType) ? "Booked" : "Walk-in");
            patientQueue.setStatus("Waiting");
            
            // Set priority based on configuration
            int priority = 0;
            if ("booked".equals(patientType)) {
                // Booked patients get higher priority
                priority = 1;
            }
            patientQueue.setPriority(priority);
            
            patientQueue.setCheckInTime(new Date());
            patientQueue.setUpdatedTime(new Date());
            
            // Add patient to queue
            patientQueueDAO.addPatientToQueue(patientQueue);
            
            // Broadcast WebSocket update for new patient in queue
            try {
                Patient patient = patientDAO.getPatientById(patientId);
                String patientJson = QueueUpdateUtil.createPatientQueueJson(patient, patientQueue);
                PatientQueueWebSocket.broadcastQueueUpdate("patient_added", patientJson);
            } catch (Exception e) {
                System.err.println("Error broadcasting WebSocket update: " + e.getMessage());
            }
            
            // Redirect to waiting screen
            response.sendRedirect("patient-queue?action=view");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    // Start consultation with a patient
    private void startConsultation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int queueId = Integer.parseInt(request.getParameter("queueId"));
            
            // Assign consultation room (get from request or auto-assign)
            String roomNumber = request.getParameter("roomNumber");
            if (roomNumber == null || roomNumber.trim().isEmpty()) {
                // Auto-assign next available room (Room 1-10)
                roomNumber = getNextAvailableRoom();
            }
            
            // Update patient queue status to "In Consultation" and assign room
            patientQueueDAO.updatePatientQueueStatus(queueId, "In Consultation");
            patientQueueDAO.updatePatientQueueRoomNumber(queueId, roomNumber);
            
            // Broadcast WebSocket update for status change
            try {
                PatientQueue updatedQueue = patientQueueDAO.getPatientQueueById(queueId);
                Patient patient = patientDAO.getPatientById(updatedQueue.getPatientId());
                String patientJson = QueueUpdateUtil.createPatientQueueJson(patient, updatedQueue);
                PatientQueueWebSocket.broadcastQueueUpdate("status_changed", patientJson);
            } catch (Exception e) {
                System.err.println("Error broadcasting WebSocket update: " + e.getMessage());
            }
            
            // Get patient queue information
            PatientQueue patientQueue = patientQueueDAO.getPatientQueueById(queueId);
            
            // Create a new consultation record
            Consultation consultation = new Consultation();
            consultation.setPatientId(patientQueue.getPatientId());
            
            // Get doctor ID from session or request
            HttpSession session = request.getSession();
            Integer doctorId = (Integer) session.getAttribute("doctorId");
            if (doctorId == null) {
                // If not in session, try to get from request
                String doctorIdStr = request.getParameter("doctorId");
                if (doctorIdStr != null) {
                    doctorId = Integer.parseInt(doctorIdStr);
                }
            }
            
            // If still no doctor ID found, get the first available doctor
            if (doctorId == null) {
                List<Doctor> doctors = doctorDAO.getAllDoctors();
                if (!doctors.isEmpty()) {
                    doctorId = doctors.get(0).getDoctorId();
                } else {
                    // No doctors in database - this is a critical error
                    throw new IllegalStateException("No doctors found in database. Cannot create consultation.");
                }
            }
            
            consultation.setDoctorId(doctorId);
            
            consultation.setQueueId(queueId);
            consultation.setStartTime(new Date());
            consultation.setStatus("In Progress");
            
            // Save consultation and get the generated ID
            int consultationId = consultationDAO.createConsultation(consultation);
            consultation.setConsultationId(consultationId);
            
            // Redirect to consultation page
            response.sendRedirect("patient-queue?action=consultation&queueId=" + queueId);
        } catch (NumberFormatException e) {
            System.err.println("Number format error in requestLabTest: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi định dạng số: Tham số không hợp lệ");
            request.getRequestDispatcher("patient-queue?action=view").forward(request, response);
        } catch (IllegalArgumentException e) {
            System.err.println("Parameter validation error in requestLabTest: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi tham số: " + e.getMessage());
            request.getRequestDispatcher("patient-queue?action=view").forward(request, response);
        } catch (Exception e) {
            System.err.println("Unexpected error in requestLabTest: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Da xay ra loi khi yeu cau xet nghiem");
            request.getRequestDispatcher("patient-queue?action=view").forward(request, response);
        }
    }

    // Get next available consultation room
    private String getNextAvailableRoom() {
        List<PatientQueue> inConsultation = patientQueueDAO.getPatientsByStatus("In Consultation");
        Set<String> occupiedRooms = new HashSet<>();
        
        for (PatientQueue pq : inConsultation) {
            if (pq.getRoomNumber() != null) {
                occupiedRooms.add(pq.getRoomNumber());
            }
        }
        
        // Try rooms 1-10
        for (int i = 1; i <= 10; i++) {
            String room = "Room " + i;
            if (!occupiedRooms.contains(room)) {
                return room;
            }
        }
        
        // If all rooms occupied, assign to Room 1 anyway
        return "Room 1";
    }

    // Request lab test during consultation
    private void requestLabTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Validate queueId parameter
            String queueIdParam = request.getParameter("queueId");
            if (queueIdParam == null || queueIdParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Queue ID is required");
            }
            int queueId = Integer.parseInt(queueIdParam);
            
            // Validate consultationId parameter
            String consultationIdParam = request.getParameter("consultationId");
            if (consultationIdParam == null || consultationIdParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Consultation ID is required");
            }
            int consultationId = Integer.parseInt(consultationIdParam);
            
            // Update patient queue status to "Awaiting Lab Results"
            patientQueueDAO.updatePatientQueueStatus(queueId, "Awaiting Lab Results");
            
            // Broadcast WebSocket update for status change
            try {
                PatientQueue updatedQueue = patientQueueDAO.getPatientQueueById(queueId);
                Patient patient = patientDAO.getPatientById(updatedQueue.getPatientId());
                String patientJson = QueueUpdateUtil.createPatientQueueJson(patient, updatedQueue);
                PatientQueueWebSocket.broadcastQueueUpdate("status_changed", patientJson);
            } catch (Exception e) {
                System.err.println("Error broadcasting WebSocket update: " + e.getMessage());
            }
            
            // Update consultation status to "Lab Requested"
            consultationDAO.updateConsultationStatus(consultationId, "Lab Requested");
            
            // Get the next patient in queue with "Waiting" status
            List<PatientQueue> waitingPatients = patientQueueDAO.getPatientsByStatus("Waiting");
            if (!waitingPatients.isEmpty()) {
                // Promote the next patient to the top of the queue
                PatientQueue nextPatient = waitingPatients.get(0);
                // In a real implementation, you might want to implement a more sophisticated
                // promotion algorithm based on priority and check-in time
            }
            
            // Redirect to consultation page
            response.sendRedirect("patient-queue?action=consultation&queueId=" + queueId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    // Complete lab test and update patient status
    private void completeLabTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int consultationId = Integer.parseInt(request.getParameter("consultationId"));
            
            // Get consultation details
            Consultation consultation = consultationDAO.getConsultationById(consultationId);
            
            // Update consultation status
            consultationDAO.updateConsultationStatus(consultationId, "Lab Completed");
            
            // Update patient queue status to "Ready for Follow-up"
            patientQueueDAO.updatePatientQueueStatus(consultation.getQueueId(), "Ready for Follow-up");
            
            // Broadcast WebSocket update for status change
            try {
                PatientQueue updatedQueue = patientQueueDAO.getPatientQueueById(consultation.getQueueId());
                Patient patient = patientDAO.getPatientById(updatedQueue.getPatientId());
                String patientJson = QueueUpdateUtil.createPatientQueueJson(patient, updatedQueue);
                PatientQueueWebSocket.broadcastQueueUpdate("status_changed", patientJson);
            } catch (Exception e) {
                System.err.println("Error broadcasting WebSocket update: " + e.getMessage());
            }
            
            // Increase priority for this patient to ensure they are seen next
            patientQueueDAO.updatePatientQueuePriority(consultation.getQueueId(), 2); // High priority
            
            // Redirect to waiting screen
            response.sendRedirect("patient-queue?action=view");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    // Complete visit and remove patient from queue
    private void completeVisit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int queueId = Integer.parseInt(request.getParameter("queueId"));
            int consultationId = Integer.parseInt(request.getParameter("consultationId"));
            
            // Clear room number before completion
            patientQueueDAO.updatePatientQueueRoomNumber(queueId, null);
            
            // Update patient queue status to "Completed"
            patientQueueDAO.updatePatientQueueStatus(queueId, "Completed");
            
            // Broadcast WebSocket update for status change
            try {
                PatientQueue updatedQueue = patientQueueDAO.getPatientQueueById(queueId);
                Patient patient = patientDAO.getPatientById(updatedQueue.getPatientId());
                String patientJson = QueueUpdateUtil.createPatientQueueJson(patient, updatedQueue);
                PatientQueueWebSocket.broadcastQueueUpdate("status_changed", patientJson);
            } catch (Exception e) {
                System.err.println("Error broadcasting WebSocket update: " + e.getMessage());
            }
            
            // Update consultation status to "Completed"
            consultationDAO.updateConsultationStatus(consultationId, "Completed");
            consultationDAO.updateConsultationEndTime(consultationId, new Date());
            
            // Remove patient from queue
            patientQueueDAO.removePatientFromQueue(queueId);
            
            // Redirect to waiting screen
            response.sendRedirect("patient-queue?action=view");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    // Mark a patient as ready for examination and optionally set room number
    private void markReadyForExamination(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int queueId = Integer.parseInt(request.getParameter("queueId"));
            String roomNumber = request.getParameter("roomNumber");

            // Update patient queue status to "Ready for Examination"
            patientQueueDAO.updatePatientQueueStatus(queueId, "Ready for Examination");
            
            // Optionally assign room number if provided
            if (roomNumber != null && roomNumber.trim().length() > 0) {
                patientQueueDAO.updatePatientQueueRoomNumber(queueId, roomNumber.trim());
            }

            // Broadcast WebSocket update for status change
            try {
                PatientQueue updatedQueue = patientQueueDAO.getPatientQueueById(queueId);
                Patient patient = patientDAO.getPatientById(updatedQueue.getPatientId());
                String patientJson = QueueUpdateUtil.createPatientQueueJson(patient, updatedQueue);
                PatientQueueWebSocket.broadcastQueueUpdate("status_changed", patientJson);
            } catch (Exception e) {
                System.err.println("Error broadcasting WebSocket update: " + e.getMessage());
            }

            // Redirect to waiting screen
            response.sendRedirect("patient-queue?action=view");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}