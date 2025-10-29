<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, entity.AuditLog"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhật ký kiểm toán | Medilab Clinic</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <jsp:include page="../includes/head-includes.jsp"/>
    
    <script src="https://cdn.tailwindcss.com"></script>
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
        .log-card {
            transition: all 0.3s ease;
        }
        .log-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .action-grant {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }
        .action-revoke {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        }
        .action-create {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
        }
        .action-update {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        }
        .action-delete {
            background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
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
            <div class="gradient-bg text-white py-6 mb-8 shadow-xl rounded-3">
                <div class="container-fluid px-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <h1 class="display-6 fw-bold mb-2">
                                <i class="fas fa-clipboard-list me-3"></i>Nhật ký kiểm toán
                            </h1>
                            <p class="text-light mb-0">Theo dõi các hoạt động và thay đổi quyền trong hệ thống</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/manager/permission-dashboard.jsp" 
                           class="btn btn-light btn-sm">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </div>
            </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 pb-10">
        <div class="max-w-7xl mx-auto">
            
            <!-- Filters and Controls -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8 animate-fade-in">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
                    <div>
                        <label for="actionTypeFilter" class="block text-sm font-medium text-gray-700 mb-2">
                            Loại hành động:
                        </label>
                        <select id="actionTypeFilter" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                                onchange="filterLogs()">
                            <option value="">-- Tất cả --</option>
                            <option value="GRANT_PERMISSION">Cấp quyền</option>
                            <option value="REVOKE_PERMISSION">Thu hồi quyền</option>
                            <option value="CREATE_USER">Tạo người dùng</option>
                            <option value="UPDATE_USER">Cập nhật người dùng</option>
                            <option value="DELETE_USER">Xóa người dùng</option>
                            <option value="CREATE_ROLE">Tạo vai trò</option>
                            <option value="UPDATE_ROLE">Cập nhật vai trò</option>
                            <option value="DELETE_ROLE">Xóa vai trò</option>
                        </select>
                    </div>
                    
                    <div>
                        <label for="userFilter" class="block text-sm font-medium text-gray-700 mb-2">
                            Người thực hiện:
                        </label>
                        <input type="text" id="userFilter" placeholder="Tên người dùng..." 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                               onkeyup="filterLogs()">
                    </div>
                    
                    <div>
                        <label for="dateFromFilter" class="block text-sm font-medium text-gray-700 mb-2">
                            Từ ngày:
                        </label>
                        <input type="date" id="dateFromFilter" 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                               onchange="filterLogs()">
                    </div>
                    
                    <div>
                        <label for="dateToFilter" class="block text-sm font-medium text-gray-700 mb-2">
                            Đến ngày:
                        </label>
                        <input type="date" id="dateToFilter" 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                               onchange="filterLogs()">
                    </div>
                </div>
                
                <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <div class="flex items-center space-x-4">
                        <button onclick="refreshLogs()" 
                                class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition duration-300">
                            <i class="fas fa-sync-alt mr-2"></i>Làm mới
                        </button>
                        <button onclick="clearFilters()" 
                                class="bg-gray-600 text-white px-4 py-2 rounded-lg hover:bg-gray-700 transition duration-300">
                            <i class="fas fa-eraser mr-2"></i>Xóa bộ lọc
                        </button>
                    </div>
                    
                    <div class="flex items-center space-x-4">
                        <select id="pageSize" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                                onchange="changePageSize()">
                            <option value="10">10 mục/trang</option>
                            <option value="25" selected>25 mục/trang</option>
                            <option value="50">50 mục/trang</option>
                            <option value="100">100 mục/trang</option>
                        </select>
                        <button onclick="exportLogs()" 
                                class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition duration-300">
                            <i class="fas fa-download mr-2"></i>Xuất Excel
                        </button>
                    </div>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="bg-white rounded-xl shadow-lg p-6 animate-fade-in">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">Tổng hoạt động</p>
                            <p id="totalActivities" class="text-2xl font-bold text-gray-900">0</p>
                        </div>
                        <div class="bg-blue-100 w-12 h-12 rounded-full flex items-center justify-center">
                            <i class="fas fa-chart-line text-blue-600 text-xl"></i>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-lg p-6 animate-fade-in">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">Cấp quyền</p>
                            <p id="grantActivities" class="text-2xl font-bold text-green-600">0</p>
                        </div>
                        <div class="bg-green-100 w-12 h-12 rounded-full flex items-center justify-center">
                            <i class="fas fa-plus-circle text-green-600 text-xl"></i>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-lg p-6 animate-fade-in">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">Thu hồi quyền</p>
                            <p id="revokeActivities" class="text-2xl font-bold text-red-600">0</p>
                        </div>
                        <div class="bg-red-100 w-12 h-12 rounded-full flex items-center justify-center">
                            <i class="fas fa-minus-circle text-red-600 text-xl"></i>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-lg p-6 animate-fade-in">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">Hôm nay</p>
                            <p id="todayActivities" class="text-2xl font-bold text-purple-600">0</p>
                        </div>
                        <div class="bg-purple-100 w-12 h-12 rounded-full flex items-center justify-center">
                            <i class="fas fa-calendar-day text-purple-600 text-xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Audit Logs Table -->
            <div class="bg-white rounded-xl shadow-lg overflow-hidden animate-fade-in">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-800">Danh sách hoạt động</h3>
                </div>
                
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Thời gian
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Hành động
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Người thực hiện
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Đối tượng
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Mô tả
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    IP Address
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Chi tiết
                                </th>
                            </tr>
                        </thead>
                        <tbody id="auditLogsTableBody" class="bg-white divide-y divide-gray-200">
                            <!-- Audit logs will be loaded here -->
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination -->
                <div class="px-6 py-4 border-t border-gray-200 flex items-center justify-between">
                    <div class="text-sm text-gray-700">
                        Hiển thị <span id="showingFrom">0</span> đến <span id="showingTo">0</span> trong tổng số <span id="totalRecords">0</span> bản ghi
                    </div>
                    <div class="flex items-center space-x-2">
                        <button id="prevPageBtn" onclick="changePage(-1)" 
                                class="px-3 py-1 border border-gray-300 rounded-lg text-sm hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <span id="currentPageInfo" class="px-3 py-1 text-sm text-gray-700"></span>
                        <button id="nextPageBtn" onclick="changePage(1)" 
                                class="px-3 py-1 border border-gray-300 rounded-lg text-sm hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <div id="emptyState" class="text-center py-16 hidden">
                <i class="fas fa-clipboard-list text-6xl text-gray-400 mb-6"></i>
                <h3 class="text-xl font-semibold text-gray-600 mb-2">Không có hoạt động nào</h3>
                <p class="text-gray-500">Chưa có hoạt động nào được ghi lại hoặc không có kết quả phù hợp với bộ lọc</p>
            </div>
        </div>
    </div>

    <!-- Log Detail Modal -->
    <div id="logDetailModal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-xl shadow-2xl w-full max-w-2xl max-h-screen overflow-y-auto">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-800">Chi tiết hoạt động</h3>
                </div>
                
                <div class="p-6" id="logDetailContent">
                    <!-- Log details will be loaded here -->
                </div>
                
                <div class="px-6 py-4 border-t border-gray-200 flex justify-end">
                    <button type="button" onclick="closeLogDetailModal()" 
                            class="px-4 py-2 text-gray-700 bg-gray-200 rounded-lg hover:bg-gray-300 transition duration-300">
                        Đóng
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        let allLogs = [];
        let filteredLogs = [];
        let currentPage = 1;
        let pageSize = 25;
        let totalPages = 1;

        // Load data on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadAuditLogs();
            
            // Set default date range (last 30 days)
            const today = new Date();
            const thirtyDaysAgo = new Date(today.getTime() - (30 * 24 * 60 * 60 * 1000));
            
            document.getElementById('dateToFilter').value = today.toISOString().split('T')[0];
            document.getElementById('dateFromFilter').value = thirtyDaysAgo.toISOString().split('T')[0];
        });

        function loadAuditLogs() {
            const params = new URLSearchParams({
                action: 'getAuditLogs',
                page: currentPage,
                pageSize: pageSize
            });

            // Add filters
            const actionType = document.getElementById('actionTypeFilter').value;
            const userFilter = document.getElementById('userFilter').value;
            const dateFrom = document.getElementById('dateFromFilter').value;
            const dateTo = document.getElementById('dateToFilter').value;

            if (actionType) params.append('actionType', actionType);
            if (userFilter) params.append('userFilter', userFilter);
            if (dateFrom) params.append('dateFrom', dateFrom);
            if (dateTo) params.append('dateTo', dateTo);

            fetch(`${pageContext.request.contextPath}/permission-management?${params.toString()}`)
                .then(response => response.json())
                .then(data => {
                    allLogs = data.logs;
                    filteredLogs = allLogs;
                    totalPages = Math.ceil(data.totalCount / pageSize);
                    
                    displayLogs();
                    updateStatistics(data.statistics);
                    updatePagination(data.totalCount);
                    
                    // Show/hide empty state
                    if (filteredLogs.length === 0) {
                        document.getElementById('emptyState').classList.remove('hidden');
                    } else {
                        document.getElementById('emptyState').classList.add('hidden');
                    }
                })
                .catch(error => {
                    console.error('Error loading audit logs:', error);
                    showNotification('Lỗi khi tải nhật ký kiểm toán', 'error');
                });
        }

        function displayLogs() {
            const tbody = document.getElementById('auditLogsTableBody');
            
            if (filteredLogs.length === 0) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="7" class="px-6 py-8 text-center text-gray-500">
                            Không có dữ liệu để hiển thị
                        </td>
                    </tr>
                `;
                return;
            }

            tbody.innerHTML = filteredLogs.map(log => `
                <tr class="hover:bg-gray-50 cursor-pointer" onclick="showLogDetail(${log.auditId})">
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        ${formatDateTime(log.createdDate)}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getActionTypeClass(log.actionType)}">
                            ${getActionTypeIcon(log.actionType)} ${getActionTypeText(log.actionType)}
                        </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        <div class="flex items-center">
                            <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center mr-3">
                                <i class="fas fa-user text-blue-600 text-xs"></i>
                            </div>
                            ${log.username || 'System'}
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        ${getTargetInfo(log)}
                    </td>
                    <td class="px-6 py-4 text-sm text-gray-900 max-w-xs truncate">
                        ${log.description || 'N/A'}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        ${log.ipAddress || 'N/A'}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-blue-600">
                        <button onclick="event.stopPropagation(); showLogDetail(${log.auditId})" 
                                class="hover:text-blue-800">
                            <i class="fas fa-eye mr-1"></i>Xem
                        </button>
                    </td>
                </tr>
            `).join('');
        }

        function getActionTypeClass(actionType) {
            const classes = {
                'GRANT_PERMISSION': 'bg-green-100 text-green-800',
                'REVOKE_PERMISSION': 'bg-red-100 text-red-800',
                'CREATE_USER': 'bg-blue-100 text-blue-800',
                'UPDATE_USER': 'bg-yellow-100 text-yellow-800',
                'DELETE_USER': 'bg-purple-100 text-purple-800',
                'CREATE_ROLE': 'bg-blue-100 text-blue-800',
                'UPDATE_ROLE': 'bg-yellow-100 text-yellow-800',
                'DELETE_ROLE': 'bg-purple-100 text-purple-800'
            };
            return classes[actionType] || 'bg-gray-100 text-gray-800';
        }

        function getActionTypeIcon(actionType) {
            const icons = {
                'GRANT_PERMISSION': '<i class="fas fa-plus-circle mr-1"></i>',
                'REVOKE_PERMISSION': '<i class="fas fa-minus-circle mr-1"></i>',
                'CREATE_USER': '<i class="fas fa-user-plus mr-1"></i>',
                'UPDATE_USER': '<i class="fas fa-user-edit mr-1"></i>',
                'DELETE_USER': '<i class="fas fa-user-minus mr-1"></i>',
                'CREATE_ROLE': '<i class="fas fa-plus mr-1"></i>',
                'UPDATE_ROLE': '<i class="fas fa-edit mr-1"></i>',
                'DELETE_ROLE': '<i class="fas fa-trash mr-1"></i>'
            };
            return icons[actionType] || '<i class="fas fa-info-circle mr-1"></i>';
        }

        function getActionTypeText(actionType) {
            const texts = {
                'GRANT_PERMISSION': 'Cấp quyền',
                'REVOKE_PERMISSION': 'Thu hồi quyền',
                'CREATE_USER': 'Tạo người dùng',
                'UPDATE_USER': 'Cập nhật người dùng',
                'DELETE_USER': 'Xóa người dùng',
                'CREATE_ROLE': 'Tạo vai trò',
                'UPDATE_ROLE': 'Cập nhật vai trò',
                'DELETE_ROLE': 'Xóa vai trò'
            };
            return texts[actionType] || actionType;
        }

        function getTargetInfo(log) {
            let target = '';
            if (log.targetUsername) {
                target += `<i class="fas fa-user mr-1 text-blue-600"></i>${log.targetUsername}`;
            }
            if (log.roleName) {
                target += target ? '<br>' : '';
                target += `<i class="fas fa-user-tag mr-1 text-green-600"></i>${log.roleName}`;
            }
            if (log.permissionName) {
                target += target ? '<br>' : '';
                target += `<i class="fas fa-key mr-1 text-purple-600"></i>${log.permissionName}`;
            }
            return target || 'N/A';
        }

        function showLogDetail(auditId) {
            const log = allLogs.find(l => l.auditId === auditId);
            if (!log) return;

            const content = document.getElementById('logDetailContent');
            content.innerHTML = `
                <div class="space-y-4">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">ID Hoạt động:</label>
                            <p class="text-sm text-gray-900">${log.auditId}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Thời gian:</label>
                            <p class="text-sm text-gray-900">${formatDateTime(log.createdDate)}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Loại hành động:</label>
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getActionTypeClass(log.actionType)}">
                                ${getActionTypeIcon(log.actionType)} ${getActionTypeText(log.actionType)}
                            </span>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Người thực hiện:</label>
                            <p class="text-sm text-gray-900">${log.username || 'System'}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">IP Address:</label>
                            <p class="text-sm text-gray-900">${log.ipAddress || 'N/A'}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">User Agent:</label>
                            <p class="text-sm text-gray-900 truncate" title="${log.userAgent || 'N/A'}">${log.userAgent || 'N/A'}</p>
                        </div>
                    </div>
                    
                    ${log.targetUsername ? `
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Người dùng đích:</label>
                            <p class="text-sm text-gray-900">${log.targetUsername}</p>
                        </div>
                    ` : ''}
                    
                    ${log.roleName ? `
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Vai trò:</label>
                            <p class="text-sm text-gray-900">${log.roleName}</p>
                        </div>
                    ` : ''}
                    
                    ${log.permissionName ? `
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Quyền:</label>
                            <p class="text-sm text-gray-900">${log.permissionName} (${log.permissionCode || 'N/A'})</p>
                        </div>
                    ` : ''}
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Mô tả:</label>
                        <p class="text-sm text-gray-900">${log.description || 'N/A'}</p>
                    </div>
                    
                    ${log.oldValue ? `
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Giá trị cũ:</label>
                            <pre class="text-sm text-gray-900 bg-gray-100 p-2 rounded">${log.oldValue}</pre>
                        </div>
                    ` : ''}
                    
                    ${log.newValue ? `
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Giá trị mới:</label>
                            <pre class="text-sm text-gray-900 bg-gray-100 p-2 rounded">${log.newValue}</pre>
                        </div>
                    ` : ''}
                </div>
            `;

            document.getElementById('logDetailModal').classList.remove('hidden');
        }

        function closeLogDetailModal() {
            document.getElementById('logDetailModal').classList.add('hidden');
        }

        function updateStatistics(stats) {
            document.getElementById('totalActivities').textContent = stats.total || 0;
            document.getElementById('grantActivities').textContent = stats.grants || 0;
            document.getElementById('revokeActivities').textContent = stats.revokes || 0;
            document.getElementById('todayActivities').textContent = stats.today || 0;
        }

        function updatePagination(totalCount) {
            const showingFrom = (currentPage - 1) * pageSize + 1;
            const showingTo = Math.min(currentPage * pageSize, totalCount);
            
            document.getElementById('showingFrom').textContent = totalCount > 0 ? showingFrom : 0;
            document.getElementById('showingTo').textContent = showingTo;
            document.getElementById('totalRecords').textContent = totalCount;
            document.getElementById('currentPageInfo').textContent = `Trang ${currentPage} / ${totalPages}`;
            
            document.getElementById('prevPageBtn').disabled = currentPage <= 1;
            document.getElementById('nextPageBtn').disabled = currentPage >= totalPages;
        }

        function changePage(direction) {
            const newPage = currentPage + direction;
            if (newPage >= 1 && newPage <= totalPages) {
                currentPage = newPage;
                loadAuditLogs();
            }
        }

        function changePageSize() {
            pageSize = parseInt(document.getElementById('pageSize').value);
            currentPage = 1;
            loadAuditLogs();
        }

        function filterLogs() {
            currentPage = 1;
            loadAuditLogs();
        }

        function clearFilters() {
            document.getElementById('actionTypeFilter').value = '';
            document.getElementById('userFilter').value = '';
            document.getElementById('dateFromFilter').value = '';
            document.getElementById('dateToFilter').value = '';
            currentPage = 1;
            loadAuditLogs();
        }

        function refreshLogs() {
            loadAuditLogs();
        }

        function exportLogs() {
            const params = new URLSearchParams({
                action: 'exportAuditLogs'
            });

            // Add current filters
            const actionType = document.getElementById('actionTypeFilter').value;
            const userFilter = document.getElementById('userFilter').value;
            const dateFrom = document.getElementById('dateFromFilter').value;
            const dateTo = document.getElementById('dateToFilter').value;

            if (actionType) params.append('actionType', actionType);
            if (userFilter) params.append('userFilter', userFilter);
            if (dateFrom) params.append('dateFrom', dateFrom);
            if (dateTo) params.append('dateTo', dateTo);

            window.open(`${pageContext.request.contextPath}/permission-management?${params.toString()}`, '_blank');
        }

        function formatDateTime(dateString) {
            if (!dateString) return 'N/A';
            const date = new Date(dateString);
            return date.toLocaleString('vi-VN');
        }

        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = `fixed top-4 right-4 p-4 rounded-lg text-white z-50 ${type === 'success' ? 'bg-green-600' : 'bg-red-600'}`;
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.remove();
            }, 3000);
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