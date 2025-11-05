<%-- 
    Document   : Receptionist Dashboard
    Created on : Oct 18, 2025, 10:37:08 PM
    Author     : KiênPC
--%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Receptionist Dashboard | Medilab Clinic</title>
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
                padding-top: 70px; /* Account for fixed header */
            }
            
            .sidebar-fixed {
                position: fixed;
                top: 90px;
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
                background: #0d6efd;
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
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="../includes/header.jsp"/>
        
        <div class="main-wrapper">
            <!-- Sidebar -->
            <%@ include file="../includes/sidebar-receptionist.jsp" %>

            <!-- Main Content Area -->
            <div class="content-area">
                <!-- Welcome Section -->
                <div class="dashboard-header">
                    <h1>Welcome to Receptionist Dashboard</h1>
                    <p>Manage patient check-ins, appointments, and clinic operations efficiently</p>
                </div>

                <!-- Quick Actions -->
                <div class="quick-actions">
                    <!-- Patient Check-in -->
                    <a href="checkin-form" class="action-card">
                        <i class="fas fa-user-plus"></i>
                        <h3>Patient Check-in</h3>
                        <p>Register new patients or check-in existing patients for appointments</p>
                    </a>

                    <!-- Search Patients -->
                    <a href="Patient-Search" class="action-card">
                        <i class="fas fa-search"></i>
                        <h3>Search Patients</h3>
                        <p>Find and view patient information quickly and efficiently</p>
                    </a>

                    <!-- Appointment Management -->
                    <a href="Appointment-List" class="action-card">
                        <i class="fas fa-calendar-alt"></i>
                        <h3>Appointments</h3>
                        <p>View and manage today's appointments and schedules</p>
                    </a>

                    <!-- Patient Queue -->
                    <a href="patient-queue" class="action-card">
                        <i class="fas fa-clock"></i>
                        <h3>Patient Queue</h3>
                        <p>Monitor waiting patients and manage queue efficiently</p>
                    </a>

                    <!-- Patient Profiles -->
                    <a href="patient-profiles" class="action-card">
                        <i class="fas fa-user"></i>
                        <h3>Patient Profiles</h3>
                        <p>Access detailed patient information and medical history</p>
                    </a>

                    <!-- Reports -->
                    <a href="reports" class="action-card">
                        <i class="fas fa-chart-bar"></i>
                        <h3>Reports</h3>
                        <p>Generate and view clinic reports and statistics</p>
                    </a>
                </div>

                <!-- Statistics Section -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">24</div>
                        <div class="stat-label">Today's Appointments</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">8</div>
                        <div class="stat-label">Waiting Patients</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">156</div>
                        <div class="stat-label">Total Patients</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">12</div>
                        <div class="stat-label">Completed Today</div>
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
