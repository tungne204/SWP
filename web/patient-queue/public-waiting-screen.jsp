<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%
    // Get current date for filtering
    Date currentDate = new Date();
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String todayStr = dateFormat.format(currentDate);

    // Calculate start of today for comparison
    Calendar cal = Calendar.getInstance();
    cal.setTime(currentDate);
    cal.set(Calendar.HOUR_OF_DAY, 0);
    cal.set(Calendar.MINUTE, 0);
    cal.set(Calendar.SECOND, 0);
    cal.set(Calendar.MILLISECOND, 0);
    Date startOfToday = cal.getTime();

    request.setAttribute("startOfToday", startOfToday);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hàng Đợi Bệnh Nhân - Medilab</title>

    <!-- Favicons -->
    <link href="<c:url value='/assets/img/favicon.png'/>" rel="icon">
    <link href="<c:url value='/assets/img/apple-touch-icon.png'/>" rel="apple-touch-icon">

    <!-- Vendor CSS Files -->
    <link href="<c:url value='/assets/vendor/aos/aos.css'/>" rel="stylesheet">
    <link href="<c:url value='/assets/vendor/fontawesome-free/css/all.min.css'/>" rel="stylesheet">

    <!-- Main CSS File -->
    <link href="<c:url value='/assets/css/main.css'/>" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #0f172a;
            font-family: 'Poppins', 'Roboto', sans-serif;
            min-height: 100vh;
        }
        .main { padding: 40px 0; }
        .queue-container { max-width: 1400px; margin: 0 auto; padding: 0 20px; }
        .queue-header {
            text-align: center;
            margin-bottom: 40px;
            background: rgba(255,255,255,0.95);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .queue-header h1 {
            font-size: 36px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 10px;
        }
        .queue-header .subtitle {
            font-size: 16px;
            color: #64748b;
            margin-bottom: 20px;
        }
        .current-time {
            font-size: 18px;
            font-weight: 600;
            color: #3b82f6;
        }
        .queue-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        .queue-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border-left: 5px solid #3b82f6;
            max-width: 300px;
        }
        .queue-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        .queue-card.current-patient {
            border-left-color: #22c55e;
            background: linear-gradient(135deg, rgba(34, 197, 94, 0.1) 0%, rgba(255,255,255,0.95) 100%);
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
            50% { box-shadow: 0 15px 40px rgba(34, 197, 94, 0.3); }
            100% { box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        }
        .patient-name {
            font-size: 24px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .patient-name i {
            color: #3b82f6;
        }
        .queue-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .info-label {
            font-size: 12px;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
        }
        .status-badge {
            padding: 12px 0px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
            text-align: center;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            width: 100%;
            justify-content: center;
        }
        .status-waiting {
            background: linear-gradient(135deg, #f7dd74, #fbbf24);
            color: #92400e;
        }
        .status-in-consultation {
            background: linear-gradient(135deg, #d1fae5, #34d399);
            color: #065f46;
        }
        .status-awaiting-lab {
            background: linear-gradient(135deg, #dbeafe, #60a5fa);
            color: #1e40af;
        }
        .status-ready-followup {
            background: linear-gradient(135deg, #e9d5ff, #c084fc);
            color: #7c2d12;
        }
        .status-completed {
            background: linear-gradient(135deg, #f3f4f6, #9ca3af);
            color: #374151;
        }
        .queue-type-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            background: #f1f5f9;
            color: #475569;
        }
        .queue-type-badge.walk-in {
            background: #fef2f2;
            color: #dc2626;
        }
        .queue-type-badge.booked {
            background: #f0f9ff;
            color: #0284c7;
        }
        .wait-time {
            background: #f8fafc;
            border-radius: 15px;
            padding: 15px;
            text-align: center;
            margin-top: 15px;
        }
        .wait-time-label {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 5px;
        }
        .wait-time-value {
            font-size: 18px;
            font-weight: 700;
            color: #3b82f6;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .empty-state h3 {
            font-size: 28px;
            color: #1e293b;
            margin-bottom: 15px;
        }
        .empty-state p {
            font-size: 16px;
            color: #64748b;
        }
        .stats-bar {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .stat-item {
            background: rgba(255,255,255,0.95);
            padding: 20px 30px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #3b82f6;
            display: block;
        }
        .stat-label {
            font-size: 14px;
            color: #64748b;
            margin-top: 5px;
        }
        @media (max-width: 768px) {
            .queue-grid { grid-template-columns: 1fr; }
            .queue-info { grid-template-columns: 1fr; }
            .stats-bar { flex-direction: column; align-items: center; }
        }
    </style>
</head>
<body>
    <main class="main">
        <section class="section">
            <div class="queue-container">
                <div class="queue-header" data-aos="fade-down">
                    <h1><i class="fas fa-hospital-user"></i> Hàng Đợi Bệnh Nhân</h1>
                    <div class="current-time">
                        <i class="fas fa-clock"></i>
                        <span id="currentTime"></span>
                    </div>
                </div>

                <!-- Statistics Bar -->
                <div class="stats-bar" data-aos="fade-up">
                    <div class="stat-item">
                        <span class="stat-number" id="waitingCount">0</span>
                        <div class="stat-label">Đang Chờ</div>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number" id="consultingCount">0</span>
                        <div class="stat-label">Đang Khám</div>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number" id="totalCount">0</span>
                        <div class="stat-label">Tổng Số</div>
                    </div>
                </div>

                <c:set var="activeQueueCount" value="0"/>
                <c:set var="waitingCount" value="0"/>
                <c:set var="consultingCount" value="0"/>

                <c:choose>
                    <c:when test="${empty queueDetails}">
                        <div class="empty-state" data-aos="fade-up">
                            <h3><i class="fas fa-user-clock"></i> Không có bệnh nhân trong hàng đợi</h3>
                            <p>Hiện tại không có ai đang chờ khám. Vui lòng quay lại sau.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="queue-grid" data-aos="fade-up" data-aos-delay="200">
                            <c:forEach var="queueDetail" items="${queueDetails}">
                                <!-- Filter out completed and old entries -->
                                <c:if test="${queueDetail.queue.status != 'Completed' && queueDetail.queue.checkInTime >= startOfToday}">
                                    <c:set var="activeQueueCount" value="${activeQueueCount + 1}"/>

                                    <c:set var="statusClass" value=""/>
                                    <c:set var="statusText" value=""/>
                                    <c:set var="statusIcon" value=""/>
                                    <c:set var="isCurrentPatient" value="false"/>

                                    <c:choose>
                                        <c:when test="${queueDetail.queue.status == 'Waiting'}">
                                            <c:set var="statusClass" value="status-waiting"/>
                                            <c:set var="statusText" value="Đang Chờ"/>
                                            <c:set var="statusIcon" value="fas fa-clock"/>
                                            <c:set var="waitingCount" value="${waitingCount + 1}"/>
                                        </c:when>
                                        <c:when test="${queueDetail.queue.status == 'In Consultation'}">
                                            <c:set var="statusClass" value="status-in-consultation"/>
                                            <c:set var="statusText" value="Đang Khám"/>
                                            <c:set var="statusIcon" value="fas fa-stethoscope"/>
                                            <c:set var="isCurrentPatient" value="true"/>
                                            <c:set var="consultingCount" value="${consultingCount + 1}"/>
                                        </c:when>
                                        <c:when test="${queueDetail.queue.status == 'Awaiting Lab Results'}">
                                            <c:set var="statusClass" value="status-awaiting-lab"/>
                                            <c:set var="statusText" value="Chờ Xét Nghiệm"/>
                                            <c:set var="statusIcon" value="fas fa-vial"/>
                                        </c:when>
                                        <c:when test="${queueDetail.queue.status == 'Ready for Follow-up'}">
                                            <c:set var="statusClass" value="status-ready-followup"/>
                                            <c:set var="statusText" value="Sẵn Sàng Khám Lại"/>
                                            <c:set var="statusIcon" value="fas fa-redo"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="statusClass" value="status-waiting"/>
                                            <c:set var="statusText" value="Đang Chờ"/>
                                            <c:set var="statusIcon" value="fas fa-clock"/>
                                            <c:set var="waitingCount" value="${waitingCount + 1}"/>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="queue-card ${isCurrentPatient ? 'current-patient' : ''}" data-aos="zoom-in" data-aos-delay="${(activeQueueCount * 100) % 600}">
                                        <div class="patient-name">
                                            <i class="fas fa-user"></i>
                                            ${queueDetail.patient.fullName}
                                        </div>

                                        <div class="queue-info">
                                            <div class="info-item">
                                                <div class="info-label">Loại Khám</div>
                                                <div class="info-value">
                                                    <span class="queue-type-badge ${queueDetail.queue.queueType == 'Walk-in' ? 'walk-in' : 'booked'}">
                                                        <i class="fas ${queueDetail.queue.queueType == 'Walk-in' ? 'fa-walking' : 'fa-calendar-check'}"></i>
                                                        ${queueDetail.queue.queueType == 'Walk-in' ? 'Khám Trực Tiếp' : 'Đã Đặt Lịch'}
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="info-item">
                                                <div class="info-label">Thời Gian Đăng Ký</div>
                                                <div class="info-value">
                                                    <fmt:formatDate value="${queueDetail.queue.checkInTime}" pattern="HH:mm"/>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="status-badge ${statusClass}">
                                            <i class="${statusIcon}"></i>
                                            ${statusText}
                                        </div>

                                        <c:if test="${queueDetail.queue.status == 'Waiting'}">
                                            <div class="wait-time">
                                                <div class="wait-time-label">Thời gian chờ ước tính</div>
                                                <div class="wait-time-value">
                                                    <c:set var="waitMinutes" value="${(activeQueueCount - consultingCount) * 15}"/>
                                                    <c:choose>
                                                        <c:when test="${waitMinutes <= 15}">5-15 phút</c:when>
                                                        <c:when test="${waitMinutes <= 30}">15-30 phút</c:when>
                                                        <c:when test="${waitMinutes <= 60}">30-60 phút</c:when>
                                                        <c:otherwise>Hơn 1 giờ</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>

                        <c:if test="${activeQueueCount == 0}">
                            <div class="empty-state" data-aos="fade-up">
                                <h3><i class="fas fa-user-clock"></i> Không có bệnh nhân đang chờ hôm nay</h3>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/assets/vendor/aos/aos.js'/>"></script>
    <script>
        AOS.init({ duration: 600, once: true });

        // Update current time
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('vi-VN', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            });
            const dateString = now.toLocaleDateString('vi-VN', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            document.getElementById('currentTime').textContent = dateString + ' - ' + timeString;
        }

        // Update statistics
        function updateStats() {
            const waitingCount = ${waitingCount};
            const consultingCount = ${consultingCount};
            const totalCount = ${activeQueueCount};

            document.getElementById('waitingCount').textContent = waitingCount;
            document.getElementById('consultingCount').textContent = consultingCount;
            document.getElementById('totalCount').textContent = totalCount;
        }

        // Initialize
        updateTime();
        updateStats();
        setInterval(updateTime, 1000);

        // Auto refresh every 30 seconds
        setTimeout(function(){ location.reload(); }, 30000);
    </script>
</body>
</html>