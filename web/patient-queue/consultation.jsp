<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khám Bệnh - ${patient.fullName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1 class="mb-4">Khám Bệnh - ${patient.fullName}</h1>
        
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
                        <p><strong>Ngày Sinh:</strong> ${patient.dob}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Địa Chỉ:</strong> ${patient.address}</p>
                        <p><strong>Thông Tin Bảo Hiểm:</strong> ${patient.insuranceInfo}</p>
                        <p><strong>Loại Bệnh Nhân:</strong> ${patientQueue.queueType == 'Walk-in' ? 'Khám Trực Tiếp' : 'Đã Đặt Lịch'}</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Trạng thái hiện tại -->
        <div class="alert 
            <c:choose>
                <c:when test="${patientQueue.status == 'Waiting'}">alert-warning</c:when>
                <c:when test="${patientQueue.status == 'In Consultation'}">alert-primary</c:when>
                <c:when test="${patientQueue.status == 'Awaiting Lab Results'}">alert-info</c:when>
                <c:when test="${patientQueue.status == 'Ready for Follow-up'}">alert-success</c:when>
                <c:otherwise>alert-secondary</c:otherwise>
            </c:choose>
        " role="alert">
            <strong>Trạng Thái:</strong> ${patientQueue.status}
        </div>
        
        <!-- Form khám bệnh -->
        <div class="card">
            <div class="card-header">
                <h5>Thông Tin Khám Bệnh</h5>
            </div>
            <div class="card-body">
                <form action="patient-queue" method="post">
                    <input type="hidden" name="action" value="requestLabTest">
                    <input type="hidden" name="queueId" value="${patientQueue.queueId}">
                    <input type="hidden" name="consultationId" value="${consultation.consultationId}">
                    
                    <div class="mb-3">
                        <label for="diagnosis" class="form-label">Chẩn Đoán</label>
                        <textarea class="form-control" id="diagnosis" name="diagnosis" rows="3"></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="prescription" class="form-label">Đơn Thuốc</label>
                        <textarea class="form-control" id="prescription" name="prescription" rows="3"></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="notes" class="form-label">Ghi Chú</label>
                        <textarea class="form-control" id="notes" name="notes" rows="2"></textarea>
                    </div>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="submit" class="btn btn-primary me-md-2">Yêu Cầu Xét Nghiệm</button>
                        <a href="patient-queue?action=completeVisit&queueId=${patientQueue.queueId}&consultationId=${consultation.consultationId}" 
                           class="btn btn-success">Hoàn Tất Khám</a>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Lịch sử khám bệnh -->
        <div class="card mt-4">
            <div class="card-header">
                <h5>Lịch Sử Khám Bệnh</h5>
            </div>
            <div class="card-body">
                <c:if test="${not empty consultation}">
                    <p><strong>Thời Gian Bắt Đầu:</strong> ${consultation.startTime}</p>
                    <p><strong>Trạng Thái:</strong> ${consultation.status}</p>
                </c:if>
                <c:if test="${empty consultation}">
                    <p>Chưa có lịch sử khám bệnh.</p>
                </c:if>
            </div>
        </div>
        
        <!-- Nút quay lại -->
        <div class="mt-3">
            <a href="patient-queue?action=view" class="btn btn-secondary">Quay Lại Danh Sách</a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>