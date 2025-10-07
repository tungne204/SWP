<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Get current date and time
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy", new java.util.Locale("vi", "VN"));
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Màn Hình Chờ Khám - Medilab</title>
    <meta name="description" content="Màn hình chờ khám bệnh nhân">

    <!-- Favicons -->
    <link href="<c:url value="/assets/img/favicon.png"/>" rel="icon">
    <link href="<c:url value="/assets/img/apple-touch-icon.png"/>" rel="apple-touch-icon">

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Inter:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <!-- Vendor CSS Files -->
    <link href="<c:url value="/assets/vendor/fontawesome-free/css/all.min.css"/>" rel="stylesheet">

    <!-- Main CSS File -->
    <link href="<c:url value="/assets/css/main.css"/>" rel="stylesheet">

    <!-- Tailwind CSS -->
    <script src="<c:url value="/assets/vendor/tailwindv4/tailwind.min.js"/>"></script>

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
        }

        .queue-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .queue-header {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .priority-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .priority-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            padding: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-left: 4px solid #3b82f6;
        }

        .priority-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        }

        .priority-card.urgent {
            border-left-color: #ef4444;
        }

        .priority-card.high {
            border-left-color: #f59e0b;
        }

        .priority-card.medium {
            border-left-color: #3b82f6;
        }

        .priority-card.low {
            border-left-color: #10b981;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .queue-number-large {
            font-size: 2rem;
            font-weight: 700;
            color: #3b82f6;
        }

        .priority-badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .priority-badge.urgent {
            background-color: #fee2e2;
            color: #ef4444;
        }

        .priority-badge.high {
            background-color: #fef3c7;
            color: #f59e0b;
        }

        .priority-badge.medium {
            background-color: #dbeafe;
            color: #3b82f6;
        }

        .priority-badge.low {
            background-color: #d1fae5;
            color: #10b981;
        }

        .patient-name-large {
            font-size: 1.2rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 10px;
        }

        .status-badge-large {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
            display: inline-block;
        }

        .queue-list {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .queue-list-header {
            background-color: #3b82f6;
            color: white;
            padding: 15px 20px;
            display: grid;
            grid-template-columns: 1fr 2fr 1fr 1fr 1fr;
            gap: 15px;
            font-weight: 600;
            font-size: 16px;
        }

        .queue-item {
            display: grid;
            grid-template-columns: 1fr 2fr 1fr 1fr 1fr;
            gap: 15px;
            padding: 15px 20px;
            border-bottom: 1px solid #e2e8f0;
            align-items: center;
        }

        .queue-item:last-child {
            border-bottom: none;
        }

        .queue-number {
            font-size: 20px;
            font-weight: 700;
            color: #3b82f6;
        }

        .patient-name {
            font-size: 16px;
            font-weight: 500;
            color: #1e293b;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
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

        .status-completed {
            background-color: #f3f4f6;
            color: #4b5563;
        }

        .current-patient {
            background-color: #dbeafe;
            border-left: 4px solid #3b82f6;
        }

        @media (max-width: 768px) {
            .priority-grid {
                grid-template-columns: 1fr;
            }

            .queue-list-header,
            .queue-item {
                grid-template-columns: 1fr 1fr;
                gap: 10px;
                font-size: 14px;
            }

            .queue-list-header div:nth-child(3),
            .queue-list-header div:nth-child(4),
            .queue-list-header div:nth-child(5),
            .queue-item div:nth-child(3),
            .queue-item div:nth-child(4),
            .queue-item div:nth-child(5) {
                display: none;
            }
        }
    </style>
</head>
<body>
<header class="sticky top-0 z-50 bg-white shadow">
    <div class="bg-gray-100 py-2 px-4">
        <div class="container mx-auto flex flex-col md:flex-row justify-between items-center">
            <div class="flex items-center space-x-4 mb-2 md:mb-0">
                <div class="flex items-center">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                         xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                    </svg>
                    <a href="mailto:contact@example.com" class="text-sm">contact@example.com</a>
                </div>
                <div class="flex items-center ml-4">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                         xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path>
                    </svg>
                    <span class="text-sm">+1 5589 55488 55</span>
                </div>
            </div>
            <div class="hidden md:flex items-center space-x-3">
                <a href="#" class="text-gray-600 hover:text-blue-500">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"></path>
                    </svg>
                </a>
                <a href="#" class="text-gray-600 hover:text-blue-500">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.879V14.89h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.989C18.343 21.129 22 16.99 22 12z"></path>
                    </svg>
                </a>
                <a href="#" class="text-gray-600 hover:text-pink-500">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.336 0 8.744 0 12c0 3.258.014 3.668.072 4.948.2 4.36 2.618 6.78 6.98 6.98C8.336 23.986 8.744 24 12 24c3.258 0 3.668-.014 4.948-.072 4.362-.2 6.782-2.618 6.98-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.948-.196-4.361-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.849 1.44 1.44 0 000-2.849z"></path>
                    </svg>
                </a>
                <a href="#" class="text-gray-600 hover:text-blue-700">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 01-2.063-2.065 2.064 2.064 0 112.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"></path>
                    </svg>
                </a>
            </div>
        </div>
    </div>

    <div class="bg-white py-4 px-4">
        <div class="container mx-auto flex flex-col md:flex-row items-center justify-between">
            <a href="<c:url value="/Home.jsp"/>" class="flex items-center mb-4 md:mb-0">
                <h1 class="text-2xl font-bold text-blue-600">Medilab</h1>
            </a>

            <nav class="w-full md:w-auto">
                <ul class="flex flex-col md:flex-row space-y-2 md:space-y-0 md:space-x-8 items-center">
                    <li><a href="<c:url value="/Home.jsp"/>" class="text-gray-600 hover:text-blue-600">Trang Chủ</a></li>
                    <li><a href="<c:url value="/patient-queue?action=public-view"/>" class="text-blue-600 font-medium">Hàng Đợi</a></li>
                    <li><a href="#statistics" class="text-gray-600 hover:text-blue-600">Thống Kê</a></li>
                </ul>
            </nav>

            <a class="hidden md:block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition" href="<c:url value="/Login.jsp"/>">Login</a>
        </div>
    </div>
</header>

<main class="queue-container">
    <!-- Header Section -->
    <div class="queue-header">
        <h1 class="text-2xl md:text-3xl font-bold"><i class="fas fa-users-medical mr-2"></i> Màn Hình Chờ Khám Bệnh</h1>
        <!-- Date and Time Display -->
        <div class="bg-white rounded-lg p-4 mb-6 shadow-sm">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                <div class="text-lg font-semibold text-gray-800">
                    <span id="currentDate"><%= dateFormatter.format(now) %></span>
                </div>
                <div class="text-2xl font-mono font-bold text-blue-600 mt-2 md:mt-0">
                    <span id="currentTime"><%= timeFormatter.format(now) %></span>
                </div>
            </div>
        </div>
    </div>


    <!-- Priority Grid for Top 10 Patients -->
    <div class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800 mb-4">Bệnh Nhân Ưu Tiên</h2>
        <div class="priority-grid">
            <c:forEach var="queueDetail" items="${queueDetails}" varStatus="status">
                <c:if test="${status.index < 10}">
                    <c:choose>
                        <c:when test="${queueDetail.queue.status == 'In Consultation'}">
                            <!-- Current Patient -->
                            <div class="priority-card">
                                <div class="card-header">
                                    <div class="queue-number-large">#${queueDetail.queue.queueNumber}</div>
                                    <span class="priority-badge urgent">Khẩn Cấp</span>
                                </div>
                                <div class="patient-name-large">${queueDetail.patient.fullName}</div>
                                <div>
                                    <span class="status-badge-large status-in-consultation">Đang Khám</span>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${queueDetail.queue.status == 'Ready for Follow-up'}">
                            <!-- Ready for Follow-up Patient -->
                            <div class="priority-card">
                                <div class="card-header">
                                    <div class="queue-number-large">#${queueDetail.queue.queueNumber}</div>
                                </div>
                                <div class="patient-name-large">${queueDetail.patient.fullName}</div>
                                <div>
                                    <span class="status-badge-large status-ready-followup">Sẵn Sàng Khám Lại</span>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${queueDetail.queue.status == 'Awaiting Lab Results'}">
                            <!-- Awaiting Lab Results Patient -->
                            <div class="priority-card">
                                <div class="card-header">
                                    <div class="queue-number-large">#${queueDetail.queue.queueNumber}</div>
                                </div>
                                <div class="patient-name-large">${queueDetail.patient.fullName}</div>
                                <div>
                                    <span class="status-badge-large status-awaiting-lab">Chờ Xét Nghiệm</span>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${queueDetail.queue.status == 'Waiting'}">
                            <!-- Waiting Patient -->
                            <div class="priority-card">
                                <div class="card-header">
                                    <div class="queue-number-large">#${queueDetail.queue.queueNumber}</div>
                                </div>
                                <div class="patient-name-large">${queueDetail.patient.fullName}</div>
                                <div>
                                    <span class="status-badge-large status-waiting">Đang Chờ</span>
                                </div>
                            </div>
                        </c:when>
                    </c:choose>
                </c:if>
            </c:forEach>
        </div>
    </div>

    <!-- Remaining Patients Table -->
    <div class="queue-list">
        <div class="queue-list-header">
            <div>STT</div>
            <div>Họ Tên Bệnh Nhân</div>
            <div>Trạng Thái</div>
            <div>Ưu Tiên</div>
            <div>Thời Gian</div>
        </div>

        <c:forEach var="queueDetail" items="${queueDetails}" varStatus="status">
            <c:if test="${status.index >= 10}">
                <c:choose>
                    <c:when test="${queueDetail.queue.status == 'In Consultation'}">
                        <!-- Current Patient -->
                        <div class="queue-item current-patient">
                            <div class="queue-number">#${queueDetail.queue.queueNumber}</div>
                            <div class="patient-name">${queueDetail.patient.fullName}</div>
                            <div>
                                <span class="status-badge status-in-consultation">Đang Khám</span>
                            </div>
                            <div>
                                <span class="priority-badge urgent">Khẩn Cấp</span>
                            </div>
                            <div class="text-gray-600 text-sm">${queueDetail.queue.checkInTime}</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Other Patients -->
                        <div class="queue-item">
                            <div class="queue-number">#${queueDetail.queue.queueNumber}</div>
                            <div class="patient-name">${queueDetail.patient.fullName}</div>
                            <div>
                                <c:choose>
                                    <c:when test="${queueDetail.queue.status == 'Waiting'}">
                                        <span class="status-badge status-waiting">Đang Chờ</span>
                                    </c:when>
                                    <c:when test="${queueDetail.queue.status == 'Awaiting Lab Results'}">
                                        <span class="status-badge status-awaiting-lab">Chờ Xét Nghiệm</span>
                                    </c:when>
                                    <c:when test="${queueDetail.queue.status == 'Ready for Follow-up'}">
                                        <span class="status-badge status-ready-followup">Sẵn Sàng Khám Lại</span>
                                    </c:when>
                                    <c:when test="${queueDetail.queue.status == 'Completed'}">
                                        <span class="status-badge status-completed">Hoàn Tất</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-waiting">${queueDetail.queue.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${queueDetail.queue.status == 'Ready for Follow-up'}">
                                        <span class="priority-badge high">Ưu Tiên Cao</span>
                                    </c:when>
                                    <c:when test="${queueDetail.queue.status == 'Awaiting Lab Results'}">
                                        <span class="priority-badge medium">Ưu Tiên Trung Bình</span>
                                    </c:when>
                                    <c:when test="${queueDetail.queue.status == 'Waiting'}">
                                        <span class="priority-badge low">Ưu Tiên Thấp</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="priority-badge low">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-gray-600 text-sm">${queueDetail.queue.checkInTime}</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </c:forEach>
    </div>

    <!-- Refresh Button -->
    <div class="mt-6 text-center">
        <button onclick="refreshPage()"
                class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-6 rounded-lg transition duration-300 flex items-center justify-center mx-auto">
            <i class="fas fa-sync-alt mr-2"></i>
            Làm mới thông tin (Tự động làm mới sau <span id="countdown">30</span> giây)
        </button>
    </div>

    <!-- Information Section -->
    <div class="mt-8 bg-white rounded-lg p-6 shadow-sm">
        <h2 class="text-xl font-bold text-gray-800 mb-4">Hướng dẫn cho bệnh nhân</h2>

        <div class="grid md:grid-cols-2 gap-4">
            <div class="flex items-start space-x-3">
                <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                    <i class="fas fa-bell text-blue-600"></i>
                </div>
                <div>
                    <h3 class="font-medium text-gray-800">Lắng nghe thông báo</h3>
                    <p class="text-gray-600 text-sm mt-1">Khi đến lượt, tên bạn sẽ được gọi qua loa thông báo. Vui lòng
                        lắng nghe và đến phòng khám khi được gọi.</p>
                </div>
            </div>

            <div class="flex items-start space-x-3">
                <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                    <i class="fas fa-chair text-blue-600"></i>
                </div>
                <div>
                    <h3 class="font-medium text-gray-800">Giữ khoảng cách</h3>
                    <p class="text-gray-600 text-sm mt-1">Vui lòng ngồi cách nhau ít nhất 2 ghế để đảm bảo khoảng cách
                        an toàn.</p>
                </div>
            </div>

            <div class="flex items-start space-x-3">
                <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                    <i class="fas fa-head-side-mask text-blue-600"></i>
                </div>
                <div>
                    <h3 class="font-medium text-gray-800">Đeo khẩu trang</h3>
                    <p class="text-gray-600 text-sm mt-1">Luôn đeo khẩu trang trong suốt thời gian chờ đợi tại phòng
                        khám.</p>
                </div>
            </div>

            <div class="flex items-start space-x-3">
                <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                    <i class="fas fa-mobile-alt text-blue-600"></i>
                </div>
                <div>
                    <h3 class="font-medium text-gray-800">Giữ điện thoại sẵn sàng</h3>
                    <p class="text-gray-600 text-sm mt-1">Vui lòng giữ điện thoại ở chế độ âm lượng cao để nhận được
                        thông báo khi đến lượt.</p>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="bg-gray-100 py-6 mt-10">
    <div class="container mx-auto text-center text-gray-600">
        <p>© <span>Copyright</span> <strong class="px-1">Medilab</strong> <span>All Rights Reserved</span></p>
    </div>
</footer>

<script>
    // Update current time every second
    function updateTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('vi-VN', {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: false
        });
        document.getElementById('currentTime').textContent = timeString;

        const dateString = now.toLocaleDateString('vi-VN', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
        document.getElementById('currentDate').textContent = dateString;
    }

    // Refresh page function
    function refreshPage() {
        location.reload();
    }

    // Countdown for auto-refresh
    let countdown = 30;
    const countdownElement = document.getElementById('countdown');

    function updateCountdown() {
        countdown--;
        countdownElement.textContent = countdown;

        if (countdown <= 0) {
            refreshPage();
        }
    }

    // Initialize time on load
    updateTime();

    // Update time every second
    setInterval(updateTime, 1000);

    // Update countdown every second
    setInterval(updateCountdown, 1000);

    // Auto refresh every 30 seconds
    setInterval(refreshPage, 30000);
</script>
</body>
</html>