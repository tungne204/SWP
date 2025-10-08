<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Màn Hình Chờ Công Khai - Medilab</title>

    <!-- Favicons -->
    <link href="<c:url value='/assets/img/favicon.png'/>" rel="icon">
    <link href="<c:url value='/assets/img/apple-touch-icon.png'/>" rel="apple-touch-icon">

    <!-- Vendor CSS Files -->
    <link href="<c:url value='/assets/vendor/aos/aos.css'/>" rel="stylesheet">
    <link href="<c:url value='/assets/vendor/fontawesome-free/css/all.min.css'/>" rel="stylesheet">

    <!-- Main CSS File -->
    <link href="<c:url value='/assets/css/main.css'/>" rel="stylesheet">

    <style>
        body { background-color: #f8fafc; color: #0f172a; font-family: 'Poppins', 'Roboto', sans-serif; }
        .main { padding: 30px 0; }
        .queue-container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        .queue-header { text-align: center; margin-bottom: 20px; }
        .queue-header h1 { font-size: 28px; font-weight: 700; color: #1e293b; }
        .queue-list { background: #fff; border-radius: 10px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); overflow: hidden; }
        .queue-list-header { background-color: #3b82f6; color: #fff; padding: 16px 22px; display: grid; grid-template-columns: 80px 2fr 140px 200px 180px; gap: 12px; font-weight: 600; font-size: 14px; }
        .queue-item { display: grid; grid-template-columns: 80px 2fr 140px 200px 180px; gap: 12px; padding: 16px 22px; border-bottom: 1px solid #e2e8f0; align-items: center; }
        .queue-item:last-child { border-bottom: none; }
        .queue-number { font-size: 22px; font-weight: 700; color: #3b82f6; }
        .patient-name { font-size: 16px; font-weight: 600; color: #1e293b; }
        .patient-id { font-size: 14px; color: #64748b; }
        .check-in-time { font-size: 13px; color: #64748b; }
        .queue-type { font-size: 13px; font-weight: 500; padding: 4px 10px; border-radius: 12px; color: #3b82f6; border: 1px solid #93c5fd; display: inline-block; }
        .status-badge { padding: 8px 15px; border-radius: 20px; font-size: 13px; font-weight: 600; text-align: center; display: inline-block; }
        .status-waiting { background-color: #fffbeb; color: #f59e0b; }
        .status-in-consultation { background-color: #dcfce7; color: #22c55e; }
        .status-awaiting-lab { background-color: #dbeafe; color: #3b82f6; }
        .status-ready-followup { background-color: #e9d5ff; color: #a855f7; }
        .status-completed { background-color: #f3f4f6; color: #4b5563; }
        .empty-state { text-align: center; padding: 40px 20px; color: #64748b; }
        .empty-state h3 { font-size: 22px; color: #1e293b; margin-bottom: 8px; }
        @media (max-width: 992px) {
            .queue-list-header, .queue-item { grid-template-columns: 1fr; gap: 8px; }
            .queue-list-header { display: none; }
        }
    </style>
</head>
<body>
    <main class="main">
        <section class="section">
            <div class="queue-container">
                <div class="queue-header" data-aos="fade-down">
                    <h1><i class="fas fa-users"></i> Hàng Đợi Bệnh Nhân (Công Khai)</h1>
                </div>

                <div class="queue-list" data-aos="fade-up" data-aos-delay="100">
                    <div class="queue-list-header">
                        <div>STT</div>
                        <div>Họ Tên</div>
                        <div>Mã BN</div>
                        <div>Trạng Thái</div>
                        <div>Thời Gian</div>
                    </div>

                    <c:choose>
                        <c:when test="${empty queueDetails}">
                            <div class="empty-state">
                                <h3>Không có bệnh nhân trong hàng đợi</h3>
                                <p>Vui lòng quay lại sau.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="queueDetail" items="${queueDetails}">
                                <c:set var="statusClass" value=""/>
                                <c:set var="statusText" value=""/>
                                <c:choose>
                                    <c:when test="${queueDetail.queue.status == 'Waiting'}">
                                        <c:set var="statusClass" value="status-waiting"/>
                                        <c:set var="statusText" value="Đang Chờ"/>
                                    </c:when>
                                    <c:when test="${queueDetail.queue.status == 'In Consultation'}">
                                        <c:set var="statusClass" value="status-in-consultation"/>
                                        <c:set var="statusText" value="Đang Khám"/>
                                    </c:when>
                                    <c:when test="${queueDetail.queue.status == 'Awaiting Lab Results'}">
                                        <c:set var="statusClass" value="status-awaiting-lab"/>
                                        <c:set var="statusText" value="Chờ Xét Nghiệm"/>
                                    </c:when>
                                    <c:when test="${queueDetail.queue.status == 'Ready for Follow-up'}">
                                        <c:set var="statusClass" value="status-ready-followup"/>
                                        <c:set var="statusText" value="Sẵn Sàng Khám Lại"/>
                                    </c:when>
                                    <c:when test="${queueDetail.queue.status == 'Completed'}">
                                        <c:set var="statusClass" value="status-completed"/>
                                        <c:set var="statusText" value="Hoàn Tất"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="statusClass" value="status-waiting"/>
                                        <c:set var="statusText" value="Đang Chờ"/>
                                    </c:otherwise>
                                </c:choose>

                                <div class="queue-item">
                                    <div class="queue-number">#${queueDetail.queue.queueNumber}</div>
                                    <div>
                                        <div class="patient-name">${queueDetail.patient.fullName}</div>
                                        <div class="patient-id">ID: ${queueDetail.patient.patientId}</div>
                                    </div>
                                    <div>
                                        <span class="status-badge ${statusClass}">${statusText}</span>
                                    </div>
                                    <div class="check-in-time">
                                        <i class="far fa-clock"></i> ${queueDetail.queue.checkInTime}
                                    </div>
                                    <div>
                                        <span class="queue-type">${queueDetail.queue.queueType}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/assets/vendor/aos/aos.js'/>"></script>
    <script>
        AOS.init({ duration: 600, once: true });
        setTimeout(function(){ location.reload(); }, 30000);
    </script>
</body>
</html>