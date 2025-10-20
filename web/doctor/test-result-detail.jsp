<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết xét nghiệm #${testResult.testId}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background-color: #f4f8fb;
                font-family: 'Poppins', sans-serif;
                color: #2c4964;
            }
            .header-section {
                background: linear-gradient(135deg, #3fbbc0 0%, #2a9ca1 100%);
                color: white;
                padding: 2rem 0;
                margin-bottom: 2rem;
            }
            .header-section h1 {
                font-weight: 700;
            }
            .breadcrumb-item a {
                color: #fff;
                text-decoration: none;
            }
            .breadcrumb-item.active {
                color: rgba(255,255,255,0.7);
            }
            .card {
                border: none;
                border-radius: 1rem;
                box-shadow: 0 0 20px rgba(0,0,0,0.08);
                margin-bottom: 2rem;
            }
            .card-header {
                font-weight: 600;
                border-radius: 1rem 1rem 0 0;
            }
            .card-header.bg-info {
                background-color: #3fbbc0 !important;
            }
            .card-header.bg-success {
                background-color: #2a9ca1 !important;
            }
            .card-header.bg-warning {
                background-color: #ffc107 !important;
            }
            .card-header.bg-secondary {
                background-color: #2c4964 !important;
            }
            .info-label {
                font-weight: 600;
                color: #2c4964;
                margin-bottom: 0.5rem;
            }
            .info-value {
                background-color: #f9f9f9;
                padding: 1rem;
                border-radius: 0.5rem;
                border-left: 4px solid #3fbbc0;
            }
            .result-box {
                background: linear-gradient(135deg, #e0f7fa 0%, #b2ebf2 100%);
                border: 2px solid #3fbbc0;
                border-radius: 10px;
                padding: 2rem;
                font-size: 1.1rem;
                font-weight: 500;
                color: #2c4964;
            }
            .btn {
                border-radius: 0.5rem;
            }
            .btn-info {
                background-color: #3fbbc0;
                border: none;
            }
            .btn-info:hover {
                background-color: #2a9ca1;
            }
            .btn-success {
                background-color: #2a9ca1;
                border: none;
            }
            .btn-success:hover {
                background-color: #3fbbc0;
            }
            .alert-info {
                background-color: #e0f7fa;
                color: #2c4964;
                border-left: 4px solid #3fbbc0;
            }
            ul.small li {
                margin-bottom: 0.25rem;
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
                    <i class="fas fa-microscope"></i> 
                    Chi tiết kết quả xét nghiệm #${testResult.testId}
                </h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="medical-report?action=list" class="text-white">Đơn thuốc</a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="test-result?action=list" class="text-white">Xét nghiệm</a>
                        </li>
                        <li class="breadcrumb-item active text-white-50">Chi tiết #${testResult.testId}</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="container">
            <!-- Action buttons -->
            <div class="card no-print">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <a href="test-result?action=list" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Danh sách
                            </a>
                            <a href="test-result?action=view-by-record&recordId=${testResult.recordId}" 
                               class="btn btn-info">
                                <i class="fas fa-folder-open"></i> Xem theo hồ sơ
                            </a>
                        </div>
                        <button onclick="window.print()" class="btn btn-success">
                            <i class="fas fa-print"></i> In kết quả
                        </button>
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
                                    <i class="fas fa-id-card"></i> Mã xét nghiệm
                                </div>
                                <div class="info-value">
                                    <strong>#${testResult.testId}</strong>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="info-label">
                                    <i class="fas fa-user"></i> Họ và tên
                                </div>
                                <div class="info-value">
                                    ${testResult.patientName}
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="info-label">
                                    <i class="fas fa-folder-open"></i> Mã hồ sơ bệnh án
                                </div>
                                <div class="info-value">
                                    <a href="medical-report?action=view&id=${testResult.recordId}" 
                                       class="text-decoration-none">
                                        #${testResult.recordId}
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thông tin xét nghiệm -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-flask"></i> Thông tin xét nghiệm
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <div class="info-label">
                                    <i class="fas fa-microscope"></i> Loại xét nghiệm
                                </div>
                                <div class="info-value">
                                    <span class="badge bg-success fs-6">
                                        ${testResult.testType}
                                    </span>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="info-label">
                                    <i class="far fa-calendar"></i> Ngày thực hiện
                                </div>
                                <div class="info-value">
                                    ${testResult.date}
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="info-label">
                                    <i class="fas fa-notes-medical"></i> Chẩn đoán ban đầu
                                </div>
                                <div class="info-value">
                                    ${testResult.diagnosis}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Kết quả xét nghiệm -->
            <div class="card">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0">
                        <i class="fas fa-clipboard-check"></i> Kết quả xét nghiệm
                    </h5>
                </div>
                <div class="card-body">
                    <div class="result-box">
                        <div class="text-center mb-3">
                            <i class="fas fa-check-circle text-success fa-3x"></i>
                        </div>
                        <div class="text-center">
                            <h4 class="text-success mb-3">KẾT QUẢ XÉT NGHIỆM</h4>
                            <p class="mb-0">${testResult.result}</p>
                        </div>
                    </div>

                    <div class="alert alert-info mt-4 no-print">
                        <h6 class="alert-heading">
                            <i class="fas fa-info-circle"></i> Lưu ý về kết quả:
                        </h6>
                        <ul class="mb-0 small">
                            <li>Kết quả xét nghiệm cần được bác sĩ giải thích và đánh giá</li>
                            <li>Không tự ý điều trị dựa trên kết quả xét nghiệm</li>
                            <li>Nếu có thắc mắc, vui lòng tái khám với bác sĩ</li>
                            <li>Kết quả này chỉ có giá trị tại thời điểm xét nghiệm</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Thông tin thêm -->
            <div class="card">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-clipboard-list"></i> Hướng dẫn xử lý
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="text-success">
                                <i class="fas fa-check-circle"></i> Những việc cần làm:
                            </h6>
                            <ul class="small">
                                <li>Mang kết quả này đến gặp bác sĩ điều trị</li>
                                <li>Tuân thủ điều trị theo chỉ định của bác sĩ</li>
                                <li>Thực hiện xét nghiệm lại nếu cần thiết</li>
                                <li>Theo dõi sức khỏe thường xuyên</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6 class="text-danger">
                                <i class="fas fa-times-circle"></i> Những việc cần tránh:
                            </h6>
                            <ul class="small">
                                <li>Không tự ý điều trị hoặc ngừng thuốc</li>
                                <li>Không so sánh kết quả với người khác</li>
                                <li>Không hoang mang nếu kết quả bất thường</li>
                                <li>Không bỏ qua lời khuyên của bác sĩ</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Phần ký tên (chỉ hiện khi in) -->
            <div class="card d-none d-print-block">
                <div class="card-body">
                    <div class="row mt-5">
                        <div class="col-6 text-center">
                            <p><strong>Người nhận kết quả</strong></p>
                            <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
                            <div style="min-height: 80px;"></div>
                            <p><strong>${testResult.patientName}</strong></p>
                        </div>
                        <div class="col-6 text-center">
                            <p><strong>Bác sĩ xác nhận</strong></p>
                            <p class="text-muted small">(Ký và đóng dấu)</p>
                            <div style="min-height: 80px;"></div>
                        </div>
                    </div>
                    <div class="text-center mt-4">
                        <p class="small text-muted">
                            Phòng khám nhi khoa - Địa chỉ: 123 ABC, Hà Nội - Hotline: 1900-xxxx
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>