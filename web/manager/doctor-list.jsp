<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Bác sĩ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 10px;
        }
        .doctor-card {
            transition: transform 0.3s;
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .status-badge {
            font-size: 0.85rem;
        }
        .alert {
            border-radius: 8px;
        }
    </style>
</head>
<body class="bg-light">
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
                        <a href="${pageContext.request.contextPath}/manager/doctors?action=add" 
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
                                <a href="${pageContext.request.contextPath}/manager/doctors?action=view&id=${doctor.doctorId}" 
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </a>
                                <div class="btn-group">
                                    <a href="${pageContext.request.contextPath}/manager/doctors?action=edit&id=${doctor.doctorId}" 
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(doctorId, doctorName) {
            if (confirm('Bạn có chắc chắn muốn xóa bác sĩ "' + doctorName + '"?\n\nLưu ý: Tất cả bằng cấp của bác sĩ cũng sẽ bị xóa.')) {
                window.location.href = '${pageContext.request.contextPath}/manager/doctors?action=delete&id=' + doctorId;
            }
        }
    </script>
</body>
</html>