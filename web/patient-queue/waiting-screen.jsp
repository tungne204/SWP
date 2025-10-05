<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Màn Hình Chờ - Quản Lý Bệnh Nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .status-waiting { background-color: #ffc107; }
        .status-in-consultation { background-color: #198754; color: white; }
        .status-awaiting-lab { background-color: #0d6efd; color: white; }
        .status-ready-followup { background-color: #6f42c1; color: white; }
        .status-completed { background-color: #6c757d; color: white; }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h1 class="mb-4">Danh Sách Bệnh Nhân Đang Chờ</h1>
        
        <!-- Thông báo -->
        <c:if test="${not empty message}">
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <!-- Bảng danh sách bệnh nhân -->
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>STT</th>
                        <th>Họ Tên</th>
                        <th>Mã BN</th>
                        <th>Trạng Thái</th>
                        <th>Thời Gian Vào</th>
                        <th>Loại</th>
                        <th>Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="queueDetail" items="${queueDetails}">
                        <tr>
                            <td>${queueDetail.queue.queueNumber}</td>
                            <td>${queueDetail.patient.fullName}</td>
                            <td>${queueDetail.patient.patientId}</td>
                            <td>
                                <span class="badge 
                                    <c:choose>
                                        <c:when test="${queueDetail.queue.status == 'Waiting'}">status-waiting</c:when>
                                        <c:when test="${queueDetail.queue.status == 'In Consultation'}">status-in-consultation</c:when>
                                        <c:when test="${queueDetail.queue.status == 'Awaiting Lab Results'}">status-awaiting-lab</c:when>
                                        <c:when test="${queueDetail.queue.status == 'Ready for Follow-up'}">status-ready-followup</c:when>
                                        <c:when test="${queueDetail.queue.status == 'Completed'}">status-completed</c:when>
                                    </c:choose>
                                ">
                                    ${queueDetail.queue.status}
                                </span>
                            </td>
                            <td>${queueDetail.queue.checkInTime}</td>
                            <td>${queueDetail.queue.queueType}</td>
                            <td>
                                <c:if test="${queueDetail.queue.status == 'Waiting'}">
                                    <a href="patient-queue?action=consultation&queueId=${queueDetail.queue.queueId}" 
                                       class="btn btn-primary btn-sm">Bắt Đầu Khám</a>
                                </c:if>
                                <c:if test="${queueDetail.queue.status == 'In Consultation'}">
                                    <a href="patient-queue?action=consultation&queueId=${queueDetail.queue.queueId}" 
                                       class="btn btn-success btn-sm">Tiếp Tục Khám</a>
                                </c:if>
                                <c:if test="${queueDetail.queue.status == 'Awaiting Lab Results'}">
                                    <button class="btn btn-info btn-sm" disabled>Chờ Kết Quả Xét Nghiệm</button>
                                </c:if>
                                <c:if test="${queueDetail.queue.status == 'Ready for Follow-up'}">
                                    <a href="patient-queue?action=consultation&queueId=${queueDetail.queue.queueId}" 
                                       class="btn btn-warning btn-sm">Khám Lại</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <!-- Nút hành động -->
        <div class="mt-3">
            <a href="patient-queue/checkin-form.jsp" class="btn btn-success">Đăng Ký Bệnh Nhân</a>
            <button class="btn btn-secondary" onclick="location.reload()">Làm Mới</button>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>