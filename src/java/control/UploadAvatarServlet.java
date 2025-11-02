package control;

import dao.UserDAO;
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

@WebServlet(name = "UploadAvatarServlet", urlPatterns = {"/uploadAvatar"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB
    maxRequestSize = 1024 * 1024 * 10    // 10MB
)
public class UploadAvatarServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
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
            Part filePart = request.getPart("avatar");
            
            if (filePart == null || filePart.getSize() == 0) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "No file uploaded");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Validate file type
            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Please upload an image file");
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
            String sourcePath = projectRoot.getAbsolutePath() + File.separator + "web" + File.separator + "assets" + File.separator + "img" + File.separator + "avatars" + File.separator;
            File sourceDir = new File(sourcePath);
            if (!sourceDir.exists()) {
                sourceDir.mkdirs();
            }
            
            // Also save to webapp directory for immediate access
            String webappRoot = getServletContext().getRealPath("/");
            String webappPath = webappRoot + "assets/img/avatars/";
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
            
            // Get old avatar path before updating (to delete it later)
            String oldAvatarPath = user.getAvatar();
            
            // Update user avatar in database
            String avatarPath = "assets/img/avatars/" + uniqueFileName;
            boolean updateSuccess = userDAO.updateUserAvatar(user.getUserId(), avatarPath);
            
            if (updateSuccess) {
                // Delete old avatar file if it exists and is not default avatar
                if (oldAvatarPath != null && !oldAvatarPath.isEmpty() 
                    && !oldAvatarPath.equals("assets/img/default-avatar.png") 
                    && !oldAvatarPath.equals("assets/img/avata.jpg")) {
                    try {
                        // Delete from source folder
                        String oldSourcePath = projectRoot.getAbsolutePath() + File.separator + "web" + File.separator + oldAvatarPath;
                        Files.deleteIfExists(Paths.get(oldSourcePath));
                        
                        // Delete from webapp folder
                        String oldWebappPath = webappRoot + oldAvatarPath;
                        Files.deleteIfExists(Paths.get(oldWebappPath));
                    } catch (Exception e) {
                        // Log but don't fail if old file deletion fails
                        System.out.println("Note: Could not delete old avatar file: " + e.getMessage());
                    }
                }
                
                // Update session
                user.setAvatar(avatarPath);
                session.setAttribute("acc", user);
                
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Avatar updated successfully");
                jsonResponse.addProperty("avatarPath", avatarPath);
            } else {
                // Delete uploaded file if database update failed
                Files.deleteIfExists(Paths.get(sourceFilePath));
                try {
                    Files.deleteIfExists(Paths.get(webappPath + uniqueFileName));
                } catch (Exception e) {
                    // Ignore
                }
                
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to update avatar in database");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error uploading avatar: " + e.getMessage());
        }
        
        out.print(jsonResponse.toString());
        out.flush();
    }
}

