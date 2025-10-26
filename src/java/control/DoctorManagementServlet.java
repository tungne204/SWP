/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package control;

import dao.DoctorDAO;
import dao.QualificationDAO;
import entity.Doctor;
import entity.Qualification;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Quang Anh
 */
@WebServlet(name="DoctorManagementServlet", urlPatterns={"/doctors1"})
public class DoctorManagementServlet extends HttpServlet {
    private DoctorDAO doctorDAO;
    private QualificationDAO qualificationDAO;
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        qualificationDAO = new QualificationDAO();
    }
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DoctorManagementServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DoctorManagementServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listDoctors(request, response);
                break;
            case "view":
                viewDoctor(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteDoctor(request, response);
                break;
            case "addQualification":
                showAddQualificationForm(request, response);
                break;
            case "editQualification":
                showEditQualificationForm(request, response);
                break;
            case "deleteQualification":
                deleteQualification(request, response);
                break;
            default:
                listDoctors(request, response);
                break;
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        switch (action) {
            case "insert":
                insertDoctor(request, response);
                break;
            case "update":
                updateDoctor(request, response);
                break;
            case "insertQualification":
                insertQualification(request, response);
                break;
            case "updateQualification":
                updateQualification(request, response);
                break;
            default:
                listDoctors(request, response);
                break;
        }
    }
private void listDoctors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Doctor> doctors = doctorDAO.getAllDoctors1();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/manager/doctor-list.jsp").forward(request, response);
    }
    
    // Xem chi tiết bác sĩ
    private void viewDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int doctorId = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorDAO.getDoctorById1(doctorId);
        
        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/manager/doctor-view.jsp").forward(request, response);
    }
    
    // Hiển thị form thêm bác sĩ
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/manager/doctor-add.jsp").forward(request, response);
    }
    
    // Hiển thị form sửa bác sĩ
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int doctorId = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorDAO.getDoctorById1(doctorId);
        
        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/manager/doctor-edit.jsp").forward(request, response);
    }
    
    // Thêm bác sĩ
    private void insertDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId"));
        String specialty = request.getParameter("specialty");
        
        boolean success = doctorDAO.insertDoctor(userId, specialty);
        
        if (success) {
            request.getSession().setAttribute("message", "Thêm bác sĩ thành công!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Thêm bác sĩ thất bại!");
            request.getSession().setAttribute("messageType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/manager/doctors?action=list");
    }
    
    // Cập nhật bác sĩ
    private void updateDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String specialty = request.getParameter("specialty");
        
        boolean success1 = doctorDAO.updateDoctorUser(userId, username, email, phone);
        boolean success2 = doctorDAO.updateDoctor(doctorId, specialty);
        
        if (success1 && success2) {
            request.getSession().setAttribute("message", "Cập nhật thông tin bác sĩ thành công!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Cập nhật thông tin bác sĩ thất bại!");
            request.getSession().setAttribute("messageType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/manager/doctors?action=view&id=" + doctorId);
    }
    
    // Xóa bác sĩ
    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int doctorId = Integer.parseInt(request.getParameter("id"));
        boolean success = doctorDAO.deleteDoctor(doctorId);
        
        if (success) {
            request.getSession().setAttribute("message", "Xóa bác sĩ thành công!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Xóa bác sĩ thất bại!");
            request.getSession().setAttribute("messageType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/manager/doctors?action=list");
    }
    
    // Hiển thị form thêm bằng cấp
    private void showAddQualificationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        request.setAttribute("doctorId", doctorId);
        request.getRequestDispatcher("/manager/qualification-add.jsp").forward(request, response);
    }
    
    // Hiển thị form sửa bằng cấp
    private void showEditQualificationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int qualId = Integer.parseInt(request.getParameter("id"));
        Qualification qual = qualificationDAO.getQualificationById(qualId);
        
        request.setAttribute("qualification", qual);
        request.getRequestDispatcher("/manager/qualification-edit.jsp").forward(request, response);
    }
    
    // Thêm bằng cấp
    private void insertQualification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        String degreeName = request.getParameter("degreeName");
        String institution = request.getParameter("institution");
        int yearObtained = Integer.parseInt(request.getParameter("yearObtained"));
        String certificateNumber = request.getParameter("certificateNumber");
        String description = request.getParameter("description");
        
        Qualification qual = new Qualification();
        qual.setDoctorId(doctorId);
        qual.setDegreeName(degreeName);
        qual.setInstitution(institution);
        qual.setYearObtained(yearObtained);
        qual.setCertificateNumber(certificateNumber);
        qual.setDescription(description);
        
        boolean success = qualificationDAO.insertQualification(qual);
        
        if (success) {
            request.getSession().setAttribute("message", "Thêm bằng cấp thành công!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Thêm bằng cấp thất bại!");
            request.getSession().setAttribute("messageType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/manager/doctors?action=view&id=" + doctorId);
    }
    
    // Cập nhật bằng cấp
    private void updateQualification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int qualId = Integer.parseInt(request.getParameter("qualificationId"));
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        String degreeName = request.getParameter("degreeName");
        String institution = request.getParameter("institution");
        int yearObtained = Integer.parseInt(request.getParameter("yearObtained"));
        String certificateNumber = request.getParameter("certificateNumber");
        String description = request.getParameter("description");
        
        Qualification qual = new Qualification();
        qual.setQualificationId(qualId);
        qual.setDoctorId(doctorId);
        qual.setDegreeName(degreeName);
        qual.setInstitution(institution);
        qual.setYearObtained(yearObtained);
        qual.setCertificateNumber(certificateNumber);
        qual.setDescription(description);
        
        boolean success = qualificationDAO.updateQualification(qual);
        
        if (success) {
            request.getSession().setAttribute("message", "Cập nhật bằng cấp thành công!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Cập nhật bằng cấp thất bại!");
            request.getSession().setAttribute("messageType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/manager/doctors?action=view&id=" + doctorId);
    }
    
    // Xóa bằng cấp
    private void deleteQualification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int qualId = Integer.parseInt(request.getParameter("id"));
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        
        boolean success = qualificationDAO.deleteQualification(qualId);
        
        if (success) {
            request.getSession().setAttribute("message", "Xóa bằng cấp thành công!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Xóa bằng cấp thất bại!");
            request.getSession().setAttribute("messageType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/manager/doctors?action=view&id=" + doctorId);
    }
    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
