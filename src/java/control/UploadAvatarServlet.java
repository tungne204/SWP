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
            
            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("/") + "assets/img/avatars/";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Save file
            String filePath = uploadPath + uniqueFileName;
            filePart.write(filePath);
            
            // Update user avatar in database
            String avatarPath = "assets/img/avatars/" + uniqueFileName;
            boolean updateSuccess = userDAO.updateUserAvatar(user.getUserId(), avatarPath);
            
            if (updateSuccess) {
                // Update session
                user.setAvatar(avatarPath);
                session.setAttribute("acc", user);
                
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Avatar updated successfully");
                jsonResponse.addProperty("avatarPath", avatarPath);
            } else {
                // Delete uploaded file if database update failed
                Files.deleteIfExists(Paths.get(filePath));
                
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
