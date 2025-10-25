<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, entity.User, entity.Role"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phân quyền người dùng</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in {
            animation: fadeIn 0.5s ease-out;
        }
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .table-row-hover {
            transition: all 0.3s ease;
        }
        .table-row-hover:hover {
            transform: translateX(4px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <%@ include file="../includes/header.jsp" %>
    
    <!-- Include Sidebar -->
    <%@ include file="../includes/sidebar-manager.jsp" %>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="row mb-4">
                <div class="col-12">
                    <h1 class="h3 mb-2">🔐 Quản Lý Phân Quyền</h1>
                    <p class="text-muted">Quản lý vai trò và quyền hạn người dùng trong hệ thống</p>
                </div>
            </div>
            
            <!-- Stats Cards -->
            <div class="row g-4 mb-4">
                <div class="col-lg-4 col-md-6">
                    <div class="card border-start border-primary border-4 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-muted small">Tổng người dùng</h6>
                                    <h2 class="fw-bold text-dark">
                                        <%= (request.getAttribute("users") != null) ? ((List<User>)request.getAttribute("users")).size() : 0 %>
                                    </h2>
                                </div>
                                <div class="bg-primary bg-opacity-10 rounded-circle p-3">
                                    <i class="fas fa-users text-primary fs-4"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="card border-start border-success border-4 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-muted small">Vai trò</h6>
                                    <h2 class="fw-bold text-dark">
                                        <%= (request.getAttribute("roles") != null) ? ((List<Role>)request.getAttribute("roles")).size() : 0 %>
                                    </h2>
                                </div>
                                <div class="bg-success bg-opacity-10 rounded-circle p-3">
                                    <i class="fas fa-shield-alt text-success fs-4"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="card border-start border-info border-4 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-muted small">Trạng thái</h6>
                                    <h4 class="fw-bold text-success">Hoạt động</h4>
                                </div>
                                <div class="bg-info bg-opacity-10 rounded-circle p-3">
                                    <i class="fas fa-check-circle text-info fs-4"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Section -->
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0 d-flex align-items-center">
                        <i class="fas fa-users me-2"></i>
                        Danh sách người dùng
                    </h5>
                </div>
                
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="px-3 py-3 text-start fw-bold text-muted small text-uppercase">
                                        ID
                                    </th>
                                    <th class="px-3 py-3 text-start fw-bold text-muted small text-uppercase">
                                        Tên đăng nhập
                                    </th>
                                    <th class="px-3 py-3 text-start fw-bold text-muted small text-uppercase">
                                        Email
                                    </th>
                                    <th class="px-3 py-3 text-start fw-bold text-muted small text-uppercase">
                                        Vai trò hiện tại
                                    </th>
                                    <th class="px-3 py-3 text-center fw-bold text-muted small text-uppercase">
                                    Thao tác
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<User> users = (List<User>) request.getAttribute("users");
                                List<Role> roles = (List<Role>) request.getAttribute("roles");
                                if (users != null && !users.isEmpty()) {
                                    for (User u : users) {
                            %>
                            <tr>
                                <form action="set-permission" method="post" class="d-contents">
                                    <td class="px-3 py-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center text-white fw-bold" style="width: 40px; height: 40px; font-size: 0.9rem;">
                                                <%=u.getUserId()%>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-3 py-3">
                                        <div class="fw-semibold text-dark"><%=u.getUsername()%></div>
                                    </td>
                                    <td class="px-3 py-3">
                                        <div class="text-muted d-flex align-items-center">
                                            <i class="fas fa-envelope me-2 text-muted"></i>
                                            <%=u.getEmail()%>
                                        </div>
                                    </td>
                                    <td class="px-3 py-3">
                                        <span class="badge bg-primary rounded-pill">
                                            <%=u.getRoleName()%>
                                        </span>
                                    </td>
                                    <td class="px-3 py-3 text-center">
                                        <div class="d-flex align-items-center justify-content-center gap-2">
                                            <input type="hidden" name="userId" value="<%=u.getUserId()%>">
                                            <select name="roleId" class="form-select form-select-sm" style="width: 150px;">
                                                <% for (Role r : roles) { %>
                                                    <option value="<%=r.getRoleId()%>"
                                                        <%= (r.getRoleId() == u.getRoleId() ? "selected" : "") %>>
                                                        <%=r.getRoleName()%>
                                                    </option>
                                                <% } %>
                                            </select>
                                            <button type="submit" class="btn btn-primary btn-sm">
                                                <i class="fas fa-sync-alt me-1"></i>
                                                Cập nhật
                                            </button>
                                        </div>
                                    </td>
                                </form>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="5" class="px-3 py-5 text-center">
                                    <div class="d-flex flex-column align-items-center justify-content-center">
                                        <i class="fas fa-users text-muted mb-3" style="font-size: 4rem;"></i>
                                        <p class="text-muted h5">Không có người dùng nào trong hệ thống</p>
                                        <p class="text-muted small mt-1">Hãy thêm người dùng mới để bắt đầu</p>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    </div>
                </div>
            </div>

            <!-- Footer Info -->
            <div class="mt-4 text-center text-muted">
                <p><i class="fas fa-info-circle me-1"></i> Lưu ý: Thay đổi vai trò sẽ ảnh hưởng đến quyền truy cập của người dùng trong hệ thống</p>
            </div>
        </div> <!-- End container-fluid -->
    </div> <!-- End main-content -->

</body>
</html>