<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Details - Medilab</title>
    
    <!-- Include all CSS files -->
    <jsp:include page="../../includes/head-includes.jsp"/>
    
    <style>
        /* Scope CSS chỉ cho content, không ảnh hưởng header/sidebar */
        .main * {
            box-sizing: border-box;
        }
        
        .main {
            font-family: 'Roboto', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #ffffff;
            min-height: calc(100vh - 80px);
        }
        
        .main .container {
            max-width: 900px;
            margin: 20px auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .main .container .header {
            background: linear-gradient(135deg, #1977cc 0%, #2c4964 100%);
            color: white;
            padding: 40px;
        }
        
        .main .container .back-link {
            display: inline-block;
            color: white;
            text-decoration: none;
            margin-bottom: 20px;
            opacity: 0.9;
            transition: opacity 0.3s;
        }
        
        .main .container .back-link:hover {
            opacity: 1;
        }
        
        .main .container .header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .main .container .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
        }
        
        .main .container .status-pending { background: #fff3cd; color: #856404; }
        .main .container .status-confirmed { background: #d1ecf1; color: #0c5460; }
        .main .container .status-waiting { background: #ffeaa7; color: #d63031; }
        .main .container .status-in-progress { background: #d4edda; color: #155724; }
        .main .container .status-testing { background: #cce5ff; color: #004085; }
        .main .container .status-completed { background: #d4edda; color: #155724; }
        .main .container .status-cancelled { background: #f8d7da; color: #721c24; }
        
        .main .container .content {
            padding: 40px;
        }
        
        .main .container .section {
            margin-bottom: 30px;
            padding-bottom: 30px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .main .container .section:last-child {
            border-bottom: none;
        }
        
        .main .container .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .main .container .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .main .container .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid #1977cc;
        }
        
        .main .container .info-label {
            font-size: 13px;
            color: #6c757d;
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .main .container .info-value {
            font-size: 16px;
            color: #2c3e50;
            font-weight: 500;
        }
        
        .main .container .doctor-card {
            background: linear-gradient(135deg, #1977cc 0%, #2c4964 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .main .container .doctor-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid white;
        }
        
        .main .container .doctor-info h3 {
            font-size: 22px;
            margin-bottom: 8px;
        }
        
        .main .container .doctor-info p {
            opacity: 0.9;
            font-size: 14px;
        }
        
        .main .container .medical-box {
            background: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 20px;
            border-radius: 10px;
            margin-top: 15px;
        }
        
        .main .container .medical-box h4 {
            color: #2e7d32;
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        .main .container .medical-box p {
            color: #1b5e20;
            white-space: pre-wrap;
            line-height: 1.6;
        }
        
        .main .container .timeline {
            position: relative;
            padding-left: 40px;
        }
        
        .main .container .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e0e0e0;
        }
        
        .main .container .timeline-item {
            position: relative;
            margin-bottom: 20px;
            padding-left: 30px;
        }
        
        .main .container .timeline-item::before {
            content: '✓';
            position: absolute;
            left: -26px;
            top: 0;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #1977cc;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        
        .main .container .timeline-item.pending::before {
            content: '⏳';
            background: #ffc107;
        }
        
        .main .container .timeline-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .main .container .timeline-desc {
            font-size: 14px;
            color: #6c757d;
        }
        
        .main .container .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .main .container .btn {
            flex: 1;
            padding: 14px 28px;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }
        
        .main .container .btn-back {
            background: #95a5a6;
            color: white;
        }
        
        .main .container .btn-back:hover {
            background: #7f8c8d;
        }
        
        .main .container .btn-cancel {
            background: #e74c3c;
            color: white;
        }
        
        .main .container .btn-cancel:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
        }
    </style>
    <script>
        function confirmCancel() {
            return confirm('Bạn có chắc chắn muốn hủy lịch hẹn này? Hành động này không thể hoàn tác.');
        }
    </script>
</head>
<body class="index-page">
    <!-- Header -->
    <jsp:include page="../../includes/header.jsp"/>
    
    <main class="main" style="padding-top: 80px;">
        <div class="container">
        <div class="header">
            <a href="${pageContext.request.contextPath}/appointments" class="back-link">
                ← Quay lại lịch hẹn của tôi
            </a>
            <h1>📋 Chi tiết lịch hẹn</h1>
            <span class="status-badge status-${appointment.status.toLowerCase().replace(' ', '-')}">
                ${appointment.status}
            </span>
        </div>
        
        <div class="content">
            <!-- Appointment Information -->
            <div class="section">
                <div class="section-title">
                    📅 Thông tin lịch hẹn
                </div>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Mã lịch hẹn</div>
                        <div class="info-value">#${appointment.appointmentId}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Ngày & Giờ</div>
                        <div class="info-value">
                            <fmt:formatDate value="${appointment.dateTime}" 
                                           pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Thứ trong tuần</div>
                        <div class="info-value">
                            <fmt:formatDate value="${appointment.dateTime}" 
                                           pattern="EEEE"/>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Trạng thái</div>
                        <div class="info-value">${appointment.status}</div>
                    </div>
                </div>
            </div>
            
            <!-- Doctor Information -->
            <div class="section">
                <div class="section-title">
                    👨‍⚕️ Thông tin bác sĩ
                </div>
                <c:choose>
                    <c:when test="${not empty doctor}">
                        <div class="doctor-card">
                            <c:if test="${not empty doctor.avatar}">
                                <img src="${pageContext.request.contextPath}/${doctor.avatar}" 
                                     alt="Doctor" class="doctor-avatar">
                            </c:if>
                            <div class="doctor-info">
                                <h3>Dr. ${doctor.username}</h3>
                                <c:if test="${not empty doctor.experienceYears}">
                                    <p>Kinh nghiệm: ${doctor.experienceYears} năm</p>
                                </c:if>
                                <c:if test="${not empty doctor.email}">
                                    <p>Email: ${doctor.email}</p>
                                </c:if>
                                <c:if test="${not empty doctor.phone}">
                                    <p>Điện thoại: ${doctor.phone}</p>
                                </c:if>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #6c757d;">Không có thông tin bác sĩ</p>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Medical Report (if available) -->
            <c:if test="${not empty medicalReport}">
                <div class="section">
                    <div class="section-title">
                        📝 Báo cáo y tế
                    </div>
                    
                    <c:if test="${not empty medicalReport.diagnosis}">
                        <div class="medical-box">
                            <h4>Chẩn đoán</h4>
                            <p>${medicalReport.diagnosis}</p>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty medicalReport.prescription}">
                        <div class="medical-box" style="background: #e3f2fd; border-left-color: #1977cc;">
                            <h4 style="color: #2c4964;">Đơn thuốc</h4>
                            <p style="color: #2c4964;">${medicalReport.prescription}</p>
                        </div>
                    </c:if>
                    
                    <c:if test="${medicalReport.testRequest}">
                        <div class="medical-box" style="background: #fff3e0; border-left-color: #ff9800;">
                            <h4 style="color: #e65100;">Đã yêu cầu xét nghiệm</h4>
                            <p style="color: #e65100;">Đã yêu cầu xét nghiệm cho lịch hẹn này.</p>
                        </div>
                    </c:if>
                </div>
            </c:if>
            
            <!-- Test Results (if available and appointment is completed) -->
            <c:if test="${appointment.status == 'Completed' && not empty testResults}">
                <div class="section">
                    <div class="section-title">
                        🧪 Kết quả xét nghiệm
                    </div>
                    <c:forEach var="testResult" items="${testResults}">
                        <div class="medical-box" style="background: #f3e5f5; border-left-color: #9c27b0; margin-bottom: 15px;">
                            <h4 style="color: #6a1b9a; margin-bottom: 10px;">
                                ${testResult.testType}
                                <c:if test="${not empty testResult.date}">
                                    <span style="font-size: 12px; font-weight: normal; color: #9c27b0;">
                                        - <fmt:formatDate value="${testResult.date}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </c:if>
                            </h4>
                            <p style="color: #4a148c; white-space: pre-wrap; line-height: 1.6;">
                                ${testResult.result}
                            </p>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            
            <!-- Show message if completed but no test results -->
            <c:if test="${appointment.status == 'Completed' && (empty testResults || testResults.size() == 0)}">
                <div class="section">
                    <div class="section-title">
                        🧪 Test Results (Kết quả xét nghiệm)
                    </div>
                    <div class="medical-box" style="background: #fff3e0; border-left-color: #ff9800;">
                        <h4 style="color: #e65100;">Không có kết quả xét nghiệm</h4>
                        <p style="color: #e65100;">Không có xét nghiệm nào được thực hiện cho lịch hẹn này.</p>
                    </div>
                </div>
            </c:if>
            
            <!-- Appointment Status Timeline -->
            <div class="section">
                <div class="section-title">
                    🔄 Lịch sử trạng thái
                </div>
                <div class="timeline">
                    <div class="timeline-item ${appointment.status == 'Pending' ? 'pending' : ''}">
                        <div class="timeline-title">Đã tạo lịch hẹn</div>
                        <div class="timeline-desc">Lịch hẹn của bạn đã được tạo và đang chờ xác nhận</div>
                    </div>
                    
                    <c:if test="${appointment.status != 'Pending' && appointment.status != 'Cancelled'}">
                        <div class="timeline-item">
                            <div class="timeline-title">Đã xác nhận bởi lễ tân</div>
                            <div class="timeline-desc">Lịch hẹn của bạn đã được xác nhận</div>
                        </div>
                    </c:if>
                    
                    <c:if test="${appointment.status == 'Waiting' || appointment.status == 'In Progress' || 
                                  appointment.status == 'Testing' || appointment.status == 'Completed'}">
                        <div class="timeline-item">
                            <div class="timeline-title">Đã check-in</div>
                            <div class="timeline-desc">Bạn đã check-in và đang chờ bác sĩ</div>
                        </div>
                    </c:if>
                    
                    <c:if test="${appointment.status == 'In Progress' || appointment.status == 'Testing' || 
                                  appointment.status == 'Completed'}">
                        <div class="timeline-item">
                            <div class="timeline-title">Đã bắt đầu khám</div>
                            <div class="timeline-desc">Bác sĩ đã bắt đầu khám</div>
                        </div>
                    </c:if>
                    
                    <c:if test="${appointment.status == 'Testing'}">
                        <div class="timeline-item pending">
                            <div class="timeline-title">Đang xét nghiệm</div>
                            <div class="timeline-desc">Đang thực hiện xét nghiệm</div>
                        </div>
                    </c:if>
                    
                    <c:if test="${appointment.status == 'Completed'}">
                        <div class="timeline-item">
                            <div class="timeline-title">Đã hoàn thành</div>
                            <div class="timeline-desc">Lịch hẹn của bạn đã được hoàn thành</div>
                        </div>
                    </c:if>
                    
                    <c:if test="${appointment.status == 'Cancelled'}">
                        <div class="timeline-item" style="border-left-color: #e74c3c;">
                            <div class="timeline-title" style="color: #e74c3c;">Đã hủy</div>
                            <div class="timeline-desc">Lịch hẹn này đã bị hủy</div>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <!-- Actions -->
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/appointments" class="btn btn-back">
                    ← Quay lại danh sách
                </a>
                
                <c:if test="${appointment.status == 'Pending' || appointment.status == 'Confirmed'}">
                    <form method="post" action="${pageContext.request.contextPath}/patient" 
                          onsubmit="return confirmCancel()" style="flex: 1;">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                        <button type="submit" class="btn btn-cancel" style="width: 100%;">
                            ❌ Hủy lịch hẹn
                        </button>
                    </form>
                </c:if>
            </div>
        </div>
    </div>
    </main>
    
    <!-- Include all JS files -->
    <jsp:include page="../../includes/footer-includes.jsp"/>
</body>
</html>