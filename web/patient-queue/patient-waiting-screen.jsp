<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="entity.User" %>
<%@ page import="entity.Patient" %>
<%@ page import="entity.PatientQueue" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User acc = (User) session.getAttribute("acc");
    if (acc == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    // Get current date and time
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");

    // Mock data for patient queue information - in real implementation, this would come from database
    String patientName = acc.getUsername(); // Using username as patient name for demo
    String patientId = "BN001"; // This would come from database
    String queueNumber = "#005"; // Current queue number
    int positionInQueue = 5; // Current position

    String assignedDoctor = "BS. Nguyễn Văn An"; // Assigned doctor
    String currentStatus = "waiting"; // waiting, in-consultation, ready
    String nextStep = "Vui lòng chờ đến lượt của bạn. Chúng tôi sẽ gọi tên khi đến lượt.";
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
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Vendor CSS Files -->
    <link href="<c:url value="/assets/vendor/fontawesome-free/css/all.min.css"/>" rel="stylesheet">

    <!-- Main CSS File -->
    <link href="<c:url value="/assets/css/main.css"/>" rel="stylesheet">

    <!-- Tailwind CSS -->
    <script src="<c:url value="/assets/vendor/tailwindv4/tailwind.min.js"/>"></script>

    <style>
        body {
            font-family: 'Inter', sans-serif;
        }

        .patient-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .status-card {
            transition: all 0.3s ease;
        }

        .status-card:hover {
            transform: translateY(-2px);
        }

        .pulse-animation {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }

        .waiting-pulse {
            animation: waitingPulse 3s infinite;
        }

        @keyframes waitingPulse {
            0%, 100% {
                box-shadow: 0 0 0 0 rgba(251, 191, 36, 0.7);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(251, 191, 36, 0);
            }
        }

        .refresh-button {
            transition: all 0.3s ease;
        }

        .refresh-button:hover {
            transform: rotate(180deg);
        }
    </style>
</head>
<body>
    <div class="patient-container">
        <!-- Header -->
        <header class="bg-white/10 backdrop-blur-md border-b border-white/20">
            <div class="container mx-auto px-4 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-3">
                        <div class="w-10 h-10 bg-white rounded-full flex items-center justify-center">
                            <i class="fas fa-hospital text-blue-600 text-lg"></i>
                        </div>
                        <div>
                            <h1 class="text-white text-xl font-bold">Medilab</h1>
                            <p class="text-white/80 text-sm">Hệ thống bệnh viện</p>
                        </div>
                    </div>

                    <div class="text-white text-right">
                        <div class="text-sm opacity-80">Hôm nay</div>
                        <div class="font-semibold"><%= dateFormatter.format(now) %></div>
                        <div class="text-lg font-mono" id="currentTime"><%= timeFormatter.format(now) %></div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="container mx-auto px-4 py-8">
            <div class="max-w-4xl mx-auto">

                <!-- Welcome Section -->
                <div class="text-center mb-8">
                    <h2 class="text-3xl md:text-4xl font-bold text-white mb-2">
                        Xin chào, <%= patientName %>!
                    </h2>
                    <p class="text-white/90 text-lg">
                        Cảm ơn bạn đã kiên nhẫn chờ đợi
                    </p>
                </div>

                <!-- Status Cards Grid -->
                <div class="grid md:grid-cols-2 gap-6 mb-8">

                    <!-- Queue Position Card -->
                    <div class="status-card bg-white rounded-2xl p-6 shadow-xl">
                        <div class="flex items-center justify-between mb-4">
                            <h3 class="text-lg font-semibold text-gray-800">Vị trí trong hàng đợi</h3>
                            <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-list-ol text-blue-600 text-xl"></i>
                            </div>
                        </div>
                        <div class="text-center">
                            <div class="text-4xl md:text-5xl font-bold text-blue-600 mb-2">
                                <%= queueNumber %>
                            </div>
                            <p class="text-gray-600">Số thứ tự của bạn</p>
                            <div class="mt-3 inline-flex items-center px-3 py-1 bg-blue-50 text-blue-700 rounded-full text-sm font-medium">
                                <i class="fas fa-users mr-2"></i>
                                Còn <%= positionInQueue %> bệnh nhân trước bạn
                            </div>
                        </div>
                    </div>


                </div>

                <!-- Doctor Information Card -->
                <div class="status-card bg-white rounded-2xl p-6 shadow-xl mb-8">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-800">Thông tin bác sĩ</h3>
                        <div class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center">
                            <i class="fas fa-user-md text-purple-600 text-xl"></i>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4">
                        <div class="w-16 h-16 bg-gradient-to-br from-purple-400 to-purple-600 rounded-full flex items-center justify-center">
                            <i class="fas fa-user-md text-white text-2xl"></i>
                        </div>
                        <div>
                            <div class="text-xl font-bold text-gray-800 mb-1">
                                <%= assignedDoctor %>
                            </div>
                            <div class="text-gray-600 mb-2">Bác sĩ điều trị</div>
                            <div class="flex items-center text-sm text-gray-500">
                                <i class="fas fa-map-marker-alt mr-1"></i>
                                Phòng khám số 201
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Current Status Card -->
                <div class="status-card bg-white rounded-2xl p-6 shadow-xl mb-8">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-800">Trạng thái hiện tại</h3>
                        <div class="w-12 h-12 bg-yellow-100 rounded-full flex items-center justify-center">
                            <i class="fas fa-info-circle text-yellow-600 text-xl"></i>
                        </div>
                    </div>

                    <% if ("waiting".equals(currentStatus)) { %>
                        <div class="text-center">
                            <div class="waiting-pulse w-20 h-20 bg-yellow-400 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-clock text-white text-3xl"></i>
                            </div>
                            <h4 class="text-2xl font-bold text-gray-800 mb-2">Đang chờ khám</h4>
                            <p class="text-gray-600 mb-4">Vui lòng kiên nhẫn chờ đến lượt của bạn</p>
                            <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                                <div class="flex items-start space-x-3">
                                    <i class="fas fa-lightbulb text-yellow-600 mt-1"></i>
                                    <div class="text-left">
                                        <div class="font-medium text-yellow-800 mb-1">Lưu ý quan trọng:</div>
                                        <p class="text-yellow-700 text-sm">
                                            <%= nextStep %>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } else if ("in-consultation".equals(currentStatus)) { %>
                        <div class="text-center">
                            <div class="w-20 h-20 bg-green-400 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-stethoscope text-white text-3xl"></i>
                            </div>
                            <h4 class="text-2xl font-bold text-gray-800 mb-2">Đang được khám</h4>
                            <p class="text-gray-600 mb-4">Bác sĩ đang khám cho bạn</p>
                            <div class="bg-green-50 border border-green-200 rounded-lg p-4">
                                <div class="flex items-start space-x-3">
                                    <i class="fas fa-check-circle text-green-600 mt-1"></i>
                                    <div class="text-left">
                                        <div class="font-medium text-green-800 mb-1">Tiếp theo:</div>
                                        <p class="text-green-700 text-sm">
                                            Vui lòng trả lời câu hỏi của bác sĩ một cách chi tiết và trung thực.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } else if ("ready".equals(currentStatus)) { %>
                        <div class="text-center">
                            <div class="w-20 h-20 bg-blue-400 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-bell text-white text-3xl"></i>
                            </div>
                            <h4 class="text-2xl font-bold text-gray-800 mb-2">Đến lượt bạn!</h4>
                            <p class="text-gray-600 mb-4">Vui lòng vào phòng khám ngay</p>
                            <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
                                <div class="flex items-start space-x-3">
                                    <i class="fas fa-arrow-right text-blue-600 mt-1"></i>
                                    <div class="text-left">
                                        <div class="font-medium text-blue-800 mb-1">Hướng dẫn:</div>
                                        <p class="text-blue-700 text-sm">
                                            Vui lòng vào phòng khám số 201 và gặp <%= assignedDoctor %>.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Instructions Card -->
                <div class="status-card bg-white rounded-2xl p-6 shadow-xl mb-8">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-800">Hướng dẫn cho bệnh nhân</h3>
                        <div class="w-12 h-12 bg-indigo-100 rounded-full flex items-center justify-center">
                            <i class="fas fa-clipboard-list text-indigo-600 text-xl"></i>
                        </div>
                    </div>

                    <div class="space-y-4">
                        <div class="flex items-start space-x-3">
                            <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                                <span class="text-blue-600 font-bold text-sm">1</span>
                            </div>
                            <div>
                                <h4 class="font-medium text-gray-800">Giữ khoảng cách an toàn</h4>
                                <p class="text-gray-600 text-sm">Vui lòng giữ khoảng cách tối thiểu 2m với bệnh nhân khác</p>
                            </div>
                        </div>

                        <div class="flex items-start space-x-3">
                            <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                                <span class="text-blue-600 font-bold text-sm">2</span>
                            </div>
                            <div>
                                <h4 class="font-medium text-gray-800">Đeo khẩu trang</h4>
                                <p class="text-gray-600 text-sm">Luôn đeo khẩu trang trong suốt thời gian chờ đợi</p>
                            </div>
                        </div>

                        <div class="flex items-start space-x-3">
                            <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                                <span class="text-blue-600 font-bold text-sm">3</span>
                            </div>
                            <div>
                                <h4 class="font-medium text-gray-800">Chuẩn bị giấy tờ</h4>
                                <p class="text-gray-600 text-sm">Chuẩn bị sẵn thẻ BHYT và giấy tờ tùy thân</p>
                            </div>
                        </div>

                        <div class="flex items-start space-x-3">
                            <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                                <span class="text-blue-600 font-bold text-sm">4</span>
                            </div>
                            <div>
                                <h4 class="font-medium text-gray-800">Lắng nghe thông báo</h4>
                                <p class="text-gray-600 text-sm">Lắng nghe loa thông báo khi gọi tên bạn</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
                    <button onclick="refreshPage()"
                            class="refresh-button bg-white text-gray-800 px-6 py-3 rounded-xl font-medium hover:bg-gray-50 transition-all duration-300 flex items-center space-x-2 shadow-lg">
                        <i class="fas fa-sync-alt"></i>
                        <span>Làm mới thông tin</span>
                    </button>

                    <a href="<c:url value="/patient-queue/checkin-form.jsp"/>"
                       class="bg-white text-gray-800 px-6 py-3 rounded-xl font-medium hover:bg-gray-50 transition-all duration-300 flex items-center space-x-2 shadow-lg">
                        <i class="fas fa-edit"></i>
                        <span>Cập nhật thông tin</span>
                    </a>

                    <button onclick="showHelp()"
                            class="bg-transparent border-2 border-white text-white px-6 py-3 rounded-xl font-medium hover:bg-white hover:text-gray-800 transition-all duration-300 flex items-center space-x-2">
                        <i class="fas fa-question-circle"></i>
                        <span>Trợ giúp</span>
                    </button>
                </div>

                <!-- Footer Info -->
                <div class="text-center mt-8">
                    <p class="text-white/80 text-sm">
                        Nếu bạn cần hỗ trợ khẩn cấp, vui lòng liên hệ quầy tiếp tân
                    </p>
                    <div class="flex items-center justify-center space-x-4 mt-2 text-white/60 text-sm">
                        <span class="flex items-center">
                            <i class="fas fa-phone mr-1"></i>
                            (028) 1234-5678
                        </span>
                        <span class="flex items-center">
                            <i class="fas fa-clock mr-1"></i>
                            Hoạt động 24/7
                        </span>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Help Modal -->
    <div id="helpModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-white rounded-2xl p-6 m-4 max-w-md w-full">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-xl font-bold text-gray-800">Trợ giúp</h3>
                <button onclick="closeHelp()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>

            <div class="space-y-4">
                <div class="p-4 bg-blue-50 rounded-lg">
                    <h4 class="font-medium text-blue-800 mb-2">Câu hỏi thường gặp</h4>
                    <div class="space-y-2 text-sm text-blue-700">
                        <div><strong>Q:</strong> Thời gian chờ có chính xác không?</div>
                        <div><strong>A:</strong> Thời gian chỉ là ước tính và có thể thay đổi.</div>

                        <div class="mt-3"><strong>Q:</strong> Tôi có thể rời khỏi hàng đợi không?</div>
                        <div><strong>A:</strong> Bạn có thể rời đi nhưng sẽ mất vị trí hiện tại.</div>

                        <div class="mt-3"><strong>Q:</strong> Làm thế nào để thay đổi thông tin?</div>
                        <div><strong>A:</strong> Liên hệ quầy tiếp tân để được hỗ trợ.</div>
                    </div>
                </div>

                <div class="p-4 bg-green-50 rounded-lg">
                    <h4 class="font-medium text-green-800 mb-2">Liên hệ khẩn cấp</h4>
                    <div class="text-sm text-green-700">
                        <p><strong>Điện thoại:</strong> (028) 1234-5678</p>
                        <p><strong>Email:</strong> support@medilab.vn</p>
                        <p><strong>Địa chỉ:</strong> 123 Đường ABC, Quận XYZ</p>
                    </div>
                </div>
            </div>

            <div class="mt-6 text-center">
                <button onclick="closeHelp()"
                        class="bg-blue-600 text-white px-6 py-2 rounded-lg font-medium hover:bg-blue-700 transition">
                    Đã hiểu
                </button>
            </div>
        </div>
    </div>

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
        }

        // Refresh page function
        function refreshPage() {
            location.reload();
        }

        // Show help modal
        function showHelp() {
            document.getElementById('helpModal').classList.remove('hidden');
        }

        // Close help modal
        function closeHelp() {
            document.getElementById('helpModal').classList.add('hidden');
        }

        // Auto refresh every 30 seconds
        setInterval(refreshPage, 30000);

        // Update time every second
        setInterval(updateTime, 1000);

        // Initialize time on load
        updateTime();

        // Add click outside modal to close
        document.getElementById('helpModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeHelp();
            }
        });

        // Add keyboard navigation
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeHelp();
            }
        });
    </script>
</body>
</html>