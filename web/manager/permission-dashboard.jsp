<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, entity.User, entity.Role, entity.Permission"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển quản lý quyền | Medilab Clinic</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <jsp:include page="../includes/head-includes.jsp"/>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3fbbc0;
            --sidebar-width: 280px;
        }
        
        body {
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .main-wrapper {
            display: flex;
            min-height: 100vh;
            padding-top: 0px;
        }
        
        .sidebar-fixed {
            position: fixed;
            top: 115px;
            left: 0;
            width: var(--sidebar-width);
            height: calc(100vh - 70px);
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            overflow-y: auto;
            z-index: 1000;
        }
        
        .content-area {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 30px;
            min-height: calc(100vh - 70px);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in {
            animation: fadeIn 0.5s ease-out;
        }
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .card-hover {
            transition: all 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="../includes/header.jsp"/>
    
    <div class="main-wrapper">
        <!-- Sidebar -->
        <%@ include file="../includes/sidebar-manager.jsp" %>

        <!-- Main Content Area -->
        <div class="content-area">
            <!-- Header Section -->
            <div class="gradient-bg text-white py-8 mb-10 shadow-2xl rounded-3">
                <div class="container-fluid px-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <h1 class="display-5 fw-bold mb-2">
                                <i class="fas fa-shield-alt me-3"></i>Bảng điều khiển quản lý quyền
                            </h1>
                            <p class="text-light fs-5 mb-0">Quản lý toàn diện hệ thống phân quyền</p>
                        </div>
                        <div class="text-end">
                            <p class="small text-light mb-1">Xin chào, <span class="fw-semibold">${sessionScope.user.username}</span></p>
                            <p class="small text-light mb-0">Vai trò: ${sessionScope.user.roleName}</p>
                        </div>
                    </div>
                </div>
            </div>

    <!-- Navigation Breadcrumb -->
    <div class="container mx-auto px-4 mb-6">
        <nav class="flex" aria-label="Breadcrumb">
            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                <li class="inline-flex items-center">
                    <a href="${pageContext.request.contextPath}/Home.jsp" class="text-gray-700 hover:text-blue-600">
                        <i class="fas fa-home mr-2"></i>Trang chủ
                    </a>
                </li>
                <li>
                    <div class="flex items-center">
                        <i class="fas fa-chevron-right text-gray-400 mx-2"></i>
                        <span class="text-gray-500">Quản lý quyền</span>
                    </div>
                </li>
            </ol>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 pb-10">
        <div class="max-w-7xl mx-auto">
            
            <!-- Quick Stats -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8 animate-fade-in">
                <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-blue-500 card-hover">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500 text-sm font-medium">Tổng quyền</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1" id="totalPermissions">-</p>
                        </div>
                        <div class="bg-blue-100 p-3 rounded-full">
                            <i class="fas fa-key text-blue-600 text-xl"></i>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-green-500 card-hover">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500 text-sm font-medium">Vai trò hoạt động</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1" id="activeRoles">-</p>
                        </div>
                        <div class="bg-green-100 p-3 rounded-full">
                            <i class="fas fa-users text-green-600 text-xl"></i>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-yellow-500 card-hover">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500 text-sm font-medium">Người dùng có quyền</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1" id="usersWithPermissions">-</p>
                        </div>
                        <div class="bg-yellow-100 p-3 rounded-full">
                            <i class="fas fa-user-shield text-yellow-600 text-xl"></i>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-red-500 card-hover">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500 text-sm font-medium">Hoạt động hôm nay</p>
                            <p class="text-3xl font-bold text-gray-800 mt-1" id="todayActivities">-</p>
                        </div>
                        <div class="bg-red-100 p-3 rounded-full">
                            <i class="fas fa-chart-line text-red-600 text-xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Management Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                
                <!-- Permission Management -->
                <div class="bg-white rounded-xl shadow-lg p-6 card-hover">
                    <div class="text-center">
                        <div class="bg-blue-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-key text-blue-600 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-800 mb-2">Quản lý quyền</h3>
                        <p class="text-gray-600 mb-4">Tạo, chỉnh sửa và quản lý các quyền trong hệ thống</p>
                        <a href="${pageContext.request.contextPath}/permission-management?action=listPermissions" 
                           class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition duration-300">
                            <i class="fas fa-cog mr-2"></i>Quản lý
                        </a>
                    </div>
                </div>

                <!-- Role Permission Management -->
                <div class="bg-white rounded-xl shadow-lg p-6 card-hover">
                    <div class="text-center">
                        <div class="bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-users-cog text-green-600 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-800 mb-2">Quyền vai trò</h3>
                        <p class="text-gray-600 mb-4">Phân quyền cho các vai trò trong hệ thống</p>
                        <a href="${pageContext.request.contextPath}/permission-management?action=rolePermissions" 
                           class="bg-green-600 text-white px-6 py-2 rounded-lg hover:bg-green-700 transition duration-300">
                            <i class="fas fa-user-tag mr-2"></i>Phân quyền
                        </a>
                    </div>
                </div>

                <!-- User Permission Management -->
                <div class="bg-white rounded-xl shadow-lg p-6 card-hover">
                    <div class="text-center">
                        <div class="bg-purple-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-user-shield text-purple-600 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-800 mb-2">Quyền người dùng</h3>
                        <p class="text-gray-600 mb-4">Phân quyền cá nhân cho từng người dùng</p>
                        <a href="${pageContext.request.contextPath}/permission-management?action=userPermissions" 
                           class="bg-purple-600 text-white px-6 py-2 rounded-lg hover:bg-purple-700 transition duration-300">
                            <i class="fas fa-user-plus mr-2"></i>Phân quyền
                        </a>
                    </div>
                </div>

                <!-- Audit Logs -->
                <div class="bg-white rounded-xl shadow-lg p-6 card-hover">
                    <div class="text-center">
                        <div class="bg-yellow-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-history text-yellow-600 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-800 mb-2">Nhật ký kiểm toán</h3>
                        <p class="text-gray-600 mb-4">Xem lịch sử thay đổi quyền và hoạt động</p>
                        <a href="${pageContext.request.contextPath}/permission-management?action=auditLogs" 
                           class="bg-yellow-600 text-white px-6 py-2 rounded-lg hover:bg-yellow-700 transition duration-300">
                            <i class="fas fa-search mr-2"></i>Xem nhật ký
                        </a>
                    </div>
                </div>

                <!-- Permission Check -->
                <div class="bg-white rounded-xl shadow-lg p-6 card-hover">
                    <div class="text-center">
                        <div class="bg-indigo-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-search text-indigo-600 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-800 mb-2">Kiểm tra quyền</h3>
                        <p class="text-gray-600 mb-4">Kiểm tra quyền của người dùng hoặc vai trò</p>
                        <a href="${pageContext.request.contextPath}/permission-management?action=checkPermissions" 
                           class="bg-indigo-600 text-white px-6 py-2 rounded-lg hover:bg-indigo-700 transition duration-300">
                            <i class="fas fa-check-circle mr-2"></i>Kiểm tra
                        </a>
                    </div>
                </div>

                <!-- System Settings -->
                <div class="bg-white rounded-xl shadow-lg p-6 card-hover">
                    <div class="text-center">
                        <div class="bg-red-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-cogs text-red-600 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-800 mb-2">Cài đặt hệ thống</h3>
                        <p class="text-gray-600 mb-4">Cấu hình các thiết lập bảo mật và quyền</p>
                        <a href="${pageContext.request.contextPath}/permission-management?action=systemSettings" 
                           class="bg-red-600 text-white px-6 py-2 rounded-lg hover:bg-red-700 transition duration-300">
                            <i class="fas fa-wrench mr-2"></i>Cài đặt
                        </a>
                    </div>
                </div>
            </div>

            <!-- Recent Activities -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
                <div class="flex items-center justify-between mb-6">
                    <h3 class="text-xl font-bold text-gray-800">
                        <i class="fas fa-clock mr-2 text-blue-600"></i>Hoạt động gần đây
                    </h3>
                    <a href="${pageContext.request.contextPath}/permission-management?action=auditLogs" 
                       class="text-blue-600 hover:text-blue-800 text-sm">
                        Xem tất cả <i class="fas fa-arrow-right ml-1"></i>
                    </a>
                </div>
                <div id="recentActivities" class="space-y-4">
                    <!-- Activities will be loaded here via AJAX -->
                    <div class="text-center text-gray-500 py-8">
                        <i class="fas fa-spinner fa-spin text-2xl mb-2"></i>
                        <p>Đang tải hoạt động gần đây...</p>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-xl font-bold text-gray-800 mb-6">
                    <i class="fas fa-bolt mr-2 text-yellow-600"></i>Thao tác nhanh
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                    <button onclick="showCreatePermissionModal()" 
                            class="bg-blue-50 border border-blue-200 rounded-lg p-4 text-center hover:bg-blue-100 transition duration-300">
                        <i class="fas fa-plus text-blue-600 text-xl mb-2"></i>
                        <p class="text-blue-800 font-medium">Tạo quyền mới</p>
                    </button>
                    
                    <button onclick="showBulkAssignModal()" 
                            class="bg-green-50 border border-green-200 rounded-lg p-4 text-center hover:bg-green-100 transition duration-300">
                        <i class="fas fa-users text-green-600 text-xl mb-2"></i>
                        <p class="text-green-800 font-medium">Phân quyền hàng loạt</p>
                    </button>
                    
                    <button onclick="exportPermissions()" 
                            class="bg-purple-50 border border-purple-200 rounded-lg p-4 text-center hover:bg-purple-100 transition duration-300">
                        <i class="fas fa-download text-purple-600 text-xl mb-2"></i>
                        <p class="text-purple-800 font-medium">Xuất báo cáo</p>
                    </button>
                    
                    <button onclick="showPermissionAnalytics()" 
                            class="bg-orange-50 border border-orange-200 rounded-lg p-4 text-center hover:bg-orange-100 transition duration-300">
                        <i class="fas fa-chart-bar text-orange-600 text-xl mb-2"></i>
                        <p class="text-orange-800 font-medium">Phân tích quyền</p>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Load dashboard data
        document.addEventListener('DOMContentLoaded', function() {
            loadDashboardStats();
            loadRecentActivities();
        });

        function loadDashboardStats() {
            fetch('${pageContext.request.contextPath}/permission-management?action=getDashboardStats')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('totalPermissions').textContent = data.totalPermissions || '0';
                    document.getElementById('activeRoles').textContent = data.activeRoles || '0';
                    document.getElementById('usersWithPermissions').textContent = data.usersWithPermissions || '0';
                    document.getElementById('todayActivities').textContent = data.todayActivities || '0';
                })
                .catch(error => {
                    console.error('Error loading dashboard stats:', error);
                });
        }

        function loadRecentActivities() {
            fetch('${pageContext.request.contextPath}/permission-management?action=getRecentActivities&limit=5')
                .then(response => response.json())
                .then(data => {
                    const container = document.getElementById('recentActivities');
                    if (data.activities && data.activities.length > 0) {
                        container.innerHTML = data.activities.map(activity => `
                            <div class="flex items-center p-4 bg-gray-50 rounded-lg">
                                <div class="flex-shrink-0 w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                                    <i class="fas fa-\${getActivityIcon(activity.actionType)} text-blue-600"></i>
                                </div>
                                <div class="ml-4 flex-1">
                                    <p class="text-sm font-medium text-gray-900">\${activity.description}</p>
                                    <p class="text-xs text-gray-500">bởi \${activity.username} • \${formatDate(activity.createdDate)}</p>
                                </div>
                            </div>
                        `).join('');
                    } else {
                        container.innerHTML = `
                            <div class="text-center text-gray-500 py-8">
                                <i class="fas fa-inbox text-2xl mb-2"></i>
                                <p>Chưa có hoạt động nào</p>
                            </div>
                        `;
                    }
                })
                .catch(error => {
                    console.error('Error loading recent activities:', error);
                    document.getElementById('recentActivities').innerHTML = `
                        <div class="text-center text-red-500 py-8">
                            <i class="fas fa-exclamation-triangle text-2xl mb-2"></i>
                            <p>Lỗi khi tải hoạt động gần đây</p>
                        </div>
                    `;
                });
        }

        function getActivityIcon(actionType) {
            const icons = {
                'GRANT': 'plus',
                'REVOKE': 'minus',
                'CREATE': 'plus-circle',
                'UPDATE': 'edit',
                'DELETE': 'trash',
                'ACCESS': 'eye'
            };
            return icons[actionType] || 'info';
        }

        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN');
        }

        // Quick action functions
        function showCreatePermissionModal() {
            // Implementation for create permission modal
            alert('Chức năng tạo quyền mới sẽ được triển khai');
        }

        function showBulkAssignModal() {
            // Implementation for bulk assign modal
            alert('Chức năng phân quyền hàng loạt sẽ được triển khai');
        }

        function exportPermissions() {
            // Implementation for export functionality
            window.open('${pageContext.request.contextPath}/permission-management?action=export', '_blank');
        }

        function showPermissionAnalytics() {
            // Implementation for analytics modal
            alert('Chức năng phân tích quyền sẽ được triển khai');
        }
    </script>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="../includes/footer.jsp"/>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>