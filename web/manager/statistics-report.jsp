<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Thống Kê - Phòng Khám Nhi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <jsp:include page="../includes/head-includes.jsp"/>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
        }

        .header {
            width: 100%;
            background: white;
            padding: 15px 25px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .main-layout {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        .sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: white;
            min-height: calc(100vh - 70px);
            position: sticky;
            top: 70px;
        }

        .main-content {
            flex: 1;
            padding: 25px;
        }

        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn-primary { background: #3498db; color: white; }
        .btn-primary:hover { background: #2980b9; }
        .btn-success { background: #27ae60; color: white; }
        .btn-success:hover { background: #229954; }
        .btn-warning { background: #f1c40f; color: black; }
        .btn-warning:hover { background: #d4ac0d; }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border-bottom: 1px solid #ddd;
            padding: 10px;
        }
        thead {
            background: #f8f9fa;
            color: #2c3e50;
        }
        tbody tr:hover { background: #f9f9f9; }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-style: italic;
        }

        /* Statistics specific styles */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .stat-card.revenue {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .stat-card.patients {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .stat-card.appointments {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }

        .stat-card.doctors {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .stat-icon {
            font-size: 3rem;
            opacity: 0.3;
            margin-bottom: 15px;
        }

        .chart-section {
            margin-top: 30px;
        }

        .chart-container {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .chart-title {
            font-size: 1.3rem;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .progress-bar {
            background: #ecf0f1;
            border-radius: 10px;
            height: 20px;
            overflow: hidden;
            margin: 5px 0;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #3498db, #2980b9);
            transition: width 0.3s ease;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { padding: 15px; }
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>

<body>
<jsp:include page="../includes/header.jsp" />

<div class="main-layout">
    <jsp:include page="../includes/sidebar-admin.jsp" />

    <div class="main-content">
        <div class="container">
            <h1><i class="fas fa-chart-bar"></i> Báo cáo thống kê</h1>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <!-- Thống kê tổng quan -->
            <div class="stats-grid">
                <div class="stat-card patients">
                    <div class="stat-icon"><i class="fas fa-users"></i></div>
                    <div class="stat-number">${totalPatients}</div>
                    <div class="stat-label">Tổng số bệnh nhân</div>
                </div>

                <div class="stat-card appointments">
                    <div class="stat-icon"><i class="fas fa-calendar-check"></i></div>
                    <div class="stat-number">${totalAppointments}</div>
                    <div class="stat-label">Tổng số cuộc hẹn</div>
                </div>

                <div class="stat-card doctors">
                    <div class="stat-icon"><i class="fas fa-user-md"></i></div>
                    <div class="stat-number">${totalDoctors}</div>
                    <div class="stat-label">Tổng số bác sĩ</div>
                </div>

                <div class="stat-card revenue">
                    <div class="stat-icon"><i class="fas fa-dollar-sign"></i></div>
                    <div class="stat-number">
                        <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" />
                    </div>
                    <div class="stat-label">Tổng doanh thu</div>
                </div>
            </div>

            <!-- Thống kê chi tiết -->
            <div class="chart-section">
                <!-- Cuộc hẹn theo trạng thái -->
                <div class="chart-container">
                    <div class="chart-title">
                        <i class="fas fa-pie-chart"></i> Thống kê cuộc hẹn theo trạng thái
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Trạng thái</th>
                                <th>Số lượng</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty appointmentsByStatus}">
                                    <c:set var="totalAppointmentCount" value="0" />
                                    <c:forEach var="status" items="${appointmentsByStatus}">
                                        <c:set var="totalAppointmentCount" value="${totalAppointmentCount + status.count}" />
                                    </c:forEach>
                                    
                                    <c:forEach var="status" items="${appointmentsByStatus}">
                                        <tr>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${status.status == 'active'}">
                                                        <i class="fas fa-check-circle" style="color: #27ae60;"></i> Hoạt động
                                                    </c:when>
                                                    <c:when test="${status.status == 'inactive'}">
                                                        <i class="fas fa-times-circle" style="color: #e74c3c;"></i> Không hoạt động
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-question-circle"></i> ${status.status}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${status.count}</td>
                                            <td>
                                                <c:if test="${totalAppointmentCount > 0}">
                                                    <fmt:formatNumber value="${(status.count / totalAppointmentCount) * 100}" maxFractionDigits="1" />%
                                                </c:if>
                                                <c:if test="${totalAppointmentCount == 0}">0%</c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="no-data">Không có dữ liệu cuộc hẹn.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Top bác sĩ -->
                <div class="chart-container">
                    <div class="chart-title">
                        <i class="fas fa-trophy"></i> Top bác sĩ theo số cuộc hẹn
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Bác sĩ</th>
                                <th>Số cuộc hẹn</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty topDoctors}">
                                    <c:set var="maxAppointments" value="${topDoctors[0].appointment_count}" />
                                    <c:forEach var="doctor" items="${topDoctors}">
                                        <tr>
                                            <td>
                                                <i class="fas fa-user-md" style="color: #3498db;"></i>
                                                ${doctor.doctor_name}
                                            </td>
                                            <td>${doctor.appointment_count}</td>
                                            <td>
                                                <div class="progress-bar">
                                                    <div class="progress-fill" style="width: ${(doctor.appointment_count / maxAppointments) * 100}%"></div>
                                                </div>
                                                <fmt:formatNumber value="${(doctor.appointment_count / maxAppointments) * 100}" maxFractionDigits="1" />%
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="no-data">Không có dữ liệu bác sĩ.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Phương thức thanh toán -->
                <div class="chart-container">
                    <div class="chart-title">
                        <i class="fas fa-credit-card"></i> Phân bố phương thức thanh toán
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Phương thức</th>
                                <th>Số lượng</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty paymentMethods}">
                                    <c:set var="totalPayments" value="0" />
                                    <c:forEach var="payment" items="${paymentMethods}">
                                        <c:set var="totalPayments" value="${totalPayments + payment.count}" />
                                    </c:forEach>
                                    
                                    <c:forEach var="payment" items="${paymentMethods}">
                                        <tr>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.method == 'cash'}">
                                                        <i class="fas fa-money-bill" style="color: #27ae60;"></i> Tiền mặt
                                                    </c:when>
                                                    <c:when test="${payment.method == 'card'}">
                                                        <i class="fas fa-credit-card" style="color: #3498db;"></i> Thẻ
                                                    </c:when>
                                                    <c:when test="${payment.method == 'transfer'}">
                                                        <i class="fas fa-exchange-alt" style="color: #9b59b6;"></i> Chuyển khoản
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-question-circle"></i> ${payment.method}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${payment.count}</td>
                                            <td>
                                                <c:if test="${totalPayments > 0}">
                                                    <fmt:formatNumber value="${(payment.count / totalPayments) * 100}" maxFractionDigits="1" />%
                                                </c:if>
                                                <c:if test="${totalPayments == 0}">0%</c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="no-data">Không có dữ liệu thanh toán.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Doanh thu theo tháng -->
                <div class="chart-container">
                    <div class="chart-title">
                        <i class="fas fa-chart-line"></i> Doanh thu theo tháng
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Tháng</th>
                                <th>Doanh thu</th>
                                <th>Biểu đồ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty monthlyRevenue}">
                                    <c:set var="maxRevenue" value="0" />
                                    <c:forEach var="i" begin="1" end="12">
                                        <c:if test="${monthlyRevenue[i] > maxRevenue}">
                                            <c:set var="maxRevenue" value="${monthlyRevenue[i]}" />
                                        </c:if>
                                    </c:forEach>
                                    
                                    <c:forEach var="i" begin="1" end="12">
                                        <tr>
                                            <td>Tháng ${i}</td>
                                            <td>
                                                <fmt:formatNumber value="${monthlyRevenue[i]}" type="currency" currencySymbol="₫" />
                                            </td>
                                            <td>
                                                <c:if test="${maxRevenue > 0}">
                                                    <div class="progress-bar">
                                                        <div class="progress-fill" style="width: ${(monthlyRevenue[i] / maxRevenue) * 100}%"></div>
                                                    </div>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="no-data">Không có dữ liệu doanh thu.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>