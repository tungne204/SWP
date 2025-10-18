<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>My Appointments</title>
    <link href="/assets/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
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
        .action-buttons {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #dee2e6;
        }
        .edit-form {
            display: none;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-top: 10px;
        }
        .edit-form.show {
            display: block;
        }
        .form-group {
            margin-bottom: 10px;
        }
        .form-group label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 5px;
        }
        .form-control {
            border: 1px solid #ced4da;
            border-radius: 4px;
            padding: 8px 12px;
        }
        .btn-sm {
            padding: 5px 10px;
            font-size: 0.875rem;
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
                                
                                <!-- Action Buttons -->
                                <div class="action-buttons">
                                    <button type="button" class="btn btn-warning btn-sm me-2" onclick="toggleEditForm(${appointment.appointmentId})">
                                        <i class="bi bi-pencil"></i> Update
                                    </button>
                                    <button type="button" class="btn btn-danger btn-sm" onclick="deleteAppointment(${appointment.appointmentId})">
                                        <i class="bi bi-trash"></i> Delete
                                    </button>
                                </div>
                                
                                <!-- Edit Form -->
                                <div id="editForm_${appointment.appointmentId}" class="edit-form">
                                    <h6><i class="bi bi-pencil-square"></i> Edit Appointment</h6>
                                    <form id="updateForm_${appointment.appointmentId}" onsubmit="updateAppointment(event, ${appointment.appointmentId})">
                                        <!-- Hidden fields for IDs -->
                                        <input type="hidden" id="patientId_${appointment.appointmentId}" value="${appointment.patientId}">
                                        <input type="hidden" id="doctorId_${appointment.appointmentId}" value="${appointment.doctorId}">
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="patientFullName_${appointment.appointmentId}">Patient Full Name:</label>
                                                    <input type="text" class="form-control" id="patientFullName_${appointment.appointmentId}" 
                                                           value="${appointment.patientFullName}" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="patientDob_${appointment.appointmentId}">Date of Birth:</label>
                                                    <input type="date" class="form-control" id="patientDob_${appointment.appointmentId}" 
                                                           value="<fmt:formatDate value='${appointment.patientDob}' pattern='yyyy-MM-dd' />" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="patientAddress_${appointment.appointmentId}">Address:</label>
                                                    <input type="text" class="form-control" id="patientAddress_${appointment.appointmentId}" 
                                                           value="${appointment.patientAddress}" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="patientInsuranceInfo_${appointment.appointmentId}">Insurance Info:</label>
                                                    <input type="text" class="form-control" id="patientInsuranceInfo_${appointment.appointmentId}" 
                                                           value="${appointment.patientInsuranceInfo}" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="parentName_${appointment.appointmentId}">Parent Name:</label>
                                                    <input type="text" class="form-control" id="parentName_${appointment.appointmentId}" 
                                                           value="${appointment.parentName}" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="parentIdInfo_${appointment.appointmentId}">Parent ID:</label>
                                                    <input type="text" class="form-control" id="parentIdInfo_${appointment.appointmentId}" 
                                                           value="${appointment.parentIdInfo}" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="dateTime_${appointment.appointmentId}">Date & Time:</label>
                                                    <input type="datetime-local" class="form-control" id="dateTime_${appointment.appointmentId}" 
                                                           data-datetime="<fmt:formatDate value='${appointment.dateTime}' pattern='yyyy-MM-dd HH:mm' />" required>
                                                </div>
                                                <!-- Status field removed - patients cannot change appointment status -->
                                            </div>
                                        </div>
                                        <div class="text-end mt-3">
                                            <button type="button" class="btn btn-secondary btn-sm me-2" onclick="toggleEditForm(${appointment.appointmentId})">
                                                <i class="bi bi-x-circle"></i> Cancel
                                            </button>
                                            <button type="submit" class="btn btn-success btn-sm">
                                                <i class="bi bi-check-circle"></i> Confirm Update
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Toggle edit form visibility
        function toggleEditForm(appointmentId) {
            const editForm = document.getElementById('editForm_' + appointmentId);
            editForm.classList.toggle('show');
        }
        
        // Update appointment
        function updateAppointment(event, appointmentId) {
            event.preventDefault();
            
            // Get form data
            const formData = new FormData();
            formData.append('appointmentId', appointmentId.toString());
            formData.append('patientId', document.getElementById('patientId_' + appointmentId)?.value || '');
            formData.append('doctorId', document.getElementById('doctorId_' + appointmentId)?.value || '');
            formData.append('dateTime', document.getElementById('dateTime_' + appointmentId).value);
            // Status removed - patients cannot change appointment status
            
            // Debug: Log form data
            console.log('Sending form data:');
            for (let [key, value] of formData.entries()) {
                console.log(key + ': ' + value);
            }
            
            // Send update request
            fetch('UpdateAppointmentServlet', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    return response.text();
                } else {
                    return response.text().then(text => {
                        throw new Error(text || 'Update failed');
                    });
                }
            })
            .then(result => {
                if (result === 'success') {
                    // Show success message
                    showMessage('Appointment updated successfully!', 'success');
                    // Hide edit form
                    toggleEditForm(appointmentId);
                    // Reload page after a short delay
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                } else {
                    throw new Error(result || 'Update failed');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Error updating appointment: ' + error.message, 'error');
            });
        }
        
        // Delete appointment
        function deleteAppointment(appointmentId) {
            if (confirm('Are you sure you want to delete this appointment? This action cannot be undone.')) {
                const formData = new FormData();
                formData.append('appointmentId', appointmentId.toString());
                
                // Debug: Log form data
                console.log('Deleting appointment ID:', appointmentId);
                
                fetch('DeleteAppointmentServlet', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        showMessage('Appointment deleted successfully!', 'success');
                        // Reload page after a short delay
                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);
                    } else {
                        throw new Error('Delete failed');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showMessage('Error deleting appointment. Please try again.', 'error');
                });
            }
        }
        
        // Show message function
        function showMessage(message, type) {
            // Remove existing alerts
            const existingAlerts = document.querySelectorAll('.alert');
            existingAlerts.forEach(alert => alert.remove());
            
            // Create new alert
            const alertDiv = document.createElement('div');
            const alertClass = type === 'success' ? 'success' : 'danger';
            const iconClass = type === 'success' ? 'check-circle' : 'exclamation-triangle';
            alertDiv.className = 'alert alert-' + alertClass + ' alert-dismissible fade show';
            alertDiv.innerHTML = 
                '<i class="bi bi-' + iconClass + '"></i> ' + message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            // Insert at the top of the container
            const container = document.querySelector('.container');
            container.insertBefore(alertDiv, container.firstChild);
            
            // Auto dismiss after 5 seconds
            setTimeout(() => {
                if (alertDiv.parentNode) {
                    alertDiv.remove();
                }
            }, 5000);
        }
        
        // Sort appointments by ID (descending - newest first)
        document.addEventListener('DOMContentLoaded', function() {
            const appointmentCards = document.querySelectorAll('.appointment-card');
            const container = document.querySelector('.col-12');
            
            // Convert to array and sort by appointment ID
            const sortedCards = Array.from(appointmentCards).sort((a, b) => {
                const idA = parseInt(a.querySelector('h5').textContent.match(/#(\d+)/)[1]);
                const idB = parseInt(b.querySelector('h5').textContent.match(/#(\d+)/)[1]);
                return idB - idA; // Descending order (newest first)
            });
            
            // Re-append sorted cards
            sortedCards.forEach(card => {
                container.appendChild(card);
            });
            
            // Convert datetime format for datetime-local inputs
            const datetimeInputs = document.querySelectorAll('input[type="datetime-local"]');
            datetimeInputs.forEach(input => {
                const datetimeValue = input.getAttribute('data-datetime');
                if (datetimeValue) {
                    // Convert "yyyy-MM-dd HH:mm" to "yyyy-MM-ddTHH:mm" format
                    const formattedValue = datetimeValue.replace(' ', 'T');
                    input.value = formattedValue;
                }
            });
        });
    </script>
</body>
</html>
