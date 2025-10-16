<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn thuốc #${report.recordId}</title>
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
        .prescription-box {
            background-color: #fff;
            border: 2px solid #667eea;
            border-radius: 0.5rem;
            padding: 1.5rem;
            white-space: pre-line;
        }
        @media print {
            .no-print {
                display: none;
            }
            .card {
                box-shadow: none;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header-section no-print">
        <div class="container">
            <h1>
                <i class="fas fa-file-medical-alt"></i> 
                Chi tiết đơn thuốc #${report.recordId}
            </h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="medical-report" class="text-white">Danh sách</a></li>
                    <li class="breadcrumb-item active text-white-50">Chi tiết</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container">
        <!-- Action buttons -->
        <div class="card no-print">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <a href="medical-report" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <div>
                        <a href="medical-report?action=edit&id=${report.recordId}" class="btn btn-warning">
                            <i class="fas fa-edit"></i> Chỉnh sửa
                        </a>
                        <button onclick="window.print()" class="btn btn-primary">
                            <i class="fas fa-print"></i> In đơn thuốc
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Thông tin bệnh nhân -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-user-injured"></i> Thông tin bệnh nhân
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-id-card"></i> Mã hồ sơ
                            </div>
                            <div class="info-value">
                                <strong>#${report.recordId}</strong>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-user"></i> Họ và tên
                            </div>
                            <div class="info-value">
                                ${report.patientName}
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="far fa-calendar"></i> Ngày khám
                            </div>
                            <div class="info-value">
                                ${report.appointmentDate}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thông tin bác sĩ -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-user-md"></i> Thông tin bác sĩ
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-user-doctor"></i> Bác sĩ khám
                            </div>
                            <div class="info-value">
                                BS. ${report.doctorName}
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">
                                <i class="fas fa-flask"></i> Yêu cầu xét nghiệm
                            </div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${report.testRequest}">
                                        <span class="badge bg-warning text-dark fs-6">
                                            <i class="fas fa-check-circle"></i> Có yêu cầu xét nghiệm
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary fs-6">
                                            <i class="fas fa-times-circle"></i> Không yêu cầu
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Chẩn đoán -->
        <div class="card">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0">
                    <i class="fas fa-stethoscope"></i> Chẩn đoán
                </h5>
            </div>
            <div class="card-body">
                <div class="info-value">
                    ${report.diagnosis}
                </div>
            </div>
        </div>

        <!-- Đơn thuốc -->
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    <i class="fas fa-prescription"></i> Đơn thuốc
                </h5>
            </div>
            <div class="card-body">
                <div class="prescription-box">
                    ${report.prescription}
                </div>
                
                <div class="alert alert-info mt-4 no-print">
                    <h6 class="alert-heading">
                        <i class="fas fa-info-circle"></i> Lưu ý dùng thuốc:
                    </h6>
                    <ul class="mb-0 small">
                        <li>Dùng thuốc đúng liều lượng và thời gian theo chỉ định của bác sĩ</li>
                        <li>Không tự ý tăng hoặc giảm liều lượng</li>
                        <li>Bảo quản thuốc ở nơi khô ráo, tránh ánh nắng trực tiếp</li>
                        <li>Nếu có bất kỳ phản ứng bất thường nào, liên hệ ngay với bác sĩ</li>
                        <li>Đối với trẻ em, phụ huynh cần giám sát việc dùng thuốc</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Ký tên (chỉ hiện khi in) -->
        <div class="card d-none d-print-block">
            <div class="card-body">
                <div class="row mt-5">
                    <div class="col-6 text-center">
                        <p><strong>Người nhận đơn</strong></p>
                        <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
                        <div style="min-height: 80px;"></div>
                    </div>
                    <div class="col-6 text-center">
                        <p><strong>Bác sĩ khám bệnh</strong></p>
                        <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
                        <div style="min-height: 80px;"></div>
                        <p><strong>BS. ${report.doctorName}</strong></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>