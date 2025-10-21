<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yêu Cầu Xét Nghiệm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1 class="mb-4">Yêu Cầu Xét Nghiệm</h1>
        
        <!-- Thông tin bệnh nhân -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Thông Tin Bệnh Nhân</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Họ Tên:</strong> ${patient.fullName}</p>
                        <p><strong>Mã Bệnh Nhân:</strong> ${patient.patientId}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Loại Bệnh Nhân:</strong> ${patientQueue.queueType == 'Walk-in' ? 'Khám Trực Tiếp' : 'Đã Đặt Lịch'}</p>
                        <p><strong>Trạng Thái:</strong> ${patientQueue.status}</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Form yêu cầu xét nghiệm -->
        <div class="card">
            <div class="card-header">
                <h5>Thông Tin Xét Nghiệm</h5>
            </div>
            <div class="card-body">
                <form action="patient-queue" method="post">
                    <input type="hidden" name="action" value="requestLabTest">
                    <input type="hidden" name="queueId" value="${patientQueue.queueId}">
                    <input type="hidden" name="consultationId" value="${consultation.consultationId}">
                    
                    <div class="mb-3">
                        <label for="testType" class="form-label">Loại Xét Nghiệm</label>
                        <select class="form-select" id="testType" name="testType" required>
                            <option value="">Chọn loại xét nghiệm</option>
                            <option value="Xét nghiệm máu">Xét nghiệm máu</option>
                            <option value="Xét nghiệm nước tiểu">Xét nghiệm nước tiểu</option>
                            <option value="Chụp X-quang">Chụp X-quang</option>
                            <option value="Siêu âm">Siêu âm</option>
                            <option value="Nội soi">Nội soi</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label for="testDescription" class="form-label">Mô Tả Yêu Cầu</label>
                        <textarea class="form-control" id="testDescription" name="testDescription" rows="3"></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="priority" class="form-label">Mức Độ Ưu Tiên</label>
                        <select class="form-select" id="priority" name="priority">
                            <option value="normal">Bình thường</option>
                            <option value="urgent">Khẩn cấp</option>
                        </select>
                    </div>
                    
                    <div class="alert alert-info">
                        <strong>Lưu ý:</strong> Sau khi yêu cầu xét nghiệm, bệnh nhân sẽ được chuyển sang trạng thái "Chờ Kết Quả Xét Nghiệm" 
                        và bác sĩ có thể tiếp tục khám bệnh nhân tiếp theo.
                    </div>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="patient-queue?action=consultation&queueId=${patientQueue.queueId}" class="btn btn-secondary me-md-2">Hủy</a>
                        <button type="submit" class="btn btn-primary">Gửi Yêu Cầu Xét Nghiệm</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Nút quay lại -->
        <div class="mt-3">
            <a href="patient-queue?action=consultation&queueId=${patientQueue.queueId}" class="btn btn-secondary">Quay Lại Khám Bệnh</a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>