<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch hẹn bệnh nhân - Phòng khám nhi</title>
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
            .table-hover tbody tr:hover {
                background-color: #f1f3ff;
            }
            .status-badge {
                font-size: 0.875rem;
                padding: 0.4rem 0.8rem;
            }
            .date-picker {
                max-width: 300px;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <div class="header-section">
            <div class="container">
                <h1><i class="fas fa-calendar-alt"></i> Lịch hẹn bệnh nhân</h1>
                <p class="mb-0">Quản lý và theo dõi lịch khám bệnh</p>
            </div>
        </div>

        <div class="container">
            <!-- Thông báo -->
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert">
                    <i class="fas fa-${sessionScope.messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                    ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="message" scope="session"/>
                <c:remove var="messageType" scope="session"/>
            </c:if>

            <!-- Filter -->
            <div class="card">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <ul class="nav nav-pills">
                                <li class="nav-item">
                                    <a class="nav-link ${viewType == 'all' ? 'active' : ''}" 
                                       href="appointment?action=list">
                                        <i class="fas fa-list"></i> Tất cả
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${viewType == 'pending' ? 'active' : ''}" 
                                       href="appointment?action=pending">
                                        <i class="fas fa-clock"></i> Chờ khám
                                    </a>
                                </li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <form action="appointment" method="get" class="d-flex justify-content-end">
                                <input type="hidden" name="action" value="by-date">
                                <div class="input-group date-picker">
                                    <input type="date" 
                                           class="form-control" 
                                           name="date" 
                                           value="${selectedDate}"
                                           required>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search"></i> Lọc theo ngày
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Statistics -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card bg-primary text-white">
                        <div class="card-body text-center">
                            <i class="fas fa-calendar-check fa-3x mb-2"></i>
                            <h5>Tổng lịch hẹn</h5>
                            <h2>${appointments.size()}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card bg-success text-white">
                        <div class="card-body text-center">
                            <i class="fas fa-check-circle fa-3x mb-2"></i>
                            <h5>Đã khám</h5>
                            <h2>
                                <c:set var="completed" value="0"/>
                                <c:forEach var="apt" items="${appointments}">
                                    <c:if test="${apt.hasMedicalReport}">
                                        <c:set var="completed" value="${completed + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${completed}
                            </h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card bg-warning text-white">
                        <div class="card-body text-center">
                            <i class="fas fa-hourglass-half fa-3x mb-2"></i>
                            <h5>Chờ khám</h5>
                            <h2>${appointments.size() - completed}</h2>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-list"></i> 
                        <c:choose>
                            <c:when test="${viewType == 'pending'}">
                                Danh sách lịch hẹn chờ khám
                            </c:when>
                            <c:when test="${viewType == 'by-date'}">
                                Lịch hẹn ngày ${selectedDate} (${appointmentCount} lịch)
                            </c:when>
                            <c:otherwise>
                                Tất cả lịch hẹn
                            </c:otherwise>
                        </c:choose>
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã lịch</th>
                                    <th>Bệnh nhân</th>
                                    <th>Ngày sinh</th>
                                    <th>Phụ huynh</th>
                                    <th>Ngày khám</th>
                                    <th>Giờ khám</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="apt" items="${appointments}">
                                    <tr>
                                        <td><strong>#${apt.appointmentId}</strong></td>
                                        <td>
                                            <fmt:parseDate value="${apt.patientDob}" pattern="yyyy-MM-dd" var="parsedDob"/>
                                            <fmt:formatDate value="${parsedDob}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty apt.parentName}">
                                                    <i class="fas fa-user"></i> ${apt.parentName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <i class="far fa-calendar"></i>
                                            <fmt:formatDate value="${apt.dateTime}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <i class="far fa-clock"></i>
                                            <fmt:formatDate value="${apt.dateTime}" pattern="HH:mm"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${apt.hasMedicalReport}">
                                                    <span class="badge bg-success status-badge">
                                                        <i class="fas fa-check"></i> Đã khám
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning status-badge">
                                                        <i class="fas fa-clock"></i> Chờ khám
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="appointment?action=view&id=${apt.appointmentId}" 
                                                   class="btn btn-sm btn-info" 
                                                   title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <c:if test="${apt.hasMedicalReport}">
                                                    <a href="medical-report?action=view&id=${apt.recordId}" 
                                                       class="btn btn-sm btn-success" 
                                                       title="Xem đơn thuốc">
                                                        <i class="fas fa-prescription"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${!apt.hasMedicalReport}">
                                                    <a href="medical-report?action=add&appointmentId=${apt.appointmentId}" 
                                                       class="btn btn-sm btn-primary" 
                                                       title="Kê đơn thuốc">
                                                        <i class="fas fa-plus"></i>
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty appointments}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-5">
                                            <i class="fas fa-inbox fa-3x mb-3"></i>
                                            <p>
                                                <c:choose>
                                                    <c:when test="${viewType == 'pending'}">
                                                        Không có lịch hẹn chờ khám
                                                    </c:when>
                                                    <c:when test="${viewType == 'by-date'}">
                                                        Không có lịch hẹn trong ngày này
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa có lịch hẹn nào
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="card">
                <div class="card-header bg-info text-white">
                    <h6 class="mb-0"><i class="fas fa-link"></i> Liên kết nhanh</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <a href="medical-report?action=list" class="btn btn-outline-primary w-100 mb-2">
                                <i class="fas fa-prescription-bottle-medical"></i> Quản lý đơn thuốc
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="test-result?action=list" class="btn btn-outline-success w-100 mb-2">
                                <i class="fas fa-vials"></i> Kết quả xét nghiệm
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="appointment?action=pending" class="btn btn-outline-warning w-100 mb-2">
                                <i class="fas fa-clock"></i> Xem lịch chờ khám
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Tự động ẩn alert sau 5 giây
            setTimeout(function () {
                const alert = document.querySelector('.alert');
                if (alert) {
                    alert.classList.remove('show');
                    setTimeout(() => alert.remove(), 150);
                }
            }, 5000);
        </script>
    </body>
</html><i class="fas fa-child text-primary"></i>
${apt.patientName}
</td>
<td>