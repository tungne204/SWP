package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import entity.User;

@WebFilter(urlPatterns = {"/doctor/*", "/receptionist/*", "/manager/*", "/patient/*", "/patient-queue/*", "/medical-assistant/*"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Allow public access to patient-queue public-view action
        String uri = req.getRequestURI();
        String action = req.getParameter("action");
        if (uri.contains("/patient-queue") && "public-view".equals(action)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("acc") : null;

        if (acc == null) {
            res.sendRedirect(req.getContextPath() + "/Login.jsp");
            return;
        }

        int roleId = acc.getRoleId();

        if (uri.contains("/doctor/") && roleId != 2) {
            res.sendRedirect(req.getContextPath() + "/403.jsp");
            return;
        }
        if (uri.contains("/receptionist/") && roleId != 5) {
            res.sendRedirect(req.getContextPath() + "/403.jsp");
            return;
        }
        if (uri.contains("/manager/") && roleId != 1) {
            res.sendRedirect(req.getContextPath() + "/403.jsp");
            return;
        }
        if (uri.contains("/patient-queue/")) {
            // Allow multiple roles to access patient-queue view action
            if ("view".equals(action)) {
                // Allow doctor (2), patient (3), medical-assistant (4), receptionist (5), manager (1)
                if (roleId != 1 && roleId != 2 && roleId != 3 && roleId != 4 && roleId != 5) {
                    res.sendRedirect(req.getContextPath() + "/403.jsp");
                    return;
                }
            } else {
                // For other actions, only allow patients (roleId = 3)
                if (roleId != 3) {
                    res.sendRedirect(req.getContextPath() + "/403.jsp");
                    return;
                }
            }
        if (uri.contains("/patient/") && roleId != 3) {
            res.sendRedirect(req.getContextPath() + "/403.jsp");
            return;
        }
        if (uri.contains("/medical-assistant/") && roleId != 4) {
            res.sendRedirect(req.getContextPath() + "/403.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}
