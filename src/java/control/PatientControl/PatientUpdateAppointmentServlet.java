package control.PatientControl;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;

/**
 * Patient Update Appointment Servlet - Handles patient appointment updates
 * This servlet is specifically for patient functionality to avoid conflicts
 */
@WebServlet(name="PatientUpdateAppointmentServlet", urlPatterns={"/PatientUpdateAppointmentServlet"})
public class PatientUpdateAppointmentServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        
        try {
            // Debug: Log all parameters
            System.out.println("=== PatientUpdateAppointmentServlet Debug ===");
            System.out.println("Request method: " + request.getMethod());
            System.out.println("Content type: " + request.getContentType());
            System.out.println("Content length: " + request.getContentLength());
            System.out.println("Request URI: " + request.getRequestURI());
            System.out.println("Request URL: " + request.getRequestURL());
            System.out.println("Servlet path: " + request.getServletPath());
            System.out.println("Path info: " + request.getPathInfo());
            
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            int paramCount = 0;
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println("Parameter " + (++paramCount) + ": " + paramName + " = " + paramValue);
            }
            System.out.println("Total parameters received: " + paramCount);
            
            // Debug: Try to read raw request body
            try {
                java.io.BufferedReader reader = request.getReader();
                StringBuilder body = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    body.append(line);
                }
                System.out.println("Raw request body: " + body.toString());
            } catch (Exception e) {
                System.out.println("Could not read request body: " + e.getMessage());
            }
            
            System.out.println("=== End Debug ===");
            
            // Get parameters with validation
            String appointmentIdStr = request.getParameter("appointmentId");
            String patientIdStr = request.getParameter("patientId");
            String parentIdStr = request.getParameter("parentId");
            String doctorIdStr = request.getParameter("doctorId");
            String dateTimeStr = request.getParameter("dateTime");
            
            // Patient data
            String patientFullName = request.getParameter("patientFullName");
            String patientDobStr = request.getParameter("patientDob");
            String patientAddress = request.getParameter("patientAddress");
            String patientInsuranceInfo = request.getParameter("patientInsuranceInfo");
            
            // Parent data
            String parentName = request.getParameter("parentName");
            String parentIdInfo = request.getParameter("parentIdInfo");
            
            // Debug: Log each parameter
            System.out.println("=== Parameter Values ===");
            System.out.println("appointmentIdStr: " + appointmentIdStr);
            System.out.println("patientIdStr: " + patientIdStr);
            System.out.println("parentIdStr: " + parentIdStr);
            System.out.println("doctorIdStr: " + doctorIdStr);
            System.out.println("dateTimeStr: " + dateTimeStr);
            System.out.println("patientFullName: " + patientFullName);
            System.out.println("patientDobStr: " + patientDobStr);
            System.out.println("patientAddress: " + patientAddress);
            System.out.println("patientInsuranceInfo: " + patientInsuranceInfo);
            System.out.println("parentName: " + parentName);
            System.out.println("parentIdInfo: " + parentIdInfo);
            System.out.println("=== End Parameter Values ===");
            
            // Validate required parameters
            if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
                System.out.println("ERROR: appointmentIdStr is null or empty!");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Appointment ID is required");
                return;
            }
            
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Patient ID is required");
                return;
            }
            
            if (parentIdStr == null || parentIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Parent ID is required");
                return;
            }
            
            if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Doctor ID is required");
                return;
            }
            
            if (dateTimeStr == null || dateTimeStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Date and time is required");
                return;
            }
            
            // Parse parameters
            int appointmentId = Integer.parseInt(appointmentIdStr);
            int patientId = Integer.parseInt(patientIdStr);
            int parentId = Integer.parseInt(parentIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            
            // Parse datetime
            java.util.Date dateTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(dateTimeStr);
            
            // Validate datetime is in the future
            if (dateTime.before(new java.util.Date())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Appointment date must be in the future");
                return;
            }

            // Parse patient DOB
            java.util.Date patientDob = new SimpleDateFormat("yyyy-MM-dd").parse(patientDobStr);

            // Update Parent
            dao.RolePatient.ParentDAO parentDAO = new dao.RolePatient.ParentDAO();
            entity.Parent parent = new entity.Parent();
            parent.setParentId(parentId);
            parent.setParentname(parentName);
            parent.setIdInfo(parentIdInfo);
            parentDAO.updateParent(parent);
            System.out.println("Parent updated: " + parentName);

            // Update Patient
            dao.RolePatient.PatientDAO patientDAO = new dao.RolePatient.PatientDAO();
            entity.Patient patient = new entity.Patient();
            patient.setPatientId(patientId);
            patient.setFullName(patientFullName);
            patient.setDob(patientDob);
            patient.setAddress(patientAddress);
            patient.setInsuranceInfo(patientInsuranceInfo);
            patient.setParentId(parentId);
            patientDAO.updatePatient(patient);
            System.out.println("Patient updated: " + patientFullName);

            // Update Appointment - only update patient_id, doctor_id, date_time
            // Keep existing status unchanged
            dao.RolePatient.PatientAppointmentDAO appointmentDAO = new dao.RolePatient.PatientAppointmentDAO();
            
            // Get existing appointment to preserve status
            entity.Appointment existingAppointment = appointmentDAO.getAppointmentById(appointmentId);
            if (existingAppointment != null) {
                // Create new appointment object with updated fields but same status
                entity.Appointment appointment = new entity.Appointment();
                appointment.setAppointmentId(appointmentId);
                appointment.setPatientId(patientId);
                appointment.setDoctorId(doctorId);
                appointment.setDateTime(dateTime);
                appointment.setStatus(existingAppointment.isStatus()); // Keep existing status
                
                appointmentDAO.updateAppointment(appointment);
            } else {
                throw new Exception("Appointment not found with ID: " + appointmentId);
            }
            
            System.out.println("Appointment updated successfully: " + appointmentId);
            
            // If no exception thrown, update was successful
            response.getWriter().write("success");

        } catch (NumberFormatException e) {
            System.err.println("NumberFormatException in PatientUpdateAppointmentServlet: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid number format");
        } catch (java.text.ParseException e) {
            System.err.println("ParseException in PatientUpdateAppointmentServlet: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid date format");
        } catch (Exception e) {
            System.err.println("Exception in PatientUpdateAppointmentServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Internal server error: " + e.getMessage());
        }
    }
}
