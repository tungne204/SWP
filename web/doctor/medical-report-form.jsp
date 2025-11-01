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
    <title>${report != null ? 'Chỉnh sửa' : 'Thêm mới'} đơn thuốc - Medilab</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* =================== CHỈ ÁP DỤNG TRONG MAIN-CONTENT =================== */
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

        .main-content {
            margin-left: 250px;
            flex: 1;
            padding: 30px;
            background: #f7f9fb;
            min-height: 100vh;
        }

        /* ===== HEADER SECTION ===== */
        .header-section {
            background: #ffffff;
            color: #34495e;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 6px solid #3498db;
        }

        .header-section h1 {
            font-size: 1.7rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .breadcrumb {
            margin-top: 8px;
        }

        .breadcrumb a {
            color: #3498db;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            color: #2c3e50;
        }

        /* ===== CARD ===== */
        .card {
            border: none;
            border-radius: 10px;
            background: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }

        .card-header {
            background: #34495e;
            color: white;
            font-weight: 600;
            border-radius: 10px 10px 0 0;
            padding: 14px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-body {
            padding: 25px;
            background: #fcfcfc;
        }

        /* ===== FORM ===== */
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .form-label i {
            color: #3498db;
        }

        .required::after {
            content: " *";
            color: #e74c3c;
        }

        .form-control,
        .form-select {
            border: 2px solid #e3e6ea;
            border-radius: 8px;
            padding: 10px 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 0.15rem rgba(52, 152, 219, 0.25);
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .form-text {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin-top: 6px;
        }

        /* ===== ALERT ===== */
        .alert-info {
            background: #eaf3fc;
            color: #2c3e50;
            border-left: 4px solid #3498db;
            border-radius: 8px;
            padding: 1rem 1.4rem;
        }

        .alert-warning {
            background: #fff3cd;
            border-left: 4px solid #f1c40f;
            color: #856404;
            border-radius: 8px;
            padding: 1rem 1.4rem;
        }

        /* ===== BUTTONS ===== */
        .btn {
            border: none;
            border-radius: 6px;
            font-weight: 500;
            padding: 8px 16px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.25s ease;
        }

        .btn-primary {
            background: #3498db;
            color: white;
        }
        .btn-primary:hover { background: #2980b9; }

        .btn-secondary {
            background: #7f8c8d;
            color: white;
        }
        .btn-secondary:hover { background: #636e72; }

        /* ===== GUIDE BOX ===== */
        .guide-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
        }

        .guide-section h6 {
            font-weight: 600;
            color: #34495e;
        }

        .guide-example {
            background: #fff;
            border: 1px solid #e3e6ea;
            border-radius: 6px;
            padding: 1rem;
            font-family: 'Courier New', monospace;
            line-height: 1.6;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .sidebar-wrap { display: none; }
            .main-content { margin-left: 0; padding: 20px; }
        }
    </style>
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../includes/header.jsp" />

    <!-- LAYOUT -->
    <div class="layout">
        <!-- SIDEBAR -->
        <% if (acc != null && acc.getRoleId() == 2) { %>
            <jsp:include page="../includes/sidebar-doctor.jsp" />
        <% } %>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            <div class="header-section">
                <h1><i class="fas fa-file-medical"></i> ${report != null ? 'Chỉnh sửa' : 'Thêm mới'} đơn thuốc</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="medical-report"><i class="fas fa-list"></i> Danh sách</a></li>
                        <li class="breadcrumb-item active">${report != null ? 'Chỉnh sửa' : 'Thêm mới'}</li>
                    </ol>
                </nav>
            </div>

            <div class="card">
                <div class="card-header"><i class="fas fa-clipboard-list"></i> Thông tin đơn thuốc</div>
                <div class="card-body">
                    <form action="medical-report" method="post" id="medicalReportForm">
                        <input type="hidden" name="action" value="${report != null ? 'update' : 'insert'}">
                        <c:if test="${report != null}">
                            <input type="hidden" name="recordId" value="${report.recordId}">
                        </c:if>

                        <!-- Chọn appointment -->
                        <c:if test="${report == null}">
                            <div class="mb-4">
                                <label class="form-label required"><i class="fas fa-calendar-check"></i> Chọn lịch khám</label>
                                <select class="form-select" name="appointmentId" required>
                                    <option value="">-- Chọn lịch khám --</option>
                                    <c:forEach var="apt" items="${appointments}">
                                        <option value="${apt.appointmentId}">
                                            #${apt.appointmentId} - ${apt.patientName} - ${apt.dateTime}
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${empty appointments}">
                                    <div class="alert alert-warning mt-2">
                                        <i class="fas fa-info-circle me-2"></i> Không có lịch khám nào chưa có đơn thuốc
                                    </div>
                                </c:if>
                            </div>
                        </c:if>

                        <!-- Thông tin bệnh nhân -->
                        <c:if test="${report != null}">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="alert alert-info">
                                        <strong><i class="fas fa-user-injured me-2"></i>Bệnh nhân:</strong> ${report.patientName}
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="alert alert-info">
                                        <strong><i class="far fa-calendar me-2"></i>Ngày khám:</strong> ${report.appointmentDate}
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- Chẩn đoán -->
                        <div class="mb-4">
                            <label class="form-label required"><i class="fas fa-stethoscope"></i> Chẩn đoán</label>
                            <textarea class="form-control" name="diagnosis" maxlength="255" required>${report != null ? report.diagnosis : ''}</textarea>
                            <div class="form-text">Mô tả tình trạng bệnh của bệnh nhân.</div>
                        </div>

                        <!-- Đơn thuốc -->
                        <div class="mb-4">
                            <label class="form-label required"><i class="fas fa-prescription"></i> Đơn thuốc</label>
                            <textarea class="form-control" name="prescription" maxlength="255" required>${report != null ? report.prescription : ''}</textarea>
                            <div class="form-text">Ghi rõ tên thuốc, liều lượng, cách dùng.</div>
                        </div>

                        <!-- Xét nghiệm -->
                        <div class="mb-4">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="testRequest" ${report != null && report.testRequest ? 'checked' : ''}>
                                <label class="form-check-label"><i class="fas fa-flask me-2"></i>Yêu cầu xét nghiệm</label>
                            </div>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex justify-content-between mt-4 pt-3 border-top">
                            <a href="medical-report" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Quay lại</a>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> ${report != null ? 'Cập nhật' : 'Thêm mới'}</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Hướng dẫn kê đơn -->
            <div class="card">
                <div class="card-header"><i class="fas fa-info-circle"></i> Hướng dẫn kê đơn</div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <div class="guide-section">
                                <h6><i class="fas fa-check-circle me-2"></i>Lưu ý:</h6>
                                <ul class="small mb-0">
                                    <li>Ghi rõ tên thuốc, liều lượng</li>
                                    <li>Kiểm tra dị ứng thuốc trước khi kê</li>
                                    <li>Không kê thuốc trùng hoạt chất</li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="guide-section">
                                <h6><i class="fas fa-lightbulb me-2"></i>Mẫu kê đơn:</h6>
                                <div class="guide-example">
                                    1. Paracetamol 500mg - 1 viên x 3 lần/ngày<br>
                                    2. Amoxicillin 250mg - 1 viên x 2 lần/ngày<br>
                                    3. Siro ho - 5ml x 3 lần/ngày
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
