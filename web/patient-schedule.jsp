<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Patient Schedule - Doctor Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .schedule-card {
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
                border: none;
            }
            .appointment-card {
                border-left: 4px solid #007bff;
                transition: all 0.3s ease;
            }
            .appointment-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .status-badge {
                font-size: 0.8em;
            }
            .status-active {
                background-color: #28a745;
            }
            .status-inactive {
                background-color: #6c757d;
            }
            .filter-section {
                background-color: white;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }
            .time-badge {
                background-color: #e9ecef;
                color: #495057;
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 0.9em;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 bg-dark text-white min-vh-100 p-3">
                    <h4 class="mb-4">Doctor Panel</h4>
                    <nav class="nav flex-column">
                        <a class="nav-link text-white" href="doctorDashboard.jsp">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                        <a class="nav-link text-white active" href="${pageContext.request.contextPath}/PatientScheduleController">
                            <i class="fas fa-calendar-alt me-2"></i>Patient Schedule
                        </a>
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/doctor/medical-reports">
                            <i class="fas fa-file-medical me-2"></i>Medical Reports
                        </a>
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </a>
                    </nav>
                </div>

                <!-- Main Content -->
                <div class="col-md-10 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0">
                            <i class="fas fa-calendar-alt text-primary me-3"></i>
                            Lịch Khám Bệnh Nhi
                        </h2>
                        <div class="text-muted">
                            <div>Xin chào, <strong>${sessionScope.acc.username}</strong></div>
                            <small>
                                <i class="fas fa-clock me-2"></i>
                                <jsp:useBean id="now" class="java.util.Date"/>
                                <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm"/>
                            </small>
                        </div>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <h5 class="mb-3">
                            <i class="fas fa-filter me-2"></i>Filter Appointments
                        </h5>
                        <form method="GET" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Filter Type</label>
                                <select name="filter" id="filterType" class="form-select">
                                    <option value="">All Appointments</option>
                                    <option value="date"
                                            <c:if test="${currentFilter eq 'date'}">selected</c:if>>By Date</option>
                                            <option value="range"
                                            <c:if test="${currentFilter eq 'range'}">selected</c:if>>Date Range</option>
                                    </select>
                                </div>

                                <div class="col-md-3" id="dateFilter"
                                     style="display: <c:choose><c:when test='${currentFilter eq "date"}'>block</c:when><c:otherwise>none</c:otherwise></c:choose>;">
                                         <label class="form-label">Select Date</label>
                                             <input type="date" name="date" class="form-control" value="${selectedDate}">
                            </div>

                            <div class="col-md-2" id="fromDateFilter"
                                 style="display: <c:choose><c:when test='${currentFilter eq "range"}'>block</c:when><c:otherwise>none</c:otherwise></c:choose>;">
                                         <label class="form-label">From Date</label>
                                             <input type="date" name="fromDate" class="form-control" value="${selectedFromDate}">
                            </div>

                            <div class="col-md-2" id="toDateFilter"
                                 style="display: <c:choose><c:when test='${currentFilter eq "range"}'>block</c:when><c:otherwise>none</c:otherwise></c:choose>;">
                                         <label class="form-label">To Date</label>
                                             <input type="date" name="toDate" class="form-control" value="${selectedToDate}">
                            </div>

                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2">
                                    <i class="fas fa-search me-1"></i>Filter
                                </button>
                                <a href="${pageContext.request.contextPath}/PatientScheduleController" class="btn btn-outline-secondary">
                                    <i class="fas fa-undo me-1"></i>Reset
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Appointments List -->
                    <div class="card schedule-card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-list me-2"></i>
                                Appointments (<c:out value="${fn:length(appointments)}"/> found)
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty appointments}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No appointments found</h5>
                                        <p class="text-muted">There are no appointments scheduled for the selected criteria.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row">
                                        <c:forEach var="appointment" items="${appointments}">
                                            <div class="col-md-6 col-lg-4 mb-3">
                                                <div class="card appointment-card h-100">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                                            <h6 class="card-title mb-0">
                                                                <i class="fas fa-user me-2"></i>
                                                                ${appointment.patientName}
                                                            </h6>
                                                            <c:choose>
                                                                <c:when test="${appointment.status}">
                                                                    <span class="badge status-badge status-active">Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge status-badge status-inactive">Cancelled</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <div class="mb-2">
                                                            <small class="text-muted">
                                                                <i class="fas fa-calendar me-1"></i>
                                                                <fmt:formatDate value="${appointment.dateTime}" pattern="dd/MM/yyyy"/>
                                                            </small>
                                                        </div>

                                                        <div class="mb-2">
                                                            <span class="time-badge">
                                                                <i class="fas fa-clock me-1"></i>
                                                                <fmt:formatDate value="${appointment.dateTime}" pattern="HH:mm"/>
                                                            </span>
                                                        </div>

                                                        <div class="mb-2">
                                                            <small class="text-muted">
                                                                <i class="fas fa-phone me-1"></i>
                                                                ${appointment.patientPhone}
                                                            </small>
                                                        </div>

                                                        <div class="mb-3">
                                                            <small class="text-muted">
                                                                <i class="fas fa-envelope me-1"></i>
                                                                ${appointment.patientEmail}
                                                            </small>
                                                        </div>

                                                        <div class="d-grid gap-2">
                                                            <a href="${pageContext.request.contextPath}/doctor/appointment-details?id=${appointment.appointmentId}" 
                                                               class="btn btn-sm btn-outline-primary">
                                                                <i class="fas fa-eye me-1"></i>View Details
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Handle filter type change
            document.getElementById('filterType').addEventListener('change', function () {
                const filterType = this.value;
                const dateFilter = document.getElementById('dateFilter');
                const fromDateFilter = document.getElementById('fromDateFilter');
                const toDateFilter = document.getElementById('toDateFilter');

                dateFilter.style.display = 'none';
                fromDateFilter.style.display = 'none';
                toDateFilter.style.display = 'none';

                if (filterType === 'date') {
                    dateFilter.style.display = 'block';
                } else if (filterType === 'range') {
                    fromDateFilter.style.display = 'block';
                    toDateFilter.style.display = 'block';
                }
            });

            // Set current date as max for inputs
            const today = new Date().toISOString().split('T')[0];
            document.querySelectorAll('input[type="date"]').forEach(input => {
                if (!input.value) {
                    input.max = today;
                }
            });
        </script>
    </body>
</html>
