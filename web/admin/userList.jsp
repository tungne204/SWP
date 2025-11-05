<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Người Dùng - Phòng Khám Nhi</title>

    <!-- Icon & head includes dùng chung -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <jsp:include page="../includes/head-includes.jsp"/>

    <style>
        /* ===== Layout giống trang Home - Medilab ===== */
        .main { padding-top: 80px; } /* header fixed ~80px */

        /* Sidebar container cố định bên trái (giữ nguyên include bên trong) */
        .sidebar-container {
            width: 280px;
            background: #fff;
            border-right: 1px solid #dee2e6;
            position: fixed;
            top: 80px;
            left: 0;
            height: calc(100vh - 80px);
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        }

        /* Nội dung chính đẩy sang phải 280px khi có sidebar */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 20px;
            min-height: calc(100vh - 80px);
            padding-bottom: 100px;
        }

        /* Ẩn sidebar khi màn hẹp */
        @media (max-width: 991px) {
            .sidebar-container { display: none; }
            .main-content { margin-left: 0; }
        }

        /* ===== Trang danh sách user (giữ style đẹp, đồng bộ với Home) ===== */
        .ul-card {
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
        }

        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 16px;
        }

        h1 {
            color: #2c3e50;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 22px;
            font-weight: 700;
        }

        /* Form tìm kiếm & lọc */
        form input[type="text"],
        form select {
            min-width: 200px;
            height: 36px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        form button,
        form a.btn { height: 38px; }

        /* Nút */
        .btn {
            padding: 10px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .btn-primary { background: #3498db; color: #fff; }
        .btn-primary:hover { background: #2980b9; }
        .btn-success { background: #27ae60; color: #fff; }
        .btn-success:hover { background: #229954; }
        .btn-warning { background: #f1c40f; color: #000; }
        .btn-warning:hover { background: #d4ac0d; }
        .btn-sm { padding: 6px 12px; font-size: 13px; }

        /* Bảng */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 14px;
        }
        thead { background: #ffffff; color: #000; font-size: 15px; }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        tbody tr:hover { background: #f8f9fa; }

        /* Badge & trạng thái */
        .badge { padding: 4px 8px; border-radius: 3px; font-size: 12px; font-weight: 600; }
        .badge-info { background: #3498db; color: #fff; }
        .status-badge { padding: 5px 8px; border-radius: 5px; font-size: 0.85rem; }
        .status-active { background: #d4edda; color: #155724; }
        .status-inactive { background: #f8d7da; color: #721c24; }

        /* Trạng thái rỗng */
        .no-data {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-style: italic;
        }

        /* Phân trang */
        .pagination {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 18px;
        }
        .pagination a,
        .pagination span {
            padding: 8px 14px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
        }
        .pagination a { background: #ecf0f1; color: #2c3e50; }
        .pagination a:hover { background-color: #dfe6e9; }
        .pagination span { background: #3498db; color: #fff; }
    </style>
</head>

<body class="index-page">
    <!-- Header (KHÔNG thay đổi) -->
    <jsp:include page="../includes/header.jsp" />

    <main class="main">
        <div class="container-fluid p-0">
            <div class="row g-0">
                <!-- Sidebar (KHÔNG thay đổi nội dung; chỉ bọc trong .sidebar-container giống trang Home) -->
                <c:if test="${not empty sessionScope.acc and sessionScope.acc.roleId == 1}">
                    <div class="sidebar-container">
                        <jsp:include page="../includes/sidebar-admin.jsp" />
                    </div>
                </c:if>

                <!-- Content -->
                <div class="main-content">
                    <div class="ul-card">

                        <!-- Header actions: tiêu đề + nút tạo + form lọc -->
                        <div class="header-actions">
                            <h1>
                                <i class="fas fa-users-cog"></i>
                                <c:choose>
                                    <c:when test="${group == 'staff'}">Danh sách nhân viên</c:when>
                                    <c:otherwise>Danh sách khách</c:otherwise>
                                </c:choose>
                            </h1>

                            <!-- Nút tạo người dùng -->
                            <c:url var="createUrl" value="/admin/users">
                                <c:param name="action" value="createForm"/>
                                <c:param name="group" value="${group}"/>
                            </c:url>
                            <a class="btn btn-success" href="${createUrl}">
                                <i class="fas fa-user-plus"></i> Tạo người dùng
                            </a>
                        </div>

                        <!-- Form tìm kiếm & lọc -->
                        <form method="get" action="${pageContext.request.contextPath}/admin/users"
                              style="display:flex;flex-wrap:wrap;gap:10px;align-items:center;margin-bottom:8px;">
                            <input type="hidden" name="group" value="${group}">
                            <input type="text" name="search" placeholder="Tìm theo username, email, phone..." value="${search}">
                            <select name="roleFilter">
                                <option value="">Tất cả vai trò</option>
                                <c:forEach var="role" items="${roles}">
                                    <option value="${role.roleId}"
                                        <c:if test="${roleFilter != null && roleFilter == role.roleId}">selected</c:if>>
                                        ${role.roleName}
                                    </option>
                                </c:forEach>
                            </select>
                            <select name="statusFilter">
                                <option value="">Tất cả trạng thái</option>
                                <option value="1" <c:if test="${statusFilter != null && statusFilter == 1}">selected</c:if>>Đang hoạt động</option>
                                <option value="0" <c:if test="${statusFilter != null && statusFilter == 0}">selected</c:if>>Tạm ngưng</option>
                            </select>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i> Tìm kiếm
                            </button>
                        </form>

                        <!-- Bảng danh sách -->
                        <table>
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
                                    <tr>
                                        <td colspan="7" class="no-data">
                                            <i class="fas fa-inbox" style="font-size: 42px; display:block; margin-bottom:10px;"></i>
                                            Không tìm thấy người dùng nào.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td><strong>${user.userId}</strong></td>
                                            <td>${user.username}</td>
                                            <td>${user.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty user.phone}">${user.phone}</c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><span class="badge badge-info">${user.roleName}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.status}">
                                                        <span class="status-badge status-active">
                                                            <i class="fas fa-check-circle"></i> Hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-inactive">
                                                            <i class="fas fa-pause-circle"></i> Tạm ngưng
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="white-space:nowrap;">
                                                <a href="${pageContext.request.contextPath}/admin/users?action=view&group=${group}&id=${user.userId}"
                                                   class="btn btn-primary btn-sm">
                                                    <i class="fas fa-eye"></i> Xem
                                                </a>
                                                <button class="btn ${user.status ? 'btn-warning' : 'btn-success'} btn-sm"
                                                        onclick="toggleStatus(${user.userId}, '${user.username}')">
                                                    <i class="fas ${user.status ? 'fa-pause' : 'fa-play'}"></i>
                                                    ${user.status ? 'Tạm dừng' : 'Kích hoạt'}
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>

                        <!-- Phân trang -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination">
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span>${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url var="pageUrl" value="/admin/users">
                                                <c:param name="action" value="list"/>
                                                <c:param name="group" value="${group}"/>
                                                <c:param name="page" value="${i}"/>
                                                <c:if test="${not empty search}">
                                                    <c:param name="search" value="${search}"/>
                                                </c:if>
                                                <c:if test="${roleFilter != null}">
                                                    <c:param name="roleFilter" value="${roleFilter}"/>
                                                </c:if>
                                                <c:if test="${statusFilter != null}">
                                                    <c:param name="statusFilter" value="${statusFilter}"/>
                                                </c:if>
                                            </c:url>
                                            <a href="${pageUrl}">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </c:if>

                    </div><!-- /.ul-card -->
                </div><!-- /.main-content -->
            </div><!-- /.row -->
        </div><!-- /.container-fluid -->
    </main>

    <!-- Sweetalert & Bootstrap bundle -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function toggleStatus(userId, username) {
            Swal.fire({
                title: 'Xác nhận thay đổi trạng thái',
                html: 'Bạn có chắc muốn thay đổi trạng thái của user <strong>' + username + '</strong>?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Xác nhận',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/admin/users?action=toggle&group=${group}&id=' + userId;
                }
            });
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
</body>
</html>
