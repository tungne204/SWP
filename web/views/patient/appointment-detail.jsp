<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Details</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            min-height: 100vh;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
        }
        
        .back-link {
            display: inline-block;
            color: white;
            text-decoration: none;
            margin-bottom: 20px;
            opacity: 0.9;
            transition: opacity 0.3s;
        }
        
        .back-link:hover {
            opacity: 1;
        }
        
        .header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #d1ecf1; color: #0c5460; }
        .status-waiting { background: #ffeaa7; color: #d63031; }
        .status-in-progress { background: #d4edda; color: #155724; }
        .status-testing { background: #cce5ff; color: #004085; }
        .status-completed { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        
        .content {
            padding: 40px;
        }
        
        .section {
            margin-bottom: 30px;
            padding-bottom: 30px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .section:last-child {
            border-bottom: none;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid #667eea;
        }
        
        .info-label {
            font-size: 13px;
            color: #6c757d;
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .info-value {
            font-size: 16px;
            color: #2c3e50;
            font-weight: 500;
        }
        
        .doctor-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .doctor-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid white;
        }
        
        .doctor-info h3 {
            font-size: 22px;
            margin-bottom: 8px;
        }
        
        .doctor-info p {
            opacity: 0.9;
            font-size: 14px;
        }
        
        .medical-box {
            background: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 20px;
            border-radius: 10px;
            margin-top: 15px;
        }
        
        .medical-box h4 {
            color: #2e7d32;
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        .medical-box p {
            color: #1b5e20;
            white-space: pre-wrap;
            line-height: 1.6;
        }
        
        .timeline {
            position: relative;
            padding-left: 40px;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e0e0e0;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 20px;
            padding-left: 30px;
        }
        
        .timeline-item::before {
            content: '✓';
            position: absolute;
            left: -26px;
            top: 0;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #667eea;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        
        .timeline-item.pending::before {
            content: '⏳';
            background: #ffc107;
        }
        
        .timeline-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .timeline-desc {
            font-size: 14px;
            color: #6c757d;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
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
        
        .btn-back {
            background: #95a5a6;
            color: white;
        }
        
        .btn-back:hover {
            background: #7f8c8d;
        }
        
        .btn-cancel {
            background: #e74c3c;
            color: white;
        }
        
        .btn-cancel:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
        }
    </style>
    <script>
        function confirmCancel() {
            return confirm('Are you sure you want to cancel this appointment? This action cannot be undone.');
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="${pageContext.request.contextPath}/patient" class="back-link">
                ← Back to My Appointments
            </a>
            <h1>📋 Appointment Details</h1>
            <span class="status-badge status-${appointment.status.toLowerCase().replace(' ', '-')}">
                ${appointment.status}
            </span>
        </div>
        
        <div class="content">
            <!-- Appointment Information -->
            <div class="section">
                <div class="section-title">
                    📅 Appointment Information
                </div>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Appointment ID</div>
                        <div class="info-value">#${appointment.appointmentId}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Date & Time</div>
                        <div class="info-value">
                            <fmt:formatDate value="${appointment.dateTime}" 
                                           pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Day of Week</div>
                        <div class="info-value">
                            <fmt:formatDate value="${appointment.dateTime}" 
                                           pattern="EEEE"/>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Status</div>
                        <div class="info-value">${appointment.status}</div>
                    </div>
                </div>
            </div>
            
            <!-- Doctor Information -->
            <div class="section">
                <div class="section-title">
                    👨‍⚕️ Doctor Information
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
                                    <p>Experience: ${doctor.experienceYears} years</p>
                                </c:if>
                                <c:if test="${not empty doctor.email}">
                                    <p>Email: ${doctor.email}</p>
                                </c:if>
                                <c:if test="${not empty doctor.phone}">
                                    <p>Phone: ${doctor.phone}</p>
                                </c:if>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #6c757d;">Doctor information not available</p>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Medical Report (if available) -->
            <c:if test="${not empty medicalReport}">
                <div class="section">
                    <div class="section-title">
                        📝 Medical Report
                    </div>
                    
                    <c:if test="${not empty medicalReport.diagnosis}">
                        <div class="medical-box">
                            <h4>Diagnosis (Chẩn đoán)</h4>
                            <p>${medicalReport.diagnosis}</p>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty medicalReport.prescription}">
                        <div class="medical-box" style="background: #e3f2fd; border-left-color: #2196f3;">
                            <h4 style="color: #1565c0;">Prescription (Đơn thuốc)</h4>
                            <p style="color: #0d47a1;">${medicalReport.prescription}</p>
                        </div>
                    </c:if>
                    
                    <c:if test="${medicalReport.testRequest}">
                        <div class="medical-box" style="background: #fff3e0; border-left-color: #ff9800;">
                            <h4 style="color: #e65100;">Test Requested</h4>
                            <p style="color: #e65100;">Laboratory tests have been requested for this appointment.</p>
                        </div>
                    </c:if>
                </div>
            </c:if>
            
            <!-- Appointment Status Timeline -->
            <div class="section">
                <div class="section-title">
                    🔄 Status Timeline
                </div>
                <div class="timeline">
                    <div class="timeline-item ${appointment.status == 'Pending' ? 'pending' : ''}">
                        <div class="timeline-title">Appointment Created</div>
                        <div class="timeline-desc">Your appointment has been created and is waiting for confirmation</div>
                    </div>
                    
                    <c:if test="${appointment.status != 'Pending' && appointment.status != 'Cancelled'}">
                        <div class="timeline-item">
                            <div class="timeline-title">Confirmed by Receptionist</div>
                            <div class="timeline-desc">Your appointment has been confirmed</div>
                        </div>
                    </c:if>
                    
                    <c:if test="${appointment.status == 'Waiting' || appointment.status == 'In Progress' || 
                                  appointment.status == 'Testing' || appointment.status == 'Completed'}">
                        <div class="timeline-item">
                            <div class="timeline-title">Checked In</div>
                            <div class="timeline-desc">You have been checked in and are waiting for the doctor</div>
                        </div>
                    </c:if>
                    
                    <c:if test="${appointment.status == 'In Progress' || appointment.status == 'Testing' || 
                                  appointment.status == 'Completed'}">
                        <div class="timeline-item">
                            <div class="timeline-title">Examination Started</div>
                            <div class="timeline-desc">Doctor has started the examination</div>
                        </div>
                    </c:if>
                    
                    <c:if test="${appointment.status == 'Testing'}">
                        <div class="timeline-item pending">
                            <div class="timeline-title">Laboratory Testing</div>
                            <div class="timeline-desc">Tests are being conducted</div>
                        </div>
                    </c:if>
                    
                    <c:if test="${appointment.status == 'Completed'}">
                        <div class="timeline-item">
                            <div class="timeline-title">Completed</div>
                            <div class="timeline-desc">Your appointment has been completed</div>
                        </div>
                    </c:if>
                    
                    <c:if test="${appointment.status == 'Cancelled'}">
                        <div class="timeline-item" style="border-left-color: #e74c3c;">
                            <div class="timeline-title" style="color: #e74c3c;">Cancelled</div>
                            <div class="timeline-desc">This appointment has been cancelled</div>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <!-- Actions -->
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/patient" class="btn btn-back">
                    ← Back to List
                </a>
                
                <c:if test="${appointment.status == 'Pending' || appointment.status == 'Confirmed'}">
                    <form method="post" action="${pageContext.request.contextPath}/patient" 
                          onsubmit="return confirmCancel()" style="flex: 1;">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                        <button type="submit" class="btn btn-cancel" style="width: 100%;">
                            ❌ Cancel Appointment
                        </button>
                    </form>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>