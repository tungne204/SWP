<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết lịch hẹn #${appointment.appointmentId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .header-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .card {
            border: none;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }
        .info-value {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 0.5rem;
            border-left: 4px solid #667eea;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header-section">
        <div class="container">
            <h1>
                <i class="fas fa-calendar-check"></i> 
                Chi tiết lịch hẹn #${appointment.appointmentId}
            </h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="appointment?action=list" class="text-white">Danh sách lịch hẹn</a>
                    </li>
                    <li class="breadcrumb-item active text-white-50">Chi tiết</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container">
        <!-- Action buttons -->
        <div class="card">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <a href="appointment?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <div>
                        <c:choose>
                            <c:when test="${appointment.hasMedicalReport}">
                                <a href="medical-report?action=view&id=${appointment.recordId}" 
                                   class="btn btn-success">
                                    <i class="fas fa-prescription"></i> Xem đơn thuốc
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="medical-report?action=add&appointmentId=${appointment.appointmentId}" 
                                   class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Kê đơn thuốc
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Status Card -->
        <div class="row">
            <div class="col-md-12">
                <c:choose>
                    <c:when test="${appointment.hasMedicalReport}">
                        <div class="alert alert-success">
                            <h5 class="alert-heading">
                                <i class="fas fa-check-circle"></i> Đã khám xong
                            </h5>
                            <p class="mb-0">
                                Bệnh nhân đã được khám và kê đơn thuốc. 
                                <strong>Chẩn đoán:</strong> ${appointment.diagnosis}
                            </p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning">
                            <h5 class="alert-heading">
                                <i class="fas fa-clock"></i> Chờ khám
                            </h5>
                            <p class="mb-0">
                                Bệnh nhân chưa được khám. Vui lòng thực hiện khám và kê đơn thuốc.
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="row">
            <!-- Thông tin bệnh nhân -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-child"></i> Thông tin bệnh nhân
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-user"></i> Họ và tên
                            </div>
                            <div class="info-value">
                                ${appointment.patientName}
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-birthday-cake"></i> Ngày sinh
                            </div>
                            <div class="info-value">
                                <fmt:parseDate value="${appointment.patientDob}" pattern="yyyy-MM-dd" var="parsedDob"/>
                                <fmt:formatDate value="${parsedDob}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-users"></i> Phụ huynh
                            </div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty appointment.parentName}">
                                        ${appointment.parentName}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Chưa có thông tin</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-map-marker-alt"></i> Địa chỉ
                            </div>
                            <div class="info-value">
                                ${appointment.patientAddress}
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-id-card"></i> Bảo hiểm y tế
                            </div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty appointment.patientInsurance}">
                                        ${appointment.patientInsurance}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Không có BHYT</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thông tin lịch hẹn -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-calendar-alt"></i> Thông tin lịch hẹn
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-hashtag"></i> Mã lịch hẹn
                            </div>
                            <div class="info-value">
                                <strong>#${appointment.appointmentId}</strong>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="far fa-calendar"></i> Ngày khám
                            </div>
                            <div class="info-value">
                                <fmt:formatDate value="${appointment.dateTime}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="far fa-clock"></i> Giờ khám
                            </div>
                            <div class="info-value">
                                <fmt:formatDate value="${appointment.dateTime}" pattern="HH:mm"/>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-user-md"></i> Bác sĩ khám
                            </div>
                            <div class="info-value">
                                BS. ${appointment.doctorName}
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-stethoscope"></i> Chuyên khoa
                            </div>
                            <div class="info-value">
                                ${appointment.doctorSpecialty}
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-info-circle"></i> Trạng thái
                            </div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${appointment.hasMedicalReport}">
                                        <span class="badge bg-success fs-6">
                                            <i class="fas fa-check"></i> Đã khám
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning fs-6">
                                            <i class="fas fa-clock"></i> Chờ khám
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Medical Report Info (nếu có) -->
        <c:if test="${appointment.hasMedicalReport}">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-file-medical"></i> Thông tin khám bệnh
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="text-success">
                                <i class="fas fa-notes-medical"></i> Chẩn đoán:
                            </h6>
                            <p class="bg-light p-3 rounded">${appointment.diagnosis}</p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="text-primary">
                                <i class="fas fa-prescription"></i> Đơn thuốc:
                            </h6>
                            <a href="medical-report?action=view&id=${appointment.recordId}" 
                               class="btn btn-success">
                                <i class="fas fa-eye"></i> Xem đầy đủ đơn thuốc
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Hướng dẫn -->
        <div class="card">
            <div class="card-header bg-secondary text-white">
                <h6 class="mb-0">
                    <i class="fas fa-info-circle"></i> Hướng dẫn
                </h6>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${appointment.hasMedicalReport}">
                        <p class="mb-2">
                            <i class="fas fa-check text-success"></i> 
                            Bệnh nhân đã được khám và có đơn thuốc.
                        </p>
                        <p class="mb-0">
                            <i class="fas fa-info-circle text-info"></i> 
                            Bạn có thể xem lại đơn thuốc hoặc kết quả xét nghiệm (nếu có).
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p class="mb-2">
                            <i class="fas fa-arrow-right text-primary"></i> 
                            Click nút "Kê đơn thuốc" để thực hiện khám bệnh.
                        </p>
                        <p class="mb-0">
                            <i class="fas fa-arrow-right text-primary"></i> 
                            Sau khi khám xong, đơn thuốc sẽ được lưu vào hệ thống.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>