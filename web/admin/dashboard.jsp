<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Tổng Quan - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <jsp:include page="../includes/head-includes.jsp"/>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
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
            overflow-y: auto;
        }

        .main-content {
            flex: 1;
            padding: 30px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 2rem;
        }

        .error-message {
            background: #e74c3c;
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--card-color), var(--card-color-light));
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .stat-card.patients {
            --card-color: #3498db;
            --card-color-light: #5dade2;
        }

        .stat-card.doctors {
            --card-color: #27ae60;
            --card-color-light: #52be80;
        }

        .stat-card.receptionists {
            --card-color: #f39c12;
            --card-color-light: #f5b041;
        }

        .stat-card.medical-assistants {
            --card-color: #9b59b6;
            --card-color-light: #bb8fce;
        }

        .stat-card.blogs {
            --card-color: #e74c3c;
            --card-color-light: #ec7063;
        }

        .stat-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            font-size: 30px;
            color: white;
            background: linear-gradient(135deg, var(--card-color), var(--card-color-light));
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
            line-height: 1;
        }

        .stat-label {
            font-size: 1rem;
            color: #7f8c8d;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Chart Section */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }

        .chart-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .chart-title {
            font-size: 1.5rem;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .chart-container {
            position: relative;
            height: 350px;
            margin-top: 20px;
        }

        /* Table Section */
        .table-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-top: 30px;
        }

        .table-title {
            font-size: 1.5rem;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stats-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .summary-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }

        .summary-card.success {
            background: linear-gradient(135deg, #27ae60 0%, #52be80 100%);
        }

        .summary-card.warning {
            background: linear-gradient(135deg, #f39c12 0%, #f5b041 100%);
        }

        .summary-card.info {
            background: linear-gradient(135deg, #3498db 0%, #5dade2 100%);
        }

        .summary-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .summary-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        tbody tr {
            transition: background-color 0.3s;
        }

        tbody tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status-badge.pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-badge.active {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.completed {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-badge.cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        @media (max-width: 768px) {
            .charts-grid {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .main-content {
                padding: 15px;
            }

            .stats-summary {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 0.9rem;
            }

            th, td {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />

    <div class="main-layout">
        <jsp:include page="../includes/sidebar-admin.jsp" />

        <div class="main-content">
            <div class="container">
                <h1><i class="fas fa-tachometer-alt"></i> Trang Tổng Quan</h1>

                <c:if test="${not empty error}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i> ${error}
                    </div>
                </c:if>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card patients">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-number">${totalPatients}</div>
                        <div class="stat-label">Bệnh Nhân</div>
                    </div>

                    <div class="stat-card doctors">
                        <div class="stat-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="stat-number">${totalDoctors}</div>
                        <div class="stat-label">Bác Sĩ</div>
                    </div>

                    <div class="stat-card receptionists">
                        <div class="stat-icon">
                            <i class="fas fa-user-tie"></i>
                        </div>
                        <div class="stat-number">${totalReceptionists}</div>
                        <div class="stat-label">Lễ Tân</div>
                    </div>

                    <div class="stat-card medical-assistants">
                        <div class="stat-icon">
                            <i class="fas fa-user-nurse"></i>
                        </div>
                        <div class="stat-number">${totalMedicalAssistants}</div>
                        <div class="stat-label">Trợ Lý Y Tế</div>
                    </div>

                    <div class="stat-card blogs">
                        <div class="stat-icon">
                            <i class="fas fa-blog"></i>
                        </div>
                        <div class="stat-number">${totalBlogs}</div>
                        <div class="stat-label">Bài Viết Blog</div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="charts-grid">
                    <!-- Pie Chart - Phân bổ nhân sự -->
                    <div class="chart-section">
                        <h2 class="chart-title">
                            <i class="fas fa-chart-pie"></i> Phân Bổ Nhân Sự
                        </h2>
                        <div class="chart-container">
                            <canvas id="staffPieChart"></canvas>
                        </div>
                    </div>

                    <!-- Bar Chart - So sánh tổng quan -->
                    <div class="chart-section">
                        <h2 class="chart-title">
                            <i class="fas fa-chart-bar"></i> Thống Kê Tổng Quan
                        </h2>
                        <div class="chart-container">
                            <canvas id="overviewBarChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Appointment Statistics Table -->
                <div class="table-section">
                    <h2 class="table-title">
                        <i class="fas fa-calendar-check"></i> Thống Kê Lịch Hẹn
                    </h2>

                    <!-- Summary Cards -->
                    <div class="stats-summary">
                        <div class="summary-card info">
                            <div class="summary-number">${totalAppointments}</div>
                            <div class="summary-label">Tổng Số Lịch Hẹn</div>
                        </div>
                        <div class="summary-card success">
                            <div class="summary-number">${activeAppointments}</div>
                            <div class="summary-label">Lịch Hẹn Đang Hoạt Động</div>
                        </div>
                        <div class="summary-card warning">
                            <div class="summary-number">${recentAppointments}</div>
                            <div class="summary-label">Lịch Hẹn 30 Ngày Gần Đây</div>
                        </div>
                    </div>

                    <!-- Status Table -->
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Trạng Thái</th>
                                    <th>Số Lượng</th>
                                    <th>Tỷ Lệ</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty appointmentsByStatus}">
                                        <c:forEach var="statusItem" items="${appointmentsByStatus}">
                                            <tr>
                                                <td>
                                                    <c:set var="statusValue" value="${statusItem.status}" />
                                                    <c:set var="statusClass" value="pending" />
                                                    <c:set var="statusText" value="Chờ Xử Lý" />
                                                    
                                                    <c:choose>
                                                        <c:when test="${statusValue == '0' || statusValue == 0}">
                                                            <c:set var="statusClass" value="pending" />
                                                            <c:set var="statusText" value="Chờ Xử Lý" />
                                                        </c:when>
                                                        <c:when test="${statusValue == '1' || statusValue == 1}">
                                                            <c:set var="statusClass" value="active" />
                                                            <c:set var="statusText" value="Đang Hoạt Động" />
                                                        </c:when>
                                                        <c:when test="${statusValue == '2' || statusValue == 2}">
                                                            <c:set var="statusClass" value="completed" />
                                                            <c:set var="statusText" value="Hoàn Thành" />
                                                        </c:when>
                                                        <c:when test="${statusValue == '3' || statusValue == 3}">
                                                            <c:set var="statusClass" value="cancelled" />
                                                            <c:set var="statusText" value="Đã Hủy" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="statusText" value="${statusValue}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                    
                                                    <span class="status-badge ${statusClass}">
                                                        ${statusText}
                                                    </span>
                                                </td>
                                                <td><strong>${statusItem.count}</strong></td>
                                                <td>
                                                    <c:if test="${totalAppointments > 0}">
                                                        <fmt:formatNumber value="${(statusItem.count / totalAppointments) * 100}" maxFractionDigits="1" />%
                                                    </c:if>
                                                    <c:if test="${totalAppointments == 0}">
                                                        0%
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="3" style="text-align: center; color: #95a5a6;">
                                                Chưa có dữ liệu lịch hẹn
                                            </td>
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

    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <script>
        // Prepare data from JSP variables
        const totalPatients = ${totalPatients != null ? totalPatients : 0};
        const totalDoctors = ${totalDoctors != null ? totalDoctors : 0};
        const totalReceptionists = ${totalReceptionists != null ? totalReceptionists : 0};
        const totalMedicalAssistants = ${totalMedicalAssistants != null ? totalMedicalAssistants : 0};
        const totalBlogs = ${totalBlogs != null ? totalBlogs : 0};

        // Pie Chart - Phân bổ nhân sự
        const pieCtx = document.getElementById('staffPieChart').getContext('2d');
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: ['Bác Sĩ', 'Lễ Tân', 'Trợ Lý Y Tế'],
                datasets: [{
                    label: 'Số lượng',
                    data: [totalDoctors, totalReceptionists, totalMedicalAssistants],
                    backgroundColor: [
                        '#27ae60',
                        '#f39c12',
                        '#9b59b6'
                    ],
                    borderColor: [
                        '#1e8449',
                        '#d68910',
                        '#7d3c98'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 15,
                            font: {
                                size: 14
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                label += context.parsed || context.raw || 0;
                                label += ' người';
                                return label;
                            }
                        }
                    }
                }
            }
        });

        // Bar Chart - So sánh tổng quan
        const barCtx = document.getElementById('overviewBarChart').getContext('2d');
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: ['Bệnh Nhân', 'Bác Sĩ', 'Lễ Tân', 'Trợ Lý Y Tế', 'Bài Blog'],
                datasets: [{
                    label: 'Số lượng',
                    data: [
                        totalPatients,
                        totalDoctors,
                        totalReceptionists,
                        totalMedicalAssistants,
                        totalBlogs
                    ],
                    backgroundColor: [
                        '#3498db',
                        '#27ae60',
                        '#f39c12',
                        '#9b59b6',
                        '#e74c3c'
                    ],
                    borderColor: [
                        '#2980b9',
                        '#1e8449',
                        '#d68910',
                        '#7d3c98',
                        '#c0392b'
                    ],
                    borderWidth: 2,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.dataset.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                // Check if it's the last item (Blog)
                                const labels = ['Bệnh Nhân', 'Bác Sĩ', 'Lễ Tân', 'Trợ Lý Y Tế', 'Bài Blog'];
                                if (context.dataIndex === labels.length - 1) {
                                    label += context.parsed.y + ' bài viết';
                                } else {
                                    label += context.parsed.y + ' người';
                                }
                                return label;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1,
                            font: {
                                size: 12
                            }
                        },
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        ticks: {
                            font: {
                                size: 12
                            }
                        },
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    </script>

    <jsp:include page="../includes/footer-includes.jsp"/>
</body>
</html>

