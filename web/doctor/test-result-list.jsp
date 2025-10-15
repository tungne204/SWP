<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả xét nghiệm - Phòng khám nhi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .header-section {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
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
            background-color: #e8f5e9;
        }
        .test-type-badge {
            font-size: 0.875rem;
            padding: 0.4rem 0.8rem;
        }
        .nav-pills .nav-link {
            color: #495057;
        }
        .nav-pills .nav-link.active {
            background-color: #11998e;
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
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="fas fa-vials"></i> Tổng số xét nghiệm
                        </h5>
                        <h2 class="mb-0">${testResults.size()}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-info text-white">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="fas fa-user-injured"></i> Bệnh nhân
                        </h5>
                        <h2 class="mb-0">
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
            </div>
            <div class="col-md-4">
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="fas fa-clipboard-list"></i> Loại xét nghiệm
                        </h5>
                        <h2 class="mb-0">
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
        </div>

        <!-- Table -->
        <div class="card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">
                    <i class="fas fa-list"></i> Danh sách kết quả xét nghiệm
                </h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
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
                                        <i class="fas fa-user-injured text-success"></i>
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
                                    <td colspan="7" class="text-center text-muted py-5">
                                        <i class="fas fa-inbox fa-3x mb-3"></i>
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
                    <h5 class="mb-0">
                        <i class="fas fa-users"></i> Thống kê theo bệnh nhân
                    </h5>
                </div>
                <div class="card-body">
                    <c:set var="processedPatients" value=""/>
                    <c:forEach var="tr" items="${testResults}">
                        <c:if test="${!processedPatients.contains(tr.patientName)}">
                            <div class="alert alert-info">
                                <h6 class="alert-heading">
                                    <i class="fas fa-user-injured"></i> ${tr.patientName}
                                </h6>
                                <p class="mb-2"><strong>Chẩn đoán:</strong> ${tr.diagnosis}</p>
                                <p class="mb-0">
                                    <strong>Số xét nghiệm:</strong>
                                    <c:set var="count" value="0"/>
                                    <c:forEach var="t" items="${testResults}">
                                        <c:if test="${t.patientName == tr.patientName}">
                                            <c:set var="count" value="${count + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    <span class="badge bg-success">${count}</span>
                                    
                                    <a href="test-result?action=view-by-record&recordId=${tr.recordId}" 
                                       class="btn btn-sm btn-success float-end">
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
        // Tự động ẩn alert
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