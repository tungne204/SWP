<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Doanh Thu - Phòng Khám Nhi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <jsp:include page="../includes/head-includes.jsp"/>
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
        }

        .main-wrapper {
            display: flex;
            min-height: 100vh;
            padding-top: 80px;
        }

        .sidebar-fixed {
            width: 280px;
            background: white;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 80px;
            left: 0;
            height: calc(100vh - 80px);
            overflow-y: auto;
            z-index: 1000;
        }

        .content-area {
            margin-left: 280px;
            flex: 1;
            padding: 20px;
            min-height: calc(100vh - 80px);
            padding-bottom: 100px;
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

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
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

        .stat-card.today {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .stat-card.month {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .stat-card.total {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
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

        .chart-wrapper {
            position: relative;
            height: 400px;
            margin-top: 20px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border-bottom: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }

        thead {
            background: #f8f9fa;
            color: #2c3e50;
        }

        tbody tr:hover {
            background: #f9f9f9;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-style: italic;
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

        @media (max-width: 992px) {
            .sidebar-fixed {
                display: none;
            }
            .content-area {
                margin-left: 0;
                padding: 15px;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .chart-wrapper {
                height: 300px;
            }
        }
    </style>
</head>

<body>
<jsp:include page="../includes/header.jsp" />

<div class="main-wrapper">
    <div class="sidebar-fixed">
        <%@ include file="../includes/sidebar-receptionist.jsp" %>
    </div>

    <div class="content-area">
        <div class="container">
            <h1><i class="fas fa-chart-line"></i> Quản Lý Doanh Thu</h1>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <!-- Thống kê tổng quan -->
            <div class="stats-grid">
                <div class="stat-card today">
                    <div class="stat-icon"><i class="fas fa-calendar-day"></i></div>
                    <div class="stat-number">
                        <fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="₫" />
                    </div>
                    <div class="stat-label">Doanh thu hôm nay</div>
                </div>

                <div class="stat-card month">
                    <div class="stat-icon"><i class="fas fa-calendar-alt"></i></div>
                    <div class="stat-number">
                        <fmt:formatNumber value="${currentMonthRevenue}" type="currency" currencySymbol="₫" />
                    </div>
                    <div class="stat-label">Doanh thu tháng này</div>
                </div>

                <div class="stat-card total">
                    <div class="stat-icon"><i class="fas fa-dollar-sign"></i></div>
                    <div class="stat-number">
                        <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" />
                    </div>
                    <div class="stat-label">Tổng doanh thu</div>
                </div>
            </div>

            <!-- Thống kê chi tiết -->
            <div class="chart-section">
                <!-- Biểu đồ doanh thu theo tháng -->
                <div class="chart-container">
                    <div class="chart-title">
                        <i class="fas fa-chart-bar"></i> Doanh thu theo tháng trong năm <fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy" />
                    </div>
                    <div class="chart-wrapper">
                        <canvas id="monthlyRevenueChart"></canvas>
                    </div>
                </div>

                <!-- Bảng doanh thu theo tháng -->
                <div class="chart-container">
                    <div class="chart-title">
                        <i class="fas fa-table"></i> Chi tiết doanh thu theo tháng
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Tháng</th>
                                <th>Doanh thu</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty monthlyRevenue}">
                                    <c:set var="maxRevenue" value="0" />
                                    <c:forEach var="i" begin="1" end="12">
                                        <c:set var="monthValue" value="${monthlyRevenue[i] != null ? monthlyRevenue[i] : 0}" />
                                        <c:if test="${monthValue > maxRevenue}">
                                            <c:set var="maxRevenue" value="${monthValue}" />
                                        </c:if>
                                    </c:forEach>
                                    
                                    <c:forEach var="i" begin="1" end="12">
                                        <c:set var="monthValue" value="${monthlyRevenue[i] != null ? monthlyRevenue[i] : 0}" />
                                        <tr>
                                            <td>Tháng ${i}</td>
                                            <td>
                                                <fmt:formatNumber value="${monthValue}" type="currency" currencySymbol="₫" />
                                            </td>
                                            <td>
                                                <c:if test="${maxRevenue > 0}">
                                                    <div class="progress-bar">
                                                        <div class="progress-fill" style="width: ${(monthValue / maxRevenue) * 100}%"></div>
                                                    </div>
                                                    <fmt:formatNumber value="${(monthValue / maxRevenue) * 100}" maxFractionDigits="1" />%
                                                </c:if>
                                                <c:if test="${maxRevenue == 0}">0%</c:if>
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

                <!-- Phân bố phương thức thanh toán -->
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
                                                    <c:when test="${payment.method == 'cash' || payment.method == 'Tiền mặt'}">
                                                        <i class="fas fa-money-bill" style="color: #27ae60;"></i> Tiền mặt
                                                    </c:when>
                                                    <c:when test="${payment.method == 'card' || payment.method == 'Thẻ'}">
                                                        <i class="fas fa-credit-card" style="color: #3498db;"></i> Thẻ
                                                    </c:when>
                                                    <c:when test="${payment.method == 'transfer' || payment.method == 'Chuyển khoản'}">
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
            </div>
        </div>
    </div>
</div>

<script>
    // Monthly Revenue Chart Data
    var monthlyRevenueArray = [];
    <c:forEach var="i" begin="1" end="12">
        <c:set var="monthValue" value="${monthlyRevenue[i] != null ? monthlyRevenue[i] : 0}" />
        monthlyRevenueArray.push(${monthValue});
    </c:forEach>
    
    const monthlyRevenueData = {
        labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 
                 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'],
        datasets: [{
            label: 'Doanh thu (₫)',
            data: monthlyRevenueArray,
            backgroundColor: 'rgba(54, 162, 235, 0.2)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 2,
            fill: true,
            tension: 0.4
        }]
    };

    const monthlyRevenueConfig = {
        type: 'line',
        data: monthlyRevenueData,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: true,
                    position: 'top',
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(context.parsed.y);
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND',
                                notation: 'compact'
                            }).format(value);
                        }
                    }
                }
            }
        }
    };

    // Initialize chart
    const monthlyRevenueChart = new Chart(
        document.getElementById('monthlyRevenueChart'),
        monthlyRevenueConfig
    );
</script>

<jsp:include page="../includes/footer.jsp"/>
<jsp:include page="../includes/footer-includes.jsp"/>
</body>
</html>

