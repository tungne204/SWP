<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hoàn Tất Khám Bệnh</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1 class="mb-4">Hoàn Tất Khám Bệnh</h1>
        
        <!-- Thông báo thành công -->
        <div class="alert alert-success" role="alert">
            <h4 class="alert-heading">Khám Bệnh Đã Hoàn Tất!</h4>
            <p>Ca khám bệnh của bệnh nhân đã được hoàn thành thành công.</p>
            <hr>
            <p class="mb-0">Bệnh nhân đã được xóa khỏi hàng đợi và có thể rời khỏi phòng khám.</p>
        </div>
        
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
                        <p><strong>Thời Gian Vào:</strong> ${patientQueue.checkInTime}</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Thông tin chẩn đoán -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Thông Tin Chẩn Đoán</h5>
            </div>
            <div class="card-body">
                <p><strong>Chẩn Đoán:</strong> ${medicalReport.diagnosis}</p>
                <p><strong>Đơn Thuốc:</strong> ${medicalReport.prescription}</p>
                <p><strong>Yêu Cầu Xét Nghiệm:</strong> 
                    <c:choose>
                        <c:when test="${medicalReport.testRequest == true}">Có</c:when>
                        <c:when test="${medicalReport.testRequest == false}">Không</c:when>
                        <c:otherwise>Chưa xác định</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>
        
        <!-- Thống kê nhanh -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Thống Kê</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="border rounded p-3 text-center">
                            <h3>${totalVisits}</h3>
                            <p>Tổng Số Lượt Khám Hôm Nay</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="border rounded p-3 text-center">
                            <h3>${waitingPatients}</h3>
                            <p>Bệnh Nhân Đang Chờ</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="border rounded p-3 text-center">
                            <h3>${completedPatients}</h3>
                            <p>Bệnh Nhân Đã Hoàn Tất</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Nút hành động -->
        <div class="mt-3">
            <a href="patient-queue?action=view" class="btn btn-primary">Quay Lại Danh Sách</a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>