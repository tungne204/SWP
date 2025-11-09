package control;

import entity.ListUser.User;
import entity.ListUser.Role;
import dao.ListUser.RoleDAO;
import dao.ListUser.UserDAO;
import dao.DoctorDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UserServlet", urlPatterns = {"/admin/users"})
public class UserServlet extends HttpServlet {

    private UserDAO userDAO;
    private RoleDAO roleDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        roleDAO = new RoleDAO();
        doctorDAO = new DoctorDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html><html><head><title>Servlet UserServlet</title></head><body>");
            out.println("<h1>Servlet UserServlet at " + request.getContextPath() + "</h1>");
            out.println("</body></html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listUsers(request, response);
                break;
            case "toggle":
                toggleUserStatus(request, response);
                break;
            case "view":
                viewUserDetail(request, response);
                break;
            case "createForm":
                showCreateForm(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String group = request.getParameter("group");
        if (group == null || (!group.equals("staff") && !group.equals("customers"))) {
            group = "customers"; // mặc định danh sách khách
        }

        String search = request.getParameter("search");
        String roleFilterStr = request.getParameter("roleFilter");
        String statusFilterStr = request.getParameter("statusFilter");
        String pageStr = request.getParameter("page");

        Integer roleFilter = null;
        Integer statusFilter = null;
        int page = 1;
        int recordsPerPage = 10;

        try {
            if (roleFilterStr != null && !roleFilterStr.isEmpty()) {
                roleFilter = Integer.parseInt(roleFilterStr);
            }
            if (statusFilterStr != null && !statusFilterStr.isEmpty()) {
                statusFilter = Integer.parseInt(statusFilterStr);
            }
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        int offset = (page - 1) * recordsPerPage;

        // role names theo group
        List<String> roleNamesForGroup = "staff".equals(group)
                ? java.util.Arrays.asList("Receptionist", "Doctor", "MedicalAssistant")
                : java.util.Arrays.asList("Patient");

        // users + tổng số cho phân trang
        List<User> users = userDAO.getAllUsers(
                search, roleFilter, statusFilter,
                offset, recordsPerPage, roleNamesForGroup
        );
        int totalRecords = userDAO.getTotalUsers(
                search, roleFilter, statusFilter, roleNamesForGroup
        );
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        List<Role> roles = roleDAO.getRolesByNames(roleNamesForGroup);

        request.setAttribute("group", group);
        request.setAttribute("users", users);
        request.setAttribute("roles", roles);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);

        request.getRequestDispatcher("/admin/userList.jsp").forward(request, response);
    }

    private void viewUserDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.getUserById(userId);

        String group = request.getParameter("group");
        if (group == null || (!group.equals("staff") && !group.equals("customers"))) {
            group = "customers";
        }

        request.setAttribute("group", group);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/admin/userDetail.jsp").forward(request, response);
    }

    private void setMessage(HttpServletRequest request, boolean success, String successMsg, String errorMsg) {
        if (success) {
            request.getSession().setAttribute("message", successMsg);
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", errorMsg);
            request.getSession().setAttribute("messageType", "error");
        }
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String group = request.getParameter("group");
        if (group == null || (!group.equals("staff") && !group.equals("customers"))) {
            group = "customers";
        }
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            boolean result = userDAO.toggleUserStatus(userId);
            setMessage(request, result, "Thay đổi trạng thái thành công!", "Thay đổi trạng thái thất bại!");
        } catch (Exception e) {
            e.printStackTrace();
            setMessage(request, false, "", "Lỗi hệ thống khi thay đổi trạng thái!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?action=list&group=" + group);
    }

