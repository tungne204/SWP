package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import entity.User;

@WebFilter(urlPatterns = {"/doctor/*", "/receptionist/*", "/manager/*", "/patient-queue/*", "/medical-assistant/*"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("acc") : null;

        if (acc == null) {
            res.sendRedirect(req.getContextPath() + "/Login.jsp");
            return;
        }

        int roleId = acc.getRoleId();
        String uri = req.getRequestURI();

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
        if (uri.contains("/patient-queue/") && roleId != 3) {
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
