<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, entity.Role, entity.Permission, entity.RolePermission"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý quyền vai trò | Medilab Clinic</title>
    
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
                                <i class="fas fa-users-cog me-3"></i>Quản lý quyền vai trò
                            </h1>
                            <p class="text-light mb-0">Phân quyền cho các vai trò trong hệ thống</p>
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
            
            <!-- Role Selection -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8 animate-fade-in">
                <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <div class="flex items-center space-x-4">
                        <div>
                            <label for="roleSelect" class="block text-sm font-medium text-gray-700 mb-2">
                                Chọn vai trò để quản lý quyền:
                            </label>
                            <select id="roleSelect" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 min-w-64">
                                <option value="">-- Chọn vai trò --</option>
                                <!-- Roles will be loaded here -->
                            </select>
                        </div>
                        <div class="mt-6">
                            <button onclick="loadRolePermissions()" 
                                    class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition duration-300">
                                <i class="fas fa-search mr-2"></i>Xem quyền
                            </button>
                        </div>
                    </div>
                    
                    <div class="flex items-center space-x-4">
                        <button onclick="showBulkAssignModal()" 
                                class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition duration-300">
                            <i class="fas fa-plus mr-2"></i>Phân quyền hàng loạt
                        </button>
                        <button onclick="exportRolePermissions()" 
                                class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition duration-300">
                            <i class="fas fa-download mr-2"></i>Xuất báo cáo
                        </button>
                    </div>
                </div>
            </div>

            <!-- Role Info Card -->
            <div id="roleInfoCard" class="bg-white rounded-xl shadow-lg p-6 mb-8 hidden animate-fade-in">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <div class="bg-blue-100 w-16 h-16 rounded-full flex items-center justify-center">
                            <i class="fas fa-user-tag text-blue-600 text-2xl"></i>
                        </div>
                        <div>
                            <h3 id="selectedRoleName" class="text-xl font-bold text-gray-800"></h3>
                            <p class="text-gray-600">Vai trò được chọn</p>
                        </div>
                    </div>
                    <div class="text-right">
                        <p class="text-sm text-gray-500">Tổng quyền được cấp</p>
                        <p id="grantedPermissionsCount" class="text-2xl font-bold text-green-600">0</p>
                    </div>
                </div>
            </div>

            <!-- Permissions by Module -->
            <div id="permissionsContainer" class="hidden">
                <!-- Permissions will be loaded here -->
            </div>

            <!-- Empty State -->
            <div id="emptyState" class="text-center py-16">
                <i class="fas fa-users-cog text-6xl text-gray-400 mb-6"></i>
                <h3 class="text-xl font-semibold text-gray-600 mb-2">Chọn vai trò để bắt đầu</h3>
                <p class="text-gray-500">Vui lòng chọn một vai trò từ danh sách để xem và quản lý quyền</p>
            </div>
        </div>
    </div>

    <!-- Bulk Assign Modal -->
    <div id="bulkAssignModal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-xl shadow-2xl w-full max-w-4xl max-h-screen overflow-y-auto">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-800">Phân quyền hàng loạt</h3>
                </div>
                
                <div class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Available Permissions -->
                        <div>
                            <h4 class="text-md font-semibold text-gray-800 mb-4">Quyền có sẵn</h4>
                            <div class="border border-gray-300 rounded-lg p-4 h-96 overflow-y-auto">
                                <div id="availablePermissions">
                                    <!-- Available permissions will be loaded here -->
                                </div>
                            </div>
                        </div>
                        
                        <!-- Selected Permissions -->
                        <div>
                            <h4 class="text-md font-semibold text-gray-800 mb-4">Quyền được chọn</h4>
                            <div class="border border-gray-300 rounded-lg p-4 h-96 overflow-y-auto">
                                <div id="selectedPermissions">
                                    <!-- Selected permissions will be loaded here -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="px-6 py-4 border-t border-gray-200 flex justify-end space-x-3">
                    <button type="button" onclick="closeBulkAssignModal()" 
                            class="px-4 py-2 text-gray-700 bg-gray-200 rounded-lg hover:bg-gray-300 transition duration-300">
                        Hủy
                    </button>
                    <button type="button" onclick="saveBulkAssign()" 
                            class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition duration-300">
                        <i class="fas fa-save mr-2"></i>Lưu thay đổi
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        let currentRoleId = null;
        let allPermissions = [];
        let rolePermissions = [];

        // Load data on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadRoles();
        });

        function loadRoles() {
            fetch('${pageContext.request.contextPath}/permission-management?action=getRoles')
                .then(response => response.json())
                .then(data => {
                    const roleSelect = document.getElementById('roleSelect');
                    roleSelect.innerHTML = '<option value="">-- Chọn vai trò --</option>';
                    
                    data.roles.forEach(role => {
                        const option = document.createElement('option');
                        option.value = role.roleId;
                        option.textContent = role.roleName;
                        roleSelect.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Error loading roles:', error);
                });
        }

        function loadRolePermissions() {
            const roleId = document.getElementById('roleSelect').value;
            if (!roleId) {
                alert('Vui lòng chọn vai trò');
                return;
            }

            currentRoleId = roleId;
            const roleName = document.getElementById('roleSelect').selectedOptions[0].text;

            // Show role info
            document.getElementById('selectedRoleName').textContent = roleName;
            document.getElementById('roleInfoCard').classList.remove('hidden');
            document.getElementById('emptyState').style.display = 'none';

            // Load permissions
            fetch(`${pageContext.request.contextPath}/permission-management?action=getRolePermissions&roleId=${roleId}`)
                .then(response => response.json())
                .then(data => {
                    allPermissions = data.allPermissions;
                    rolePermissions = data.rolePermissions;
                    displayPermissionsByModule();
                    updateGrantedCount();
                    document.getElementById('permissionsContainer').classList.remove('hidden');
                })
                .catch(error => {
                    console.error('Error loading role permissions:', error);
                });
        }

        function displayPermissionsByModule() {
            const container = document.getElementById('permissionsContainer');
            
            // Group permissions by module
            const permissionsByModule = {};
            allPermissions.forEach(permission => {
                if (!permissionsByModule[permission.module]) {
                    permissionsByModule[permission.module] = [];
                }
                permissionsByModule[permission.module].push(permission);
            });

            let html = '';
            Object.keys(permissionsByModule).forEach(module => {
                const modulePermissions = permissionsByModule[module];
                const grantedCount = modulePermissions.filter(p => 
                    rolePermissions.some(rp => rp.permissionId === p.permissionId && rp.granted)
                ).length;

                html += `
                    <div class="bg-white rounded-xl shadow-lg mb-6 animate-fade-in">
                        <div class="px-6 py-4 border-b border-gray-200">
                            <div class="flex items-center justify-between">
                                <h3 class="text-lg font-semibold text-gray-800">
                                    <i class="fas fa-folder mr-2 text-blue-600"></i>Module: ${module}
                                </h3>
                                <div class="flex items-center space-x-4">
                                    <span class="text-sm text-gray-600">
                                        ${grantedCount}/${modulePermissions.length} quyền được cấp
                                    </span>
                                    <button onclick="toggleModulePermissions('${module}', true)" 
                                            class="text-green-600 hover:text-green-800 text-sm">
                                        <i class="fas fa-check-circle mr-1"></i>Cấp tất cả
                                    </button>
                                    <button onclick="toggleModulePermissions('${module}', false)" 
                                            class="text-red-600 hover:text-red-800 text-sm">
                                        <i class="fas fa-times-circle mr-1"></i>Thu hồi tất cả
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="p-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                ${modulePermissions.map(permission => {
                                    const rolePermission = rolePermissions.find(rp => rp.permissionId === permission.permissionId);
                                    const isGranted = rolePermission && rolePermission.granted;
                                    
                                    return `
                                        <div class="permission-card border rounded-lg p-4 ${isGranted ? 'border-green-300 bg-green-50' : 'border-gray-300 bg-white'}">
                                            <div class="flex items-center justify-between mb-3">
                                                <h4 class="font-medium text-gray-800">${permission.permissionName}</h4>
                                                <label class="relative inline-flex items-center cursor-pointer">
                                                    <input type="checkbox" 
                                                           ${isGranted ? 'checked' : ''} 
                                                           onchange="togglePermission(${permission.permissionId}, this.checked)"
                                                           class="sr-only peer">
                                                    <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                                                </label>
                                            </div>
                                            <div class="text-xs text-gray-600 mb-2">
                                                <span class="inline-block bg-gray-100 px-2 py-1 rounded">${permission.permissionCode}</span>
                                            </div>
                                            <div class="text-xs text-gray-500 mb-2">
                                                <i class="fas fa-cog mr-1"></i>${permission.action} • 
                                                <i class="fas fa-cube mr-1"></i>${permission.resource || 'N/A'}
                                            </div>
                                            ${permission.description ? `<p class="text-xs text-gray-600">${permission.description}</p>` : ''}
                                            ${isGranted && rolePermission ? `
                                                <div class="mt-2 text-xs text-green-600">
                                                    <i class="fas fa-user mr-1"></i>Cấp bởi: ${rolePermission.grantedBy || 'System'}
                                                    <br><i class="fas fa-calendar mr-1"></i>Ngày: ${formatDate(rolePermission.grantedDate)}
                                                </div>
                                            ` : ''}
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

        function togglePermission(permissionId, granted) {
            if (!currentRoleId) return;

            const action = granted ? 'grantRolePermission' : 'revokeRolePermission';
            
            fetch('${pageContext.request.contextPath}/permission-management', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=${action}&roleId=${currentRoleId}&permissionId=${permissionId}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update local data
                    const existingIndex = rolePermissions.findIndex(rp => rp.permissionId === permissionId);
                    if (granted) {
                        if (existingIndex >= 0) {
                            rolePermissions[existingIndex].granted = true;
                        } else {
                            rolePermissions.push({
                                permissionId: permissionId,
                                granted: true,
                                grantedBy: '${sessionScope.user.username}',
                                grantedDate: new Date().toISOString()
                            });
                        }
                    } else {
                        if (existingIndex >= 0) {
                            rolePermissions[existingIndex].granted = false;
                        }
                    }
                    
                    updateGrantedCount();
                    showNotification(data.message, 'success');
                } else {
                    // Revert checkbox state
                    event.target.checked = !granted;
                    showNotification(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error toggling permission:', error);
                // Revert checkbox state
                event.target.checked = !granted;
                showNotification('Lỗi khi thay đổi quyền', 'error');
            });
        }

        function toggleModulePermissions(module, grant) {
            if (!currentRoleId) return;

            const modulePermissions = allPermissions.filter(p => p.module === module);
            const permissionIds = modulePermissions.map(p => p.permissionId);

            const action = grant ? 'bulkGrantRolePermissions' : 'bulkRevokeRolePermissions';
            
            fetch('${pageContext.request.contextPath}/permission-management', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=${action}&roleId=${currentRoleId}&permissionIds=${permissionIds.join(',')}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Reload permissions to reflect changes
                    loadRolePermissions();
                    showNotification(data.message, 'success');
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error toggling module permissions:', error);
                showNotification('Lỗi khi thay đổi quyền module', 'error');
            });
        }

        function updateGrantedCount() {
            const grantedCount = rolePermissions.filter(rp => rp.granted).length;
            document.getElementById('grantedPermissionsCount').textContent = grantedCount;
        }

        function showBulkAssignModal() {
            if (!currentRoleId) {
                alert('Vui lòng chọn vai trò trước');
                return;
            }
            
            // Load available permissions
            loadAvailablePermissions();
            document.getElementById('bulkAssignModal').classList.remove('hidden');
        }

        function loadAvailablePermissions() {
            const availableContainer = document.getElementById('availablePermissions');
            const selectedContainer = document.getElementById('selectedPermissions');
            
            const availablePermissions = allPermissions.filter(p => 
                !rolePermissions.some(rp => rp.permissionId === p.permissionId && rp.granted)
            );
            
            const grantedPermissions = allPermissions.filter(p => 
                rolePermissions.some(rp => rp.permissionId === p.permissionId && rp.granted)
            );

            availableContainer.innerHTML = availablePermissions.map(permission => `
                <div class="flex items-center justify-between p-2 border-b border-gray-200">
                    <div>
                        <div class="font-medium text-sm">${permission.permissionName}</div>
                        <div class="text-xs text-gray-500">${permission.permissionCode}</div>
                    </div>
                    <button onclick="addPermissionToBulk(${permission.permissionId})" 
                            class="text-green-600 hover:text-green-800">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            `).join('');

            selectedContainer.innerHTML = grantedPermissions.map(permission => `
                <div class="flex items-center justify-between p-2 border-b border-gray-200">
                    <div>
                        <div class="font-medium text-sm">${permission.permissionName}</div>
                        <div class="text-xs text-gray-500">${permission.permissionCode}</div>
                    </div>
                    <button onclick="removePermissionFromBulk(${permission.permissionId})" 
                            class="text-red-600 hover:text-red-800">
                        <i class="fas fa-minus"></i>
                    </button>
                </div>
            `).join('');
        }

        function addPermissionToBulk(permissionId) {
            togglePermission(permissionId, true);
            setTimeout(loadAvailablePermissions, 500); // Refresh after a short delay
        }

        function removePermissionFromBulk(permissionId) {
            togglePermission(permissionId, false);
            setTimeout(loadAvailablePermissions, 500); // Refresh after a short delay
        }

        function closeBulkAssignModal() {
            document.getElementById('bulkAssignModal').classList.add('hidden');
        }

        function saveBulkAssign() {
            // The changes are already saved individually, just close the modal
            closeBulkAssignModal();
            loadRolePermissions(); // Refresh the main view
        }

        function exportRolePermissions() {
            if (!currentRoleId) {
                alert('Vui lòng chọn vai trò trước');
                return;
            }
            
            window.open(`${pageContext.request.contextPath}/permission-management?action=exportRolePermissions&roleId=${currentRoleId}`, '_blank');
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