    // ============= NEW: hiển thị form tạo user =============
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String group = request.getParameter("group");
        if (group == null || (!group.equals("staff") && !group.equals("customers"))) {
            group = "customers";
        }
        request.setAttribute("group", group);
        if ("staff".equals(group)) {
            List<String> staffNames = java.util.Arrays.asList("Receptionist", "Doctor", "MedicalAssistant");
            List<Role> roles = roleDAO.getRolesByNames(staffNames);
            request.setAttribute("roles", roles);
        }
        request.getRequestDispatcher("/admin/userForm.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            handleCreate(request, response);
        } else {
            processRequest(request, response);
        }
    }

    // ============= NEW: xử lý tạo user =============
    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String group = request.getParameter("group");
        if (group == null || (!group.equals("staff") && !group.equals("customers"))) {
            group = "customers";
        }

        String username = trimOrNull(request.getParameter("username"));
        String email = trimOrNull(request.getParameter("email"));
        String phone = trimOrNull(request.getParameter("phone"));
        String password = trimOrNull(request.getParameter("password"));
        String confirm = trimOrNull(request.getParameter("confirm"));

        // Validate cơ bản
        if (username == null || email == null || password == null || confirm == null) {
            setMessage(request, false, "", "Vui lòng điền đủ thông tin bắt buộc!");
            backToForm(request, response, group);
            return;
        }
        if (!password.equals(confirm)) {
            setMessage(request, false, "", "Mật khẩu xác nhận không khớp!");
            backToForm(request, response, group);
            return;
        }
        if (userDAO.existsByUsernameOrEmail(username, email)) {
            setMessage(request, false, "", "Username hoặc Email đã tồn tại!");
            backToForm(request, response, group);
            return;
        }

        // Validate số điện thoại
        if (phone != null && !phone.trim().isEmpty()) {
            // Validate format số điện thoại (10 số, bắt đầu bằng 0 hoặc +84)
            if (!isValidPhoneNumber(phone)) {
                setMessage(request, false, "", "Số điện thoại không hợp lệ! Vui lòng nhập 10 số (bắt đầu bằng 0) hoặc định dạng quốc tế (+84).");
                backToForm(request, response, group);
                return;
            }
            // Kiểm tra số điện thoại trùng
            if (userDAO.existsByPhone(phone)) {
                setMessage(request, false, "", "Số điện thoại đã được sử dụng!");
                backToForm(request, response, group);
                return;
            }
        }

        // Xác định role
        Integer roleId = null;
        if ("customers".equals(group)) {
            Role patient = roleDAO.getRoleByName("Patient");
            if (patient == null) {
                setMessage(request, false, "", "Không tìm thấy role Patient. Vui lòng kiểm tra dữ liệu Role.");
                backToForm(request, response, group);
                return;
            }
            roleId = patient.getRoleId();
        } else { // staff
            String roleIdStr = request.getParameter("roleId");
            try {
                roleId = Integer.parseInt(roleIdStr);
            } catch (Exception e) {
                setMessage(request, false, "", "Vai trò không hợp lệ!");
                backToForm(request, response, group);
                return;
            }
            // xác thực roleId thuộc nhóm staff
            List<String> staffNames = java.util.Arrays.asList("Receptionist", "Doctor", "MedicalAssistant");
            List<Role> allowed = roleDAO.getRolesByNames(staffNames);
            boolean ok = false;
            if (allowed != null) {
                for (Role r : allowed) {
                    if (r != null && r.getRoleId() == roleId) {
                        ok = true;
                        break;
                    }
                }
            }

            if (!ok) {
                setMessage(request, false, "", "Vai trò không thuộc nhóm nhân viên!");
                backToForm(request, response, group);
                return;
            }
        }

        // Tạo entity
        User u = new User();
        u.setUsername(username);
        u.setPassword(password); // TODO: hash ở môi trường thật
        u.setEmail(email);
        u.setPhone(phone);
        u.setRoleId(roleId);
        u.setStatus(true);

        int newId = userDAO.createUser(u);
        if (newId > 0) {
            // Nếu role là Doctor, tự động tạo Doctor record với đầy đủ profile
            Role selectedRole = roleDAO.getRoleById(roleId);
            if (selectedRole != null && "Doctor".equals(selectedRole.getRoleName())) {
                String specialty = trimOrNull(request.getParameter("specialty"));
                if (specialty == null || specialty.isEmpty()) {
                    specialty = "General Medicine"; // Mặc định nếu không nhập
                }
                
                // Lấy thông tin profile doctor
                String experienceYearsStr = trimOrNull(request.getParameter("experienceYears"));
                Integer experienceYears = null;
                if (experienceYearsStr != null && !experienceYearsStr.isEmpty()) {
                    try {
                        int years = Integer.parseInt(experienceYearsStr);
                        if (years >= 0) {
                            experienceYears = years;
                        }
                    } catch (NumberFormatException e) {
                        // Bỏ qua nếu không parse được
                    }
                }
                
                String certificate = trimOrNull(request.getParameter("certificate"));
                String introduce = trimOrNull(request.getParameter("introduce"));
                
                // Tạo Doctor record với đầy đủ thông tin
                boolean doctorCreated = doctorDAO.insertDoctorWithProfile(
                    newId, specialty, experienceYears, certificate, introduce
                );
                
                if (!doctorCreated) {
                    // Nếu tạo Doctor record thất bại, vẫn thông báo thành công tạo user
                    // nhưng có thể log lỗi
                    System.err.println("Warning: User created but Doctor record creation failed for userId: " + newId);
                    setMessage(request, false, "", "Tạo tài khoản thành công nhưng không thể tạo profile Doctor. Vui lòng kiểm tra lại!");
                    backToForm(request, response, group);
                    return;
                }
            }
            
            setMessage(request, true, "Tạo người dùng thành công!", "");
            response.sendRedirect(request.getContextPath() + "/admin/users?action=list&group=" + group);
        } else {
            setMessage(request, false, "", "Tạo người dùng thất bại!");
            backToForm(request, response, group);
        }
    }

    private String trimOrNull(String s) {
        if (s == null) {
            return null;
        }
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    // ============= NEW: Validate số điện thoại =============
    private boolean isValidPhoneNumber(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return true; // Cho phép để trống
        }
        String cleaned = phone.trim().replaceAll("[\\s\\-\\(\\)]", ""); // Loại bỏ khoảng trắng, dấu gạch, ngoặc
        
        // Kiểm tra format Việt Nam: 10 số bắt đầu bằng 0
        if (cleaned.matches("^0[0-9]{9}$")) {
            return true;
        }
        
        // Kiểm tra format quốc tế: +84 hoặc 84 + 9 số
        if (cleaned.matches("^(\\+84|84)[0-9]{9}$")) {
            return true;
        }
        
        return false;
    }

    private void backToForm(HttpServletRequest request, HttpServletResponse response, String group)
            throws ServletException, IOException {
        request.setAttribute("group", group);
        if ("staff".equals(group)) {
            List<String> staffNames = java.util.Arrays.asList("Receptionist", "Doctor", "MedicalAssistant");
            List<Role> roles = roleDAO.getRolesByNames(staffNames);
            request.setAttribute("roles", roles);
        }
        request.getRequestDispatcher("/admin/userForm.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "User management servlet";
    }
}
