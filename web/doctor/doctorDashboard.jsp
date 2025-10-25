<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Medilab Pediatric Clinic</title>
    
    <style>
        :root {
            --primary-color: #3fbbc0;
            --primary-dark: #2a9fa4;
            --secondary-color: #2c4964;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            --light-bg: #f8f9fa;
        }
        
        body {
            background: linear-gradient(135deg, #e8f5f6 0%, #d4eef0 100%);
            min-height: 100vh;
            padding-bottom: 2rem;
            font-family: 'Roboto', sans-serif;
        }
        
        /* Dashboard Header */
        .dashboard-header {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin: 2rem 0;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(63, 187, 192, 0.1);
        }
        
        .dashboard-header h2 {
            color: var(--secondary-color);
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .dashboard-header h2 i {
            color: var(--primary-color);
        }
        
        .time-display {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary-color);
        }
        
        .btn-logout {
            background: linear-gradient(135deg, var(--danger-color), #c82333);
            color: white;
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
            color: white;
        }
        
        /* Statistics Cards */
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.8rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.12);
            transition: all 0.3s ease;
            border: none;
            height: 100%;
        }
        
        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
        }
        
        .stat-card .icon {
            width: 65px;
            height: 65px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            color: white;
        }
        
        .stat-card.blue .icon { 
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)); 
        }
        .stat-card.green .icon { 
            background: linear-gradient(135deg, #28a745, #218838); 
        }
        .stat-card.orange .icon { 
            background: linear-gradient(135deg, #fd7e14, #e0690c); 
        }
        .stat-card.purple .icon { 
            background: linear-gradient(135deg, #6f42c1, #5a32a3); 
        }
        
        .stat-card h6 {
            color: #6c757d;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.8rem;
        }
        
        .stat-card h2 {
            color: var(--secondary-color);
            font-weight: 700;
            font-size: 2.2rem;
            margin: 0;
        }
        
        /* Section Headers */
        .section-header {
            color: var(--secondary-color);
            font-weight: 600;
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        /* Quick Links */
        .quick-link {
            background: white;
            border-radius: 15px;
            padding: 2rem 1.5rem;
            text-align: center;
            text-decoration: none;
            color: inherit;
            display: block;
            transition: all 0.3s ease;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.12);
            height: 100%;
            border: 2px solid transparent;
        }
        
        .quick-link:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
            border-color: var(--primary-color);
            color: inherit;
        }
        
        .quick-link .icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        
        .quick-link:hover .icon {
            transform: scale(1.1);
        }
        
        .quick-link h5 {
            color: var(--secondary-color);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .quick-link p {
            color: #6c757d;
            font-size: 0.9rem;
            margin: 0;
        }
        
        /* Recent Activity */
        .recent-activity {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.12);
            height: 100%;
        }
        
        .recent-activity h5 {
            color: var(--secondary-color);
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .activity-item {
            padding: 1.2rem;
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.3s ease;
            border-radius: 10px;
            margin-bottom: 0.5rem;
        }
        
        .activity-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .activity-item:hover {
            background-color: rgba(63, 187, 192, 0.05);
        }
        
        .activity-item h6 {
            color: var(--secondary-color);
            font-weight: 600;
            margin-bottom: 0.3rem;
        }
        
        .activity-item p {
            color: #6c757d;
            margin: 0;
        }
        
        .activity-item small {
            color: #adb5bd;
            font-size: 0.85rem;
        }
        
        /* Calendar Widget */
        .calendar-widget {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.12);
            margin-bottom: 1.5rem;
        }
        
        .calendar-widget h5 {
            color: var(--secondary-color);
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .calendar-widget .alert {
            border: none;
            border-radius: 10px;
            padding: 1rem;
            background-color: #f8f9fa;
        }
        
        .calendar-widget .alert strong {
            font-size: 1.2rem;
        }
        
        .btn-view-schedule {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-view-schedule:hover {
            background: linear-gradient(135deg, var(--primary-dark), #1e7c81);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(63, 187, 192, 0.3);
            color: white;
        }
        
        /* Stats Widget */
        .stats-widget {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.12);
        }
        
        .stats-widget h5 {
            color: var(--secondary-color);
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .stats-item {
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .stats-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        
        .stats-item h4 {
            font-weight: 700;
            margin: 0;
        }
        
        .btn-view-all {
            background: white;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
            padding: 0.6rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-view-all:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(63, 187, 192, 0.3);
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <%@ include file="../includes/header.jsp" %>
    
    <!-- Include Sidebar -->
    <%@ include file="../includes/sidebar-doctor.jsp" %>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <!-- Welcome Header -->
            <div class="dashboard-header">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <h2>
                            <i class="fas fa-user-md"></i> 
                            Chào mừng, BS. ${sessionScope.username != null ? sessionScope.username : 'Doctor'}
                        </h2>
                        <p class="text-muted mb-0">
                            <i class="far fa-calendar me-2"></i> 
                            <jsp:useBean id="now" class="java.util.Date"/>
                            <fmt:formatDate value="${now}" pattern="EEEE, dd MMMM yyyy" />
                            <span class="ms-4 time-display">
                                <i class="far fa-clock me-2"></i>
                                <span id="currentTime"></span>
                            </span>
                        </p>
                    </div>
                </div>
            </div>

        <!-- Statistics Cards -->
        <div class="row g-4 mb-4">
            <div class="col-lg-3 col-md-6">
                <div class="stat-card blue">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6>Lịch hẹn hôm nay</h6>
                            <h2>${todayAppointments != null ? todayAppointments : 0}</h2>
                        </div>
                        <div class="icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-card green">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6>Bệnh nhân chờ</h6>
                            <h2>${pendingPatients != null ? pendingPatients : 0}</h2>
                        </div>
                        <div class="icon">
                            <i class="fas fa-user-clock"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-card orange">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6>Đơn thuốc tuần này</h6>
                            <h2>${weeklyReports != null ? weeklyReports : 0}</h2>
                        </div>
                        <div class="icon">
                            <i class="fas fa-prescription"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-card purple">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6>Xét nghiệm chờ</h6>
                            <h2>${pendingTests != null ? pendingTests : 0}</h2>
                        </div>
                        <div class="icon">
                            <i class="fas fa-vials"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Links -->
        <h4 class="section-header">
            <i class="fas fa-link"></i> Truy cập nhanh
        </h4>
        <div class="row g-4 mb-4">
            <div class="col-xl-2 col-lg-4 col-md-6">
                <a href="appointment?action=list" class="quick-link">
                    <div class="icon text-primary">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <h5>Lịch hẹn</h5>
                    <p>Xem và quản lý lịch khám</p>
                </a>
            </div>
            <div class="col-xl-2 col-lg-4 col-md-6">
                <a href="medical-report?action=list" class="quick-link">
                    <div class="icon text-success">
                        <i class="fas fa-prescription-bottle-medical"></i>
                    </div>
                    <h5>Đơn thuốc</h5>
                    <p>Quản lý đơn thuốc</p>
                </a>
            </div>
            <div class="col-xl-2 col-lg-4 col-md-6">
                <a href="test-result?action=list" class="quick-link">
                    <div class="icon text-info">
                        <i class="fas fa-flask"></i>
                    </div>
                    <h5>Xét nghiệm</h5>
                    <p>Xem kết quả xét nghiệm</p>
                </a>
            </div>
            <div class="col-xl-2 col-lg-4 col-md-6">
                <a href="appointment?action=pending" class="quick-link">
                    <div class="icon text-warning">
                        <i class="fas fa-user-injured"></i>
                    </div>
                    <h5>Bệnh nhân chờ</h5>
                    <p>Danh sách chờ khám</p>
                </a>
            </div>
            <div class="col-xl-2 col-lg-4 col-md-6">
                <a href="patient-queue" class="quick-link">
                    <div class="icon text-purple">
                        <i class="fas fa-users"></i>
                    </div>
                    <h5>Hàng đợi</h5>
                    <p>Theo dõi hàng đợi bệnh nhân</p>
                </a>
            </div>
        </div>

        <div class="row g-4">
            <!-- Recent Activities -->
            <div class="col-lg-8">
                <div class="recent-activity">
                    <h5>
                        <i class="fas fa-history text-primary"></i> 
                        Hoạt động gần đây
                    </h5>
                    
                    <c:choose>
                        <c:when test="${not empty recentActivities}">
                            <c:forEach var="activity" items="${recentActivities}">
                                <div class="activity-item">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="d-flex gap-3">
                                            <div>
                                                <c:choose>
                                                    <c:when test="${activity.type == 'appointment'}">
                                                        <i class="fas fa-calendar-check text-primary fa-2x"></i>
                                                    </c:when>
                                                    <c:when test="${activity.type == 'prescription'}">
                                                        <i class="fas fa-prescription text-success fa-2x"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-flask text-info fa-2x"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <h6>${activity.title}</h6>
                                                <p>${activity.description}</p>
                                            </div>
                                        </div>
                                        <small>${activity.time}</small>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="activity-item">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="d-flex gap-3">
                                        <div>
                                            <i class="fas fa-calendar-check text-primary fa-2x"></i>
                                        </div>
                                        <div>
                                            <h6>Lịch hẹn mới</h6>
                                            <p>Bé Lê Minh - Khám tổng quát</p>
                                        </div>
                                    </div>
                                    <small>10 phút trước</small>
                                </div>
                            </div>
                            <div class="activity-item">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="d-flex gap-3">
                                        <div>
                                            <i class="fas fa-prescription text-success fa-2x"></i>
                                        </div>
                                        <div>
                                            <h6>Đơn thuốc đã kê</h6>
                                            <p>Bé Lê Thu Hà - Viêm họng cấp</p>
                                        </div>
                                    </div>
                                    <small>1 giờ trước</small>
                                </div>
                            </div>
                            <div class="activity-item">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="d-flex gap-3">
                                        <div>
                                            <i class="fas fa-flask text-info fa-2x"></i>
                                        </div>
                                        <div>
                                            <h6>Kết quả xét nghiệm</h6>
                                            <p>Xét nghiệm máu - Kết quả bình thường</p>
                                        </div>
                                    </div>
                                    <small>2 giờ trước</small>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="text-center mt-4">
                        <a href="appointment?action=list" class="btn btn-view-all">
                            <i class="fas fa-history me-2"></i>Xem tất cả hoạt động
                        </a>
                    </div>
                </div>
            </div>

            <!-- Calendar & Quick Info -->
            <div class="col-lg-4">
                <!-- Today's Schedule -->
                <div class="calendar-widget">
                    <h5>
                        <i class="fas fa-calendar-day text-primary"></i> 
                        Lịch hôm nay
                    </h5>
                    <div class="alert mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-calendar-check text-success me-2"></i>Tổng lịch</span>
                            <strong class="text-primary">${todayAppointments != null ? todayAppointments : 0}</strong>
                        </div>
                    </div>
                    <div class="alert mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-user-clock text-warning me-2"></i>Chờ khám</span>
                            <strong class="text-warning">${pendingPatients != null ? pendingPatients : 0}</strong>
                        </div>
                    </div>
                    <div class="alert mb-4">
                        <div class="d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-check-circle text-success me-2"></i>Đã khám</span>
                            <strong class="text-success">${completedToday != null ? completedToday : 0}</strong>
                        </div>
                    </div>
                    <a href="appointment?action=by-date&date=<fmt:formatDate value='${now}' pattern='yyyy-MM-dd' />" 
                       class="btn btn-view-schedule w-100">
                        <i class="fas fa-eye me-2"></i>Xem lịch chi tiết
                    </a>
                </div>

                <!-- Quick Stats -->
                <div class="stats-widget">
                    <h5>
                        <i class="fas fa-chart-line text-success"></i> 
                        Thống kê nhanh
                    </h5>
                    <div class="stats-item">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted">Tổng bệnh nhân tháng này</span>
                            <h4 class="text-primary">${monthlyPatients != null ? monthlyPatients : 0}</h4>
                        </div>
                    </div>
                    <div class="stats-item">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted">Đơn thuốc đã kê</span>
                            <h4 class="text-success">${monthlyReports != null ? monthlyReports : 0}</h4>
                        </div>
                    </div>
                    <div class="stats-item">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted">Xét nghiệm thực hiện</span>
                            <h4 class="text-info">${monthlyTests != null ? monthlyTests : 0}</h4>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </div> <!-- End container-fluid -->
    </div> <!-- End main-content -->

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Update time every second
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('vi-VN', { 
                hour: '2-digit', 
                minute: '2-digit',
                second: '2-digit'
            });
            document.getElementById('currentTime').textContent = timeString;
        }
        
        updateTime();
        setInterval(updateTime, 1000);
    </script>
</body>
</html>