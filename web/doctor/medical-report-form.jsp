<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${report != null ? 'Chỉnh sửa' : 'Thêm mới'} đơn thuốc - Medilab</title>
    
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
        
        .card-header.bg-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)) !important;
        }
        
        .card-header.bg-info {
            background: linear-gradient(135deg, #17a2b8, #138496) !important;
        }
        
        .card-header h5,
        .card-header h6 {
            margin: 0;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .card-body {
            padding: 2rem;
        }
        
        /* Form Styles */
        .form-label {
            font-weight: 600;
            color: var(--secondary-color);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .form-label i {
            color: var(--primary-dark);
        }
        
        .required::after {
            content: " *";
            color: #dc3545;
            font-weight: 700;
        }
        
        .form-control,
        .form-select {
            border: 2px solid #e3e6ea;
            border-radius: 8px;
            padding: 0.7rem 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus,
        .form-select:focus {
            border-color: var(--primary-dark);
            box-shadow: 0 0 0 0.2rem rgba(94, 196, 201, 0.15);
        }
        
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-text {
            color: #6c757d;
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }
        
        /* Alert Styles */
        .alert {
            border-radius: 10px;
            border: none;
            padding: 1rem 1.2rem;
        }
        
        .alert-info {
            background-color: rgba(125, 211, 215, 0.15);
            color: var(--secondary-color);
        }
        
        .alert-warning {
            background-color: rgba(255, 193, 7, 0.15);
            color: #856404;
        }
        
        /* Switch Toggle */
        .form-check-input {
            width: 3rem;
            height: 1.5rem;
            cursor: pointer;
        }
        
        .form-check-input:checked {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }
        
        .form-check-input:focus {
            box-shadow: 0 0 0 0.2rem rgba(94, 196, 201, 0.15);
        }
        
        .form-check-label {
            font-weight: 600;
            color: var(--secondary-color);
            cursor: pointer;
            margin-left: 0.5rem;
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
            background: linear-gradient(135deg, var(--primary-dark), #4ab4b9);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(94, 196, 201, 0.3);
            color: white;
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
        
        /* Guide Section */
        .guide-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
        }
        
        .guide-section h6 {
            font-weight: 600;
            margin-bottom: 0.8rem;
        }
        
        .guide-section ul {
            padding-left: 1.5rem;
            margin-bottom: 0;
        }
        
        .guide-section li {
            margin-bottom: 0.5rem;
        }
        
        .guide-example {
            background: white;
            border: 2px solid #e3e6ea;
            border-radius: 8px;
            padding: 1rem;
            font-family: 'Courier New', monospace;
            line-height: 1.8;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header-section">
        <div class="container">
            <h1>
                <i class="fas fa-${report != null ? 'edit' : 'plus-circle'}"></i> 
                ${report != null ? 'Chỉnh sửa' : 'Thêm mới'} đơn thuốc
            </h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="medical-report">
                            <i class="fas fa-list me-1"></i>Danh sách
                        </a>
                    </li>
                    <li class="breadcrumb-item active">
                        ${report != null ? 'Chỉnh sửa' : 'Thêm mới'}
                    </li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <!-- Main Form Card -->
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5>
                            <i class="fas fa-file-medical"></i> 
                            Thông tin đơn thuốc
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="medical-report" method="post" id="medicalReportForm">
                            <input type="hidden" name="action" value="${report != null ? 'update' : 'insert'}">
                            
                            <c:if test="${report != null}">
                                <input type="hidden" name="recordId" value="${report.recordId}">
                            </c:if>

                            <!-- Chọn appointment (chỉ hiện khi thêm mới) -->
                            <c:if test="${report == null}">
                                <div class="mb-4">
                                    <label for="appointmentId" class="form-label required">
                                        <i class="fas fa-calendar-check"></i> Chọn lịch khám
                                    </label>
                                    <select class="form-select" id="appointmentId" name="appointmentId" required>
                                        <option value="">-- Chọn lịch khám --</option>
                                        <c:forEach var="apt" items="${appointments}">
                                            <option value="${apt.appointmentId}">
                                                #${apt.appointmentId} - ${apt.patientName} - ${apt.dateTime}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${empty appointments}">
                                        <div class="alert alert-warning mt-2">
                                            <i class="fas fa-info-circle me-2"></i> 
                                            Không có lịch khám nào chưa có đơn thuốc
                                        </div>
                                    </c:if>
                                </div>
                            </c:if>

                            <!-- Thông tin bệnh nhân (khi chỉnh sửa) -->
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
                                <label for="diagnosis" class="form-label required">
                                    <i class="fas fa-stethoscope"></i> Chẩn đoán
                                </label>
                                <textarea class="form-control" 
                                          id="diagnosis" 
                                          name="diagnosis" 
                                          placeholder="Nhập chẩn đoán bệnh của bác sĩ..."
                                          required>${report != null ? report.diagnosis : ''}</textarea>
                                <div class="form-text">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Mô tả tình trạng bệnh và chẩn đoán của bác sĩ
                                </div>
                            </div>

                            <!-- Đơn thuốc -->
                            <div class="mb-4">
                                <label for="prescription" class="form-label required">
                                    <i class="fas fa-prescription"></i> Đơn thuốc
                                </label>
                                <textarea class="form-control" 
                                          id="prescription" 
                                          name="prescription" 
                                          placeholder="Nhập chi tiết đơn thuốc..."
                                          required>${report != null ? report.prescription : ''}</textarea>
                                <div class="form-text">
                                    <i class="fas fa-lightbulb me-1"></i>
                                    Ghi rõ: Tên thuốc, liều lượng, cách dùng, số lượng
                                    <br>
                                    <strong>Ví dụ:</strong> Paracetamol 250mg, uống 1 viên/lần, 3 lần/ngày sau ăn, 10 viên
                                </div>
                            </div>

                            <!-- Yêu cầu xét nghiệm -->
                            <div class="mb-4">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" 
                                           type="checkbox" 
                                           id="testRequest" 
                                           name="testRequest"
                                           ${report != null && report.testRequest ? 'checked' : ''}>
                                    <label class="form-check-label" for="testRequest">
                                        <i class="fas fa-flask me-2"></i>Yêu cầu xét nghiệm
                                    </label>
                                </div>
                                <div class="form-text">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Đánh dấu nếu bệnh nhân cần thực hiện xét nghiệm
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="d-flex justify-content-between mt-4 pt-3 border-top">
                                <a href="medical-report" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> 
                                    ${report != null ? 'Cập nhật' : 'Thêm mới'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Hướng dẫn kê đơn -->
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h6>
                            <i class="fas fa-info-circle"></i> Hướng dẫn kê đơn thuốc
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <div class="guide-section">
                                    <h6 class="text-primary">
                                        <i class="fas fa-check-circle me-2"></i>Lưu ý khi kê đơn:
                                    </h6>
                                    <ul class="small mb-0">
                                        <li>Ghi rõ tên thuốc, hàm lượng</li>
                                        <li>Chỉ định liều lượng phù hợp với trẻ em</li>
                                        <li>Ghi rõ cách dùng và thời gian dùng</li>
                                        <li>Kiểm tra dị ứng thuốc của bệnh nhân</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="guide-section">
                                    <h6 class="text-success">
                                        <i class="fas fa-lightbulb me-2"></i>Mẫu kê đơn:
                                    </h6>
                                    <div class="guide-example small">
                                        1. Paracetamol 250mg - 1 viên x 3 lần/ngày - 15 viên<br>
                                        2. Amoxicillin 250mg - 1 viên x 2 lần/ngày - 10 viên<br>
                                        3. Siro ho - 5ml x 3 lần/ngày - 1 chai
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validation form
        document.getElementById('medicalReportForm').addEventListener('submit', function(e) {
            const diagnosis = document.getElementById('diagnosis').value.trim();
            const prescription = document.getElementById('prescription').value.trim();
            
            if (diagnosis.length < 10) {
                e.preventDefault();
                alert('Chẩn đoán phải có ít nhất 10 ký tự!');
                document.getElementById('diagnosis').focus();
                return false;
            }
            
            if (prescription.length < 10) {
                e.preventDefault();
                alert('Đơn thuốc phải có ít nhất 10 ký tự!');
                document.getElementById('prescription').focus();
                return false;
            }
            
            return true;
        });

        // Auto resize textarea
        document.querySelectorAll('textarea').forEach(function(textarea) {
            textarea.addEventListener('input', function() {
                this.style.height = 'auto';
                this.style.height = this.scrollHeight + 'px';
            });
        });
    </script>
</body>
</html>