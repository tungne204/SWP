<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    .sidebar-nav {
        padding: 20px 0;
    }
    
    .nav-section {
        margin-bottom: 30px;
    }
    
    .nav-section-title {
        font-size: 12px;
        font-weight: 600;
        color: #6c757d;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 10px;
        padding: 0 20px;
    }
    
    .nav-item {
        margin-bottom: 5px;
    }
    
    .nav-link {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        color: #495057;
        text-decoration: none;
        transition: all 0.3s ease;
        border-left: 3px solid transparent;
    }
    
    .nav-link:hover {
        background-color: #f8f9fa;
        color: var(--primary-color);
        border-left-color: var(--primary-color);
    }
    
    .nav-link.active {
        background-color: rgba(63, 187, 192, 0.1);
        color: var(--primary-color);
        border-left-color: var(--primary-color);
        font-weight: 500;
    }
    
    .nav-link i {
        width: 20px;
        margin-right: 12px;
        font-size: 16px;
    }
    
    .nav-link-text {
        flex: 1;
    }
    
    .nav-badge {
        background: #dc3545;
        color: white;
        font-size: 10px;
        padding: 2px 6px;
        border-radius: 10px;
        margin-left: auto;
    }
</style>

<div class="sidebar-fixed">
    <nav class="sidebar-nav">
        <!-- Dashboard Section -->
        <div class="nav-section">
            <div class="nav-section-title">Dashboard</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager-dashboard" class="nav-link">
                    <i class="bi bi-speedometer2"></i>
                    <span class="nav-link-text">Dashboard</span>
                </a>
            </div>
        </div>
        
        <!-- User Management -->
        <div class="nav-section">
            <div class="nav-section-title">User Management</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/setPermission" class="nav-link">
                    <i class="bi bi-shield-check"></i>
                    <span class="nav-link-text">Set Permissions</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/user-list" class="nav-link">
                    <i class="bi bi-people"></i>
                    <span class="nav-link-text">User List</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/role-management" class="nav-link">
                    <i class="bi bi-person-badge"></i>
                    <span class="nav-link-text">Role Management</span>
                </a>
            </div>
        </div>
        
        <!-- System Reports -->
        <div class="nav-section">
            <div class="nav-section-title">Reports & Analytics</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/system-reports" class="nav-link">
                    <i class="bi bi-graph-up"></i>
                    <span class="nav-link-text">System Reports</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/user-activity" class="nav-link">
                    <i class="bi bi-activity"></i>
                    <span class="nav-link-text">User Activity</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/audit-logs" class="nav-link">
                    <i class="bi bi-journal-text"></i>
                    <span class="nav-link-text">Audit Logs</span>
                </a>
            </div>
        </div>
        
        <!-- System Configuration -->
        <div class="nav-section">
            <div class="nav-section-title">System Settings</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/system-config" class="nav-link">
                    <i class="bi bi-gear"></i>
                    <span class="nav-link-text">System Configuration</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/backup-restore" class="nav-link">
                    <i class="bi bi-cloud-arrow-up"></i>
                    <span class="nav-link-text">Backup & Restore</span>
                </a>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="nav-section">
            <div class="nav-section-title">Quick Actions</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/setPermission" class="nav-link">
                    <i class="bi bi-plus-circle"></i>
                    <span class="nav-link-text">Add New User</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/system-reports" class="nav-link">
                    <i class="bi bi-file-earmark-text"></i>
                    <span class="nav-link-text">Generate Report</span>
                </a>
            </div>
        </div>
    </nav>
</div>