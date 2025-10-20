<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn thuốc #${report.recordId} - Medilab</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" 
          rel="stylesheet" 
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" 
          crossorigin="anonymous">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #3fbbc0;
            --primary-dark: #2a9fa4;
            --secondary-color: #2c4964;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
            --light-bg: #f0f4f8;
        }
        
        body {
            background-color: var(--light-bg);
            min-height: 100vh;
            font-family: 'Roboto', sans-serif;
            padding-bottom: 3rem;
        }
        
        /* Header Section */
        .header-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(63, 187, 192, 0.15);
        }
        
        .header-section h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.8rem;
        }
        
        .header-section h1 i {
            font-size: 2.2rem;
        }
        
        .breadcrumb {
            background: transparent;
            padding: 0;
            margin: 0;
        }
        
        .breadcrumb-item a {
            color: white;
            text-decoration: none;
            font-weight: 500;
        }
        
        .breadcrumb-item a:hover {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: underline;
        }
        
        .breadcrumb-item.active {
            color: rgba(255, 255, 255, 0.7);
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            color: rgba(255, 255, 255, 0.6);
        }
        
        /* Card Styles */
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 2rem;
            background: white;
        }
        
        .card-header {
            border-radius: 15px 15px 0 0 !important;
            padding: 1.2rem 1.5rem;
            border: none;
        }
        
        .card-header h5 {
            margin: 0;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .card-header.bg-info {
            background: linear-gradient(135deg, var(--info-color), #138496) !important;
        }
        
        .card-header.bg-success {
            background: linear-gradient(135deg, var(--success-color), #218838) !important;
        }
        
        .card-header.bg-warning {
            background: linear-gradient(135deg, var(--warning-color), #e0a800) !important;
        }
        
        .card-header.bg-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)) !important;
        }
        
        .card-body {
            padding: 2rem;
        }
        
        /* Info Display */
        .info-label {
            font-weight: 600;
            color: var(--secondary-color);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-label i {
            color: var(--primary-color);
        }
        
        .info-value {
            background-color: #f8f9fa;
            padding: 1rem 1.2rem;
            border-radius: 10px;
            border-left: 4px solid var(--primary-color);
            color: var(--secondary-color);
            font-size: 1rem;
        }
        
        /* Prescription Box */
        .prescription-box {
            background-color: #fff;
            border: 2px solid var(--primary-color);
            border-radius: 12px;
            padding: 1.5rem;
            white-space: pre-line;
            line-height: 1.8;
            color: var(--secondary-color);
            font-size: 1rem;
        }
        
        /* Buttons */
        .btn {
            padding: 0.7rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border: none;
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, var(--primary-dark), #1e7c81);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(63, 187, 192, 0.3);
            color: white;
        }
        
        .btn-warning {
            background: linear-gradient(135deg, var(--warning-color), #e0a800);
            border: none;
            color: #212529;
        }
        
        .btn-warning:hover {
            background: linear-gradient(135deg, #e0a800, #c69500);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.3);
            color: #212529;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            border: none;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.3);
        }
        
        /* Badge Styles */
        .badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
        }
        
        .badge.bg-warning {
            background-color: rgba(255, 193, 7, 0.2) !important;
            color: #e0a800 !important;
        }
        
        /* Alert Styles */
        .alert {
            border-radius: 12px;
            border: none;
            padding: 1.2rem;
        }
        
        .alert-info {
            background-color: rgba(23, 162, 184, 0.1);
            color: var(--secondary-color);
        }
        
        .alert-heading {
            font-weight: 600;
            color: var(--info-color);
            margin-bottom: 1rem;
        }
        
        .alert ul {
            padding-left: 1.5rem;
        }
        
        .alert li {
            margin-bottom: 0.5rem;
        }
        
        /* Print Signature Section */
        .signature-section {
            margin-top: 3rem;
        }
        
        .signature-box {
            text-align: center;
        }
        
        .signature-box strong {
            font-size: 1.1rem;
            color: var(--secondary-color);
        }
        
        .signature-box .text-muted {
            font-size: 0.9rem;
            font-style: italic;
        }
        
        .signature-space {
            min-height: 80px;
            margin: 1rem 0;
        }
        
        /* Print Styles */
        @media print {
            body {
                background: white;
            }
            
            .no-print {
                display: none !important;
            }
            
            .card {
                box-shadow: none;
                page-break-inside: avoid;
            }
            
            .card-header {
                background: #f8f9fa !important;
                color: var(--secondary-color) !important;
            }
            
            .d-print-block {
                display: block !important;
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
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="medical-report">
                            <i class="fas fa-list me-1"></i>Danh sách
                        </a>
                    </li>
                    <li class="breadcrumb-item active">Chi tiết</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container">
        <!-- Action buttons -->
        <div class="card no-print">
            <div class="card-body">
                <div class="d-flex justify-content-between flex-wrap gap-3">
                    <a href="medical-report" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <div class="d-flex gap-2">
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
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5>
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
                        <div class="mb-0">
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
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5>
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
                        <div class="mb-0">
                            <div class="info-label">
                                <i class="fas fa-flask"></i> Yêu cầu xét nghiệm
                            </div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${report.testRequest}">
                                        <span class="badge bg-warning fs-6">
                                            <i class="fas fa-check-circle me-1"></i> Có yêu cầu xét nghiệm
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary fs-6">
                                            <i class="fas fa-times-circle me-1"></i> Không yêu cầu
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
                <h5>
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
                <h5>
                    <i class="fas fa-prescription"></i> Đơn thuốc
                </h5>
            </div>
            <div class="card-body">
                <div class="prescription-box">
                    ${report.prescription}
                </div>
                
                <div class="alert alert-info mt-4 no-print">
                    <h6 class="alert-heading">
                        <i class="fas fa-info-circle me-2"></i> Lưu ý dùng thuốc:
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
                <div class="row signature-section">
                    <div class="col-6 signature-box">
                        <p><strong>Người nhận đơn</strong></p>
                        <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
                        <div class="signature-space"></div>
                    </div>
                    <div class="col-6 signature-box">
                        <p><strong>Bác sĩ khám bệnh</strong></p>
                        <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
                        <div class="signature-space"></div>
                        <p><strong>BS. ${report.doctorName}</strong></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>