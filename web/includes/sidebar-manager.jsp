<style>
    .sidebar-nav {
        padding: 20px 0 0 0;
    }
    
    .nav-section {
        margin-bottom: 30px;
    }
    
    .nav-section:last-child {
        margin-bottom: 0;
        padding-bottom: 20px;
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
                <a href="${pageContext.request.contextPath}/doctor-management" class="nav-link">
                    <i class="bi bi-person-badge"></i>
                    <span class="nav-link-text">Doctor Management</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/doctors?action=addQualification" class="nav-link">
                    <i class="bi bi-award"></i>
                    <span class="nav-link-text">Qualifications</span>
                </a>
            </div>
        </div>
        
        <!-- Permission Management -->
        <div class="nav-section">
            <div class="nav-section-title">Permission Management</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/permission-management?action=dashboard" class="nav-link">
                    <i class="bi bi-shield-check"></i>
                    <span class="nav-link-text">Permission Dashboard</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/permission-management" class="nav-link">
                    <i class="bi bi-key"></i>
                    <span class="nav-link-text">Manage Permissions</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/permission-management?action=role-permissions" class="nav-link">
                    <i class="bi bi-people-fill"></i>
                    <span class="nav-link-text">Role Permissions</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/permission-management?action=user-permissions" class="nav-link">
                    <i class="bi bi-person-gear"></i>
                    <span class="nav-link-text">User Permissions</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/set-permission" class="nav-link">
                    <i class="bi bi-gear"></i>
                    <span class="nav-link-text">Set Permissions</span>
                </a>
            </div>
        </div>
        
        <!-- System Management -->
        <div class="nav-section">
            <div class="nav-section-title">System Management</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/permission-management?action=audit" class="nav-link">
                    <i class="bi bi-journal-text"></i>
                    <span class="nav-link-text">Audit Logs</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager/statistics" class="nav-link">
                    <i class="bi bi-bar-chart"></i>
                    <span class="nav-link-text">Statistics</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager-dashboard?action=reports" class="nav-link">
                    <i class="bi bi-graph-up"></i>
                    <span class="nav-link-text">Reports</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager-dashboard?action=settings" class="nav-link">
                    <i class="bi bi-gear-wide-connected"></i>
                    <span class="nav-link-text">System Settings</span>
                </a>
            </div>
        </div>
        
        <!-- Analytics -->
        <div class="nav-section">
            <div class="nav-section-title">Analytics</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager-dashboard?action=analytics&type=users" class="nav-link">
                    <i class="bi bi-bar-chart"></i>
                    <span class="nav-link-text">User Analytics</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager-dashboard?action=analytics&type=appointments" class="nav-link">
                    <i class="bi bi-calendar-week"></i>
                    <span class="nav-link-text">Appointment Analytics</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager-dashboard?action=analytics&type=performance" class="nav-link">
                    <i class="bi bi-speedometer"></i>
                    <span class="nav-link-text">Performance Metrics</span>
                </a>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="nav-section">
            <div class="nav-section-title">Quick Actions</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/doctors?action=add" class="nav-link">
                    <i class="bi bi-plus-circle"></i>
                    <span class="nav-link-text">Add New Doctor</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager-dashboard?action=backup" class="nav-link">
                    <i class="bi bi-cloud-download"></i>
                    <span class="nav-link-text">Backup System</span>
                </a>
            </div>
        </div>
    </nav>
</div>