package control.ReceptionistControl;

import dao.Receptionist.PatientDAO;
import entity.Receptionist.Patient;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "PatientListServlet", urlPatterns = {"/Patient-List", "/Patient-Search"})
public class PatientListServlet extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        User acc = (User) session.getAttribute("acc");
        String role = "";
        if (acc != null && acc.getRoleId() != 0) {
            switch (acc.getRoleId()) {
                case 5 ->
                    role = "Receptionist";
                case 2 ->
                    role = "Doctor";
                case 3 ->
                    role = "Patient";
                default ->
                    role = "Other";
            }
        }
        session.setAttribute("role", role);

        if (!"Receptionist".equals(role)) {
            req.setAttribute("error", "Bạn không có quyền truy cập trang danh sách bệnh nhân.");
            req.setAttribute("patients", Collections.emptyList());
            req.getRequestDispatcher("/receptionist/PatientList.jsp").forward(req, resp);
            return;
        }

        // ===== LẤY PARAM TỪ REQUEST =====
        String keyword = getTrimmed(req.getParameter("keyword"));
        String filterName = getTrimmed(req.getParameter("filterName"));
        String filterAddress = getTrimmed(req.getParameter("filterAddress"));
        String filterInsurance = getTrimmed(req.getParameter("filterInsurance"));
        String filterPhone = getTrimmed(req.getParameter("filterPhone"));

        int currentPage = 1;
        int pageSize = 10;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        // ===== QUERY DB =====
        List<Patient> patients = patientDAO.searchPatients(
                keyword,
                filterName,
                filterAddress,
                filterInsurance,
                filterPhone,
                currentPage,
                pageSize
        );

        int totalPatients = patientDAO.countPatients(
                keyword,
                filterName,
                filterAddress,
                filterInsurance,
                filterPhone
        );

        int totalPages = (int) Math.ceil((double) totalPatients / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }

        // ===== SET ATTRIBUTE CHO JSP =====
        req.setAttribute("patients", patients);
        req.setAttribute("keyword", keyword);
        req.setAttribute("filterName", filterName);
        req.setAttribute("filterAddress", filterAddress);
        req.setAttribute("filterInsurance", filterInsurance);
        req.setAttribute("filterPhone", filterPhone);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);

        // Warning nếu không nhập gì cả
        if (isAllEmpty(keyword, filterName, filterAddress, filterInsurance, filterPhone)) {
            req.setAttribute("warning", "Vui lòng nhập điều kiện cần tìm (tên, mã, địa chỉ, bệnh nền hoặc SĐT).");
        }

        req.getRequestDispatcher("/receptionist/PatientList.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    // ===== HELPER =====
    private String getTrimmed(String s) {
        return s == null ? "" : s.trim();
    }

    private boolean isAllEmpty(String... arr) {
        for (String s : arr) {
            if (s != null && !s.isEmpty()) {
                return false;
            }
        }
        return true;
    }
}
