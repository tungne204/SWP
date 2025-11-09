/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control.ReceptionistControl;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.Receptionist.AppointmentDAO;
import dao.PatientQueueDAO;
import dao.PatientDAO;
import dao.ParentDAO;
import entity.Appointment;
import entity.PatientQueue;
import entity.Patient;
import entity.Parent;
import socket.PatientQueueWebSocket;
import util.QueueUpdateUtil;
import jakarta.servlet.*;
import java.util.*;
import java.util.Date;

/**
 * Handling status change requests
 *
 * URL: /Appointment-Status
 *
 * @author Kiên
 */
@WebServlet("/Appointment-Status")
public class AppointmentStatusServlet extends HttpServlet {

    private dao.Receptionist.AppointmentDAO appointmentDAO;
    private dao.AppointmentDAO mainAppointmentDAO;
    private PatientQueueDAO patientQueueDAO;
    private PatientDAO patientDAO;
    private ParentDAO parentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new dao.Receptionist.AppointmentDAO();
        mainAppointmentDAO = new dao.AppointmentDAO();
        patientQueueDAO = new PatientQueueDAO();
        patientDAO = new PatientDAO();
        parentDAO = new ParentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int appointmentId = Integer.parseInt(req.getParameter("id"));
            String newStatus = req.getParameter("status");  

            // Get current appointment to check if status is changing from "Confirmed" to "Waiting"
            // Must get BEFORE updating status to check the current status
            Appointment currentAppointment = mainAppointmentDAO.getById(appointmentId);
            String currentStatus = currentAppointment != null ? currentAppointment.getStatus() : null;

            // If status is changing from "Confirmed" to "Waiting", add patient to queue first
            // Then update appointment status
            if ("Waiting".equals(newStatus) && "Confirmed".equals(currentStatus)) {
                try {
                    addPatientToQueueFromAppointment(appointmentId, req);
                } catch (Exception queueException) {
                    // If adding to queue fails, don't update appointment status
                    // Error message is already set in addPatientToQueueFromAppointment
                    req.getSession().setAttribute("errorMessage", 
                        "Khong the them benh nhan vao hang cho: " + queueException.getMessage());
                    resp.sendRedirect("Appointment-List");
                    return;
                }
            }

            // Update appointment status after successfully adding to queue (if needed)
            appointmentDAO.updateStatus(appointmentId, newStatus);

            resp.sendRedirect("Appointment-List");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Co loi xay ra khi cap nhat trang thai: " + e.getMessage());
            resp.sendRedirect("Appointment-List");
        }
    }

    /**
     * Add patient to queue when appointment status changes from "Confirmed" to "Waiting"
     * Logic similar to CheckinFormServlet for booked patients
     */
    private void addPatientToQueueFromAppointment(int appointmentId, HttpServletRequest req) throws Exception {
        // Get appointment details
        Appointment appointment = mainAppointmentDAO.getById(appointmentId);
        if (appointment == null) {
            throw new Exception("Khong tim thay lich hen.");
        }

        int patientId = appointment.getPatientId();

        // Check if patient is already in queue today
        if (patientQueueDAO.isPatientInQueueToday(patientId)) {
            // Patient is already in queue today, don't add again
            req.getSession().setAttribute("errorMessage", "Benh nhan da o trong hang cho hom nay.");
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
        String priorityMessage = priority == 1 ? " (Uu tien cao)" : "";
        req.getSession().setAttribute("successMessage", 
            "Da them benh nhan vao hang cho: " + patient.getFullName() + 
            " - So thu tu: " + nextQueueNumber + priorityMessage);
    }
}


