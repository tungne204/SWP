package control;

import dao.DoctorDAO;
import entity.Doctor;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet(name = "UploadCertificateServlet", urlPatterns = {"/uploadCertificate"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 20    // 20MB
)
public class UploadCertificateServlet extends HttpServlet {

    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
    }
    
    /**
     * Find the project root directory by looking for build.xml or nbproject folder
     */
    private File findProjectRoot() {
        // Strategy 1: Try to find from webapp root
        try {
            String webappRoot = getServletContext().getRealPath("/");
            File current = new File(webappRoot);
            
            // Go up directories looking for build.xml or nbproject
            for (int i = 0; i < 5 && current != null; i++) {
                File buildXml = new File(current, "build.xml");
                File nbproject = new File(current, "nbproject");
                if (buildXml.exists() || nbproject.exists()) {
                    return current;
                }
                current = current.getParentFile();
            }
        } catch (Exception e) {
            // Continue to next strategy
        }
        
        // Strategy 2: Use user.dir (working directory)
        try {
            String userDir = System.getProperty("user.dir");
            if (userDir != null) {
                File dir = new File(userDir);
                File buildXml = new File(dir, "build.xml");
                File nbproject = new File(dir, "nbproject");
                if (buildXml.exists() || nbproject.exists()) {
                    return dir;
                }
            }
        } catch (Exception e) {
            // Continue to next strategy
        }
        
        // Strategy 3: Fallback - go up from webapp root (2 levels typical)
        try {
            String webappRoot = getServletContext().getRealPath("/");
            File webappDir = new File(webappRoot);
            File projectRoot = webappDir.getParentFile();
            if (projectRoot != null) {
                projectRoot = projectRoot.getParentFile();
            }
            if (projectRoot != null && projectRoot.exists()) {
                return projectRoot;
            }
        } catch (Exception e) {
            // Last resort
        }
        
        // Last resort: return current directory
        return new File(System.getProperty("user.dir", "."));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("acc") == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "User not logged in");
                out.print(jsonResponse.toString());
                return;
            }
            
            User user = (User) session.getAttribute("acc");
            
            // Check if user is a Doctor
            if (user.getRoleId() != 2) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Only doctors can upload certificates");
                out.print(jsonResponse.toString());
                return;
            }
            
            Part filePart = request.getPart("certificate");
            
            if (filePart == null || filePart.getSize() == 0) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "No file uploaded");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Get file extension
            String fileName = filePart.getSubmittedFileName();
            String fileExtension = "";
            if (fileName != null && fileName.contains(".")) {
                fileExtension = fileName.substring(fileName.lastIndexOf("."));
            }
            
            // Generate unique filename
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            
            // Find project root - try multiple strategies
            File projectRoot = findProjectRoot();
            
            // Use source folder path (will be copied to build during build process)
            String sourcePath = projectRoot.getAbsolutePath() + File.separator + "web" + File.separator + "assets" + File.separator + "docs" + File.separator + "certificates" + File.separator;
            File sourceDir = new File(sourcePath);
            if (!sourceDir.exists()) {
                sourceDir.mkdirs();
            }
            
            // Also save to webapp directory for immediate access
            String webappRoot = getServletContext().getRealPath("/");
            String webappPath = webappRoot + "assets/docs/certificates/";
            File webappDir2 = new File(webappPath);
            if (!webappDir2.exists()) {
                webappDir2.mkdirs();
            }
            
            // Save file to source folder first (persistent - won't be deleted on clean)
            String sourceFilePath = sourcePath + uniqueFileName;
            filePart.write(sourceFilePath);
            
            // Also copy to webapp directory for immediate use
            try {
                String webappFilePath = webappPath + uniqueFileName;
                Files.copy(Paths.get(sourceFilePath), Paths.get(webappFilePath), 
                          java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            } catch (Exception e) {
                // If copy fails, webapp will use file from source during next build
                System.out.println("Note: Could not copy to webapp directory: " + e.getMessage());
            }
            
            // Get old certificate path before updating (to delete it later)
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
            String oldCertificatePath = (doctor != null && doctor.getCertificate() != null) 
                    ? doctor.getCertificate() : null;
            
            // Update doctor certificate in database
            String certificatePath = "assets/docs/certificates/" + uniqueFileName;
            boolean updateSuccess = doctorDAO.updateDoctorCertificate(user.getUserId(), certificatePath);
            
            if (updateSuccess) {
                // Delete old certificate file if it exists and is not empty
                if (oldCertificatePath != null && !oldCertificatePath.isEmpty()) {
                    try {
                        // Delete from source folder
                        String oldSourcePath = projectRoot.getAbsolutePath() + File.separator + "web" + File.separator + oldCertificatePath;
                        Files.deleteIfExists(Paths.get(oldSourcePath));
                        
                        // Delete from webapp folder
                        String oldWebappPath = webappRoot + oldCertificatePath;
                        Files.deleteIfExists(Paths.get(oldWebappPath));
                    } catch (Exception e) {
                        // Log but don't fail if old file deletion fails
                        System.out.println("Note: Could not delete old certificate file: " + e.getMessage());
                    }
                }
                
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Certificate uploaded successfully");
                jsonResponse.addProperty("certificatePath", certificatePath);
            } else {
                // Delete uploaded file if database update failed
                Files.deleteIfExists(Paths.get(sourceFilePath));
                try {
                    Files.deleteIfExists(Paths.get(webappPath + uniqueFileName));
                } catch (Exception e) {
                    // Ignore
                }
                
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to update certificate in database");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error uploading certificate: " + e.getMessage());
        }
        
        out.print(jsonResponse.toString());
        out.flush();
    }
}

