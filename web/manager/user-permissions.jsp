<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, entity.User, entity.Permission, entity.UserPermission"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý quyền người dùng | Medilab Clinic</title>
    
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
        .permission-card {
            transition: all 0.3s ease;
        }
        .permission-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .permission-granted {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }
        .permission-denied {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
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
                                <i class="fas fa-user-cog me-3"></i>Quản lý quyền người dùng
                            </h1>
                            <p class="text-light mb-0">Phân quyền cho từng người dùng trong hệ thống</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/manager/permission-dashboard.jsp" 
                   class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-4 py-2 rounded-lg transition duration-300">
                    <i class="fas fa-arrow-left mr-2"></i>Quay lại
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 pb-10">
        <div class="max-w-7xl mx-auto">
            
            <!-- User Search and Selection -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8 animate-fade-in">
                <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                    <div class="flex flex-col md:flex-row md:items-center space-y-4 md:space-y-0 md:space-x-4">
                        <div>
                            <label for="userSearch" class="block text-sm font-medium text-gray-700 mb-2">
                                Tìm kiếm người dùng:
                            </label>
                            <div class="relative">
                                <input type="text" id="userSearch" placeholder="Nhập tên hoặc email..." 
                                       class="px-4 py-2 pl-10 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 min-w-64"
                                       onkeyup="searchUsers()">
                                <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                            </div>
                        </div>
                        <div>
                            <label for="roleFilter" class="block text-sm font-medium text-gray-700 mb-2">
                                Lọc theo vai trò:
                            </label>
                            <select id="roleFilter" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                                    onchange="filterUsersByRole()">
                                <option value="">-- Tất cả vai trò --</option>
                                <!-- Roles will be loaded here -->
                            </select>
                        </div>
                    </div>
                    
                    <div class="flex items-center space-x-4">
                        <button onclick="showBulkUserPermissionModal()" 
                                class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition duration-300">
                            <i class="fas fa-users mr-2"></i>Phân quyền hàng loạt
                        </button>
                        <button onclick="exportUserPermissions()" 
                                class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition duration-300">
                            <i class="fas fa-download mr-2"></i>Xuất báo cáo
                        </button>
                    </div>
                </div>
            </div>

            <!-- Users List -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8" id="usersContainer">
                <!-- Users will be loaded here -->
            </div>

            <!-- Selected User Info -->
            <div id="selectedUserCard" class="bg-white rounded-xl shadow-lg p-6 mb-8 hidden animate-fade-in">
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center space-x-4">
                        <div class="user-avatar w-16 h-16 rounded-full flex items-center justify-center text-white text-xl font-bold">
                            <span id="userInitials"></span>
                        </div>
                        <div>
                            <h3 id="selectedUserName" class="text-xl font-bold text-gray-800"></h3>
                            <p id="selectedUserEmail" class="text-gray-600"></p>
                            <p id="selectedUserRole" class="text-sm text-blue-600 font-medium"></p>
                        </div>
                    </div>
                    <div class="text-right">
                        <p class="text-sm text-gray-500">Quyền cá nhân</p>
                        <p id="userPermissionsCount" class="text-2xl font-bold text-green-600">0</p>
                    </div>
                </div>

                <!-- Permission Assignment Form -->
                <div class="border-t pt-6">
                    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6">
                        <h4 class="text-lg font-semibold text-gray-800">Phân quyền cá nhân</h4>
                        <div class="flex items-center space-x-4">
                            <select id="permissionSelect" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                                <option value="">-- Chọn quyền --</option>
                                <!-- Permissions will be loaded here -->
                            </select>
                            <input type="date" id="expiryDate" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                            <button onclick="grantUserPermission()" 
                                    class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition duration-300">
                                <i class="fas fa-plus mr-2"></i>Cấp quyền
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- User Permissions Display -->
            <div id="userPermissionsContainer" class="hidden">
                <!-- User permissions will be loaded here -->
            </div>

            <!-- Empty State -->
            <div id="emptyState" class="text-center py-16">
                <i class="fas fa-user-cog text-6xl text-gray-400 mb-6"></i>
                <h3 class="text-xl font-semibold text-gray-600 mb-2">Chọn người dùng để bắt đầu</h3>
                <p class="text-gray-500">Tìm kiếm và chọn một người dùng để xem và quản lý quyền cá nhân</p>
            </div>
        </div>
    </div>

    <!-- Bulk User Permission Modal -->
    <div id="bulkUserPermissionModal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-xl shadow-2xl w-full max-w-6xl max-h-screen overflow-y-auto">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-800">Phân quyền hàng loạt cho người dùng</h3>
                </div>
                
                <div class="p-6">
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <!-- Selected Users -->
                        <div>
                            <h4 class="text-md font-semibold text-gray-800 mb-4">Người dùng được chọn</h4>
                            <div class="border border-gray-300 rounded-lg p-4 h-96 overflow-y-auto">
                                <div id="bulkSelectedUsers">
                                    <!-- Selected users will be loaded here -->
                                </div>
                            </div>
                        </div>
                        
                        <!-- Available Permissions -->
                        <div>
                            <h4 class="text-md font-semibold text-gray-800 mb-4">Quyền có sẵn</h4>
                            <div class="border border-gray-300 rounded-lg p-4 h-96 overflow-y-auto">
                                <div id="bulkAvailablePermissions">
                                    <!-- Available permissions will be loaded here -->
                                </div>
                            </div>
                        </div>
                        
                        <!-- Selected Permissions -->
                        <div>
                            <h4 class="text-md font-semibold text-gray-800 mb-4">Quyền sẽ cấp</h4>
                            <div class="border border-gray-300 rounded-lg p-4 h-96 overflow-y-auto">
                                <div id="bulkSelectedPermissions">
                                    <!-- Selected permissions will be loaded here -->
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-6">
                        <label for="bulkExpiryDate" class="block text-sm font-medium text-gray-700 mb-2">
                            Ngày hết hạn (tùy chọn):
                        </label>
                        <input type="date" id="bulkExpiryDate" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                    </div>
                </div>
                
                <div class="px-6 py-4 border-t border-gray-200 flex justify-end space-x-3">
                    <button type="button" onclick="closeBulkUserPermissionModal()" 
                            class="px-4 py-2 text-gray-700 bg-gray-200 rounded-lg hover:bg-gray-300 transition duration-300">
                        Hủy
                    </button>
                    <button type="button" onclick="saveBulkUserPermissions()" 
                            class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition duration-300">
                        <i class="fas fa-save mr-2"></i>Cấp quyền hàng loạt
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        let currentUserId = null;
        let allUsers = [];
        let allPermissions = [];
        let userPermissions = [];
        let selectedUsersForBulk = [];
        let selectedPermissionsForBulk = [];

        // Load data on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadUsers();
            loadRoles();
            loadPermissions();
        });

        function loadUsers() {
            fetch('${pageContext.request.contextPath}/permission-management?action=getUsers')
                .then(response => response.json())
                .then(data => {
                    allUsers = data.users;
                    displayUsers(allUsers);
                })
                .catch(error => {
                    console.error('Error loading users:', error);
                });
        }

        function loadRoles() {
            fetch('${pageContext.request.contextPath}/permission-management?action=getRoles')
                .then(response => response.json())
                .then(data => {
                    const roleFilter = document.getElementById('roleFilter');
                    roleFilter.innerHTML = '<option value="">-- Tất cả vai trò --</option>';
                    
                    data.roles.forEach(role => {
                        const option = document.createElement('option');
                        option.value = role.roleId;
                        option.textContent = role.roleName;
                        roleFilter.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Error loading roles:', error);
                });
        }

        function loadPermissions() {
            fetch('${pageContext.request.contextPath}/permission-management?action=getPermissions')
                .then(response => response.json())
                .then(data => {
                    allPermissions = data.permissions;
                    
                    const permissionSelect = document.getElementById('permissionSelect');
                    permissionSelect.innerHTML = '<option value="">-- Chọn quyền --</option>';
                    
                    data.permissions.forEach(permission => {
                        const option = document.createElement('option');
                        option.value = permission.permissionId;
                        option.textContent = `${permission.permissionName} (${permission.permissionCode})`;
                        permissionSelect.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Error loading permissions:', error);
                });
        }

        function displayUsers(users) {
            const container = document.getElementById('usersContainer');
            
            if (users.length === 0) {
                container.innerHTML = '<div class="col-span-full text-center py-8 text-gray-500">Không tìm thấy người dùng nào</div>';
                return;
            }

            container.innerHTML = users.map(user => `
                <div class="bg-white rounded-xl shadow-lg p-6 cursor-pointer hover:shadow-xl transition duration-300 permission-card"
                     onclick="selectUser(${user.userId})">
                    <div class="flex items-center space-x-4 mb-4">
                        <div class="user-avatar w-12 h-12 rounded-full flex items-center justify-center text-white font-bold">
                            ${getInitials(user.fullName || user.username)}
                        </div>
                        <div class="flex-1">
                            <h3 class="font-semibold text-gray-800">${user.fullName || user.username}</h3>
                            <p class="text-sm text-gray-600">${user.email}</p>
                            <p class="text-xs text-blue-600 font-medium">${user.roleName || 'N/A'}</p>
                        </div>
                    </div>
                    <div class="flex items-center justify-between text-sm">
                        <span class="text-gray-500">Trạng thái:</span>
                        <span class="px-2 py-1 rounded-full text-xs ${user.isActive ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                            ${user.isActive ? 'Hoạt động' : 'Không hoạt động'}
                        </span>
                    </div>
                </div>
            `).join('');
        }

        function selectUser(userId) {
            currentUserId = userId;
            const user = allUsers.find(u => u.userId === userId);
            
            if (!user) return;

            // Update selected user info
            document.getElementById('selectedUserName').textContent = user.fullName || user.username;
            document.getElementById('selectedUserEmail').textContent = user.email;
            document.getElementById('selectedUserRole').textContent = user.roleName || 'N/A';
            document.getElementById('userInitials').textContent = getInitials(user.fullName || user.username);
            
            // Show user card
            document.getElementById('selectedUserCard').classList.remove('hidden');
            document.getElementById('emptyState').style.display = 'none';

            // Load user permissions
            loadUserPermissions(userId);
        }

        function loadUserPermissions(userId) {
            fetch(`${pageContext.request.contextPath}/permission-management?action=getUserPermissions&userId=${userId}`)
                .then(response => response.json())
                .then(data => {
                    userPermissions = data.userPermissions;
                    displayUserPermissions();
                    updateUserPermissionsCount();
                    document.getElementById('userPermissionsContainer').classList.remove('hidden');
                })
                .catch(error => {
                    console.error('Error loading user permissions:', error);
                });
        }

        function displayUserPermissions() {
            const container = document.getElementById('userPermissionsContainer');
            
            if (userPermissions.length === 0) {
                container.innerHTML = `
                    <div class="bg-white rounded-xl shadow-lg p-8 text-center">
                        <i class="fas fa-lock text-4xl text-gray-400 mb-4"></i>
                        <h3 class="text-lg font-semibold text-gray-600 mb-2">Chưa có quyền cá nhân</h3>
                        <p class="text-gray-500">Người dùng này chưa được cấp quyền cá nhân nào</p>
                    </div>
                `;
                return;
            }

            // Group permissions by module
            const permissionsByModule = {};
            userPermissions.forEach(userPerm => {
                const permission = allPermissions.find(p => p.permissionId === userPerm.permissionId);
                if (permission) {
                    if (!permissionsByModule[permission.module]) {
                        permissionsByModule[permission.module] = [];
                    }
                    permissionsByModule[permission.module].push({...userPerm, ...permission});
                }
            });

            let html = '';
            Object.keys(permissionsByModule).forEach(module => {
                const modulePermissions = permissionsByModule[module];
                
                html += `
                    <div class="bg-white rounded-xl shadow-lg mb-6 animate-fade-in">
                        <div class="px-6 py-4 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-800">
                                <i class="fas fa-folder mr-2 text-blue-600"></i>Module: ${module}
                            </h3>
                        </div>
                        <div class="p-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                ${modulePermissions.map(permission => {
                                    const isExpired = permission.expiryDate && new Date(permission.expiryDate) < new Date();
                                    const isValid = permission.granted && !isExpired;
                                    
                                    return `
                                        <div class="permission-card border rounded-lg p-4 ${isValid ? 'border-green-300 bg-green-50' : isExpired ? 'border-orange-300 bg-orange-50' : 'border-gray-300 bg-white'}">
                                            <div class="flex items-center justify-between mb-3">
                                                <h4 class="font-medium text-gray-800">${permission.permissionName}</h4>
                                                <button onclick="revokeUserPermission(${permission.userPermissionId})" 
                                                        class="text-red-600 hover:text-red-800 text-sm">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                            <div class="text-xs text-gray-600 mb-2">
                                                <span class="inline-block bg-gray-100 px-2 py-1 rounded">${permission.permissionCode}</span>
                                            </div>
                                            <div class="text-xs text-gray-500 mb-2">
                                                <i class="fas fa-cog mr-1"></i>${permission.action} • 
                                                <i class="fas fa-cube mr-1"></i>${permission.resource || 'N/A'}
                                            </div>
                                            <div class="text-xs ${isValid ? 'text-green-600' : isExpired ? 'text-orange-600' : 'text-gray-600'}">
                                                <i class="fas fa-user mr-1"></i>Cấp bởi: ${permission.grantedBy || 'System'}
                                                <br><i class="fas fa-calendar mr-1"></i>Ngày cấp: ${formatDate(permission.grantedDate)}
                                                ${permission.expiryDate ? `<br><i class="fas fa-clock mr-1"></i>Hết hạn: ${formatDate(permission.expiryDate)}` : ''}
                                                ${isExpired ? '<br><span class="text-orange-600 font-medium">⚠️ Đã hết hạn</span>' : ''}
                                            </div>
                                        </div>
                                    `;
                                }).join('')}
                            </div>
                        </div>
                    </div>
                `;
            });

            container.innerHTML = html;
        }

        function grantUserPermission() {
            const permissionId = document.getElementById('permissionSelect').value;
            const expiryDate = document.getElementById('expiryDate').value;
            
            if (!currentUserId || !permissionId) {
                alert('Vui lòng chọn quyền để cấp');
                return;
            }

            const formData = new FormData();
            formData.append('action', 'grantUserPermission');
            formData.append('userId', currentUserId);
            formData.append('permissionId', permissionId);
            if (expiryDate) {
                formData.append('expiryDate', expiryDate);
            }

            fetch('${pageContext.request.contextPath}/permission-management', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Reset form
                    document.getElementById('permissionSelect').value = '';
                    document.getElementById('expiryDate').value = '';
                    
                    // Reload user permissions
                    loadUserPermissions(currentUserId);
                    showNotification(data.message, 'success');
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error granting user permission:', error);
                showNotification('Lỗi khi cấp quyền', 'error');
            });
        }

        function revokeUserPermission(userPermissionId) {
            if (!confirm('Bạn có chắc chắn muốn thu hồi quyền này?')) return;

            fetch('${pageContext.request.contextPath}/permission-management', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=revokeUserPermission&userPermissionId=${userPermissionId}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    loadUserPermissions(currentUserId);
                    showNotification(data.message, 'success');
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error revoking user permission:', error);
                showNotification('Lỗi khi thu hồi quyền', 'error');
            });
        }

        function updateUserPermissionsCount() {
            const validPermissions = userPermissions.filter(up => {
                const isExpired = up.expiryDate && new Date(up.expiryDate) < new Date();
                return up.granted && !isExpired;
            });
            document.getElementById('userPermissionsCount').textContent = validPermissions.length;
        }

        function searchUsers() {
            const searchTerm = document.getElementById('userSearch').value.toLowerCase();
            const roleFilter = document.getElementById('roleFilter').value;
            
            let filteredUsers = allUsers.filter(user => {
                const matchesSearch = !searchTerm || 
                    (user.fullName && user.fullName.toLowerCase().includes(searchTerm)) ||
                    (user.username && user.username.toLowerCase().includes(searchTerm)) ||
                    (user.email && user.email.toLowerCase().includes(searchTerm));
                
                const matchesRole = !roleFilter || user.roleId == roleFilter;
                
                return matchesSearch && matchesRole;
            });
            
            displayUsers(filteredUsers);
        }

        function filterUsersByRole() {
            searchUsers(); // Reuse the search function which also handles role filtering
        }

        function showBulkUserPermissionModal() {
            selectedUsersForBulk = [];
            selectedPermissionsForBulk = [];
            loadBulkModalData();
            document.getElementById('bulkUserPermissionModal').classList.remove('hidden');
        }

        function loadBulkModalData() {
            // Load users for bulk selection
            const usersContainer = document.getElementById('bulkSelectedUsers');
            usersContainer.innerHTML = allUsers.map(user => `
                <div class="flex items-center justify-between p-2 border-b border-gray-200">
                    <div class="flex items-center space-x-2">
                        <input type="checkbox" id="bulkUser${user.userId}" 
                               onchange="toggleUserForBulk(${user.userId}, this.checked)">
                        <label for="bulkUser${user.userId}" class="text-sm">
                            ${user.fullName || user.username} (${user.email})
                        </label>
                    </div>
                </div>
            `).join('');

            // Load permissions for bulk selection
            const permissionsContainer = document.getElementById('bulkAvailablePermissions');
            permissionsContainer.innerHTML = allPermissions.map(permission => `
                <div class="flex items-center justify-between p-2 border-b border-gray-200">
                    <div>
                        <div class="font-medium text-sm">${permission.permissionName}</div>
                        <div class="text-xs text-gray-500">${permission.permissionCode}</div>
                    </div>
                    <button onclick="addPermissionToBulkSelection(${permission.permissionId})" 
                            class="text-green-600 hover:text-green-800">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            `).join('');

            updateBulkSelections();
        }

        function toggleUserForBulk(userId, selected) {
            if (selected) {
                if (!selectedUsersForBulk.includes(userId)) {
                    selectedUsersForBulk.push(userId);
                }
            } else {
                selectedUsersForBulk = selectedUsersForBulk.filter(id => id !== userId);
            }
        }

        function addPermissionToBulkSelection(permissionId) {
            if (!selectedPermissionsForBulk.includes(permissionId)) {
                selectedPermissionsForBulk.push(permissionId);
                updateBulkSelections();
            }
        }

        function removePermissionFromBulkSelection(permissionId) {
            selectedPermissionsForBulk = selectedPermissionsForBulk.filter(id => id !== permissionId);
            updateBulkSelections();
        }

        function updateBulkSelections() {
            const selectedContainer = document.getElementById('bulkSelectedPermissions');
            selectedContainer.innerHTML = selectedPermissionsForBulk.map(permissionId => {
                const permission = allPermissions.find(p => p.permissionId === permissionId);
                return `
                    <div class="flex items-center justify-between p-2 border-b border-gray-200">
                        <div>
                            <div class="font-medium text-sm">${permission.permissionName}</div>
                            <div class="text-xs text-gray-500">${permission.permissionCode}</div>
                        </div>
                        <button onclick="removePermissionFromBulkSelection(${permissionId})" 
                                class="text-red-600 hover:text-red-800">
                            <i class="fas fa-minus"></i>
                        </button>
                    </div>
                `;
            }).join('');
        }

        function saveBulkUserPermissions() {
            if (selectedUsersForBulk.length === 0 || selectedPermissionsForBulk.length === 0) {
                alert('Vui lòng chọn ít nhất một người dùng và một quyền');
                return;
            }

            const expiryDate = document.getElementById('bulkExpiryDate').value;
            
            const formData = new FormData();
            formData.append('action', 'bulkGrantUserPermissions');
            formData.append('userIds', selectedUsersForBulk.join(','));
            formData.append('permissionIds', selectedPermissionsForBulk.join(','));
            if (expiryDate) {
                formData.append('expiryDate', expiryDate);
            }

            fetch('${pageContext.request.contextPath}/permission-management', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    closeBulkUserPermissionModal();
                    if (currentUserId) {
                        loadUserPermissions(currentUserId);
                    }
                    showNotification(data.message, 'success');
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error bulk granting permissions:', error);
                showNotification('Lỗi khi cấp quyền hàng loạt', 'error');
            });
        }

        function closeBulkUserPermissionModal() {
            document.getElementById('bulkUserPermissionModal').classList.add('hidden');
        }

        function exportUserPermissions() {
            window.open(`${pageContext.request.contextPath}/permission-management?action=exportUserPermissions`, '_blank');
        }

        function getInitials(name) {
            if (!name) return '?';
            return name.split(' ').map(word => word.charAt(0)).join('').toUpperCase().substring(0, 2);
        }

        function formatDate(dateString) {
            if (!dateString) return 'N/A';
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN');
        }

        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = `fixed top-4 right-4 p-4 rounded-lg text-white z-50 ${type === 'success' ? 'bg-green-600' : 'bg-red-600'}`;
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout () => {
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