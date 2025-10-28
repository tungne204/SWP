package control;

import dao.QualificationDAO;
import entity.Qualification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "QualificationManagementServlet", urlPatterns = {"/qualification-management"})
public class QualificationManagementServlet extends HttpServlet {
    
    private QualificationDAO qualificationDAO;
    
    @Override
    public void init() throws ServletException {
        qualificationDAO = new QualificationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listQualifications(request, response);
                break;
            case "view":
                viewQualification(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteQualification(request, response);
                break;
            default:
                listQualifications(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                insertQualification(request, response);
                break;
            case "edit":
                updateQualification(request, response);
                break;
            default:
                listQualifications(request, response);
                break;
        }
    }
    
    private void listQualifications(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Qualification> qualifications = qualificationDAO.getAllQualifications();
            request.setAttribute("qualifications", qualifications);
            request.getRequestDispatcher("QualificationManagement.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error retrieving qualifications");
        }
    }
    
    private void viewQualification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int qualificationId = Integer.parseInt(request.getParameter("id"));
            Qualification qualification = qualificationDAO.getQualificationById(qualificationId);
            request.setAttribute("qualification", qualification);
            request.getRequestDispatcher("QualificationView.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error retrieving qualification");
        }
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("QualificationAdd.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int qualificationId = Integer.parseInt(request.getParameter("id"));
            Qualification qualification = qualificationDAO.getQualificationById(qualificationId);
            request.setAttribute("qualification", qualification);
            request.getRequestDispatcher("QualificationEdit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error retrieving qualification for edit");
        }
    }
    
    private void insertQualification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String degreeName = request.getParameter("degreeName");
            String institution = request.getParameter("institution");
            int yearObtained = Integer.parseInt(request.getParameter("yearObtained"));
            String certificateNumber = request.getParameter("certificateNumber");
            String description = request.getParameter("description");
            
            Qualification qualification = new Qualification();
            qualification.setDoctorId(doctorId);
            qualification.setDegreeName(degreeName);
            qualification.setInstitution(institution);
            qualification.setYearObtained(yearObtained);
            qualification.setCertificateNumber(certificateNumber);
            qualification.setDescription(description);
            
            qualificationDAO.insertQualification(qualification);
            response.sendRedirect("qualification-management");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error adding qualification");
        }
    }
    
    private void updateQualification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int qualificationId = Integer.parseInt(request.getParameter("id"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String degreeName = request.getParameter("degreeName");
            String institution = request.getParameter("institution");
            int yearObtained = Integer.parseInt(request.getParameter("yearObtained"));
            String certificateNumber = request.getParameter("certificateNumber");
            String description = request.getParameter("description");
            
            Qualification qualification = new Qualification();
            qualification.setQualificationId(qualificationId);
            qualification.setDoctorId(doctorId);
            qualification.setDegreeName(degreeName);
            qualification.setInstitution(institution);
            qualification.setYearObtained(yearObtained);
            qualification.setCertificateNumber(certificateNumber);
            qualification.setDescription(description);
            
            qualificationDAO.updateQualification(qualification);
            response.sendRedirect("qualification-management");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error updating qualification");
        }
    }
    
    private void deleteQualification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int qualificationId = Integer.parseInt(request.getParameter("id"));
            qualificationDAO.deleteQualification(qualificationId);
            response.sendRedirect("qualification-management");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error deleting qualification");
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Qualification Management Servlet";
    }
}