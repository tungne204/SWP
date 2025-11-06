<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; background:#f5f5f5; padding:20px; }
        .container { max-width:1200px; margin:0 auto; background:#fff; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,.1); padding:30px; }
        h1 { color:#2c3e50; margin-bottom:30px; border-bottom:3px solid #3498db; padding-bottom:15px; }
        .nav-tabs { display:flex; gap:10px; margin-bottom:24px; }
        .nav-tabs a { padding:12px 20px; border-radius:6px; text-decoration:none; background:#ecf0f1; color:#2c3e50; transition:.2s; }
        .nav-tabs a:hover, .nav-tabs a.active { background:#3498db; color:#fff; }
        .alert { padding:14px; border-radius:6px; margin-bottom:16px; }
        .alert-success { background:#d4edda; color:#155724; border-left:4px solid #28a745; }
        .alert-error { background:#f8d7da; color:#721c24; border-left:4px solid #dc3545; }
        table { width:100%; border-collapse:collapse; }
        thead { background:#3498db; color:#fff; }
        th, td { padding:14px; text-align:left; border-bottom:1px solid #e9ecef; }
        tbody tr:hover { background:#f8f9fa; }
        .status-badge { display:inline-block; padding:6px 12px; border-radius:16px; font-size:12px; font-weight:600; }
        .status-pending { background:#fff3cd; color:#856404; }
        .status-confirmed { background:#d1ecf1; color:#0c5460; }
        .status-waiting { background:#e2e3e5; color:#383d41; }
        .btn { padding:8px 14px; border:none; border-radius:6px; cursor:pointer; font-size:14px; transition:.2s; }
        .btn-primary { background:#3498db; color:#fff; }
        .btn-primary:hover { background:#2980b9; }
        .btn-success { background:#28a745; color:#fff; }
        .btn-success:hover { background:#218838; }
        .actions { display:flex; gap:8px; }
        .empty-state { text-align:center; padding:60px 20px; color:#6c757d; }
        .empty-state .icon { font-size:64px; margin-bottom:16px; opacity:.35; }
    </style>
</head>
<body>
<div class="container">
    <h1>${pageTitle}</h1>

    <!-- Tabs -->
    <div class="nav-tabs">
        <a href="${pageContext.request.contextPath}/receptionist"
           class="">Pending Appointments</a>
        <a href="${pageContext.request.contextPath}/receptionist/confirmed"
           class="active">Confirmed Appointments</a>
    </div>

    <!-- Session message -->
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
                    <th>Date &amp; Time</th>
                    <th>Status</th>
                    <th style="width:220px;">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="apt" items="${appointments}">
                    <tr>
                        <td>#${apt.appointmentId}</td>
                        <td>${apt.patientId}</td>
                        <td>${apt.doctorId}</td>
                        <td>
                            <fmt:formatDate value="${apt.dateTime}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                        <td>
                            <span class="status-badge status-${fn:toLowerCase(apt.status)}">
                                ${apt.status}
                            </span>
                        </td>
                        <td>
                            <div class="actions">
                                <!-- Only show Check In when actually Confirmed -->
                                <c:if test="${apt.status == 'Confirmed'}">
                                    <form method="post" action="${pageContext.request.contextPath}/receptionist">
                                        <input type="hidden" name="action" value="checkin"/>
                                        <input type="hidden" name="appointmentId" value="${apt.appointmentId}"/>
                                        <button type="submit" class="btn btn-success">Check In</button>
                                    </form>
                                </c:if>

                                <!-- Optional: back-to-pending (if bạn muốn) -->
                                <!--
                                <form method="post" action="${pageContext.request.contextPath}/receptionist">
                                    <input type="hidden" name="action" value="toPending"/>
                                    <input type="hidden" name="appointmentId" value="${apt.appointmentId}"/>
                                    <button type="submit" class="btn btn-primary">Mark Pending</button>
                                </form>
                                -->
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="icon">📋</div>
                <h3>No appointments found</h3>
                <p>There are no confirmed appointments right now.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
