<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh Sửa' : 'Thêm Mới'} Khuyến Mãi - Phòng Khám Nhi</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <jsp:include page="../includes/head-includes.jsp"/>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
        }

        .header {
            width: 100%;
            background: white;
            padding: 15px 25px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .main-layout {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        .sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: white;
            min-height: calc(100vh - 70px);
            position: sticky;
            top: 70px;
        }

        .main-content {
            flex: 1;
            padding: 25px;
        }

        .container-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn {
            padding: 8px 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            transition: 0.3s;
        }

        .btn-primary { background: #3498db; color: white; }
        .btn-primary:hover { background: #2980b9; }
        .btn-success { background: #27ae60; color: white; }
        .btn-success:hover { background: #1e8449; }
        .btn-warning { background: #f1c40f; color: black; }
        .btn-warning:hover { background: #d4ac0d; }
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-secondary:hover { background: #7f8c8d; }

        .form-control, .form-select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 100%;
            margin-bottom: 15px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
            display: block;
        }

        .input-group {
            display: flex;
            margin-bottom: 15px;
        }

        .input-group-text {
            background: #f8f9fa;
            border: 1px solid #ddd;
            border-right: none;
            padding: 8px 12px;
            border-radius: 5px 0 0 5px;
        }

        .input-group .form-control {
            border-left: none;
            border-radius: 0 5px 5px 0;
            margin-bottom: 0;
        }

        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .validation-message {
            font-size: 0.875rem;
            margin-top: 5px;
        }

        .validation-message.error {
            color: #e74c3c;
        }

        .validation-message.success {
            color: #27ae60;
        }

        .preview-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .preview-card {
            background: white;
            border-radius: 5px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .row {
            display: flex;
            flex-wrap: wrap;
            margin: -10px;
        }

        .col-md-6 {
            flex: 0 0 50%;
            padding: 10px;
        }

        .col-md-12 {
            flex: 0 0 100%;
            padding: 10px;
        }

        .col-lg-8 {
            flex: 0 0 66.666667%;
            padding: 10px;
        }

        .col-lg-4 {
            flex: 0 0 33.333333%;
            padding: 10px;
        }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { padding: 15px; }
            .col-md-6, .col-lg-8, .col-lg-4 { flex: 0 0 100%; }
        }
    </style>
</head>

<body>
    <!-- HEADER -->
    <jsp:include page="../includes/header.jsp" />

    <div class="main-layout">
        <!-- SIDEBAR -->
        <% if (acc != null && acc.getRoleId() == 1) { %>
            <jsp:include page="../includes/sidebar-admin.jsp" />
        <% } %>

        <!-- MAIN CONTENT -->
        <div class="main-content">
            <div class="container-box">
                <h1><i class="fas fa-${isEdit ? 'edit' : 'plus'}"></i> ${isEdit ? 'Chỉnh Sửa' : 'Thêm Mới'} Khuyến Mãi</h1>

                <!-- Error Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>
                <form id="promotionForm" method="POST" action="${pageContext.request.contextPath}/manager/discount">
                    <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="discountId" value="${promotion.discountId}">
                    </c:if>

                    <div class="row">
                        <!-- Left Column -->
                        <div class="col-lg-8">
                            <!-- Basic Information -->
                            <h6><i class="fas fa-info-circle"></i> Thông Tin Cơ Bản</h6>
                            
                            <div class="col-md-12">
                                <label for="code" class="form-label">
                                    Mã khuyến mãi <span style="color: red;">*</span>
                                </label>
                                <input type="text" class="form-control" id="code" name="code" 
                                       value="${promotion.code}" required
                                       placeholder="VD: SUMMER2024">
                                <div class="validation-message" id="codeMessage"></div>
                                <small style="color: #6c757d;">Chỉ chứa chữ cái và số, không có khoảng trắng</small>
                            </div>

                            <!-- Discount Information -->
                            <h6><i class="fas fa-percentage"></i> Thông Tin Giảm Giá</h6>
                            
                            <div class="col-md-12">
                                <label for="percentage" class="form-label">
                                    Phần trăm giảm giá <span style="color: red;">*</span>
                                </label>
                                <div class="input-group">
                                    <input type="number" class="form-control" id="percentage" name="percentage" 
                                           value="${promotion.percentage}" required min="0" max="100" step="0.01"
                                           placeholder="0">
                                    <span class="input-group-text">%</span>
                                </div>
                                <div class="validation-message" id="percentageMessage"></div>
                                <small style="color: #6c757d;">Nhập giá trị từ 0 đến 100</small>
                            </div>

                            <!-- Time Period -->
                            <h6><i class="fas fa-calendar"></i> Thời Gian Áp Dụng</h6>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="validFrom" class="form-label">
                                        Ngày bắt đầu <span style="color: red;">*</span>
                                    </label>
                                    <input type="date" class="form-control" id="validFrom" name="validFrom" 
                                           value="<fmt:formatDate value='${promotion.validFrom}' pattern='yyyy-MM-dd'/>" required>
                                    <div class="validation-message" id="validFromMessage"></div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="validTo" class="form-label">
                                        Ngày kết thúc <span style="color: red;">*</span>
                                    </label>
                                    <input type="date" class="form-control" id="validTo" name="validTo" 
                                           value="<fmt:formatDate value='${promotion.validTo}' pattern='yyyy-MM-dd'/>" required>
                                    <div class="validation-message" id="validToMessage"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column -->
                        <div class="col-lg-4">
                            <!-- Preview -->
                            <div class="preview-section">
                                <h6><i class="fas fa-eye"></i> Xem Trước</h6>
                                
                                <div class="preview-card" id="promotionPreview">
                                    <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 10px;">
                                        <h6 style="margin: 0;" id="previewCode">Mã khuyến mãi</h6>
                                        <span style="background: #27ae60; color: white; padding: 3px 8px; border-radius: 3px; font-size: 0.8rem;" id="previewStatus">Hoạt động</span>
                                    </div>
                                    <p style="margin-bottom: 10px;" id="previewDiscount">Giảm 0%</p>
                                    <p style="color: #6c757d; font-size: 0.9rem; margin: 0;" id="previewPeriod">Chọn thời gian áp dụng</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div style="display: flex; justify-content: end; gap: 10px; margin-top: 30px;">
                        <a href="${pageContext.request.contextPath}/manager/discount?action=list" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Hủy
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            ${isEdit ? 'Cập Nhật' : 'Tạo Mới'}
                        </button>
                    </div>
                </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.12/dist/sweetalert2.all.min.js"></script>
    <script>
        // Form validation and preview functionality
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('promotionForm');
            const codeInput = document.getElementById('code');
            const percentageInput = document.getElementById('percentage');
            const validFromInput = document.getElementById('validFrom');
            const validToInput = document.getElementById('validTo');

            // Preview elements
            const previewCode = document.getElementById('previewCode');
            const previewDiscount = document.getElementById('previewDiscount');
            const previewPeriod = document.getElementById('previewPeriod');

            // Update preview when inputs change
            function updatePreview() {
                const code = codeInput.value || 'Mã khuyến mãi';
                const percentage = percentageInput.value || '0';
                const validFrom = validFromInput.value;
                const validTo = validToInput.value;

                previewCode.textContent = code;
                previewDiscount.textContent = 'Giảm ' + percentage + '%';

                if (validFrom && validTo) {
                    const fromDate = new Date(validFrom).toLocaleDateString('vi-VN');
                    const toDate = new Date(validTo).toLocaleDateString('vi-VN');
                    previewPeriod.textContent = fromDate + ' - ' + toDate;
                } else {
                    previewPeriod.textContent = 'Chọn thời gian áp dụng';
                }
            }

            // Add event listeners
            codeInput.addEventListener('input', updatePreview);
            percentageInput.addEventListener('input', updatePreview);
            validFromInput.addEventListener('change', updatePreview);
            validToInput.addEventListener('change', updatePreview);

            // Form validation
            form.addEventListener('submit', function(e) {
                let isValid = true;

                // Clear previous messages
                document.querySelectorAll('.validation-message').forEach(msg => {
                    msg.textContent = '';
                    msg.style.display = 'none';
                });

                // Validate code
                const code = codeInput.value.trim();
                if (!code) {
                    showValidationMessage('codeMessage', 'Vui lòng nhập mã khuyến mãi');
                    isValid = false;
                } else if (!/^[A-Za-z0-9]+$/.test(code)) {
                    showValidationMessage('codeMessage', 'Mã chỉ được chứa chữ cái và số');
                    isValid = false;
                }

                // Validate percentage
                const percentage = parseFloat(percentageInput.value);
                if (isNaN(percentage) || percentage < 0 || percentage > 100) {
                    showValidationMessage('percentageMessage', 'Phần trăm phải từ 0 đến 100');
                    isValid = false;
                }

                // Validate dates
                const validFrom = new Date(validFromInput.value);
                const validTo = new Date(validToInput.value);
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                if (!validFromInput.value) {
                    showValidationMessage('validFromMessage', 'Vui lòng chọn ngày bắt đầu');
                    isValid = false;
                } else if (validFrom < today) {
                    showValidationMessage('validFromMessage', 'Ngày bắt đầu không được trong quá khứ');
                    isValid = false;
                }

                if (!validToInput.value) {
                    showValidationMessage('validToMessage', 'Vui lòng chọn ngày kết thúc');
                    isValid = false;
                } else if (validTo <= validFrom) {
                    showValidationMessage('validToMessage', 'Ngày kết thúc phải sau ngày bắt đầu');
                    isValid = false;
                }

                if (!isValid) {
                    e.preventDefault();
                }
            });

            function showValidationMessage(elementId, message) {
                const element = document.getElementById(elementId);
                element.textContent = message;
                element.style.display = 'block';
                element.style.color = '#dc3545';
                element.style.fontSize = '0.875rem';
                element.style.marginTop = '5px';
            }

            // Initialize preview
            updatePreview();
        });
    </script>
</body>
</html>