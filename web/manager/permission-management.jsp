<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, entity.Permission"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý quyền | Medilab Clinic</title>
    
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
        .table-row-hover {
            transition: all 0.3s ease;
        }
        .table-row-hover:hover {
            background-color: #f8fafc;
            transform: translateX(2px);
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
                                <i class="fas fa-key me-3"></i>Quản lý quyền
                            </h1>
                            <p class="text-light mb-0">Tạo, chỉnh sửa và quản lý các quyền trong hệ thống</p>
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
            
            <!-- Action Bar -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8 animate-fade-in">
                <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <div class="flex items-center space-x-4">
                        <button onclick="showCreateModal()" 
                                class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition duration-300">
                            <i class="fas fa-plus mr-2"></i>Tạo quyền mới
                        </button>
                        <button onclick="exportPermissions()" 
                                class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition duration-300">
                            <i class="fas fa-download mr-2"></i>Xuất Excel
                        </button>
                    </div>
                    
                    <div class="flex items-center space-x-4">
                        <!-- Search -->
                        <div class="relative">
                            <input type="text" id="searchInput" placeholder="Tìm kiếm quyền..." 
                                   class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </div>
                        
                        <!-- Filter by Module -->
                        <select id="moduleFilter" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                            <option value="">Tất cả module</option>
                            <option value="USER">Người dùng</option>
                            <option value="ROLE">Vai trò</option>
                            <option value="PERMISSION">Quyền</option>
                            <option value="SYSTEM">Hệ thống</option>
                            <option value="REPORT">Báo cáo</option>
                            <option value="AUDIT">Kiểm toán</option>
                        </select>
                        
                        <!-- Filter by Status -->
                        <select id="statusFilter" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                            <option value="">Tất cả trạng thái</option>
                            <option value="true">Hoạt động</option>
                            <option value="false">Không hoạt động</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Permissions Table -->
            <div class="bg-white rounded-xl shadow-lg overflow-hidden animate-fade-in">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-800">
                        <i class="fas fa-list mr-2 text-blue-600"></i>Danh sách quyền
                    </h3>
                </div>
                
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    <input type="checkbox" id="selectAll" class="rounded border-gray-300">
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Tên quyền
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Mã quyền
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Module
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Hành động
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Tài nguyên
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Trạng thái
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Thao tác
                                </th>
                            </tr>
                        </thead>
                        <tbody id="permissionsTableBody" class="bg-white divide-y divide-gray-200">
                            <!-- Permissions will be loaded here via AJAX -->
                        </tbody>
                    </table>
                </div>
                
                <!-- Loading State -->
                <div id="loadingState" class="text-center py-12">
                    <i class="fas fa-spinner fa-spin text-3xl text-blue-600 mb-4"></i>
                    <p class="text-gray-600">Đang tải danh sách quyền...</p>
                </div>
                
                <!-- Empty State -->
                <div id="emptyState" class="text-center py-12 hidden">
                    <i class="fas fa-inbox text-4xl text-gray-400 mb-4"></i>
                    <p class="text-gray-600 text-lg">Không tìm thấy quyền nào</p>
                    <button onclick="showCreateModal()" 
                            class="mt-4 bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition duration-300">
                        <i class="fas fa-plus mr-2"></i>Tạo quyền đầu tiên
                    </button>
                </div>
            </div>

            <!-- Pagination -->
            <div id="pagination" class="mt-6 flex items-center justify-between">
                <div class="text-sm text-gray-700">
                    Hiển thị <span id="showingFrom">0</span> đến <span id="showingTo">0</span> 
                    trong tổng số <span id="totalRecords">0</span> quyền
                </div>
                <div class="flex space-x-2" id="paginationButtons">
                    <!-- Pagination buttons will be generated here -->
                </div>
            </div>
        </div>
    </div>

    <!-- Create/Edit Permission Modal -->
    <div id="permissionModal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-xl shadow-2xl w-full max-w-2xl">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 id="modalTitle" class="text-lg font-semibold text-gray-800">Tạo quyền mới</h3>
                </div>
                
                <form id="permissionForm" class="p-6">
                    <input type="hidden" id="permissionId" name="permissionId">
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="permissionName" class="block text-sm font-medium text-gray-700 mb-2">
                                Tên quyền <span class="text-red-500">*</span>
                            </label>
                            <input type="text" id="permissionName" name="permissionName" required
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        </div>
                        
                        <div>
                            <label for="permissionCode" class="block text-sm font-medium text-gray-700 mb-2">
                                Mã quyền <span class="text-red-500">*</span>
                            </label>
                            <input type="text" id="permissionCode" name="permissionCode" required
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        </div>
                        
                        <div>
                            <label for="module" class="block text-sm font-medium text-gray-700 mb-2">
                                Module <span class="text-red-500">*</span>
                            </label>
                            <select id="module" name="module" required
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="">Chọn module</option>
                                <option value="USER">Người dùng</option>
                                <option value="ROLE">Vai trò</option>
                                <option value="PERMISSION">Quyền</option>
                                <option value="SYSTEM">Hệ thống</option>
                                <option value="REPORT">Báo cáo</option>
                                <option value="AUDIT">Kiểm toán</option>
                            </select>
                        </div>
                        
                        <div>
                            <label for="action" class="block text-sm font-medium text-gray-700 mb-2">
                                Hành động <span class="text-red-500">*</span>
                            </label>
                            <select id="action" name="action" required
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="">Chọn hành động</option>
                                <option value="CREATE">Tạo</option>
                                <option value="READ">Đọc</option>
                                <option value="UPDATE">Cập nhật</option>
                                <option value="DELETE">Xóa</option>
                                <option value="MANAGE">Quản lý</option>
                                <option value="VIEW">Xem</option>
                                <option value="EXPORT">Xuất</option>
                                <option value="IMPORT">Nhập</option>
                            </select>
                        </div>
                        
                        <div>
                            <label for="resource" class="block text-sm font-medium text-gray-700 mb-2">
                                Tài nguyên
                            </label>
                            <input type="text" id="resource" name="resource"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        </div>
                        
                        <div>
                            <label for="isActive" class="block text-sm font-medium text-gray-700 mb-2">
                                Trạng thái
                            </label>
                            <select id="isActive" name="isActive"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="true">Hoạt động</option>
                                <option value="false">Không hoạt động</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="mt-6">
                        <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                            Mô tả
                        </label>
                        <textarea id="description" name="description" rows="3"
                                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"></textarea>
                    </div>
                </form>
                
                <div class="px-6 py-4 border-t border-gray-200 flex justify-end space-x-3">
                    <button type="button" onclick="closeModal()" 
                            class="px-4 py-2 text-gray-700 bg-gray-200 rounded-lg hover:bg-gray-300 transition duration-300">
                        Hủy
                    </button>
                    <button type="button" onclick="savePermission()" 
                            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition duration-300">
                        <i class="fas fa-save mr-2"></i>Lưu
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        let currentPage = 1;
        let pageSize = 10;
        let totalPages = 1;

        // Load permissions on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadPermissions();
            setupEventListeners();
        });

        function setupEventListeners() {
            // Search input
            document.getElementById('searchInput').addEventListener('input', debounce(loadPermissions, 300));
            
            // Filter selects
            document.getElementById('moduleFilter').addEventListener('change', loadPermissions);
            document.getElementById('statusFilter').addEventListener('change', loadPermissions);
            
            // Select all checkbox
            document.getElementById('selectAll').addEventListener('change', function() {
                const checkboxes = document.querySelectorAll('input[name="selectedPermissions"]');
                checkboxes.forEach(cb => cb.checked = this.checked);
            });
        }

        function loadPermissions() {
            const searchTerm = document.getElementById('searchInput').value;
            const moduleFilter = document.getElementById('moduleFilter').value;
            const statusFilter = document.getElementById('statusFilter').value;
            
            const params = new URLSearchParams({
                action: 'listPermissions',
                page: currentPage,
                pageSize: pageSize,
                search: searchTerm,
                module: moduleFilter,
                status: statusFilter
            });

            fetch(`${pageContext.request.contextPath}/permission-management?${params}`)
                .then(response => response.json())
                .then(data => {
                    displayPermissions(data.permissions);
                    updatePagination(data.totalRecords);
                    document.getElementById('loadingState').style.display = 'none';
                })
                .catch(error => {
                    console.error('Error loading permissions:', error);
                    document.getElementById('loadingState').innerHTML = `
                        <div class="text-center py-12">
                            <i class="fas fa-exclamation-triangle text-3xl text-red-600 mb-4"></i>
                            <p class="text-red-600">Lỗi khi tải danh sách quyền</p>
                        </div>
                    `;
                });
        }

        function displayPermissions(permissions) {
            const tbody = document.getElementById('permissionsTableBody');
            const emptyState = document.getElementById('emptyState');
            
            if (!permissions || permissions.length === 0) {
                tbody.innerHTML = '';
                emptyState.classList.remove('hidden');
                return;
            }
            
            emptyState.classList.add('hidden');
            tbody.innerHTML = permissions.map(permission => `
                <tr class="table-row-hover">
                    <td class="px-6 py-4 whitespace-nowrap">
                        <input type="checkbox" name="selectedPermissions" value="${permission.permissionId}" 
                               class="rounded border-gray-300">
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">${permission.permissionName}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-900 font-mono">${permission.permissionCode}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                            ${permission.module}
                        </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                            ${permission.action}
                        </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-900">${permission.resource || '-'}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${permission.isActive ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                            <i class="fas fa-${permission.isActive ? 'check' : 'times'} mr-1"></i>
                            ${permission.isActive ? 'Hoạt động' : 'Không hoạt động'}
                        </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <div class="flex space-x-2">
                            <button onclick="editPermission(${permission.permissionId})" 
                                    class="text-blue-600 hover:text-blue-900" title="Chỉnh sửa">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button onclick="deletePermission(${permission.permissionId})" 
                                    class="text-red-600 hover:text-red-900" title="Xóa">
                                <i class="fas fa-trash"></i>
                            </button>
                            <button onclick="viewPermissionDetails(${permission.permissionId})" 
                                    class="text-green-600 hover:text-green-900" title="Xem chi tiết">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            `).join('');
        }

        function updatePagination(totalRecords) {
            totalPages = Math.ceil(totalRecords / pageSize);
            
            // Update showing info
            const showingFrom = (currentPage - 1) * pageSize + 1;
            const showingTo = Math.min(currentPage * pageSize, totalRecords);
            
            document.getElementById('showingFrom').textContent = showingFrom;
            document.getElementById('showingTo').textContent = showingTo;
            document.getElementById('totalRecords').textContent = totalRecords;
            
            // Generate pagination buttons
            const paginationButtons = document.getElementById('paginationButtons');
            let buttonsHTML = '';
            
            // Previous button
            if (currentPage > 1) {
                buttonsHTML += `<button onclick="changePage(${currentPage - 1})" class="px-3 py-2 text-sm bg-white border border-gray-300 rounded-lg hover:bg-gray-50">Trước</button>`;
            }
            
            // Page numbers
            for (let i = Math.max(1, currentPage - 2); i <= Math.min(totalPages, currentPage + 2); i++) {
                const isActive = i === currentPage;
                buttonsHTML += `<button onclick="changePage(${i})" class="px-3 py-2 text-sm ${isActive ? 'bg-blue-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'} border border-gray-300 rounded-lg">${i}</button>`;
            }
            
            // Next button
            if (currentPage < totalPages) {
                buttonsHTML += `<button onclick="changePage(${currentPage + 1})" class="px-3 py-2 text-sm bg-white border border-gray-300 rounded-lg hover:bg-gray-50">Sau</button>`;
            }
            
            paginationButtons.innerHTML = buttonsHTML;
        }

        function changePage(page) {
            currentPage = page;
            loadPermissions();
        }

        function showCreateModal() {
            document.getElementById('modalTitle').textContent = 'Tạo quyền mới';
            document.getElementById('permissionForm').reset();
            document.getElementById('permissionId').value = '';
            document.getElementById('permissionModal').classList.remove('hidden');
        }

        function editPermission(permissionId) {
            fetch(`${pageContext.request.contextPath}/permission-management?action=getPermission&id=${permissionId}`)
                .then(response => response.json())
                .then(permission => {
                    document.getElementById('modalTitle').textContent = 'Chỉnh sửa quyền';
                    document.getElementById('permissionId').value = permission.permissionId;
                    document.getElementById('permissionName').value = permission.permissionName;
                    document.getElementById('permissionCode').value = permission.permissionCode;
                    document.getElementById('module').value = permission.module;
                    document.getElementById('action').value = permission.action;
                    document.getElementById('resource').value = permission.resource || '';
                    document.getElementById('description').value = permission.description || '';
                    document.getElementById('isActive').value = permission.isActive.toString();
                    document.getElementById('permissionModal').classList.remove('hidden');
                })
                .catch(error => {
                    console.error('Error loading permission:', error);
                    alert('Lỗi khi tải thông tin quyền');
                });
        }

        function savePermission() {
            const form = document.getElementById('permissionForm');
            const formData = new FormData(form);
            
            const isEdit = formData.get('permissionId') !== '';
            const action = isEdit ? 'updatePermission' : 'createPermission';
            formData.set('action', action);

            fetch(`${pageContext.request.contextPath}/permission-management`, {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    closeModal();
                    loadPermissions();
                    showNotification(data.message, 'success');
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error saving permission:', error);
                showNotification('Lỗi khi lưu quyền', 'error');
            });
        }

        function deletePermission(permissionId) {
            if (confirm('Bạn có chắc chắn muốn xóa quyền này?')) {
                fetch(`${pageContext.request.contextPath}/permission-management`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=deletePermission&permissionId=${permissionId}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        loadPermissions();
                        showNotification(data.message, 'success');
                    } else {
                        showNotification(data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error deleting permission:', error);
                    showNotification('Lỗi khi xóa quyền', 'error');
                });
            }
        }

        function closeModal() {
            document.getElementById('permissionModal').classList.add('hidden');
        }

        function exportPermissions() {
            window.open(`${pageContext.request.contextPath}/permission-management?action=export`, '_blank');
        }

        function showNotification(message, type) {
            // Simple notification implementation
            const notification = document.createElement('div');
            notification.className = `fixed top-4 right-4 p-4 rounded-lg text-white z-50 ${type === 'success' ? 'bg-green-600' : 'bg-red-600'}`;
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.remove();
            }, 3000);
        }

        function debounce(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
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