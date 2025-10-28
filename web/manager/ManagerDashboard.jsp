<%-- 
    Document   : Manager Dashboard
    Created on : Oct 18, 2025, 11:30:00 PM
    Author     : System
--%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manager Dashboard | Medilab Clinic</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
        <jsp:include page="../includes/head-includes.jsp"/>
        
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
                padding-top: 0px; /* Account for fixed header */
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

            .dashboard-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 40px;
                border-radius: 15px;
                margin-bottom: 30px;
                text-align: center;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .dashboard-header h1 {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 10px;
                color: #fff;
            }
            
            .dashboard-header p {
                font-size: 1.1rem;
                opacity: 0.9;
                margin: 0;
            }
            
            .quick-actions {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 25px;
                margin-bottom: 40px;
            }
            
            .action-card {
                background: white;
                padding: 30px;
                border-radius: 15px;
                text-decoration: none;
                color: inherit;
                transition: all 0.3s ease;
                box-shadow: 0 5px 20px rgba(0,0,0,0.08);
                border: 1px solid #e9ecef;
                text-align: center;
            }
            
            .action-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.15);
                text-decoration: none;
                color: inherit;
            }
            
            .action-card i {
                font-size: 3rem;
                color: var(--primary-color);
                margin-bottom: 20px;
                display: block;
            }
            
            .action-card h3 {
                font-size: 1.4rem;
                font-weight: 600;
                margin-bottom: 15px;
                color: #2c3e50;
            }
            
            .action-card p {
                color: #6c757d;
                margin: 0;
                line-height: 1.6;
            }
            
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }
            
            .stat-card {
                background: white;
                padding: 25px;
                border-radius: 10px;
                text-align: center;
                box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            }
            
            .stat-number {
                font-size: 2rem;
                font-weight: 700;
                color: var(--primary-color);
                margin-bottom: 5px;
            }
            
            .stat-label {
                color: #6c757d;
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            
            .priority-card {
                background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
                color: white;
            }
            
            .priority-card i {
                color: white !important;
            }
            
            .priority-card h3 {
                color: white !important;
            }
            
            .priority-card p {
                color: rgba(255,255,255,0.9) !important;
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
                <!-- Welcome Section -->
                <div class="dashboard-header">
                    <h1>Manager Dashboard</h1>
                    <p>Oversee clinic operations, manage staff, and monitor system performance</p>
                </div>

                <!-- Quick Actions -->
                <div class="quick-actions">
                    <!-- Doctor Management -->
                    <a href="${pageContext.request.contextPath}/manager/doctor-list.jsp" class="action-card">
                        <i class="bi bi-person-badge"></i>
                        <h3>Doctor Management</h3>
                        <p>Manage doctor profiles, schedules, and qualifications</p>
                    </a>

                    <!-- Permission Management -->
                    <a href="${pageContext.request.contextPath}/manager/permission-dashboard.jsp" class="action-card priority-card">
                        <i class="bi bi-shield-check"></i>
                        <h3>Permission Management</h3>
                        <p>Control user access, roles, and system permissions</p>
                    </a>

                    <!-- User Permissions -->
                    <a href="${pageContext.request.contextPath}/manager/user-permissions.jsp" class="action-card">
                        <i class="bi bi-person-gear"></i>
                        <h3>User Permissions</h3>
                        <p>Assign and modify individual user permissions</p>
                    </a>

                    <!-- Role Permissions -->
                    <a href="${pageContext.request.contextPath}/manager/role-permissions.jsp" class="action-card">
                        <i class="bi bi-people-fill"></i>
                        <h3>Role Permissions</h3>
                        <p>Configure role-based access control settings</p>
                    </a>

                    <!-- Audit Logs -->
                    <a href="${pageContext.request.contextPath}/manager/audit-logs.jsp" class="action-card">
                        <i class="bi bi-journal-text"></i>
                        <h3>Audit Logs</h3>
                        <p>Monitor system activities and security events</p>
                    </a>

                    <!-- Analytics & Reports -->
                    <a href="${pageContext.request.contextPath}/analytics/users" class="action-card">
                        <i class="bi bi-bar-chart"></i>
                        <h3>Analytics & Reports</h3>
                        <p>View system performance and usage statistics</p>
                    </a>

                    <!-- Qualifications -->
                    <a href="${pageContext.request.contextPath}/manager/qualification-add.jsp" class="action-card">
                        <i class="bi bi-award"></i>
                        <h3>Qualifications</h3>
                        <p>Manage doctor qualifications and certifications</p>
                    </a>

                    <!-- System Settings -->
                    <a href="${pageContext.request.contextPath}/system-settings" class="action-card">
                        <i class="bi bi-gear-wide-connected"></i>
                        <h3>System Settings</h3>
                        <p>Configure system parameters and preferences</p>
                    </a>
                </div>

                <!-- Statistics Section -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">15</div>
                        <div class="stat-label">Active Doctors</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">8</div>
                        <div class="stat-label">Staff Members</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">1,247</div>
                        <div class="stat-label">Total Patients</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">42</div>
                        <div class="stat-label">Permissions Set</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">98%</div>
                        <div class="stat-label">System Uptime</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">156</div>
                        <div class="stat-label">Today's Activities</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="../includes/footer.jsp"/>
        
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>