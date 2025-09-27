package control;

import config.GoogleConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "GoogleConfigServlet", urlPatterns = {"/google-config"})
public class GoogleConfigServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String clientId = GoogleConfig.getClientId();
            boolean isConfigured = GoogleConfig.isConfigured();
            
            out.print("{\"clientId\": \"" + clientId + "\", \"configured\": " + isConfigured + "}");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"Configuration error\"}");
        }
    }
}
