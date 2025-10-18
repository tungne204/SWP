<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>My Appointments</title>
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="../assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <style>
        .appointment-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .appointment-header {
            background-color: #f8f9fa;
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
            border-radius: 8px 8px 0 0;
        }
        .appointment-body {
            padding: 20px;
        }
        .info-section {
            margin-bottom: 15px;
        }
        .info-section h6 {
            color: #495057;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .info-item {
            margin-bottom: 5px;
        }
        .info-label {
            font-weight: 500;
            color: #6c757d;
        }
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="bi bi-calendar-check"></i> My Appointments</h2>
                    <a href="Home.jsp" class="btn btn-primary">Go Home</a>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${empty appointmentDetails}">
                    <div class="text-center py-5">
                        <i class="bi bi-calendar-x" style="font-size: 4rem; color: #6c757d;"></i>
                        <h4 class="mt-3 text-muted">No Appointments Found</h4>
                        <p class="text-muted">You haven't made any appointments yet.</p>
                        <a href="../Home.jsp#appointment" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Make an Appointment
                        </a>
                    </div>
                </c:if>

                <c:if test="${not empty appointmentDetails}">
                    <c:forEach var="appointment" items="${appointmentDetails}" varStatus="loop">
                        <div class="appointment-card">
                            <div class="appointment-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h5 class="mb-0">
                                            <i class="bi bi-calendar-event"></i> 
                                            Appointment #${appointment.appointmentId}
                                        </h5>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <span class="status-badge ${appointment.status ? 'status-active' : 'status-inactive'}">
                                            <c:choose>
                                                <c:when test="${appointment.status}">
                                                    <i class="bi bi-check-circle"></i> Active
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-x-circle"></i> Cancelled
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="appointment-body">
                                <div class="row">
                                    <!-- Appointment Information -->
                                    <div class="col-md-6">
                                        <div class="info-section">
                                            <h6><i class="bi bi-clock"></i> Appointment Details</h6>
                                            <div class="info-item">
                                                <span class="info-label">Date & Time:</span>
                                                <fmt:formatDate value="${appointment.dateTime}" pattern="dd/MM/yyyy HH:mm" />
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Doctor:</span>
                                                ${appointment.doctorName} - ${appointment.doctorSpecialty}
                                            </div>
                                        </div>
                                        
                                        <!-- Patient Information -->
                                        <div class="info-section">
                                            <h6><i class="bi bi-person"></i> Patient Information</h6>
                                            <div class="info-item">
                                                <span class="info-label">Full Name:</span>
                                                ${appointment.patientFullName}
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Date of Birth:</span>
                                                <fmt:formatDate value="${appointment.patientDob}" pattern="dd/MM/yyyy" />
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Address:</span>
                                                ${appointment.patientAddress}
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Insurance Info:</span>
                                                ${appointment.patientInsuranceInfo}
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Parent Information -->
                                    <div class="col-md-6">
                                        <div class="info-section">
                                            <h6><i class="bi bi-person-badge"></i> Parent Information</h6>
                                            <div class="info-item">
                                                <span class="info-label">Parent Name:</span>
                                                ${appointment.parentName}
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Parent ID:</span>
                                                ${appointment.parentIdInfo}
                                            </div>
                                        </div>
                                        
                                        <!-- Additional Information -->
                                        <div class="info-section">
                                            <h6><i class="bi bi-info-circle"></i> Additional Information</h6>
                                            <div class="info-item">
                                                <span class="info-label">Appointment ID:</span>
                                                #${appointment.appointmentId}
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Patient ID:</span>
                                                #${appointment.patientId}
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Doctor ID:</span>
                                                #${appointment.doctorId}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="../assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
