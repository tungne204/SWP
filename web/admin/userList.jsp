<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - Phòng Khám Nhi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <jsp:include page="../includes/head-includes.jsp"/>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
        }

        /* ===== HEADER ===== */
        .header {
            width: 100%;
            background: white;
            padding: 15px 25px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        /* ===== LAYOUT CHÍNH ===== */
        .main-layout {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        /* Sidebar bên trái */
        .sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: white;
            min-height: calc(100vh - 70px);
            position: sticky;
            top: 70px;
        }

        /* Nội dung chính */
        .main-content {
            flex: 1;
            padding: 25px;
        }

        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-box form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            margin-bottom: 20px;
        }

        .search-box input,
        .search-box select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            height: 36px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn-primary { background: #3498db; color: white; }
        .btn-primary:hover { background: #2980b9; }
        .btn-success { background: #27ae60; color: white; }
        .btn-success:hover { background: #229954; }
        .btn-warning { background: #f1c40f; color: black; }
        .btn-danger { background: #e74c3c; color: white; }
        .btn-danger:hover { background: #c0392b; }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border-bottom: 1px solid #ddd;
            padding: 10px;
        }
        thead {
            background: #f8f9fa;
            color: #2c3e50;
        }
        tbody tr:hover { background: #f9f9f9; }

        .status-badge {
            padding: 5px 8px;
            border-radius: 5px;
            font-size: 0.85rem;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-style: italic;
        }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { padding: 15px; }
        }
    </style>
</head>

<body>

    <!-- HEADER -->
    <jsp:include page="../includes/header.jsp" />

    <!-- LAYOUT CHÍNH -->
    <div class="main-layout">
        <!-- SIDEBAR -->
        <% if (acc != null && acc.getRoleId() == 1) { %>
        <jsp:include page="../includes/sidebar-admin.jsp" />
        <% } %>

        <!-- NỘI DUNG CHÍNH -->
        <div class="main-content">
            <div class="container">
                <h1><i class="fas fa-users-cog"></i> Quản lý người dùng</h1>

                <!-- Bộ lọc -->
                <div class="search-box">
                    <form method="get" action="${pageContext.request.contextPath}/admin/users">
                        <input type="hidden" name="action" value="list">
                        <input type="text" name="search" placeholder="Tìm theo username, email, phone..." value="${search}">
                        <select name="roleFilter">
                            <option value="">Tất cả vai trò</option>
                            <c:forEach var="role" items="${roles}">
                                <option value="${role.roleId}" ${roleFilter == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                            </c:forEach>
                        </select>
                        <select name="statusFilter">
                            <option value="">Tất cả trạng thái</option>
                            <option value="1" ${statusFilter == 1 ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="0" ${statusFilter == 0 ? 'selected' : ''}>Tạm ngưng</option>
                            <option value="ban" ${statusFilter == 'ban' ? 'selected' : ''}>Bị ban</option>
                        </select>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </form>
                </div>

                <!-- Bảng danh sách -->
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Điện thoại</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty users}">
                                <tr><td colspan="7" class="no-data">Không tìm thấy người dùng nào.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td><strong>${user.userId}</strong></td>
                                        <td>${user.username}</td>
                                        <td>${user.email}</td>
                                        <td>${user.phone != null ? user.phone : 'N/A'}</td>
                                        <td><span class="badge bg-info">${user.roleName}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.banned}">
                                                    <span class="status-badge bg-danger text-white"><i class="fas fa-user-slash"></i> Bị ban</span>
                                                </c:when>
                                                <c:when test="${user.status}">
                                                    <span class="status-badge status-active"><i class="fas fa-check-circle"></i> Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-inactive"><i class="fas fa-pause-circle"></i> Tạm ngưng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.userId}" class="btn btn-primary btn-sm">
                                                <i class="fas fa-eye"></i> Xem
                                            </a>

                                            <c:if test="${!user.banned}">
                                                <button class="btn ${user.status ? 'btn-warning' : 'btn-success'} btn-sm"
                                                        onclick="toggleStatus(${user.userId}, '${user.username}')">
                                                    <i class="fas ${user.status ? 'fa-pause' : 'fa-play'}"></i>
                                                    ${user.status ? 'Tạm dừng' : 'Kích hoạt'}
                                                </button>

                                                <button class="btn btn-danger btn-sm"
                                                        onclick="banUser(${user.userId}, '${user.username}')">
                                                    <i class="fas fa-user-slash"></i> Ban
                                                </button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <div style="margin-top: 25px; display: flex; justify-content: center; gap: 6px;">
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span style="padding: 8px 14px; background: #3498db; color: white; border-radius: 5px;">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?action=list&page=${i}&search=${search}&roleFilter=${roleFilter}&statusFilter=${statusFilter}"
                                       style="padding: 8px 14px; background: #ecf0f1; border-radius: 5px; color: #2c3e50; text-decoration: none;">
                                        ${i}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function toggleStatus(userId, username) {
            Swal.fire({
                title: 'Xác nhận thay đổi trạng thái',
                html: `Bạn có chắc muốn thay đổi trạng thái của user <strong>${username}</strong>?`,
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Xác nhận',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/admin/users?action=toggle&id=' + userId;
                }
            });
        }

        function banUser(userId, username) {
            Swal.fire({
                title: 'Cảnh báo!',
                html: `Bạn có chắc muốn BAN user <strong>${username}</strong>?<br><span class="text-danger">User sẽ không thể đăng nhập!</span>`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Ban User',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/admin/users?action=ban&id=' + userId;
                }
            });
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>
