<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết người dùng - Phòng Khám Nhi</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <jsp:include page="../includes/head-includes.jsp"/>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
        }

        .header {
            width: 100%;
            background: white;
            padding: 15px 25px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .main-layout {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        .sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: white;
            min-height: calc(100vh - 70px);
            position: sticky;
            top: 70px;
        }

        .main-content {
            flex: 1;
            padding: 25px;
        }

        .container-box {
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

        .info-label { font-weight: 600; color: #6c757d; margin-bottom: 5px; }
        .info-value { font-size: 1.05rem; color: #212529; margin-bottom: 20px; }

        .status-box {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 25px;
        }
        .status-active-box { background-color: #d4edda; border-left: 5px solid #28a745; }
        .status-inactive-box { background-color: #f8d7da; border-left: 5px solid #dc3545; }

        .btn {
            padding: 8px 14px;
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
        .btn-success:hover { background: #1e8449; }
        .btn-warning { background: #f1c40f; color: black; }
        .btn-warning:hover { background: #d4ac0d; }
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-secondary:hover { background: #7f8c8d; }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { padding: 15px; }
        }
    </style>
</head>

<body>
    <!-- HEADER -->
    <jsp:include page="../includes/header.jsp" />

    <div class="main-layout">
        <!-- SIDEBAR -->
        <% if (acc != null && acc.getRoleId() == 1) { %>
            <jsp:include page="../includes/sidebar-admin.jsp" />
        <% } %>

        <!-- MAIN CONTENT -->
        <div class="main-content">
            <div class="container-box">
                <h1><i class="fas fa-user-circle"></i> Chi tiết người dùng</h1>

                <c:if test="${not empty user}">
                    <!-- Trạng thái -->
                    <div class="${user.status ? 'status-box status-active-box' : 'status-box status-inactive-box'}">
                        <h5 class="mb-0">
                            <c:choose>
                                <c:when test="${user.status}">
                                    <i class="fas fa-check-circle text-success"></i> User đang hoạt động
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-ban text-danger"></i> User bị khóa
                                </c:otherwise>
                            </c:choose>
                        </h5>
                    </div>

                    <!-- Thông tin cơ bản -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-hashtag text-primary"></i> User ID</div>
                            <div class="info-value"><span class="badge bg-primary">${user.userId}</span></div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-user text-primary"></i> Username</div>
                            <div class="info-value"><strong>${user.username}</strong></div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-envelope text-primary"></i> Email</div>
                            <div class="info-value">${user.email}</div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-phone text-primary"></i> Số điện thoại</div>
                            <div class="info-value">${user.phone != null ? user.phone : '<span class="text-muted">Chưa cập nhật</span>'}</div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-id-badge text-primary"></i> Vai trò</div>
                            <div class="info-value"><span class="badge bg-info fs-6">${user.roleName}</span></div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-toggle-on text-primary"></i> Trạng thái hoạt động</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${user.status}">
                                        <span class="badge bg-success fs-6"><i class="fas fa-check"></i> Đang hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger fs-6"><i class="fas fa-times"></i> Bị khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Nút thao tác -->
                    <div class="d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/admin/users?action=list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                        <button type="button"
                                class="btn ${user.status ? 'btn-warning' : 'btn-success'}"
                                onclick="toggleStatus(${user.userId}, '${user.username}')">
                            <i class="fas ${user.status ? 'fa-lock' : 'fa-unlock'}"></i>
                            ${user.status ? 'Khóa User' : 'Mở Khóa User'}
                        </button>
                    </div>
                </c:if>

                <c:if test="${empty user}">
                    <div class="alert alert-warning text-center">
                        <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                        <h5>Không tìm thấy thông tin user!</h5>
                        <a href="${pageContext.request.contextPath}/admin/users?action=list"
                           class="btn btn-primary mt-3">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

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
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
</body>
</html>
