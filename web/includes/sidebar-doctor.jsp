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
                <a href="${pageContext.request.contextPath}/doctor-dashboard" class="nav-link">
                    <i class="bi bi-speedometer2"></i>
                    <span class="nav-link-text">Dashboard</span>
                </a>
            </div>
        </div>
        
        <!-- Appointments -->
        <div class="nav-section">
            <div class="nav-section-title">Appointments</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/appointment-list" class="nav-link">
                    <i class="bi bi-calendar-check"></i>
                    <span class="nav-link-text">Appointment List</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/appointment-detail" class="nav-link">
                    <i class="bi bi-calendar-event"></i>
                    <span class="nav-link-text">Appointment Details</span>
                </a>
            </div>
        </div>
        
        <!-- Medical Records -->
        <div class="nav-section">
            <div class="nav-section-title">Medical Records</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/medical-report-list" class="nav-link">
                    <i class="bi bi-file-medical"></i>
                    <span class="nav-link-text">Medical Reports</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/medical-report-form" class="nav-link">
                    <i class="bi bi-file-plus"></i>
                    <span class="nav-link-text">New Medical Report</span>
                </a>
            </div>
        </div>
        
        <!-- Lab Tests -->
        <div class="nav-section">
            <div class="nav-section-title">Laboratory</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/test-result-list" class="nav-link">
                    <i class="bi bi-clipboard-data"></i>
                    <span class="nav-link-text">Test Results</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/test-result-by-record" class="nav-link">
                    <i class="bi bi-search"></i>
                    <span class="nav-link-text">Search Test Results</span>
                </a>
            </div>
        </div>
        
        <!-- Queue Management -->
        <div class="nav-section">
            <div class="nav-section-title">Patient Queue</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/patient-queue" class="nav-link">
                    <i class="bi bi-people"></i>
                    <span class="nav-link-text">Waiting Queue</span>
                </a>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="nav-section">
            <div class="nav-section-title">Quick Actions</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/medical-report-form" class="nav-link">
                    <i class="bi bi-plus-circle"></i>
                    <span class="nav-link-text">New Prescription</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/test-result-list" class="nav-link">
                    <i class="bi bi-clipboard-check"></i>
                    <span class="nav-link-text">Review Lab Results</span>
                </a>
            </div>
        </div>
    </nav>
</div>