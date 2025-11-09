<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setLocale value="vi_VN" />
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Waiting Screen - Medilab</title>
        
        <!-- Include all CSS files -->
        <jsp:include page="../includes/head-includes.jsp"/>
        
        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* Layout styles for sidebar integration */
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
            padding-bottom: 100px; /* Space for footer */
        }
        
        /* Queue Waiting Screen Custom Styles */
        .queue-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        .queue-header {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            padding: 30px 40px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0px 5px 25px rgba(0, 0, 0, 0.15);
        }
        
        .queue-header h1 {
            color: white;
            margin: 0;
            font-size: 32px;
            font-weight: 700;
        }
        
        .queue-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0px 2px 15px rgba(0, 0, 0, 0.08);
            text-align: center;
            transition: all 0.3s ease;
            border-left: 4px solid #3b82f6;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 5px 25px rgba(0, 0, 0, 0.12);
        }
        
        .stat-card .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #1e293b;
            display: block;
            margin: 10px 0;
        }
        
        .stat-card .stat-label {
            color: #64748b;
            font-size: 14px;
            font-weight: 500;
        }
        
        .queue-list {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0px 2px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .queue-list-header {
            background-color: #3b82f6;
            color: white;
            padding: 20px 30px;
            display: grid;
            grid-template-columns: 80px 2fr 120px 150px 180px 200px 120px 200px;
            gap: 15px;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
        }
        
        .queue-item {
            display: grid;
            grid-template-columns: 80px 2fr 120px 150px 180px 200px 120px 200px;
            gap: 15px;
            padding: 20px 30px;
            border-bottom: 1px solid #e2e8f0;
            align-items: center;
            transition: all 0.3s ease;
        }
        
        .queue-item:hover {
            background-color: #f1f5f9;
        }
        
        .queue-item:last-child {
            border-bottom: none;
        }
        
        .queue-number {
            font-size: 24px;
            font-weight: 700;
            color: #3b82f6;
        }
        
        .patient-name {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
        }
        
        .patient-id {
            font-size: 14px;
            color: #64748b;
        }
        
        .status-badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            text-align: center;
            display: inline-block;
        }
        
        .status-waiting {
            background-color: #fffbeb;
            color: #f59e0b;
        }
        
        .status-in-consultation {
            background-color: #dcfce7;
            color: #22c55e;
        }
        
        .status-awaiting-lab {
            background-color: #dbeafe;
            color: #3b82f6;
        }
        
        .status-ready-followup {
            background-color: #e9d5ff;
            color: #a855f7;
        }
        
        .status-ready-exam {
            background-color: #dcfdf4;
            color: #059669;
        }
        
        .status-completed {
            background-color: #f3f4f6;
            color: #4b5563;
        }
        
        .check-in-time {
            font-size: 13px;
            color: #64748b;
        }
        
        .queue-type {
            font-size: 13px;
            font-weight: 500;
            padding: 4px 10px;
            border-radius: 12px;
            background-color: #dbeafe;
            color: #3b82f6;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
        }
        
        .action-btn {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-start {
            background-color: #3b82f6;
            color: white;
        }
        
        .btn-start:hover {
            background-color: #2563eb;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0px 4px 15px rgba(59, 130, 246, 0.3);
        }
        
        .btn-continue {
            background-color: #22c55e;
            color: white;
        }
        
        .btn-continue:hover {
            background-color: #16a34a;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0px 4px 15px rgba(34, 197, 94, 0.3);
        }
        
        .btn-followup {
            background-color: #a855f7;
            color: white;
        }
        
        .btn-followup:hover {
            background-color: #9333ea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0px 4px 15px rgba(168, 85, 247, 0.3);
        }
        
        .btn-disabled {
            background-color: #94a3b8;
            color: white;
            opacity: 0.65;
            cursor: not-allowed;
        }
        
        .btn-view {
            background-color: #6b7280;
            color: white;
            border: 1px solid #d1d5db;
        }
        
        .btn-view:hover {
            background-color: #4b5563;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0px 4px 15px rgba(107, 114, 128, 0.3);
        }
        
        .btn-lab {
            background: linear-gradient(45deg, #8b5cf6, #a855f7);
            color: white;
            border: none;
        }
        
        .btn-lab:hover {
            background: linear-gradient(45deg, #7c3aed, #9333ea);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0px 4px 15px rgba(139, 92, 246, 0.3);
        }
        
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .toolbar-left {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .toolbar-btn {
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-add-patient {
            background-color: #3b82f6;
            color: white;
        }
        
        .btn-add-patient:hover {
            background-color: #2563eb;
            color: white;
        }
        
        .btn-refresh {
            background-color: transparent;
            color: #3b82f6;
            border: 2px solid #3b82f6;
        }
        
        .btn-refresh:hover {
            background-color: #3b82f6;
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #94a3b8;
        }
        
        .empty-state h3 {
            font-size: 24px;
            color: #1e293b;
            margin-bottom: 10px;
        }
        
        @media (max-width: 1200px) {
            .queue-list-header,
            .queue-item {
                grid-template-columns: 60px 1.5fr 100px 130px 150px 180px 100px 180px;
                gap: 10px;
                font-size: 13px;
            }
        }
        
        @media (max-width: 992px) {
            .queue-stats {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .queue-list-header,
            .queue-item {
                grid-template-columns: 1fr;
                gap: 5px;
            }
            
            .queue-list-header {
                display: none;
            }
            
            .queue-item {
                padding: 20px;
                border: 1px solid #cbd5e1;
                margin-bottom: 15px;
                border-radius: 8px;
            }
            
            .queue-item > div::before {
                content: attr(data-label);
                font-weight: 600;
                margin-right: 10px;
                color: #1e293b;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="../includes/header.jsp"/>

    <div class="main-wrapper">
        <!-- Sidebar -->
        <div class="sidebar-fixed">
            <%@ include file="../includes/sidebar-receptionist.jsp" %>
        </div>

        <!-- Main Content -->
        <div class="content-area">
            <main class="main">
        <section class="section">
            <div class="queue-container">
                <!-- Header Section -->
                <div class="queue-header" data-aos="fade-down">
                    <h1><i class="fas fa-users-medical"></i> Hàng Đợi Bệnh Nhân</h1>
                </div>
                
                <!-- Statistics Cards -->
                <div class="queue-stats" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card">
                        <i class="fas fa-user-clock text-3xl mb-2 text-blue-500"></i>
                        <span class="stat-number">${queueDetails.stream().filter(qd -> qd.queue.status == 'Waiting').count()}</span>
                        <span class="stat-label">Đang Chờ</span>
                    </div>
                    
                    <div class="stat-card">
                        <i class="fas fa-stethoscope text-3xl mb-2 text-green-500"></i>
                        <span class="stat-number">${queueDetails.stream().filter(qd -> qd.queue.status == 'In Consultation').count()}</span>
                        <span class="stat-label">Đang Khám</span>
                    </div>
                    
                    <div class="stat-card">
                        <i class="fas fa-flask text-3xl mb-2 text-blue-400"></i>
                        <span class="stat-number">${queueDetails.stream().filter(qd -> qd.queue.status == 'Awaiting Lab Results').count()}</span>
                        <span class="stat-label">Chờ Xét Nghiệm</span>
                    </div>
                    
                    <div class="stat-card">
                        <i class="fas fa-user-check text-3xl mb-2 text-purple-500"></i>
                        <span class="stat-number">${queueDetails.stream().filter(qd -> qd.queue.status == 'Ready for Follow-up').count()}</span>
                        <span class="stat-label">Sẵn Sàng Khám Lại</span>
                    </div>
                    
                    <div class="stat-card">
                        <i class="fas fa-door-open text-3xl mb-2 text-emerald-500"></i>
                        <span class="stat-number">${queueDetails.stream().filter(qd -> qd.queue.status == 'Ready for Examination').count()}</span>
                        <span class="stat-label">Sẵn Sàng Vào Khám</span>
                    </div>
                    
                    <div class="stat-card">
                        <i class="fas fa-check-circle text-3xl mb-2 text-gray-500"></i>
                        <span class="stat-number">${completedPatients.size()}</span>
                        <span class="stat-label">Hoàn Tất</span>
                    </div>
                </div>
                
                <!-- Toolbar -->
                <div class="toolbar" data-aos="fade-up" data-aos-delay="200">
                    <div class="toolbar-left">
                        <a href="<c:url value="/receptionist/checkin-form"/>" class="toolbar-btn btn-add-patient">
                            <i class="fas fa-user-plus"></i>
                            Đăng Ký Bệnh Nhân
                        </a>
                    </div>
                    <button class="toolbar-btn btn-refresh" onclick="location.reload()">
                        <i class="fas fa-sync-alt"></i>
                        Làm Mới
                    </button>
                </div>
                
                <!-- Queue List -->
                <div class="queue-list" data-aos="fade-up" data-aos-delay="300">
                    <div class="queue-list-header">
                        <div>STT</div>
                        <div>Họ Tên Bệnh Nhân</div>
                        <div>Mã BN</div>
                        <div>Bác Sĩ</div>
                        <div>Trạng Thái</div>
                        <div>Thời Gian Check-in</div>
                        <div>Loại</div>
                        <div>Hành Động</div>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty queueDetails}">
                            <div class="empty-state">
                                <i class="fas fa-inbox text-5xl mb-4 text-blue-300"></i>
                                <h3>Không Có Bệnh Nhân Trong Hàng Đợi</h3>
                                <p>Hiện tại không có bệnh nhân nào đang chờ khám</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="queueDetail" items="${queueDetails}">
                                <div class="queue-item">
                                    <div class="queue-number" data-label="STT: ">#${queueDetail.queue.queueNumber}</div>
                                    
                                    <div data-label="Họ Tên: ">
                                        <div class="patient-name">${queueDetail.patient.fullName}</div>
                                        <div class="patient-id">DOB: ${queueDetail.patient.dob}</div>
                                    </div>
                                    
                                    <div data-label="Mã BN: ">
                                        <strong>ID: ${queueDetail.patient.patientId}</strong>
                                    </div>
                                    
                                    <div data-label="Bác Sĩ: ">
                                        <c:choose>
                                            <c:when test="${not empty queueDetail.doctor && not empty queueDetail.doctor.username}">
                                                <div style="font-weight: 600; color: #1e293b;">
                                                    👨‍⚕️ ${queueDetail.doctor.username}
                                                </div>
                                                <c:if test="${not empty queueDetail.doctor.experienceYears && queueDetail.doctor.experienceYears > 0}">
                                                    <div style="font-size: 12px; color: #64748b; margin-top: 2px;">
                                                        ${queueDetail.doctor.experienceYears} năm kinh nghiệm
                                                    </div>
                                                </c:if>
                                            </c:when>
                                            <c:when test="${not empty queueDetail.appointment && not empty queueDetail.appointment.doctorName}">
                                                <div style="font-weight: 600; color: #1e293b;">
                                                    👨‍⚕️ ${queueDetail.appointment.doctorName}
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #94a3b8; font-style: italic;">Chưa chỉ định</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <div data-label="Trạng Thái: ">
                                        <span class="status-badge
                                            <c:choose>
                                                <c:when test="${queueDetail.queue.status == 'Waiting'}">status-waiting</c:when>
                                                <c:when test="${queueDetail.queue.status == 'In Consultation'}">status-in-consultation</c:when>
                                                <c:when test="${queueDetail.queue.status == 'Awaiting Lab Results'}">status-awaiting-lab</c:when>
                                                <c:when test="${queueDetail.queue.status == 'Ready for Follow-up'}">status-ready-followup</c:when>
                                                <c:when test="${queueDetail.queue.status == 'Ready for Examination'}">status-ready-exam</c:when>
                                                <c:when test="${queueDetail.queue.status == 'Completed'}">status-completed</c:when>
                                            </c:choose>
                                        ">
                                            <c:choose>
                                                <c:when test="${queueDetail.queue.status == 'Waiting'}">Đang Chờ</c:when>
                                                <c:when test="${queueDetail.queue.status == 'In Consultation'}">Đang Khám</c:when>
                                                <c:when test="${queueDetail.queue.status == 'Awaiting Lab Results'}">Chờ Xét Nghiệm</c:when>
                                                <c:when test="${queueDetail.queue.status == 'Ready for Follow-up'}">Sẵn Sàng Khám Lại</c:when>
                                                <c:when test="${queueDetail.queue.status == 'Ready for Examination'}">Sẵn Sàng Vào Khám</c:when>
                                                <c:when test="${queueDetail.queue.status == 'Completed'}">Hoàn Tất</c:when>
                                                <c:otherwise>${queueDetail.queue.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    
                                    <div class="check-in-time" data-label="Thời Gian: ">
                                        <i class="far fa-clock"></i> ${queueDetail.queue.checkInTime}
                                    </div>
                                    
                                    <div data-label="Loại: ">
                                        <span class="queue-type">${queueDetail.queue.queueType == 'Walk-in' ? 'Khám Trực Tiếp' : 'Đã Đặt Lịch'}</span>
                                    </div>
                                    
                                    <div class="action-buttons" data-label="">
                                        <c:choose>
                                            <c:when test="${queueDetail.queue.status == 'Waiting'}">
                                                <button type="button" class="action-btn btn-followup" onclick="markReady('${queueDetail.queue.queueId}')">
                                                    <i class="fas fa-door-open"></i>
                                                    Chuẩn Bị Khám
                                                </button>
                                                <%-- Chỉ hiển thị nút "Bắt Đầu Khám" cho bác sĩ (roleId = 2) --%>
                                                <c:if test="${sessionScope.acc.roleId == 2}">
                                                    <form action="patient-queue" method="post" style="display: inline;">
                                                        <input type="hidden" name="action" value="startConsultation">
                                                        <input type="hidden" name="queueId" value="${queueDetail.queue.queueId}">
                                                        <button type="submit" class="action-btn btn-start">
                                                            <i class="fas fa-play"></i>
                                                            Bắt Đầu Khám
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </c:when>
                                            <c:when test="${queueDetail.queue.status == 'In Consultation'}">
                                                <a href="patient-queue?action=consultation&queueId=${queueDetail.queue.queueId}"
                                                   class="action-btn btn-view">
                                                    <i class="fas fa-eye"></i>
                                                    Xem Chi Tiết
                                                </a>
                                            </c:when>
                                            <c:when test="${queueDetail.queue.status == 'Awaiting Lab Results'}">
                                                <a href="patient-queue?action=lab-completion&queueId=${queueDetail.queue.queueId}"
                                                   class="action-btn btn-lab">
                                                    <i class="fas fa-flask"></i>
                                                    Hoàn Tất XN
                                                </a>
                                            </c:when>
                                            <c:when test="${queueDetail.queue.status == 'Ready for Examination'}">
                                                <%-- Chỉ hiển thị nút "Bắt Đầu Khám" cho bác sĩ (roleId = 2) --%>
                                                <c:if test="${sessionScope.acc.roleId == 2}">
                                                    <form action="patient-queue" method="post" style="display: inline;">
                                                        <input type="hidden" name="action" value="startConsultation">
                                                        <input type="hidden" name="queueId" value="${queueDetail.queue.queueId}">
                                                        <button type="submit" class="action-btn btn-start">
                                                            <i class="fas fa-play"></i>
                                                            Bắt Đầu Khám
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </c:when>
                                            <c:when test="${queueDetail.queue.status == 'Ready for Follow-up'}">
                                                <a href="patient-queue?action=consultation&queueId=${queueDetail.queue.queueId}"
                                                   class="action-btn btn-followup">
                                                    <i class="fas fa-redo"></i>
                                                    Khám Lại
                                                </a>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>
    </main>
    
    <footer class="bg-gray-100 py-6 mt-10">
        <div class="container mx-auto text-center text-gray-600">
            <p>© <span>Copyright</span> <strong class="px-1">Medilab</strong> <span>All Rights Reserved</span></p>
        </div>
    </footer>
    
    <!-- Scroll Top -->
    <a href="#" class="fixed bottom-4 right-4 w-10 h-10 bg-blue-500 text-white rounded-full flex items-center justify-center hover:bg-blue-600 transition">
        <i class="fas fa-arrow-up"></i>
    </a>
    
    <!-- Vendor JS Files -->
    <script src="<c:url value="/assets/vendor/aos/aos.js"/>"></script>
    
    <!-- Main JS File -->
    <script src="<c:url value="/assets/js/main.js"/>"></script>
    
    <script>
        // Initialize AOS (Animate On Scroll)
        AOS.init({
            duration: 800,
            easing: 'ease-in-out',
            once: true,
            mirror: false
        });
        
        // WebSocket connection for real-time updates
        let websocket;
        let reconnectInterval;
        
        function connectWebSocket() {
            try {
                const contextPath = '${pageContext.request.contextPath}';
                const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
                const wsUrl = protocol + '//' + window.location.host + contextPath + '/patient-queue-websocket';
                websocket = new WebSocket(wsUrl);
                
                websocket.onopen = function(event) {
                    console.log('WebSocket connected');
                    if (reconnectInterval) {
                        clearInterval(reconnectInterval);
                        reconnectInterval = null;
                    }
                };
                
                websocket.onmessage = function(event) {
                    try {
                        const data = JSON.parse(event.data);
                        handleWebSocketMessage(data);
                    } catch (e) {
                        console.error('Error parsing WebSocket message:', e);
                    }
                };
                
                websocket.onclose = function(event) {
                    console.log('WebSocket disconnected');
                    // Attempt to reconnect every 5 seconds
                    if (!reconnectInterval) {
                        reconnectInterval = setInterval(connectWebSocket, 5000);
                    }
                };
                
                websocket.onerror = function(error) {
                    console.error('WebSocket error:', error);
                };
            } catch (e) {
                console.error('Failed to connect WebSocket:', e);
                // Fallback to page refresh if WebSocket fails
                setTimeout(function() { location.reload(); }, 30000);
            }
        }
        
        function handleWebSocketMessage(data) {
            if (data.type === 'queue_update') {
                // Reload the page to get updated queue data
                // In a more sophisticated implementation, we would update the DOM directly
                location.reload();
            } else if (data.type === 'connection') {
                console.log('WebSocket connection status:', data.status);
            }
        }
        
        // Initialize WebSocket connection
        connectWebSocket();
        
        // Fallback refresh every 5 minutes as backup
        setTimeout(function() {
            location.reload();
        }, 300000);
    </script>

    <script>
        function markReady(queueId) {
            try {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'patient-queue?action=markReady';
                const q = document.createElement('input');
                q.type = 'hidden';
                q.name = 'queueId';
                q.value = queueId;
                form.appendChild(q);
                document.body.appendChild(form);
                form.submit();
            } catch (e) {
                alert('Không thể gửi yêu cầu chuẩn bị khám.');
            }
        }
    </script>

            </main>
        </div> <!-- End content-area -->
    </div> <!-- End main-wrapper -->

    <!-- Footer -->
    <jsp:include page="../includes/footer.jsp"/>
    
    <!-- Include all JS files -->
    <jsp:include page="../includes/footer-includes.jsp"/>

</body>
</html>