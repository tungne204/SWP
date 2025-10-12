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
            color: var(--accent-color);
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
            border-left: 5px solid var(--accent-color);
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
            color: var(--accent-color);
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
        .status-ready-exam {
            background: #22c55e;
            color: #064e3b;
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
            color: var(--accent-color);
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
            color: var(--accent-color);
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

                <!-- Counters for statistics -->
                <c:set var="activeQueueCount" value="0"/>
                <c:set var="waitingCount" value="0"/>
                <c:set var="consultingCount" value="0"/>

                <!-- First pass: count today's active entries for stats -->
                <c:forEach var="qd" items="${queueDetails}">
                    <c:if test="${qd.queue.status != 'Completed' && qd.queue.checkInTime >= startOfToday}">
                        <c:set var="activeQueueCount" value="${activeQueueCount + 1}"/>
                        <c:choose>
                            <c:when test="${qd.queue.status == 'Waiting'}">
                                <c:set var="waitingCount" value="${waitingCount + 1}"/>
                            </c:when>
                            <c:when test="${qd.queue.status == 'In Consultation'}">
                                <c:set var="consultingCount" value="${consultingCount + 1}"/>
                            </c:when>
                        </c:choose>
                    </c:if>
                </c:forEach>

                <c:choose>
                    <c:when test="${empty queueDetails}">
                        <div class="empty-state" data-aos="fade-up">
                            <h3><i class="fas fa-user-clock"></i> Không có bệnh nhân trong hàng đợi</h3>
                            <p>Hiện tại không có ai đang chờ khám. Vui lòng quay lại sau.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Ready for Examination Zone -->
                        <div class="queue-header" data-aos="fade-down" style="margin-top: 10px;">
                            <h1 style="font-size: 24px;">
                                <i class="fas fa-door-open"></i> Khu Vực: Sẵn Sàng Vào Khám
                            </h1>
                        </div>

                        <div id="readyZoneGrid" class="queue-grid" data-aos="fade-up" data-aos-delay="200">
                            <c:set var="readyIndex" value="0"/>
                            <c:forEach var="queueDetail" items="${queueDetails}">
                                <c:if test="${queueDetail.queue.status == 'Ready for Examination' && queueDetail.queue.checkInTime >= startOfToday}">
                                    <c:set var="readyIndex" value="${readyIndex + 1}"/>
                                    <div class="queue-card" data-queue-id="${queueDetail.queue.queueId}" data-patient-id="${queueDetail.patient.patientId}" data-status="${queueDetail.queue.status}" data-aos="zoom-in" data-aos-delay="${(readyIndex * 100) % 600}">
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
                                            <div class="info-item">
                                                <div class="info-label">Phòng Khám</div>
                                                <div class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty queueDetail.queue.roomNumber}">${queueDetail.queue.roomNumber}</c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">SĐT Phụ Huynh</div>
                                                <div class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty queueDetail.patient.address}">${queueDetail.patient.address}</c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">Tên Phụ Huynh/Người Giám Hộ</div>
                                                <div class="info-value">-</div>
                                            </div>
                                        </div>
                                        <div class="status-badge status-ready-exam">
                                            <i class="fas fa-bell"></i>
                                            Sẵn Sàng Vào Khám
                                        </div>
                                        <div class="wait-time">
                                            <div class="wait-time-label">Vui lòng đến phòng khám khi được gọi</div>
                                            <div class="wait-time-value">Đã sẵn sàng</div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>

                        <!-- Waiting Zone: Top 6 next patients -->
                        <div class="queue-header" data-aos="fade-down" style="margin-top: 30px;">
                            <h1 style="font-size: 24px;">
                                <i class="fas fa-users"></i> Khu Vực: Đang Chờ
                            </h1>
                        </div>

                        <div id="waitingTopGrid" class="queue-grid" data-aos="fade-up" data-aos-delay="200">
                            <c:set var="waitingIndex" value="0"/>
                            <c:forEach var="queueDetail" items="${queueDetails}">
                                <c:if test="${queueDetail.queue.status != 'Completed' && queueDetail.queue.checkInTime >= startOfToday}">
                                    <c:if test="${queueDetail.queue.status == 'Waiting'}">
                                        <c:set var="waitingIndex" value="${waitingIndex + 1}"/>
                                        <c:if test="${waitingIndex <= 6}">
                                            <div class="queue-card" data-queue-id="${queueDetail.queue.queueId}" data-patient-id="${queueDetail.patient.patientId}" data-status="${queueDetail.queue.status}" data-aos="zoom-in" data-aos-delay="${(waitingIndex * 100) % 600}">
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
                                                    <div class="info-item">
                                                        <div class="info-label">Phòng Khám</div>
                                                        <div class="info-value">
                                                            <c:choose>
                                                                <c:when test="${not empty queueDetail.queue.roomNumber}">${queueDetail.queue.roomNumber}</c:when>
                                                                <c:otherwise>-</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                    <div class="info-item">
                                                        <div class="info-label">SĐT Phụ Huynh</div>
                                                        <div class="info-value">
                                                            <c:choose>
                                                                <c:when test="${not empty queueDetail.patient.address}">${queueDetail.patient.address}</c:when>
                                                                <c:otherwise>-</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                    <div class="info-item">
                                                        <div class="info-label">Tên Phụ Huynh/Người Giám Hộ</div>
                                                        <div class="info-value">-</div>
                                                    </div>
                                                </div>
                                                <div class="status-badge status-waiting">
                                                    <i class="fas fa-clock"></i>
                                                    Đang Chờ
                                                </div>
                                                <div class="wait-time">
                                                    <div class="wait-time-label">Thời gian chờ ước tính</div>
                                                    <div class="wait-time-value">
                                                        <c:set var="waitMinutes" value="${(waitingIndex - 1) * 15}"/>
                                                        <c:choose>
                                                            <c:when test="${waitMinutes <= 15}">5-15 phút</c:when>
                                                            <c:when test="${waitMinutes <= 30}">15-30 phút</c:when>
                                                            <c:when test="${waitMinutes <= 60}">30-60 phút</c:when>
                                                            <c:otherwise>Hơn 1 giờ</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:if>
                                </c:if>
                            </c:forEach>
                        </div>

                        <!-- Waiting Zone: Overflow patients in table -->
                        <div class="queue-header" data-aos="fade-down" style="margin-top: 30px;">
                            <h1 style="font-size: 24px;">
                                <i class="fas fa-list"></i> Khu Vực: Đang Chờ
                            </h1>
                        </div>

                        <div class="table-responsive" data-aos="fade-up" data-aos-delay="200" style="background: rgba(255,255,255,0.95); padding: 20px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                            <table class="table table-hover" style="margin: 0;">
                                <thead>
                                    <tr>
                                        <th>Tên Bệnh Nhân</th>
                                        <th>Loại Khám</th>
                                        <th>Thời Gian Đăng Ký</th>
                                        <th>Trạng Thái</th>
                                    </tr>
                                </thead>
                                <tbody id="waitingTableBody">
                                    <c:set var="waitingIndex2" value="0"/>
                                    <c:forEach var="queueDetail" items="${queueDetails}">
                                        <c:if test="${queueDetail.queue.status != 'Completed' && queueDetail.queue.checkInTime >= startOfToday}">
                                            <c:choose>
                                                <c:when test="${queueDetail.queue.status == 'Waiting'}">
                                                    <c:set var="waitingIndex2" value="${waitingIndex2 + 1}"/>
                                                    <c:if test="${waitingIndex2 > 6}">
                                                        <tr>
                                                            <td>${queueDetail.patient.fullName}</td>
                                                            <td>
                                                                <span class="queue-type-badge ${queueDetail.queue.queueType == 'Walk-in' ? 'walk-in' : 'booked'}">
                                                                    ${queueDetail.queue.queueType == 'Walk-in' ? 'Khám Trực Tiếp' : 'Đã Đặt Lịch'}
                                                                </span>
                                                            </td>
                                                            <td><fmt:formatDate value="${queueDetail.queue.checkInTime}" pattern="HH:mm"/></td>
                                                            <td><span class="status-badge status-waiting" style="padding:6px 12px; font-size:12px;">Đang Chờ</span></td>
                                                        </tr>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td>${queueDetail.patient.fullName}</td>
                                                        <td>
                                                            <span class="queue-type-badge ${queueDetail.queue.queueType == 'Walk-in' ? 'walk-in' : 'booked'}">
                                                                ${queueDetail.queue.queueType == 'Walk-in' ? 'Khám Trực Tiếp' : 'Đã Đặt Lịch'}
                                                            </span>
                                                        </td>
                                                        <td><fmt:formatDate value="${queueDetail.queue.checkInTime}" pattern="HH:mm"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${queueDetail.queue.status == 'In Consultation'}">
                                                                    <span class="status-badge status-in-consultation" style="padding:6px 12px; font-size:12px;">Đang Khám</span>
                                                                </c:when>
                                                                <c:when test="${queueDetail.queue.status == 'Awaiting Lab Results'}">
                                                                    <span class="status-badge status-awaiting-lab" style="padding:6px 12px; font-size:12px;">Chờ Xét Nghiệm</span>
                                                                </c:when>
                                                                <c:when test="${queueDetail.queue.status == 'Ready for Follow-up'}">
                                                                    <span class="status-badge status-ready-followup" style="padding:6px 12px; font-size:12px;">Sẵn Sàng Khám Lại</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="status-badge" style="padding:6px 12px; font-size:12px; background:#f1f5f9; color:#475569;">Khác</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
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

        // WebSocket connection for real-time updates
        let socket = null;
        let reconnectInterval = null;

        function connectWebSocket() {
            try {
                const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
                const wsUrl = protocol + '//' + window.location.host + '/SWP/patient-queue-websocket';
                socket = new WebSocket(wsUrl);

                socket.onopen = function(event) {
                    console.log('WebSocket connected');
                    if (reconnectInterval) {
                        clearInterval(reconnectInterval);
                        reconnectInterval = null;
                    }
                };

                socket.onmessage = function(event) {
                    try {
                        const data = JSON.parse(event.data);
                        console.log('Received WebSocket message:', data);
                        // Support both formats from server:
                        // 1) {type:'queue_update', updateType:'patient_added'|'status_changed'|'queue_stats', data:{...}}
                        // 2) {type:'patient_added'|'status_changed'|'queue_stats', data:{...}}
                        if (data.type === 'queue_update') {
                            if (data.updateType === 'patient_added') {
                                insertOrUpdateCard(data.data.patient, data.data.queue);
                            } else if (data.updateType === 'status_changed') {
                                insertOrUpdateCard(data.data.patient, data.data.queue);
                            } else if (data.updateType === 'queue_stats') {
                                updateStatsFromWebSocket(data.data);
                            }
                        } else if (data.type === 'patient_added' || data.type === 'status_changed') {
                            insertOrUpdateCard(data.data.patient, data.data.queue);
                        } else if (data.type === 'queue_stats') {
                            updateStatsFromWebSocket(data.data);
                        }
                    } catch (e) {
                        console.error('Error parsing WebSocket message:', e);
                    }
                };

                socket.onclose = function(event) {
                    console.log('WebSocket disconnected');
                    // Attempt to reconnect every 5 seconds
                    if (!reconnectInterval) {
                        reconnectInterval = setInterval(connectWebSocket, 5000);
                    }
                };

                socket.onerror = function(error) {
                    console.error('WebSocket error:', error);
                };
            } catch (e) {
                console.error('Error creating WebSocket:', e);
                // Fallback to 30-second refresh if WebSocket fails
                setTimeout(function(){ location.reload(); }, 30000);
            }
        }

        function updateStatsFromWebSocket(stats) {
            if (stats.waitingCount !== undefined) {
                document.getElementById('waitingCount').textContent = stats.waitingCount;
            }
            if (stats.consultingCount !== undefined) {
                document.getElementById('consultingCount').textContent = stats.consultingCount;
            }
            if (stats.totalCount !== undefined) {
                document.getElementById('totalCount').textContent = stats.totalCount;
            }
        }

        // Smooth UI updates without full reload
        function getStatusMeta(status) {
            switch (status) {
                case 'Waiting':
                    return { cls: 'status-waiting', text: 'Đang Chờ', icon: 'fas fa-clock' };
                case 'In Consultation':
                    return { cls: 'status-in-consultation', text: 'Đang Khám', icon: 'fas fa-stethoscope' };
                case 'Awaiting Lab Results':
                    return { cls: 'status-awaiting-lab', text: 'Chờ Xét Nghiệm', icon: 'fas fa-vial' };
                case 'Ready for Examination':
                    return { cls: 'status-ready-exam', text: 'Sẵn Sàng Vào Khám', icon: 'fas fa-bell' };
                case 'Ready for Follow-up':
                    return { cls: 'status-ready-followup', text: 'Sẵn Sàng Khám Lại', icon: 'fas fa-redo' };
                case 'Completed':
                    return { cls: 'status-completed', text: 'Hoàn Thành', icon: 'fas fa-check' };
                default:
                    return { cls: 'status-waiting', text: 'Đang Chờ', icon: 'fas fa-clock' };
            }
        }

        function formatTime(dtStr) {
            try {
                const [datePart, timePart] = dtStr.split(' ');
                if (!timePart) return dtStr;
                const [h, m] = timePart.split(':');
                return h + ':' + m;
            } catch (_) {
                return dtStr;
            }
        }

        function ensureReadyGrid() {
            let grid = document.getElementById('readyZoneGrid');
            return grid || document.querySelector('#readyZoneGrid') || document.querySelector('.queue-grid');
        }

        function ensureWaitingTopGrid() {
            let grid = document.getElementById('waitingTopGrid');
            return grid || document.querySelector('#waitingTopGrid') || document.querySelector('.queue-grid');
        }

        function createQueueCardElement(patient, queue) {
            const meta = getStatusMeta(queue.status);
            const card = document.createElement('div');
            card.className = 'queue-card';
            card.setAttribute('data-queue-id', queue.queueId);
            const pid = (patient && patient.patientId != null) ? patient.patientId : patient.id;
            card.setAttribute('data-patient-id', pid);
            card.setAttribute('data-status', queue.status);
            // store sort keys
            try {
                card.setAttribute('data-priority', (queue.priority != null ? parseInt(queue.priority) : 0));
                const ts = (function(dtStr){
                    try {
                        const d = new Date(dtStr);
                        if (!isNaN(d.getTime())) return d.getTime();
                        // Try "yyyy-MM-dd HH:mm:ss"
                        const parts = String(dtStr).split(/[\- :]/);
                        if (parts.length >= 5) {
                            const d2 = new Date(parseInt(parts[0]), parseInt(parts[1])-1, parseInt(parts[2]), parseInt(parts[3]), parseInt(parts[4]));
                            if (!isNaN(d2.getTime())) return d2.getTime();
                        }
                        // Fallback HH:mm
                        const hm = String(dtStr).split(' ')[1] || String(dtStr);
                        const [h,m] = hm.split(':');
                        const base = new Date(); base.setHours(0,0,0,0);
                        return base.getTime() + (parseInt(h||'0')*60 + parseInt(m||'0'))*60000;
                    } catch(_) { const base = new Date(); base.setHours(0,0,0,0); return base.getTime(); }
                })(queue.checkInTime);
                card.setAttribute('data-checkin-ts', ts);
            } catch(_) {}

            const name = document.createElement('div');
            name.className = 'patient-name';
            name.innerHTML = '<i class="fas fa-user"></i> ' + patient.fullName;

            const info = document.createElement('div');
            info.className = 'queue-info';
            const item1 = document.createElement('div');
            item1.className = 'info-item';
            item1.innerHTML = '<div class="info-label">Loại Khám</div>' +
                '<div class="info-value">' +
                    '<span class="queue-type-badge ' + (queue.queueType === 'Walk-in' ? 'walk-in' : 'booked') + '">' +
                        '<i class="fas ' + (queue.queueType === 'Walk-in' ? 'fa-walking' : 'fa-calendar-check') + '"></i>' +
                        (queue.queueType === 'Walk-in' ? 'Khám Trực Tiếp' : 'Đã Đặt Lịch') +
                    '</span>' +
                '</div>';
            const item2 = document.createElement('div');
            item2.className = 'info-item';
            item2.innerHTML = '<div class="info-label">Thời Gian Đăng Ký</div>' +
                '<div class="info-value">' + formatTime(queue.checkInTime) + '</div>';
            info.appendChild(item1);
            info.appendChild(item2);
            const itemRoom = document.createElement('div');
            itemRoom.className = 'info-item';
            const room = (queue && queue.roomNumber && String(queue.roomNumber).trim().length > 0) ? queue.roomNumber : '-';
            itemRoom.innerHTML = '<div class="info-label">Phòng Khám</div>' +
                '<div class="info-value">' + room + '</div>';
            info.appendChild(itemRoom);
            const item3 = document.createElement('div');
            item3.className = 'info-item';
            const parentPhone = (patient && patient.address && String(patient.address).trim().length > 0) ? patient.address : '-';
            item3.innerHTML = '<div class="info-label">SĐT Phụ Huynh</div>' +
                '<div class="info-value">' + parentPhone + '</div>';
            const item4 = document.createElement('div');
            item4.className = 'info-item';
            item4.innerHTML = '<div class="info-label">Tên Phụ Huynh/Người Giám Hộ</div>' +
                '<div class="info-value">-</div>';
            info.appendChild(item3);
            info.appendChild(item4);

            const badge = document.createElement('div');
            badge.className = 'status-badge ' + meta.cls;
            badge.innerHTML = '<i class="' + meta.icon + '"></i> ' + meta.text;

            card.appendChild(name);
            card.appendChild(info);
            card.appendChild(badge);
            return card;
        }

        function compareCards(a, b) {
            const pa = parseInt(a.getAttribute('data-priority') || '0');
            const pb = parseInt(b.getAttribute('data-priority') || '0');
            if (pa !== pb) return pb - pa; // higher priority first
            const ta = parseInt(a.getAttribute('data-checkin-ts') || '0');
            const tb = parseInt(b.getAttribute('data-checkin-ts') || '0');
            return ta - tb; // older first
        }

        function insertCardSorted(container, newCard) {
            const cards = Array.from(container.querySelectorAll('.queue-card'));
            let placed = false;
            for (let i = 0; i < cards.length; i++) {
                if (compareCards(newCard, cards[i]) < 0) {
                    container.insertBefore(newCard, cards[i]);
                    placed = true;
                    break;
                }
            }
            if (!placed) container.appendChild(newCard);
        }

        function cardToRow(card) {
            const nameText = (card.querySelector('.patient-name')?.textContent || '').trim();
            const typeEl = card.querySelector('.queue-type-badge');
            const isBooked = !!(typeEl && typeEl.classList.contains('booked'));
            const typeText = isBooked ? 'Đã Đặt Lịch' : 'Khám Trực Tiếp';
            const timeText = (card.querySelector('.queue-info .info-item:nth-child(2) .info-value')?.textContent || '').trim();
            const statusEl = card.querySelector('.status-badge');
            const statusClass = statusEl ? statusEl.className.replace('status-badge ','') : 'status-waiting';
            const statusText = statusEl ? statusEl.textContent.trim() : 'Đang Chờ';
            const tr = document.createElement('tr');
            tr.setAttribute('data-queue-id', card.getAttribute('data-queue-id'));
            tr.innerHTML = '<td>' + nameText + '</td>' +
                '<td><span class="queue-type-badge ' + (isBooked ? 'booked' : 'walk-in') + '">' + typeText + '</span></td>' +
                '<td>' + timeText + '</td>' +
                '<td><span class="status-badge ' + statusClass + '" style="padding:6px 12px; font-size:12px;">' + statusText + '</span></td>';
            return tr;
        }

        function removeRowByQueueId(qid) {
            const tbody = document.getElementById('waitingTableBody');
            if (!tbody) return;
            const row = tbody.querySelector('tr[data-queue-id="' + qid + '"]');
            if (row) row.remove();
        }

        function enforceWaitingTopLimit() {
            const container = ensureWaitingTopGrid();
            const tbody = document.getElementById('waitingTableBody');
            if (!container || !tbody) return;
            const cards = Array.from(container.querySelectorAll('.queue-card'));
            if (cards.length <= 6) return;
            cards.slice(6).forEach(card => {
                // move overflow to table
                const row = cardToRow(card);
                container.removeChild(card);
                tbody.appendChild(row);
            });
        }

        function bootstrapExistingCards() {
            const cards = document.querySelectorAll('#waitingTopGrid .queue-card');
            cards.forEach(card => {
                // infer priority from queue type badge (booked > walk-in) if not present
                if (!card.hasAttribute('data-priority')) {
                    const typeEl = card.querySelector('.queue-type-badge');
                    const isBooked = !!(typeEl && typeEl.classList.contains('booked'));
                    card.setAttribute('data-priority', isBooked ? '1' : '0');
                }
                if (!card.hasAttribute('data-checkin-ts')) {
                    const txt = (card.querySelector('.queue-info .info-item:nth-child(2) .info-value')?.textContent || '').trim();
                    const base = new Date(); base.setHours(0,0,0,0);
                    const hm = txt.split(':');
                    const ts = base.getTime() + ((parseInt(hm[0]||'0')*60 + parseInt(hm[1]||'0'))*60000);
                    card.setAttribute('data-checkin-ts', String(ts));
                }
            });
            // sort initial cards and enforce top limit
            const container = ensureWaitingTopGrid();
            const sorted = Array.from(container.querySelectorAll('.queue-card')).sort(compareCards);
            sorted.forEach(c => container.appendChild(c));
            enforceWaitingTopLimit();
        }

        function updateStatsCounters(fromStatus, toStatus) {
            const waitingEl = document.getElementById('waitingCount');
            const consultEl = document.getElementById('consultingCount');
            const totalEl = document.getElementById('totalCount');
            const metaFrom = fromStatus ? getStatusMeta(fromStatus) : null;
            const metaTo = getStatusMeta(toStatus);

            const delta = { waiting: 0, consulting: 0, total: 0 };
            const catMap = {
                'status-waiting': 'waiting',
                'status-in-consultation': 'consulting',
            };
            if (metaFrom && catMap[metaFrom.cls]) delta[catMap[metaFrom.cls]] -= 1;
            if (catMap[metaTo.cls]) delta[catMap[metaTo.cls]] += 1;
            if (!fromStatus && toStatus !== 'Completed') delta.total += 1; // added
            if (toStatus === 'Completed') delta.total -= 1; // removed

            waitingEl.textContent = Math.max(0, (parseInt(waitingEl.textContent) || 0) + delta.waiting);
            consultEl.textContent = Math.max(0, (parseInt(consultEl.textContent) || 0) + delta.consulting);
            totalEl.textContent = Math.max(0, (parseInt(totalEl.textContent) || 0) + delta.total);
        }

        function insertOrUpdateCard(patient, queue) {
            const hasQueueId = queue.queueId && Number(queue.queueId) > 0;
            const pid = (patient && patient.patientId != null) ? patient.patientId : patient.id;
            let card = hasQueueId
                ? document.querySelector('.queue-card[data-queue-id="' + queue.queueId + '"]')
                : document.querySelector('.queue-card[data-patient-id="' + pid + '"]');
            if (!card) {
                const newCard = createQueueCardElement(patient, queue);
                const target = (queue.status === 'Ready for Examination') ? ensureReadyGrid() : ensureWaitingTopGrid();
                insertCardSorted(target, newCard);
                if (target === ensureWaitingTopGrid()) enforceWaitingTopLimit();
                updateStatsCounters(undefined, queue.status);
                return;
            }
            const prevStatus = card.getAttribute('data-status');
            card.setAttribute('data-status', queue.status);
            if (hasQueueId) {
                card.setAttribute('data-queue-id', queue.queueId);
            }
            const meta = getStatusMeta(queue.status);
            const badge = card.querySelector('.status-badge');
            badge.className = 'status-badge ' + meta.cls;
            badge.innerHTML = '<i class="' + meta.icon + '"></i> ' + meta.text;
            // Move card to appropriate zone if status changed
            const desiredContainer = (queue.status === 'Ready for Examination') ? ensureReadyGrid() : ensureWaitingTopGrid();
            if (card.parentElement && card.parentElement !== desiredContainer) {
                const prevParent = card.parentElement;
                prevParent.removeChild(card);
                // remove any table row if exists
                removeRowByQueueId(card.getAttribute('data-queue-id'));
                insertCardSorted(desiredContainer, card);
                if (desiredContainer === ensureWaitingTopGrid()) enforceWaitingTopLimit();
            }
            if (queue.status === 'Completed') {
                card.remove();
            }
            updateStatsCounters(prevStatus, queue.status);
        }

        // Initialize existing cards and WebSocket connection
        bootstrapExistingCards();
        connectWebSocket();

        // Cleanup on page unload
        window.addEventListener('beforeunload', function() {
            if (socket) {
                socket.close();
            }
            if (reconnectInterval) {
                clearInterval(reconnectInterval);
            }
        });
    </script>
</body>
</html>