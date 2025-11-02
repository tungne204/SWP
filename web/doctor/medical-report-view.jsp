<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết đơn thuốc #${report.recordId} - Medilab</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f6fa;
            }

            .layout {
                display: flex;
                min-height: 100vh;
            }

            .sidebar-wrap {
                width: 250px;
                flex-shrink: 0;
                background: #2c3e50;
                color: white;
                position: fixed;
                top: 0;
                bottom: 0;
                overflow-y: auto;
                z-index: 100;
            }

            /* ===================== MAIN CONTENT ONLY ===================== */
            .main-content {
                background: #f7f9fb; /* sáng dịu, hài hòa với tone navy của sidebar/header */
                padding: 30px;
                flex: 1;
                margin-left: 250px; /* giữ đúng layout cũ */
                min-height: 100vh;
            }

            /* Header Section trong main-content */
            .main-content .header-section {
                background: #ffffff;
                color: #34495e;
                border-radius: 10px;
                padding: 25px;
                margin-bottom: 25px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                border-left: 6px solid #3498db;
            }

            .main-content .header-section h1 {
                font-size: 1.7rem;
                font-weight: 700;
                margin: 0;
                color: #2c3e50;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .main-content .breadcrumb {
                margin-top: 8px;
            }

            .main-content .breadcrumb a {
                color: #3498db;
                text-decoration: none;
            }

            .main-content .breadcrumb a:hover {
                color: #2c3e50;
            }

            /* ===================== CARD STYLE ===================== */
            .main-content .card {
                border: none;
                border-radius: 10px;
                background: #ffffff;
                box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
                margin-bottom: 25px;
                transition: all 0.25s ease;
            }

            .main-content .card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 14px rgba(0, 0, 0, 0.08);
            }

            .main-content .card-header {
                background: #34495e;
                color: #ffffff;
                font-weight: 600;
                border-radius: 10px 10px 0 0;
                padding: 14px 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .main-content .card-body {
                padding: 22px 25px;
                background: #fcfcfc;
            }

            /* ===================== INFO DISPLAY ===================== */
            .main-content .info-label {
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 6px;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .main-content .info-label i {
                color: #3498db;
            }

            .main-content .info-value {
                background: #f8fafc;
                border-left: 4px solid #3498db;
                border-radius: 6px;
                padding: 10px 14px;
                font-size: 15px;
                color: #2c3e50;
            }

            /* ===================== PRESCRIPTION BOX ===================== */
            .main-content .prescription-box {
                background: #fdfefe;
                border: 1px solid #e3e8ee;
                border-radius: 8px;
                padding: 16px;
                white-space: pre-line;
                line-height: 1.7;
                color: #2c3e50;
            }

            /* ===================== BUTTONS ===================== */
            .main-content .btn {
                border: none;
                border-radius: 6px;
                font-weight: 500;
                padding: 8px 16px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: all 0.25s ease;
            }

            .main-content .btn-primary {
                background: #3498db;
                color: white;
            }
            .main-content .btn-primary:hover {
                background: #2980b9;
            }

            .main-content .btn-success {
                background: #27ae60;
                color: white;
            }
            .main-content .btn-success:hover {
                background: #229954;
            }

            .main-content .btn-secondary {
                background: #7f8c8d;
                color: white;
            }
            .main-content .btn-secondary:hover {
                background: #636e72;
            }

            /* ===================== ALERT ===================== */
            .main-content .alert-info {
                background: #eaf3fc;
                color: #2c3e50;
                border-left: 4px solid #3498db;
                border-radius: 8px;
                padding: 1rem 1.4rem;
            }

            /* ===================== BADGE ===================== */
            .main-content .badge.bg-warning {
                background-color: #f39c12 !important;
                color: #fff !important;
            }

            /* ===================== RESPONSIVE ===================== */
            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0;
                    padding: 20px;
                }
            }

            /* ===================== PRINT ===================== */
            @media print {
                .no-print {
                    display: none !important;
                }
                body {
                    background: white;
                }
                .main-content {
                    background: white;
                }
                .main-content .card {
                    box-shadow: none;
                }
            }

        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="../includes/header.jsp" />

        <!-- Layout -->
        <div class="layout">
            <!-- Sidebar -->
            <% if (acc != null && acc.getRoleId() == 2) { %>
            <jsp:include page="../includes/sidebar-doctor.jsp" />
            <% } %>


            <!-- Main content -->
            <main class="main-content">
                <div class="header-section">
                    <h1><i class="fas fa-file-medical"></i> Chi tiết đơn thuốc </h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="medical-report"><i class="fas fa-list"></i> Danh sách</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Chi tiết</li>
                        </ol>
                    </nav>
                </div>

                <!-- Buttons -->
                <div class="mb-3 no-print d-flex justify-content-between flex-wrap gap-3">
                    <% if (acc != null && acc.getRoleId() == 2) { %>
                    <div class="d-flex gap-2">
                        <a href="medical-report?action=edit&id=${report.recordId}" class="btn btn-success">
                            <i class="fas fa-edit"></i> Chỉnh sửa
                        </a>
                        <button onclick="window.print()" class="btn btn-primary">
                            <i class="fas fa-print"></i> In đơn thuốc
                        </button>
                    </div>
                    <% } %>

                </div>

                <!-- Patient & Doctor info -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header"><i class="fas fa-user-injured"></i> Thông tin bệnh nhân</div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="info-label">Mã hồ sơ</div>
                                    <div class="info-value"><strong>#${report.recordId}</strong></div>
                                </div>
                                <div class="mb-3">
                                    <div class="info-label">Họ và tên</div>
                                    <div class="info-value">${report.patientName}</div>
                                </div>
                                <div>
                                    <div class="info-label">Ngày khám</div>
                                    <div class="info-value">${report.appointmentDate}</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header"><i class="fas fa-user-md"></i> Thông tin bác sĩ</div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="info-label">Bác sĩ phụ trách</div>
                                    <div class="info-value">BS. ${report.doctorName}</div>
                                </div>
                                <div>
                                    <div class="info-label">Yêu cầu xét nghiệm</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${report.testRequest}">
                                                <span class="badge bg-warning"><i class="fas fa-check-circle"></i> Có</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary"><i class="fas fa-times-circle"></i> Không</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Diagnosis -->
                <div class="card">
                    <div class="card-header"><i class="fas fa-stethoscope"></i> Chẩn đoán</div>
                    <div class="card-body">
                        <div class="info-value">${report.diagnosis}</div>
                    </div>
                </div>

                <!-- Prescription -->
                <div class="card">
                    <div class="card-header"><i class="fas fa-prescription"></i> Đơn thuốc</div>
                    <div class="card-body">
                        <div class="prescription-box">${report.prescription}</div>
                        <div class="alert alert-info mt-4 no-print">
                            <strong><i class="fas fa-info-circle"></i> Lưu ý:</strong>
                            <ul class="mt-2 mb-0">
                                <li>Dùng thuốc đúng liều lượng theo chỉ định</li>
                                <li>Không tự ý thay đổi liều</li>
                                <li>Bảo quản thuốc nơi khô ráo, tránh ánh nắng trực tiếp</li>
                                <li>Nếu có phản ứng bất thường, liên hệ bác sĩ ngay</li>
                                <li>Phụ huynh cần giám sát khi trẻ dùng thuốc</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Print Signature -->
                <div class="card d-none d-print-block">
                    <div class="card-body text-center">
                        <div class="row mt-5">
                            <div class="col-6">
                                <p><strong>Người nhận đơn</strong></p>
                                <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
                                <div style="height:80px;"></div>
                            </div>
                            <div class="col-6">
                                <p><strong>Bác sĩ khám bệnh</strong></p>
                                <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
                                <div style="height:80px;"></div>
                                <p><strong>BS. ${report.doctorName}</strong></p>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
