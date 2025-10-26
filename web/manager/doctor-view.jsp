<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Bác sĩ</title>
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
        .info-card {
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        .qualification-item {
            border-left: 4px solid #667eea;
            padding: 1rem;
            margin-bottom: 1rem;
            background: #f8f9fa;
            border-radius: 5px;
            transition: all 0.3s;
        }
        .qualification-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateX(5px);
        }
        .avatar-large {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border: 5px solid white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
    </style>
</head>
<body class="bg-light">
    <div class="container py-4">
        <!-- Header -->
        <div class="page-header">
            <div class="container">
                <div class="d-flex align-items-center">
                    <a href="${pageContext.request.contextPath}/manager/doctors?action=list" 
                       class="btn btn-light me-3">
                        <i class="fas fa-arrow-left"></i>
                    </a>
                    <div>
                        <h1 class="mb-0">Chi tiết Bác sĩ</h1>
                        <p class="mb-0 mt-2">Thông tin chi tiết và bằng cấp</p>
                    </div>
                </div>
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

        <div class="row">
            <!-- Left Column - Doctor Info -->
            <div class="col-lg-4 mb-4">
                <div class="card info-card">
                    <div class="card-body text-center">
                        <img src="${pageContext.request.contextPath}/${doctor.user.avatar}" 
                             alt="Avatar" 
                             class="rounded-circle avatar-large mb-3">
                        <h3 class="mb-2">${doctor.user.username}</h3>
                        <span class="badge ${doctor.user.status ? 'bg-success' : 'bg-secondary'} mb-3">
                            ${doctor.user.status ? 'Đang hoạt động' : 'Ngừng hoạt động'}
                        </span>
                        
                        <div class="text-start mt-4">
                            <div class="mb-3">
                                <i class="fas fa-stethoscope text-primary me-2"></i>
                                <strong>Chuyên khoa:</strong><br>
                                <span class="ms-4">${doctor.specialty}</span>
                            </div>
                            
                            <div class="mb-3">
                                <i class="fas fa-envelope text-primary me-2"></i>
                                <strong>Email:</strong><br>
                                <span class="ms-4">${doctor.user.email}</span>
                            </div>
                            
                            <div class="mb-3">
                                <i class="fas fa-phone text-primary me-2"></i>
                                <strong>Điện thoại:</strong><br>
                                <span class="ms-4">${doctor.user.phone}</span>
                            </div>
                            
                            <div class="mb-3">
                                <i class="fas fa-id-badge text-primary me-2"></i>
                                <strong>ID bác sĩ:</strong><br>
                                <span class="ms-4">${doctor.doctorId}</span>
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2 mt-4">
                            <a href="${pageContext.request.contextPath}/manager/doctors?action=edit&id=${doctor.doctorId}" 
                               class="btn btn-primary">
                                <i class="fas fa-edit me-2"></i>Chỉnh sửa thông tin
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column - Qualifications -->
            <div class="col-lg-8">
                <div class="card info-card">
                    <div class="card-header bg-white py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-graduation-cap text-primary me-2"></i>
                                Bằng cấp & Chứng chỉ
                            </h5>
                            <a href="${pageContext.request.contextPath}/manager/doctors?action=addQualification&doctorId=${doctor.doctorId}" 
                               class="btn btn-sm btn-primary">
                                <i class="fas fa-plus me-1"></i>Thêm bằng cấp
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty doctor.qualifications}">
                                <c:forEach var="qual" items="${doctor.qualifications}">
                                    <div class="qualification-item">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div class="flex-grow-1">
                                                <h5 class="mb-2">
                                                    <i class="fas fa-certificate text-warning me-2"></i>
                                                    ${qual.degreeName}
                                                </h5>
                                                <p class="mb-1">
                                                    <i class="fas fa-university text-muted me-2"></i>
                                                    <strong>Cơ sở đào tạo:</strong> ${qual.institution}
                                                </p>
                                                <p class="mb-1">
                                                    <i class="fas fa-calendar text-muted me-2"></i>
                                                    <strong>Năm tốt nghiệp:</strong> ${qual.yearObtained}
                                                </p>
                                                <c:if test="${not empty qual.certificateNumber}">
                                                    <p class="mb-1">
                                                        <i class="fas fa-hashtag text-muted me-2"></i>
                                                        <strong>Số chứng chỉ:</strong> ${qual.certificateNumber}
                                                    </p>
                                                </c:if>
                                                <c:if test="${not empty qual.description}">
                                                    <p class="mb-0 text-muted">
                                                        <i class="fas fa-info-circle me-2"></i>
                                                        ${qual.description}
                                                    </p>
                                                </c:if>
                                            </div>
                                            <div class="btn-group-vertical ms-3">
                                                <a href="${pageContext.request.contextPath}/manager/doctors?action=editQualification&id=${qual.qualificationId}" 
                                                   class="btn btn-sm btn-outline-success" title="Sửa">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button type="button" 
                                                        class="btn btn-sm btn-outline-danger" 
                                                        onclick="confirmDeleteQual(${qual.qualificationId}, '${qual.degreeName}')"
                                                        title="Xóa">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-graduation-cap fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Chưa có bằng cấp nào</h5>
                                    <p class="text-muted">Nhấn "Thêm bằng cấp" để thêm thông tin bằng cấp cho bác sĩ</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDeleteQual(qualId, degreeName) {
            if (confirm('Bạn có chắc chắn muốn xóa bằng cấp "' + degreeName + '"?')) {
                window.location.href = '${pageContext.request.contextPath}/manager/doctors?action=deleteQualification&id=' 
                    + qualId + '&doctorId=${doctor.doctorId}';
            }
        }
    </script>
</body>
</html>