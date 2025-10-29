<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, entity.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách bác sĩ | Medilab Clinic</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <jsp:include page="../includes/head-includes.jsp"/>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3fbbc0;
            --sidebar-width: 280px;
        }
        
        body {
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .main-wrapper {
            display: flex;
            min-height: 100vh;
            padding-top: 0px;
        }
        
        .sidebar-fixed {
            position: fixed;
            top: 115px;
            left: 0;
            width: var(--sidebar-width);
            height: calc(100vh - 70px);
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            overflow-y: auto;
            z-index: 1000;
        }
        
        .content-area {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 30px;
            min-height: calc(100vh - 70px);
        }
        
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
        .doctor-card {
            transition: all 0.3s ease;
        }
        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        .status-active {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }
        .status-inactive {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="../includes/header.jsp"/>
    
    <div class="main-wrapper">
        <!-- Sidebar -->
        <%@ include file="../includes/sidebar-manager.jsp" %>

        <!-- Main Content Area -->
        <div class="content-area">
    <div class="container py-4">
        <!-- Header -->
        <div class="page-header">
            <div class="container">
                <h1 class="mb-0"><i class="fas fa-user-md me-2"></i>Quản lý Bác sĩ</h1>
                <p class="mb-0 mt-2">Danh sách bác sĩ phòng khám nhi</p>
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert">
                <i class="fas fa-${sessionScope.messageType == 'success' ? 'check-circle' : 'exclamation-circle'} me-2"></i>
                ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="message" scope="session" />
            <c:remove var="messageType" scope="session" />
        </c:if>

        <!-- Action Bar -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h5 class="mb-0">Danh sách bác sĩ (${doctors.size()})</h5>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="${pageContext.request.contextPath}/doctors1?action=add" 
                           class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Thêm bác sĩ mới
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Doctors Grid -->
        <div class="row">
            <c:forEach var="doctor" items="${doctors}">
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card doctor-card h-100">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <img src="${pageContext.request.contextPath}/${doctor.user.avatar}" 
                                     alt="Avatar" 
                                     class="rounded-circle me-3" 
                                     style="width: 60px; height: 60px; object-fit: cover;">
                                <div class="flex-grow-1">
                                    <h5 class="mb-1">${doctor.user.username}</h5>
                                    <span class="badge ${doctor.user.status ? 'bg-success' : 'bg-secondary'} status-badge">
                                        ${doctor.user.status ? 'Đang hoạt động' : 'Ngừng hoạt động'}
                                    </span>
                                </div>
                            </div>
                            
                            <div class="mb-2">
                                <i class="fas fa-stethoscope text-primary me-2"></i>
                                <strong>Chuyên khoa:</strong> ${doctor.specialty}
                            </div>
                            
                            <div class="mb-2">
                                <i class="fas fa-envelope text-primary me-2"></i>
                                <small>${doctor.user.email}</small>
                            </div>
                            
                            <div class="mb-3">
                                <i class="fas fa-phone text-primary me-2"></i>
                                <small>${doctor.user.phone}</small>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/doctors1?action=view&id=${doctor.doctorId}" 
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </a>
                                <div class="btn-group">
                                    <a href="${pageContext.request.contextPath}/doctors1?action=edit&id=${doctor.doctorId}" 
                                       class="btn btn-sm btn-outline-success">
                                        <i class="fas fa-edit me-1"></i>Sửa
                                    </a>
                                    <button type="button" 
                                            class="btn btn-sm btn-outline-danger"
                                            onclick="confirmDelete(${doctor.doctorId}, '${doctor.user.username}')">
                                        <i class="fas fa-trash me-1"></i>Xóa
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Empty State -->
        <c:if test="${empty doctors}">
            <div class="card text-center py-5">
                <div class="card-body">
                    <i class="fas fa-user-md fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">Chưa có bác sĩ nào</h4>
                    <p class="text-muted">Nhấn nút "Thêm bác sĩ mới" để bắt đầu</p>
                </div>
            </div>
        </c:if>
    </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="../includes/footer.jsp"/>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(doctorId, doctorName) {
            if (confirm('Bạn có chắc chắn muốn xóa bác sĩ "' + doctorName + '"?\n\nLưu ý: Tất cả bằng cấp của bác sĩ cũng sẽ bị xóa.')) {
                window.location.href = '${pageContext.request.contextPath}/doctors1?action=delete&id=' + doctorId;
            }
        }
    </script>
</body>
</html>
