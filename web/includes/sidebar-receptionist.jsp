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
            <br>
            <br>
            <div class="nav-section-title">Dashboard</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/Receptionist-Dashboard" class="nav-link">
                    <i class="bi bi-speedometer2"></i>
                    <span class="nav-link-text">Dashboard</span>
                </a>
            </div>
        </div>

        <!-- Patient Management -->
        <div class="nav-section">
            <div class="nav-section-title">Patient Management</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/receptionist/checkin.jsp" class="nav-link">
                    <i class="bi bi-person-plus"></i>
                    <span class="nav-link-text">Patient Check-in</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/Patient-Search" class="nav-link">
                    <i class="bi bi-search"></i>
                    <span class="nav-link-text">Patients List</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/PatientProfile" class="nav-link">
                    <i class="bi bi-person-lines-fill"></i>
                    <span class="nav-link-text">Patient Profiles</span>
                </a>
            </div>
        </div>

        <!-- Appointments -->
        <div class="nav-section">
            <div class="nav-section-title">Appointments</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/Appointment-List" class="nav-link">
                    <i class="bi bi-calendar-check"></i>
                    <span class="nav-link-text">Appointment List</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/Appointment-UpdateSearch" class="nav-link">
                    <i class="bi bi-calendar-event"></i>
                    <span class="nav-link-text">Update Appointments</span>
                </a>
            </div>
        </div>

        <!-- Queue Management -->
        <div class="nav-section">
            <div class="nav-section-title">Queue Management</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/patient-queue" class="nav-link">
                    <i class="bi bi-people"></i>
                    <span class="nav-link-text">Waiting Screen</span>
                </a>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="nav-section">
            <div class="nav-section-title">Quick Actions</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/receptionist/checkin.jsp" class="nav-link">
                    <i class="bi bi-plus-circle"></i>
                    <span class="nav-link-text">New Patient</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/appointmentList" class="nav-link">
                    <i class="bi bi-calendar-plus"></i>
                    <span class="nav-link-text">Schedule Appointment</span>
                </a>
            </div>
        </div>
    </nav>
</div>