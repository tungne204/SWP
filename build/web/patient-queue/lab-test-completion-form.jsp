<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hoàn Tất Xét Nghiệm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .lab-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .patient-card {
            border-left: 4px solid #007bff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .test-form {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 2rem;
        }
        .btn-complete {
            background: linear-gradient(45deg, #28a745, #20c997);
            border: none;
            padding: 12px 30px;
            font-weight: 600;
        }
        .btn-complete:hover {
            background: linear-gradient(45deg, #218838, #1ea080);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        .status-badge {
            background: #ffc107;
            color: #000;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="lab-header">
        <div class="container">
            <h1 class="mb-0">
                <i class="fas fa-flask me-3"></i>
                Hoàn Tất Xét Nghiệm
            </h1>
            <p class="mb-0 mt-2">Nhập kết quả xét nghiệm và hoàn tất quy trình</p>
        </div>
    </div>

    <div class="container">
        <!-- Thông tin bệnh nhân -->
        <div class="card patient-card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    <i class="fas fa-user-injured me-2"></i>
                    Thông Tin Bệnh Nhân
                </h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong><i class="fas fa-user me-2"></i>Họ Tên:</strong> ${patient.fullName}</p>
                        <p><strong><i class="fas fa-id-card me-2"></i>Mã Bệnh Nhân:</strong> ${patient.patientId}</p>
                        <p><strong><i class="fas fa-birthday-cake me-2"></i>Ngày Sinh:</strong> ${patient.dob}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong><i class="fas fa-clock me-2"></i>Thời Gian Check-in:</strong> ${patientQueue.checkInTime}</p>
                        <p><strong><i class="fas fa-list me-2"></i>Loại Bệnh Nhân:</strong> 
                            ${patientQueue.queueType == 'Walk-in' ? 'Khám Trực Tiếp' : 'Đã Đặt Lịch'}
                        </p>
                        <p><strong><i class="fas fa-info-circle me-2"></i>Trạng Thái:</strong> 
                            <span class="status-badge">Chờ Xét Nghiệm</span>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Form hoàn tất xét nghiệm -->
        <div class="test-form">
            <h4 class="mb-4">
                <i class="fas fa-clipboard-check me-2"></i>
                Nhập Kết Quả Xét Nghiệm
            </h4>
            
            <form action="patient-queue" method="post" id="labCompletionForm">
                <input type="hidden" name="action" value="completeLabTest">
                <input type="hidden" name="consultationId" value="${consultation.consultationId}">
                <input type="hidden" name="queueId" value="${patientQueue.queueId}">
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="testType" class="form-label">
                                <i class="fas fa-vial me-2"></i>Loại Xét Nghiệm
                            </label>
                            <select class="form-select" id="testType" name="testType" required>
                                <option value="">Chọn loại xét nghiệm</option>
                                <option value="Xét nghiệm máu">Xét nghiệm máu</option>
                                <option value="Xét nghiệm nước tiểu">Xét nghiệm nước tiểu</option>
                                <option value="Chụp X-quang">Chụp X-quang</option>
                                <option value="Siêu âm">Siêu âm</option>
                                <option value="Nội soi">Nội soi</option>
                                <option value="CT Scan">CT Scan</option>
                                <option value="MRI">MRI</option>
                                <option value="Khác">Khác</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="testDate" class="form-label">
                                <i class="fas fa-calendar me-2"></i>Ngày Thực Hiện
                            </label>
                            <input type="datetime-local" class="form-control" id="testDate" name="testDate" required>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="testResult" class="form-label">
                        <i class="fas fa-file-medical me-2"></i>Kết Quả Xét Nghiệm
                    </label>
                    <textarea class="form-control" id="testResult" name="testResult" rows="4" 
                              placeholder="Nhập kết quả chi tiết xét nghiệm..." required></textarea>
                    <div class="form-text">Vui lòng nhập kết quả xét nghiệm một cách chi tiết và chính xác</div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="technician" class="form-label">
                                <i class="fas fa-user-md me-2"></i>Kỹ Thuật Viên
                            </label>
                            <input type="text" class="form-control" id="technician" name="technician" 
                                   placeholder="Tên kỹ thuật viên thực hiện" required>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="priority" class="form-label">
                                <i class="fas fa-exclamation-triangle me-2"></i>Mức Độ Khẩn Cấp
                            </label>
                            <select class="form-select" id="priority" name="priority">
                                <option value="normal">Bình thường</option>
                                <option value="urgent">Khẩn cấp</option>
                                <option value="critical">Rất khẩn cấp</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="notes" class="form-label">
                        <i class="fas fa-sticky-note me-2"></i>Ghi Chú Thêm
                    </label>
                    <textarea class="form-control" id="notes" name="notes" rows="3" 
                              placeholder="Ghi chú thêm về quá trình xét nghiệm (không bắt buộc)"></textarea>
                </div>

                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    <strong>Lưu ý:</strong> Sau khi hoàn tất xét nghiệm, bệnh nhân sẽ được chuyển sang trạng thái 
                    "Sẵn Sàng Khám Lại" với mức độ ưu tiên cao để tiếp tục quá trình khám bệnh.
                </div>

                <div class="d-flex justify-content-between">
                    <a href="patient-queue?action=view" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay Lại
                    </a>
                    <button type="submit" class="btn btn-complete text-white">
                        <i class="fas fa-check-circle me-2"></i>Hoàn Tất Xét Nghiệm
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set current date and time as default
        document.addEventListener('DOMContentLoaded', function() {
            const now = new Date();
            const localDateTime = new Date(now.getTime() - now.getTimezoneOffset() * 60000).toISOString().slice(0, 16);
            document.getElementById('testDate').value = localDateTime;
        });

        // Form validation
        document.getElementById('labCompletionForm').addEventListener('submit', function(e) {
            const testResult = document.getElementById('testResult').value.trim();
            const technician = document.getElementById('technician').value.trim();
            
            if (testResult.length < 10) {
                e.preventDefault();
                alert('Vui lòng nhập kết quả xét nghiệm chi tiết hơn (ít nhất 10 ký tự)');
                return;
            }
            
            if (technician.length < 2) {
                e.preventDefault();
                alert('Vui lòng nhập tên kỹ thuật viên');
                return;
            }
            
            // Confirm before submitting
            if (!confirm('Bạn có chắc chắn muốn hoàn tất xét nghiệm này? Hành động này không thể hoàn tác.')) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>