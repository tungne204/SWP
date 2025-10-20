<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả xét nghiệm - Medilab Pediatric Clinic</title>
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
            border: none;
            border-radius: 10px 10px 0 0 !important;
            padding: 1.25rem 1.5rem;
        }
        
        .card-header h5 {
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            margin: 0;
        }
        
        .card-header.bg-success {
            background: linear-gradient(135deg, var(--success-color), #388e3c) !important;
        }
        
        .card-header.bg-info {
            background: linear-gradient(135deg, var(--info-color), #138496) !important;
        }
        
        /* Navigation Pills */
        .nav-pills .nav-link {
            border-radius: 25px;
            padding: 0.6rem 1.5rem;
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
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
        }
        
        /* Alert Messages */
        .alert {
            border: none;
            border-radius: 8px;
            padding: 1rem 1.25rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            border-left: 5px solid;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-left-color: var(--success-color);
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-left-color: var(--danger-color);
        }
        
        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            border-left-color: var(--info-color);
        }
        
        .alert-heading {
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
        }
        
        /* Statistics Cards */
        .statistics-card {
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            color: white;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .statistics-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .statistics-card i {
            opacity: 0.9;
        }
        
        .statistics-card .card-title {
            font-size: 1rem;
            font-weight: 400;
            margin-bottom: 1rem;
            opacity: 0.95;
        }
        
        .statistics-card h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
        }
        
        .bg-success-custom {
            background: linear-gradient(135deg, var(--success-color), #388e3c);
        }
        
        .bg-info-custom {
            background: linear-gradient(135deg, var(--info-color), #138496);
        }
        
        .bg-warning-custom {
            background: linear-gradient(135deg, var(--warning-color), #ff9800);
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
        
        /* Test Type Badge */
        .test-type-badge {
            font-size: 0.85rem;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        .badge.bg-info {
            background: linear-gradient(135deg, var(--info-color), #138496) !important;
        }
        
        .badge.bg-success {
            background: linear-gradient(135deg, var(--success-color), #388e3c) !important;
        }
        
        .badge.bg-secondary {
            background: linear-gradient(135deg, #6c757d, #5a6268) !important;
        }
        
        /* Button Styling */
        .btn {
            border-radius: 25px;
            padding: 0.5rem 1.2rem;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
        }
        
        .btn i {
            margin-right: 0.4rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(63, 187, 192, 0.4);
        }
        
        .btn-success {
            background: linear-gradient(135deg, var(--success-color), #388e3c);
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #388e3c, var(--success-color));
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.4);
        }
        
        .btn-sm {
            padding: 0.4rem 1rem;
            font-size: 0.875rem;
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
            margin-bottom: 1.5rem;
        }
        
        /* Patient Statistics Section */
        .patient-stat-card {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border-left: 5px solid var(--info-color);
            padding: 1.25rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        
        .patient-stat-card:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .patient-stat-card .alert-heading {
            color: var(--dark-color);
            margin-bottom: 0.75rem;
        }
        
        .patient-stat-card p {
            color: #555;
            margin-bottom: 0.5rem;
        }
        
        .patient-stat-card .badge {
            font-size: 0.9rem;
            padding: 0.4rem 0.8rem;
        }
        
        /* Text Colors */
        .text-success-custom {
            color: var(--success-color) !important;
        }
        
        .text-primary-custom {
            color: var(--primary-color) !important;
        }
        
        .text-info-custom {
            color: var(--info-color) !important;
        }
        
        /* Link Badge */
        .badge.text-decoration-none {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .badge.text-decoration-none:hover {
            transform: scale(1.05);
            opacity: 0.9;
        }
        
        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .card {
            animation: fadeInUp 0.5s ease-out;
        }
        
        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.2s; }
        .card:nth-child(3) { animation-delay: 0.3s; }
        .card:nth-child(4) { animation-delay: 0.4s; }
        
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
            
            .statistics-card h2 {
                font-size: 2rem;
            }
            
            .table {
                font-size: 0.9rem;
            }
            
            .patient-stat-card .btn {
                width: 100%;
                margin-top: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header-section">
        <div class="container">
            <h1><i class="fas fa-vial"></i> Kết quả xét nghiệm</h1>
            <p class="mb-0">Quản lý và theo dõi kết quả xét nghiệm bệnh nhân</p>
        </div>
    </div>

    <div class="container">
        <!-- Navigation tabs -->
        <div class="card">
            <div class="card-body">
                <ul class="nav nav-pills mb-0">
                    <li class="nav-item">
                        <a class="nav-link active" href="test-result?action=list">
                            <i class="fas fa-list"></i> Tất cả kết quả
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="medical-report?action=list">
                            <i class="fas fa-prescription"></i> Quay lại đơn thuốc
                        </a>
                    </li>
                </ul>
            </div>
        </div>

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

        <!-- Statistics -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card statistics-card bg-success-custom">
                    <i class="fas fa-vials fa-3x mb-2"></i>
                    <h5 class="card-title">Tổng số xét nghiệm</h5>
                    <h2>${testResults.size()}</h2>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card statistics-card bg-info-custom">
                    <i class="fas fa-user-injured fa-3x mb-2"></i>
                    <h5 class="card-title">Bệnh nhân</h5>
                    <h2>
                        <c:set var="uniquePatients" value="${0}"/>
                        <c:set var="patientNames" value=""/>
                        <c:forEach var="tr" items="${testResults}">
                            <c:if test="${!patientNames.contains(tr.patientName)}">
                                <c:set var="uniquePatients" value="${uniquePatients + 1}"/>
                                <c:set var="patientNames" value="${patientNames}${tr.patientName},"/>
                            </c:if>
                        </c:forEach>
                        ${uniquePatients}
                    </h2>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card statistics-card bg-warning-custom">
                    <i class="fas fa-clipboard-list fa-3x mb-2"></i>
                    <h5 class="card-title">Loại xét nghiệm</h5>
                    <h2>
                        <c:set var="uniqueTypes" value="${0}"/>
                        <c:set var="testTypes" value=""/>
                        <c:forEach var="tr" items="${testResults}">
                            <c:if test="${!testTypes.contains(tr.testType)}">
                                <c:set var="uniqueTypes" value="${uniqueTypes + 1}"/>
                                <c:set var="testTypes" value="${testTypes}${tr.testType},"/>
                            </c:if>
                        </c:forEach>
                        ${uniqueTypes}
                    </h2>
                </div>
            </div>
        </div>

        <!-- Table -->
        <div class="card">
            <div class="card-header bg-success text-white">
                <h5>
                    <i class="fas fa-list"></i> Danh sách kết quả xét nghiệm
                </h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Mã XN</th>
                                <th>Bệnh nhân</th>
                                <th>Loại xét nghiệm</th>
                                <th>Kết quả</th>
                                <th>Ngày thực hiện</th>
                                <th>Mã hồ sơ</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="tr" items="${testResults}">
                                <tr>
                                    <td><strong>#${tr.testId}</strong></td>
                                    <td>
                                        <i class="fas fa-user-injured text-success-custom"></i>
                                        ${tr.patientName}
                                    </td>
                                    <td>
                                        <span class="badge test-type-badge bg-info">
                                            <i class="fas fa-microscope"></i>
                                            ${tr.testType}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="text-truncate d-inline-block" 
                                              style="max-width: 250px;" 
                                              title="${tr.result}">
                                            ${tr.result}
                                        </span>
                                    </td>
                                    <td>
                                        <i class="far fa-calendar"></i>
                                        ${tr.date}
                                    </td>
                                    <td>
                                        <a href="medical-report?action=view&id=${tr.recordId}" 
                                           class="badge bg-secondary text-decoration-none">
                                            #${tr.recordId}
                                        </a>
                                    </td>
                                    <td>
                                        <a href="test-result?action=view-detail&id=${tr.testId}" 
                                           class="btn btn-sm btn-success" 
                                           title="Xem chi tiết">
                                            <i class="fas fa-eye"></i> Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty testResults}">
                                <tr>
                                    <td colspan="7" class="empty-state">
                                        <i class="fas fa-inbox fa-3x"></i>
                                        <p>Chưa có kết quả xét nghiệm nào</p>
                                        <a href="medical-report?action=list" class="btn btn-primary">
                                            <i class="fas fa-arrow-left"></i> Quay lại đơn thuốc
                                        </a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Grouped by Patient -->
        <c:if test="${not empty testResults}">
            <div class="card">
                <div class="card-header bg-info text-white">
                    <h5>
                        <i class="fas fa-users"></i> Thống kê theo bệnh nhân
                    </h5>
                </div>
                <div class="card-body">
                    <c:set var="processedPatients" value=""/>
                    <c:forEach var="tr" items="${testResults}">
                        <c:if test="${!processedPatients.contains(tr.patientName)}">
                            <div class="patient-stat-card">
                                <h6 class="alert-heading">
                                    <i class="fas fa-user-injured"></i> ${tr.patientName}
                                </h6>
                                <p class="mb-2"><strong>Chẩn đoán:</strong> ${tr.diagnosis}</p>
                                <p class="mb-0 d-flex justify-content-between align-items-center">
                                    <span>
                                        <strong>Số xét nghiệm:</strong>
                                        <c:set var="count" value="0"/>
                                        <c:forEach var="t" items="${testResults}">
                                            <c:if test="${t.patientName == tr.patientName}">
                                                <c:set var="count" value="${count + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        <span class="badge bg-success">${count}</span>
                                    </span>
                                    
                                    <a href="test-result?action=view-by-record&recordId=${tr.recordId}" 
                                       class="btn btn-sm btn-success">
                                        <i class="fas fa-eye"></i> Xem tất cả
                                    </a>
                                </p>
                            </div>
                            <c:set var="processedPatients" value="${processedPatients}${tr.patientName},"/>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        setTimeout(function() {
            const alert = document.querySelector('.alert');
            if (alert) {
                alert.classList.remove('show');
                setTimeout(() => alert.remove(), 150);
            }
        }, 5000);
    </script>
</body>
</html>