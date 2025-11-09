<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laboratory Testing Queue - Medical Assistant</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            padding: 20px;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 30px;
        }
        
        .header h1 {
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .header p {
            opacity: 0.9;
        }
        
        .content {
            padding: 30px;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            animation: slideIn 0.3s ease-out;
        }
        
        @keyframes slideIn {
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
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(17, 153, 142, 0.3);
        }
        
        .stat-card h3 {
            font-size: 42px;
            margin-bottom: 5px;
        }
        
        .stat-card p {
            opacity: 0.9;
            font-size: 14px;
        }
        
        .info-banner {
            background: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
        }
        
        .info-banner p {
            margin: 0;
            color: #2e7d32;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        thead {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        tbody tr {
            transition: all 0.3s;
        }
        
        tbody tr:hover {
            background: #e8f5e9;
            transform: scale(1.01);
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
        }
        
        .status-testing {
            background: #ffeaa7;
            color: #d63031;
            animation: blink 1.5s infinite;
        }
        
        @keyframes blink {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.5;
            }
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-success {
            background: #27ae60;
            color: white;
        }
        
        .btn-success:hover {
            background: #229954;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(39, 174, 96, 0.4);
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state .icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        
        .urgent {
            border-left: 4px solid #e74c3c;
        }
        
        .time-info {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .refresh-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            border: none;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 5px 20px rgba(17, 153, 142, 0.4);
            transition: all 0.3s;
        }
        
        .refresh-btn:hover {
            transform: rotate(180deg) scale(1.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <span>🧪</span>
                Laboratory Testing Queue
            </h1>
            <p>Medical Assistant Dashboard</p>
        </div>
        
        <div class="content">
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-${sessionScope.messageType}">
                    ${sessionScope.message}
                </div>
                <c:remove var="message" scope="session"/>
                <c:remove var="messageType" scope="session"/>
            </c:if>
            
            <div class="stats">
                <div class="stat-card">
                    <h3>${not empty appointments ? appointments.size() : 0}</h3>
                    <p>Tests Pending</p>
                </div>
            </div>
            
            <div class="info-banner">
                <p><strong>📋 Instructions:</strong> Complete the laboratory tests for patients below. 
                   After submitting results, patients will be automatically returned to the doctor's queue.</p>
            </div>
            
            <c:choose>
                <c:when test="${not empty appointments}">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Appointment ID</th>
                                <th>Patient ID</th>
                                <th>Scheduled Time</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="apt" items="${appointments}" varStatus="status">
                                <tr class="${status.index < 3 ? 'urgent' : ''}">
                                    <td><strong>${status.index + 1}</strong></td>
                                    <td>
                                        #${apt.appointmentId}
                                        <c:if test="${status.index < 3}">
                                            <span style="color: #e74c3c; font-size: 12px;">⚠️ Priority</span>
                                        </c:if>
                                    </td>
                                    <td>${apt.patientId}</td>
                                    <td>
                                        <fmt:formatDate value="${apt.dateTime}" 
                                                       pattern="dd/MM/yyyy HH:mm"/>
                                        <div class="time-info">
                                            <fmt:formatDate value="${apt.dateTime}" 
                                                           pattern="EEEE"/>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${apt.status.toLowerCase().replace(' ', '-')}">
                                            ${apt.status}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/medicalassistant/test/${apt.appointmentId}" 
                                           class="btn btn-success">
                                            🧪 Enter Results
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="icon">✅</div>
                        <h3>No Tests Pending</h3>
                        <p>All laboratory tests have been completed. Great job!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <button class="refresh-btn" onclick="location.reload()" title="Refresh">
        🔄
    </button>
</body>
</html>