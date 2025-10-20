<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch hẹn bệnh nhân - Medilab Pediatric Clinic</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

        <style>
            :root {
                --primary-color: #3fbbc0;
                --secondary-color: #2a9ca1;
                --dark-color: #2c4964;
                --light-bg: #f8f9fa;
                --success-color: #4caf50;
                --warning-color: #ffc107;
                --danger-color: #dc3545;
                --info-color: #17a2b8;
            }

            * {
                font-family: 'Roboto', sans-serif;
            }

            body {
                background-color: var(--light-bg);
                color: #444444;
            }

            /* Header Section */
            .header-section {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
                padding: 3rem 0 2rem;
                margin-bottom: 2rem;
                box-shadow: 0 4px 15px rgba(63, 187, 192, 0.3);
            }

            .header-section h1 {
                font-family: 'Poppins', sans-serif;
                font-weight: 600;
                font-size: 2.5rem;
                margin-bottom: 0.5rem;
            }

            .header-section p {
                font-size: 1.1rem;
                opacity: 0.95;
            }

            /* Card Styling */
            .card {
                border: none;
                border-radius: 10px;
                box-shadow: 0 2px 20px rgba(0, 0, 0, 0.08);
                margin-bottom: 2rem;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 30px rgba(0, 0, 0, 0.12);
            }

            .card-header {
                background: var(--primary-color);
                border: none;
                border-radius: 10px 10px 0 0 !important;
                padding: 1rem 1.5rem;
            }

            .card-header h5, .card-header h6 {
                font-family: 'Poppins', sans-serif;
                font-weight: 500;
                margin: 0;
            }

            /* Alert Messages */
            .alert {
                border: none;
                border-radius: 8px;
                padding: 1rem 1.25rem;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            }

            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border-left: 4px solid var(--success-color);
            }

            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border-left: 4px solid var(--danger-color);
            }

            /* Navigation Pills */
            .nav-pills .nav-link {
                border-radius: 25px;
                padding: 0.5rem 1.5rem;
                margin-right: 0.5rem;
                color: var(--dark-color);
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .nav-pills .nav-link:hover {
                background-color: rgba(63, 187, 192, 0.1);
                color: var(--primary-color);
            }

            .nav-pills .nav-link.active {
                background-color: var(--primary-color);
                color: white;
            }

            /* Date Picker Group */
            .date-picker {
                max-width: 350px;
            }

            .date-picker .form-control {
                border-radius: 25px 0 0 25px;
                border: 2px solid #e0e0e0;
                padding: 0.6rem 1rem;
            }

            .date-picker .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(63, 187, 192, 0.25);
            }

            .date-picker .btn {
                border-radius: 0 25px 25px 0;
                padding: 0.6rem 1.5rem;
                font-weight: 500;
            }

            /* Statistics Cards */
            .statistics-card {
                border-radius: 15px;
                padding: 1.5rem;
                text-align: center;
                color: white;
                transition: transform 0.3s ease;
            }

            .statistics-card:hover {
                transform: translateY(-8px);
            }

            .statistics-card i {
                opacity: 0.9;
            }

            .statistics-card h5 {
                font-size: 1rem;
                font-weight: 400;
                margin-top: 0.5rem;
                opacity: 0.95;
            }

            .statistics-card h2 {
                font-size: 2.5rem;
                font-weight: 700;
                margin: 0.5rem 0 0;
            }

            .bg-primary-custom {
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            }

            .bg-success-custom {
                background: linear-gradient(135deg, #4caf50, #388e3c);
            }

            .bg-warning-custom {
                background: linear-gradient(135deg, #ffc107, #ff9800);
            }

            /* Table Styling */
            .table-responsive {
                border-radius: 8px;
                overflow: hidden;
            }

            .table {
                margin-bottom: 0;
            }

            .table thead th {
                background-color: #f8f9fa;
                color: var(--dark-color);
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 0.5px;
                padding: 1rem;
                border: none;
            }

            .table tbody td {
                padding: 1rem;
                vertical-align: middle;
                border-color: #f0f0f0;
            }

            .table-hover tbody tr {
                transition: all 0.3s ease;
            }

            .table-hover tbody tr:hover {
                background-color: rgba(63, 187, 192, 0.08);
                transform: scale(1.01);
            }

            /* Status Badges */
            .status-badge {
                font-size: 0.85rem;
                padding: 0.4rem 1rem;
                border-radius: 20px;
                font-weight: 500;
                display: inline-flex;
                align-items: center;
                gap: 0.4rem;
            }

            .badge.bg-success {
                background-color: var(--success-color) !important;
            }

            .badge.bg-warning {
                background-color: var(--warning-color) !important;
                color: #333 !important;
            }

            /* Button Styling */
            .btn {
                border-radius: 25px;
                padding: 0.5rem 1.2rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .btn-primary:hover {
                background-color: var(--secondary-color);
                border-color: var(--secondary-color);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(63, 187, 192, 0.4);
            }

            .btn-group .btn {
                border-radius: 4px;
                margin: 0 2px;
            }

            .btn-sm {
                padding: 0.4rem 0.8rem;
                font-size: 0.875rem;
            }

            .btn-info {
                background-color: var(--info-color);
                border-color: var(--info-color);
                color: white;
            }

            .btn-info:hover {
                background-color: #138496;
                border-color: #138496;
            }

            .btn-outline-primary {
                color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .btn-outline-primary:hover {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
                color: white;
            }

            .btn-outline-success {
                color: var(--success-color);
                border-color: var(--success-color);
            }

            .btn-outline-success:hover {
                background-color: var(--success-color);
                border-color: var(--success-color);
            }

            .btn-outline-warning {
                color: #ff9800;
                border-color: #ff9800;
            }

            .btn-outline-warning:hover {
                background-color: #ff9800;
                border-color: #ff9800;
                color: white;
            }

            /* Empty State */
            .empty-state {
                padding: 3rem 1rem;
                text-align: center;
            }

            .empty-state i {
                color: #ccc;
                margin-bottom: 1rem;
            }

            .empty-state p {
                color: #999;
                font-size: 1.1rem;
            }

            /* Quick Links Card */
            .quick-links-card .card-header {
                background: var(--info-color);
            }

            /* Icons */
            .text-primary-custom {
                color: var(--primary-color) !important;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .header-section h1 {
                    font-size: 1.8rem;
                }

                .header-section {
                    padding: 2rem 0 1.5rem;
                }

                .nav-pills {
                    flex-direction: column;
                }

                .nav-pills .nav-link {
                    margin-bottom: 0.5rem;
                    margin-right: 0;
                }

                .date-picker {
                    max-width: 100%;
                    margin-top: 1rem;
                }

                .statistics-card h2 {
                    font-size: 2rem;
                }
            }

            /* Animation */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .card {
                animation: fadeInUp 0.5s ease-out;
            }
            .btn-back {
                background-color: #58c1c5;
                border: none;
                color: white;
            }
            .btn-back:hover {
                background-color: #3fb0b5;
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
            <!-- Nút trở về trang chính bác sĩ -->
            <div class="mb-3 text-end">
                <a href="doctor-dashboard" class="btn btn-back">
                    <i class="fas fa-arrow-left"></i> Trang chính bác sĩ
                </a>

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
                    <div class="card statistics-card bg-primary-custom">
                        <i class="fas fa-calendar-check fa-3x"></i>
                        <h5>Tổng lịch hẹn</h5>
                        <h2>${appointments.size()}</h2>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card statistics-card bg-success-custom">
                        <i class="fas fa-check-circle fa-3x"></i>
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
                <div class="col-md-4">
                    <div class="card statistics-card bg-warning-custom">
                        <i class="fas fa-hourglass-half fa-3x"></i>
                        <h5>Chờ khám</h5>
                        <h2>${appointments.size() - completed}</h2>
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="card">
                <div class="card-header">
                    <h5>
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
                            <thead>
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
                                            <i class="fas fa-child text-primary-custom"></i>
                                            ${apt.patientName}
                                        </td>
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
                                        <td colspan="8" class="empty-state">
                                            <i class="fas fa-inbox fa-3x"></i>
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
            <div class="card quick-links-card">
                <div class="card-header">
                    <h6><i class="fas fa-link"></i> Liên kết nhanh</h6>
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
            setTimeout(function () {
                const alert = document.querySelector('.alert');
                if (alert) {
                    alert.classList.remove('show');
                    setTimeout(() => alert.remove(), 150);
                }
            }, 5000);
        </script>
    </body>
</html>