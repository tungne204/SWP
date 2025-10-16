<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${report != null ? 'Chỉnh sửa' : 'Thêm mới'} đơn thuốc</title>
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
        }
        .form-label {
            font-weight: 600;
            color: #495057;
        }
        .required::after {
            content: " *";
            color: red;
        }
        textarea {
            min-height: 120px;
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
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="medical-report" class="text-white">Danh sách</a></li>
                    <li class="breadcrumb-item active text-white-50">${report != null ? 'Chỉnh sửa' : 'Thêm mới'}</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
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
                                            <i class="fas fa-info-circle"></i> 
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
                                            <strong><i class="fas fa-user-injured"></i> Bệnh nhân:</strong> ${report.patientName}
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="alert alert-info">
                                            <strong><i class="far fa-calendar"></i> Ngày khám:</strong> ${report.appointmentDate}
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
                                <div class="form-text">Mô tả tình trạng bệnh và chẩn đoán của bác sĩ</div>
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
                                        <i class="fas fa-flask"></i> Yêu cầu xét nghiệm
                                    </label>
                                </div>
                                <div class="form-text">Đánh dấu nếu bệnh nhân cần thực hiện xét nghiệm</div>
                            </div>

                            <!-- Buttons -->
                            <div class="d-flex justify-content-between">
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
                <div class="card mt-4">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-info-circle"></i> Hướng dẫn kê đơn thuốc
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="text-primary"><i class="fas fa-check-circle"></i> Lưu ý khi kê đơn:</h6>
                                <ul class="small">
                                    <li>Ghi rõ tên thuốc, hàm lượng</li>
                                    <li>Chỉ định liều lượng phù hợp với trẻ em</li>
                                    <li>Ghi rõ cách dùng và thời gian dùng</li>
                                    <li>Kiểm tra dị ứng thuốc của bệnh nhân</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6 class="text-success"><i class="fas fa-lightbulb"></i> Mẫu kê đơn:</h6>
                                <div class="small bg-light p-2 rounded">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validation form
        document.getElementById('medicalReportForm').addEventListener('submit', function(e) {
            const diagnosis = document.getElementById('diagnosis').value.trim();
            const prescription = document.getElementById('prescription').value.trim();
            
            if (diagnosis.length < 10) {
                e.preventDefault();
                alert('Chẩn đoán phải có ít nhất 10 ký tự!');
                return false;
            }
            
            if (prescription.length < 10) {
                e.preventDefault();
                alert('Đơn thuốc phải có ít nhất 10 ký tự!');
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