<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả xét nghiệm - Hồ sơ #${recordId}</title>
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
        .test-card {
            border-left: 4px solid #11998e;
            transition: all 0.3s;
        }
        .test-card:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .result-box {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            border: 2px dashed #11998e;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header-section">
        <div class="container">
            <h1>
                <i class="fas fa-flask"></i> 
                Kết quả xét nghiệm - Hồ sơ #${recordId}
            </h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 text-white">
                    <li class="breadcrumb-item">
                        <a href="medical-report?action=list" class="text-white">Đơn thuốc</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="test-result?action=list" class="text-white">Xét nghiệm</a>
                    </li>
                    <li class="breadcrumb-item active text-white-50">Hồ sơ #${recordId}</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container">
        <!-- Action buttons -->
        <div class="card">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <a href="test-result?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>
                    <a href="medical-report?action=view&id=${recordId}" class="btn btn-info">
                        <i class="fas fa-file-medical"></i> Xem hồ sơ bệnh án
                    </a>
                </div>
            </div>
        </div>

        <!-- Status Card -->
        <div class="row">
            <div class="col-md-4">
                <div class="card text-white ${hasTestRequest ? 'bg-warning' : 'bg-secondary'}">
                    <div class="card-body text-center">
                        <i class="fas fa-flask fa-3x mb-2"></i>
                        <h5>Yêu cầu xét nghiệm</h5>
                        <h3>${hasTestRequest ? 'CÓ' : 'KHÔNG'}</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-success">
                    <div class="card-body text-center">
                        <i class="fas fa-vials fa-3x mb-2"></i>
                        <h5>Số xét nghiệm đã thực hiện</h5>
                        <h3>${testCount}</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white ${testCount > 0 ? 'bg-info' : 'bg-danger'}">
                    <div class="card-body text-center">
                        <i class="fas fa-check-circle fa-3x mb-2"></i>
                        <h5>Trạng thái</h5>
                        <h3>${testCount > 0 ? 'ĐÃ CÓ KẾT QUẢ' : 'CHƯA CÓ'}</h3>
                    </div>
                </div>
            </div>
        </div>

        <!-- Test Results List -->
        <c:choose>
            <c:when test="${not empty testResults}">
                <c:forEach var="tr" items="${testResults}" varStatus="status">
                    <div class="card test-card">
                        <div class="card-header bg-success text-white">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h5 class="mb-0">
                                        <i class="fas fa-microscope"></i> 
                                        Xét nghiệm #${status.count}: ${tr.testType}
                                    </h5>
                                </div>
                                <div class="col-auto">
                                    <span class="badge bg-light text-dark">
                                        <i class="far fa-calendar"></i> ${tr.date}
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <p class="mb-1"><strong><i class="fas fa-user-injured"></i> Bệnh nhân:</strong></p>
                                    <p class="text-muted">${tr.patientName}</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1"><strong><i class="fas fa-notes-medical"></i> Chẩn đoán:</strong></p>
                                    <p class="text-muted">${tr.diagnosis}</p>
                                </div>
                            </div>
                            
                            <div class="result-box">
                                <p class="mb-1"><strong><i class="fas fa-flask"></i> Kết quả xét nghiệm:</strong></p>
                                <p class="mb-0 fs-5">${tr.result}</p>
                            </div>
                            
                            <div class="text-end mt-3">
                                <a href="test-result?action=view-detail&id=${tr.testId}" 
                                   class="btn btn-success">
                                    <i class="fas fa-eye"></i> Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="card">
                    <div class="card-body text-center py-5">
                        <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">
                            ${hasTestRequest ? 'Chưa có kết quả xét nghiệm' : 'Không có yêu cầu xét nghiệm'}
                        </h4>
                        <p class="text-muted">
                            ${hasTestRequest ? 'Kết quả xét nghiệm sẽ được cập nhật sau khi nhận từ phòng xét nghiệm' : 'Hồ sơ này không có yêu cầu xét nghiệm'}
                        </p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Notes -->
        <c:if test="${hasTestRequest && testCount == 0}">
            <div class="alert alert-warning">
                <h6 class="alert-heading">
                    <i class="fas fa-exclamation-triangle"></i> Lưu ý
                </h6>
                <p class="mb-0">
                    Hồ sơ bệnh án này có yêu cầu xét nghiệm nhưng chưa có kết quả. 
                    Vui lòng liên hệ phòng xét nghiệm để cập nhật kết quả.
                </p>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>