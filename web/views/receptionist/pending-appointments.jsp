<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        h1 {
            color: #2c3e50;
            margin-bottom: 30px;
            border-bottom: 3px solid #3498db;
            padding-bottom: 15px;
        }
        
        .nav-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
        }
        
        .nav-tabs a {
            padding: 12px 24px;
            text-decoration: none;
            background: #ecf0f1;
            color: #2c3e50;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .nav-tabs a:hover, .nav-tabs a.active {
            background: #3498db;
            color: white;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
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
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        thead {
            background: #3498db;
            color: white;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        tbody tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-confirmed {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${pageTitle}</h1>
        
        <div class="nav-tabs">
            <a href="${pageContext.request.contextPath}/receptionist" 
               class="${pageTitle.contains('Pending') ? 'active' : ''}">
                Pending Appointments
            </a>
            <a href="${pageContext.request.contextPath}/receptionist/confirmed" 
               class="${pageTitle.contains('Confirmed') ? 'active' : ''}">
                Confirmed Appointments
            </a>
        </div>
        
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-${sessionScope.messageType}">
                ${sessionScope.message}
            </div>
            <c:remove var="message" scope="session"/>
            <c:remove var="messageType" scope="session"/>
        </c:if>
        
        <c:choose>
            <c:when test="${not empty appointments}">
                <table>
                    <thead>
                        <tr>
                            <th>Appointment ID</th>
                            <th>Patient ID</th>
                            <th>Doctor ID</th>
                            <th>Date & Time</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="apt" items="${appointments}">
                            <tr>
                                <td>#${apt.appointmentId}</td>
                                <td>${apt.patientId}</td>
                                <td>${apt.doctorId}</td>
                                <td>
                                    <fmt:formatDate value="${apt.dateTime}" 
                                                   pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <span class="status-badge status-${apt.status.toLowerCase()}">
                                        ${apt.status}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${apt.status == 'Pending'}">
                                            <form method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="confirm">
                                                <input type="hidden" name="appointmentId" 
                                                       value="${apt.appointmentId}">
                                                <button type="submit" class="btn btn-primary">
                                                    Confirm
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:when test="${apt.status == 'Confirmed'}">
                                            <form method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="checkin">
                                                <input type="hidden" name="appointmentId" 
                                                       value="${apt.appointmentId}">
                                                <button type="submit" class="btn btn-success">
                                                    Check In
                                                </button>
                                            </form>
                                        </c:when>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div style="font-size: 64px; margin-bottom: 20px;">📋</div>
                    <h3>No appointments found</h3>
                    <p>There are no appointments in this status.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>c