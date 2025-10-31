<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết User - Phòng Khám Nhi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .info-label {
            font-weight: 600;
            color: #6c757d;
            margin-bottom: 5px;
        }
        .info-value {
            font-size: 1.1rem;
            color: #212529;
            margin-bottom: 20px;
        }
        .status-box {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .status-active-box {
            background-color: #d4edda;
            border-left: 5px solid #28a745;
        }
        .status-inactive-box {
            background-color: #f8d7da;
            border-left: 5px solid #dc3545;
        }
        .card {
            border-radius: 15px;
            overflow: hidden;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-lg">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0">
                            <i class="fas fa-user-circle"></i> Chi Tiết User
                        </h4>
                    </div>
                    <div class="card-body p-4">
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
                                    <div class="info-label">
                                        <i class="fas fa-hashtag text-primary"></i> User ID
                                    </div>
                                    <div class="info-value">
                                        <span class="badge bg-primary">${user.userId}</span>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="info-label">
                                        <i class="fas fa-user text-primary"></i> Username
                                    </div>
                                    <div class="info-value">
                                        <strong>${user.username}</strong>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-label">
                                        <i class="fas fa-envelope text-primary"></i> Email
                                    </div>
                                    <div class="info-value">
                                        ${user.email}
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="info-label">
                                        <i class="fas fa-phone text-primary"></i> Số điện thoại
                                    </div>
                                    <div class="info-value">
                                        ${user.phone != null ? user.phone : '<span class="text-muted">Chưa cập nhật</span>'}
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-label">
                                        <i class="fas fa-id-badge text-primary"></i> Vai trò
                                    </div>
                                    <div class="info-value">
                                        <span class="badge bg-info fs-6">${user.roleName}</span>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="info-label">
                                        <i class="fas fa-toggle-on text-primary"></i> Trạng thái hoạt động
                                    </div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${user.status}">
                                                <span class="badge bg-success fs-6">
                                                    <i class="fas fa-check"></i> Đang hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger fs-6">
                                                    <i class="fas fa-times"></i> Bị khóa
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <!-- Thao tác -->
                            <div class="d-flex justify-content-between align-items-center">
                                <a href="${pageContext.request.contextPath}/admin/users?action=list" 
                                   class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                                </a>
                                
                                <div>
                                    <button type="button" 
                                            class="btn ${user.status ? 'btn-warning' : 'btn-success'}" 
                                            onclick="toggleStatus(${user.userId}, '${user.username}')">
                                        <i class="fas ${user.status ? 'fa-lock' : 'fa-unlock'}"></i> 
                                        ${user.status ? 'Khóa User' : 'Mở Khóa User'}
                                    </button>
                                    
                                    <c:if test="${user.status}">
                                        <button type="button" 
                                                class="btn btn-danger" 
                                                onclick="banUser(${user.userId}, '${user.username}')">
                                            <i class="fas fa-user-slash"></i> Ban User
                                        </button>
                                    </c:if>
                                </div>
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
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
</body>
</html>