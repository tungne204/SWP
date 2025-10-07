package control;

import dao.*;
import entity.*;
import context.DBContext;

import java.io.IOException;
import java.util.*;
import java.sql.Timestamp;

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

    @Override
    public void init() throws ServletException {
        patientQueueDAO = new PatientQueueDAO();
        patientDAO = new PatientDAO();
        appointmentDAO = new AppointmentDAO();
        consultationDAO = new ConsultationDAO();
        testResultDAO = new TestResultDAO();
        queueConfigDAO = new QueueConfigurationDAO();
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
            
            // Get consultation information if exists
            List<Consultation> consultations = consultationDAO.getConsultationsByPatientId(patient.getPatientId());
            if (!consultations.isEmpty()) {
                request.setAttribute("consultation", consultations.get(0)); // Get latest consultation
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
                // Create a new patient record first
                Patient newPatient = new Patient();
                newPatient.setFullName(request.getParameter("patientName"));
                newPatient.setAddress(request.getParameter("patientPhone")); // Using address field for phone
                // Set default values for required fields
                newPatient.setUserId(0); // Use 0 to indicate no user ID
                newPatient.setInsuranceInfo(""); // Empty insurance info
                newPatient.setParentId(null); // No parent
                newPatient.setDob(new Date()); // Set current date as default DOB
                
                // Save new patient and get the generated patient ID
                patientId = patientDAO.createPatient(newPatient);
                
                // Check if patient creation was successful
                if (patientId == -1) {
                    throw new Exception("Failed to create patient record");
                }
            } else {
                patientId = Integer.parseInt(patientIdStr);
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
            
            // Update patient queue status to "In Consultation"
            patientQueueDAO.updatePatientQueueStatus(queueId, "In Consultation");
            
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
            
            if (doctorId != null) {
                consultation.setDoctorId(doctorId);
            }
            
            consultation.setQueueId(queueId);
            consultation.setStartTime(new Date());
            consultation.setStatus("In Progress");
            
            // Save consultation
            consultationDAO.createConsultation(consultation);
            
            // Redirect to consultation page
            response.sendRedirect("patient-queue?action=consultation&queueId=" + queueId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    // Request lab test during consultation
    private void requestLabTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int queueId = Integer.parseInt(request.getParameter("queueId"));
            int consultationId = Integer.parseInt(request.getParameter("consultationId"));
            
            // Update patient queue status to "Awaiting Lab Results"
            patientQueueDAO.updatePatientQueueStatus(queueId, "Awaiting Lab Results");
            
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
            
            // Update patient queue status to "Completed"
            patientQueueDAO.updatePatientQueueStatus(queueId, "Completed");
            
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
}