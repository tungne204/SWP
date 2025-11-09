<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments</title>
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
            max-width: 1200px;
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-left h1 {
            font-size: 32px;
            margin-bottom: 10px;
        }
        
        .header-left p {
            opacity: 0.9;
        }
        
        .btn-create {
            padding: 14px 28px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-block;
        }
        
        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(255, 255, 255, 0.3);
        }
        
        .content {
            padding: 40px;
        }
        
        .alert {
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 10px;
            animation: slideDown 0.3s ease-out;
        }
        
        @keyframes slideDown {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        
        .stat-card h3 {
            font-size: 36px;
            margin-bottom: 5px;
        }
        
        .stat-card p {
            opacity: 0.9;
            font-size: 14px;
        }
        
        .appointment-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            transition: all 0.3s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .appointment-card:hover {
            border-color: #667eea;
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.2);
            transform: translateY(-3px);
        }
        
        .appointment-main {
            flex: 1;
        }
        
        .appointment-id {
            font-size: 14px;
            color: #6c757d;
            margin-bottom: 10px;
        }
        
        .appointment-date {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .appointment-doctor {
            font-size: 15px;
            color: #555;
            margin-bottom: 5px;
        }
        
        .appointment-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
            align-items: flex-end;
        }
        
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 10px;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-confirmed {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-waiting {
            background: #ffeaa7;
            color: #d63031;
        }
        
        .status-in-progress {
            background: #d4edda;
            color: #155724;
        }
        
        .status-testing {
            background: #cce5ff;
            color: #004085;
        }
        
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-view {
            background: #667eea;
            color: white;
        }
        
        .btn-view:hover {
            background: #5568d3;
            transform: translateY(-2px);
        }
        
        .btn-cancel {
            background: #e74c3c;
            color: white;
        }
        
        .btn-cancel:hover {
            background: #c0392b;
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #6c757d;
        }
        
        .empty-state .icon {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        
        .empty-state h3 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #2c3e50;
        }
        
        .empty-state p {
            margin-bottom: 30px;
        }
        
        .empty-state .btn-create {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }
            
            .appointment-card {
                flex-direction: column;
                gap: 15px;
            }
            
            .appointment-actions {
                width: 100%;
                flex-direction: row;
                justify-content: space-between;
            }
        }
    </style>
    <script>
        function confirmCancel(appointmentId) {
            if (confirm('Are you sure you want to cancel this appointment?')) {
                document.getElementById('cancelForm' + appointmentId).submit();
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-left">
                <h1>📅 My Appointments</h1>
                <p>Manage your healthcare appointments</p>
            </div>
            <a href="${pageContext.request.contextPath}/patient/create" class="btn-create">
                ➕ New Appointment
            </a>
        </div>
        
        <div class="content">
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-${sessionScope.messageType}">
                    ${sessionScope.message}
                </div>
                <c:remove var="message" scope="session"/>
                <c:remove var="messageType" scope="session"/>
            </c:if>
            
            <c:if test="${not empty appointments}">
                <div class="stats">
                    <div class="stat-card">
                        <h3>${appointments.size()}</h3>
                        <p>Total Appointments</p>
                    </div>
                    <div class="stat-card">
                        <h3>
                            <c:set var="pendingCount" value="0"/>
                            <c:forEach var="apt" items="${appointments}">
                                <c:if test="${apt.status == 'Pending'}">
                                    <c:set var="pendingCount" value="${pendingCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${pendingCount}
                        </h3>
                        <p>Pending</p>
                    </div>
                    <div class="stat-card">
                        <h3>
                            <c:set var="completedCount" value="0"/>
                            <c:forEach var="apt" items="${appointments}">
                                <c:if test="${apt.status == 'Completed'}">
                                    <c:set var="completedCount" value="${completedCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${completedCount}
                        </h3>
                        <p>Completed</p>
                    </div>
                </div>
            </c:if>
            
            <c:choose>
                <c:when test="${not empty appointments}">
                    <c:forEach var="apt" items="${appointments}">
                        <div class="appointment-card">
                            <div class="appointment-main">
                                <div class="appointment-id">
                                    Appointment #${apt.appointmentId}
                                </div>
                                <div class="appointment-date">
                                    📅 <fmt:formatDate value="${apt.dateTime}" 
                                                      pattern="EEEE, dd MMMM yyyy"/>
                                    at <fmt:formatDate value="${apt.dateTime}" pattern="HH:mm"/>
                                </div>
                                <div class="appointment-doctor">
                                    👨‍⚕️ Doctor ID: ${apt.doctorId}
                                </div>
                            </div>
                            
                            <div class="appointment-actions">
                                <span class="status-badge status-${apt.status.toLowerCase().replace(' ', '-')}">
                                    ${apt.status}
                                </span>
                                
                                <div style="display: flex; gap: 10px;">
                                    <a href="${pageContext.request.contextPath}/patient/detail/${apt.appointmentId}" 
                                       class="btn btn-view">
                                        👁️ View Details
                                    </a>
                                    
                                    <c:if test="${apt.status == 'Pending' || apt.status == 'Confirmed'}">
                                        <form id="cancelForm${apt.appointmentId}" method="post" 
                                              action="${pageContext.request.contextPath}/patient" 
                                              style="display: inline;">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="appointmentId" 
                                                   value="${apt.appointmentId}">
                                            <button type="button" class="btn btn-cancel" 
                                                    onclick="confirmCancel(${apt.appointmentId})">
                                                ❌ Cancel
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="icon">📋</div>
                        <h3>No Appointments Yet</h3>
                        <p>You haven't created any appointments. Start by booking your first appointment!</p>
                        <a href="${pageContext.request.contextPath}/patient/create" class="btn-create">
                            ➕ Create Your First Appointment
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>