
<%@ include file="../includes/header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>My Appointments</title>
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="../assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 20px;
        }
        
        .page-title {
            color: #2c3e50;
            font-size: 2.2rem;
            font-weight: 600;
            text-align: center;
            margin-bottom: 30px;
            position: relative;
        }
        
        .page-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #3498db, #2980b9);
            border-radius: 2px;
        }
        
        .appointment-card {
            border: 1px solid #e3f2fd;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .appointment-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, #3498db, #2980b9);
        }
        
        .appointment-card:hover {
            box-shadow: 0 6px 20px rgba(52, 152, 219, 0.2);
            transform: translateY(-3px);
        }
        
        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e3f2fd;
        }
        
        .appointment-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
        }
        
        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-pending {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            color: white;
            box-shadow: 0 2px 4px rgba(243, 156, 18, 0.3);
        }
        
        .status-approved {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            color: white;
            box-shadow: 0 2px 4px rgba(39, 174, 96, 0.3);
        }
        
        .appointment-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .info-section h6 {
            color: #34495e;
            margin-bottom: 12px;
            font-weight: 600;
            font-size: 0.95em;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .info-section h6 i {
            color: #3498db;
        }
        
        .info-item {
            margin-bottom: 8px;
            font-size: 0.9em;
            display: flex;
            align-items: center;
        }
        
        .info-label {
            font-weight: 600;
            color: #7f8c8d;
            display: inline-block;
            width: 130px;
            min-width: 130px;
        }
        
        .info-value {
            color: #2c3e50;
            font-weight: 500;
        }
        
        .action-buttons {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 20px;
        }
        
        .btn-action {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 0.9em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .btn-update {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            box-shadow: 0 3px 6px rgba(52, 152, 219, 0.3);
        }
        
        .btn-update:hover {
            background: linear-gradient(135deg, #2980b9, #1f618d);
            transform: translateY(-2px);
            box-shadow: 0 5px 12px rgba(52, 152, 219, 0.4);
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            box-shadow: 0 3px 6px rgba(231, 76, 60, 0.3);
        }
        
        .btn-delete:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-2px);
            box-shadow: 0 5px 12px rgba(231, 76, 60, 0.4);
        }
        
        .edit-form {
            display: none;
            margin-top: 25px;
            padding: 25px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 12px;
            border: 2px solid #e3f2fd;
            position: relative;
        }
        
        .edit-form::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #3498db, #2980b9);
            border-radius: 12px 12px 0 0;
        }
        
        .edit-form.show {
            display: block;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .edit-section {
            margin-bottom: 25px;
        }
        
        .edit-section h6 {
            color: #2c3e50;
            margin-bottom: 18px;
            font-weight: 600;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 2px solid #e3f2fd;
            padding-bottom: 8px;
        }
        
        .edit-section h6 i {
            color: #3498db;
        }
        
        .form-group {
            margin-bottom: 18px;
        }
        
        .form-group label {
            font-weight: 600;
            color: #34495e;
            margin-bottom: 8px;
            display: block;
            font-size: 0.9em;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e3f2fd;
            border-radius: 8px;
            font-size: 0.9em;
            transition: all 0.3s ease;
            background-color: white;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            transform: translateY(-1px);
        }
        
        .form-control.is-invalid {
            border-color: #e74c3c;
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
        }
        
        .invalid-feedback {
            color: #e74c3c;
            font-size: 0.8em;
            margin-top: 5px;
            font-weight: 500;
        }
        
        .btn-success {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 0.9em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 3px 6px rgba(39, 174, 96, 0.3);
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            transform: translateY(-2px);
            box-shadow: 0 5px 12px rgba(39, 174, 96, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 0.9em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 3px 6px rgba(149, 165, 166, 0.3);
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #7f8c8d, #6c7b7d);
            transform: translateY(-2px);
            box-shadow: 0 5px 12px rgba(149, 165, 166, 0.4);
        }
        
        .alert {
            padding: 16px 20px;
            margin-bottom: 25px;
            border: none;
            border-radius: 10px;
            font-size: 0.95em;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border-left: 4px solid #27ae60;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border-left: 4px solid #e74c3c;
        }
        
        .alert i {
            font-size: 1.2em;
        }
        
        .btn-close {
            background: none;
            border: none;
            font-size: 1.2em;
            cursor: pointer;
            opacity: 0.7;
            transition: opacity 0.3s ease;
        }
        
        .btn-close:hover {
            opacity: 1;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #bdc3c7;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            color: #34495e;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            font-size: 1.1em;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1 class="page-title">My Appointments</h1>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle"></i>
                ${error}
                <button type="button" class="btn-close" onclick="this.parentElement.remove()">&times;</button>
            </div>
        </c:if>
        
        <c:if test="${not empty appointmentDetails}">
            <div class="row">
                <div class="col-12">
                    <c:forEach var="appointment" items="${appointmentDetails}">
                        <div class="appointment-card">
                            <div class="appointment-header">
                                <h5 class="appointment-title">
                                    <i class="bi bi-calendar-event"></i>
                                    Appointment Details
                                </h5>
                                <span class="status-badge ${appointment.status ? 'status-pending' : 'status-approved'}">
                                    <c:choose>
                                        <c:when test="${appointment.status}">
                                            <i class="bi bi-clock"></i> Pending Approval
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-check-circle"></i> Approved
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            
                            <div class="appointment-info">
                                <!-- Appointment Details -->
                                <div class="info-section">
                                    <h6><i class="bi bi-calendar-event"></i> Appointment Details</h6>
                                    <div class="info-item">
                                        <span class="info-label">Date & Time:</span>
                                        <span class="info-value">
                                            <fmt:formatDate value="${appointment.dateTime}" pattern="EEEE, MMMM dd, yyyy 'at' HH:mm" />
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Doctor:</span>
                                        <span class="info-value">${appointment.doctorName} - ${appointment.doctorSpecialty}</span>
                                    </div>
                                </div>
                                
                                <!-- Patient Information -->
                                <div class="info-section">
                                    <h6><i class="bi bi-person"></i> Patient Information</h6>
                                    <div class="info-item">
                                        <span class="info-label">Full Name:</span>
                                        <span class="info-value">${appointment.patientFullName}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Date of Birth:</span>
                                        <span class="info-value">
                                            <fmt:formatDate value="${appointment.patientDob}" pattern="MMMM dd, yyyy" />
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Address:</span>
                                        <span class="info-value">${appointment.patientAddress}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Insurance:</span>
                                        <span class="info-value">${appointment.patientInsuranceInfo}</span>
                                    </div>
                                </div>
                                
                                <!-- Parent Information -->
                                <div class="info-section">
                                    <h6><i class="bi bi-person-badge"></i> Parent Information</h6>
                                    <div class="info-item">
                                        <span class="info-label">Parent Name:</span>
                                        <span class="info-value">${appointment.parentName}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Parent ID:</span>
                                        <span class="info-value">${appointment.parentIdInfo}</span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="action-buttons">
                                <button class="btn-action btn-update" onclick="toggleEditForm('${appointment.appointmentId}')">
                                    <i class="bi bi-pencil-square"></i> Update
                                </button>
                                <button class="btn-action btn-delete" onclick="deleteAppointment('${appointment.appointmentId}')">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                            </div>
                            
                            <!-- Edit Form -->
                            <div id="editForm_${appointment.appointmentId}" class="edit-form">
                                <h5><i class="bi bi-pencil-square"></i> Edit Appointment</h5>
                                <form id="updateForm_${appointment.appointmentId}" data-appointment-id="${appointment.appointmentId}" onsubmit="updateAppointment(event, this)">
                                    <!-- Hidden fields for IDs -->
                                    <input type="hidden" name="appointmentId" id="appointmentId_${appointment.appointmentId}" value="${appointment.appointmentId}">
                                    <input type="hidden" name="patientId" id="patientId_${appointment.appointmentId}" value="${appointment.patientId}">
                                    <input type="hidden" name="parentId" id="parentId_${appointment.appointmentId}" value="${appointment.parentId}">
                                    
                                    <div class="row">
                                        <!-- Appointment Details -->
                                        <div class="col-md-6">
                                            <div class="edit-section">
                                                <h6><i class="bi bi-calendar-event"></i> Appointment Details</h6>
                                                <div class="form-group">
                                                    <label for="appointmentDate_${appointment.appointmentId}">Appointment Date:</label>
                                                    <input type="date" name="appointmentDate" class="form-control" id="appointmentDate_${appointment.appointmentId}" 
                                                           value="<fmt:formatDate value='${appointment.dateTime}' pattern='yyyy-MM-dd' />" required min="">
                                                    <div class="invalid-feedback">Appointment date must be in the future</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="appointmentTime_${appointment.appointmentId}">Appointment Time:</label>
                                                    <select name="appointmentTime" class="form-control" id="appointmentTime_${appointment.appointmentId}" required>
                                                        <option value="">Choose a time</option>
                                                        <option value="08:00" ${appointment.dateTime.hours == 8 ? 'selected' : ''}>8:00 AM</option>
                                                        <option value="09:00" ${appointment.dateTime.hours == 9 ? 'selected' : ''}>9:00 AM</option>
                                                        <option value="10:00" ${appointment.dateTime.hours == 10 ? 'selected' : ''}>10:00 AM</option>
                                                        <option value="11:00" ${appointment.dateTime.hours == 11 ? 'selected' : ''}>11:00 AM</option>
                                                        <option value="13:00" ${appointment.dateTime.hours == 13 ? 'selected' : ''}>1:00 PM</option>
                                                        <option value="14:00" ${appointment.dateTime.hours == 14 ? 'selected' : ''}>2:00 PM</option>
                                                        <option value="15:00" ${appointment.dateTime.hours == 15 ? 'selected' : ''}>3:00 PM</option>
                                                        <option value="16:00" ${appointment.dateTime.hours == 16 ? 'selected' : ''}>4:00 PM</option>
                                                    </select>
                                                    <div class="invalid-feedback">Please select a valid time slot</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="doctorId_${appointment.appointmentId}">Doctor:</label>
                                                    <select name="doctorId" class="form-control" id="doctorId_${appointment.appointmentId}" required>
                                                        <option value="${appointment.doctorId}">${appointment.doctorName} - ${appointment.doctorSpecialty}</option>
                                                        <!-- Other doctors will be loaded via JavaScript -->
                                                    </select>
                                                </div>
                                            </div>
                                            
                                            <!-- Patient Information -->
                                            <div class="edit-section">
                                                <h6><i class="bi bi-person"></i> Patient Information</h6>
                                                <div class="form-group">
                                                    <label for="patientFullName_${appointment.appointmentId}">Full Name:</label>
                                                    <input type="text" name="patientFullName" class="form-control" id="patientFullName_${appointment.appointmentId}" 
                                                           value="${appointment.patientFullName}" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="patientDob_${appointment.appointmentId}">Date of Birth:</label>
                                                    <input type="date" name="patientDob" class="form-control" id="patientDob_${appointment.appointmentId}" 
                                                           value="<fmt:formatDate value='${appointment.patientDob}' pattern='yyyy-MM-dd' />" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="patientAddress_${appointment.appointmentId}">Address:</label>
                                                    <input type="text" name="patientAddress" class="form-control" id="patientAddress_${appointment.appointmentId}" 
                                                           value="${appointment.patientAddress}" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="patientInsuranceInfo_${appointment.appointmentId}">Insurance Info:</label>
                                                    <input type="text" name="patientInsuranceInfo" class="form-control" id="patientInsuranceInfo_${appointment.appointmentId}" 
                                                           value="${appointment.patientInsuranceInfo}" required>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Parent Information -->
                                        <div class="col-md-6">
                                            <div class="edit-section">
                                                <h6><i class="bi bi-person-badge"></i> Parent Information</h6>
                                                <div class="form-group">
                                                    <label for="parentName_${appointment.appointmentId}">Parent Name:</label>
                                                    <input type="text" name="parentName" class="form-control" id="parentName_${appointment.appointmentId}" 
                                                           value="${appointment.parentName}" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="parentIdInfo_${appointment.appointmentId}">Parent ID:</label>
                                                    <input type="text" name="parentIdInfo" class="form-control" id="parentIdInfo_${appointment.appointmentId}" 
                                                           value="${appointment.parentIdInfo}" required maxlength="12" pattern="[0-9]{12}">
                                                    <div class="invalid-feedback">Parent ID must be exactly 12 digits</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Form Actions -->
                                    <div class="text-end mt-3">
                                        <button type="button" class="btn-secondary btn-sm me-2" onclick="toggleEditForm('${appointment.appointmentId}')">
                                            <i class="bi bi-x-circle"></i> Cancel
                                        </button>
                                        <button type="submit" class="btn-success btn-sm">
                                            <i class="bi bi-check-circle"></i> Confirm Update
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
        
        <c:if test="${empty appointmentDetails}">
            <div class="empty-state">
                <i class="bi bi-calendar-x"></i>
                <h3>No Appointments Found</h3>
                <p>You don't have any appointments scheduled yet.</p>
            </div>
        </c:if>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="../assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Toggle edit form visibility
        function toggleEditForm(appointmentId) {
            const editForm = document.getElementById('editForm_' + appointmentId);
            editForm.classList.toggle('show');
            
            // Load doctors when opening edit form
            if (editForm.classList.contains('show')) {
                loadDoctors(appointmentId);
                setupDateTimeValidation(appointmentId);
            }
        }
        
        // Update appointment
        function updateAppointment(event, formElement) {
            event.preventDefault();
            
            // Extract appointmentId from form ID
            const formId = formElement.id;
            const appointmentId = formId.replace('updateForm_', '');
            
            // Validate form
            if (!validateForm(appointmentId)) {
                return;
            }
            
            // Get form data - use URLSearchParams (like create form)
            const formData = new URLSearchParams();
            
            // Add all form fields
            formData.append('appointmentId', document.getElementById('appointmentId_' + appointmentId).value);
            formData.append('patientId', document.getElementById('patientId_' + appointmentId).value);
            formData.append('parentId', document.getElementById('parentId_' + appointmentId).value);
            formData.append('doctorId', document.getElementById('doctorId_' + appointmentId).value);
            
            // Combine date and time
            const appointmentDate = document.getElementById('appointmentDate_' + appointmentId).value;
            const appointmentTime = document.getElementById('appointmentTime_' + appointmentId).value;
            const dateTime = appointmentDate + 'T' + appointmentTime + ':00';
            formData.append('dateTime', dateTime);
            
            formData.append('patientFullName', document.getElementById('patientFullName_' + appointmentId).value);
            formData.append('patientDob', document.getElementById('patientDob_' + appointmentId).value);
            formData.append('patientAddress', document.getElementById('patientAddress_' + appointmentId).value);
            formData.append('patientInsuranceInfo', document.getElementById('patientInsuranceInfo_' + appointmentId).value);
            formData.append('parentName', document.getElementById('parentName_' + appointmentId).value);
            formData.append('parentIdInfo', document.getElementById('parentIdInfo_' + appointmentId).value);
            
            console.log('URLSearchParams from form:');
            for (let [key, value] of formData.entries()) {
                console.log(key + ': ' + value);
            }
            
            // Send update request
            fetch('PatientUpdateAppointmentServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
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
                    showMessage('Appointment updated successfully!', 'success');
                    toggleEditForm(appointmentId);
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
                // Use URLSearchParams (like update)
                const formData = new URLSearchParams();
                formData.append('appointmentId', appointmentId.toString());
                
                // Debug: Log form data
                console.log('Deleting appointment ID:', appointmentId);
                
                fetch('PatientDeleteAppointmentServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData
                })
                .then(response => {
                    console.log('Delete response status:', response.status);
                    if (response.ok) {
                        return response.text();
                    } else {
                        return response.text().then(text => {
                            throw new Error(text || 'Delete failed');
                        });
                    }
                })
                .then(result => {
                    console.log('Delete result:', result);
                    if (result === 'success') {
                        showMessage('Appointment deleted successfully!', 'success');
                        // Reload page after a short delay
                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);
                    } else {
                        throw new Error(result || 'Delete failed');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showMessage('Error deleting appointment: ' + error.message, 'error');
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
        
        // Load doctors for dropdown
        function loadDoctors(appointmentId) {
            fetch('doctors')
            .then(response => response.json())
            .then(doctors => {
                const doctorSelect = document.getElementById('doctorId_' + appointmentId);
                if (doctorSelect) {
                    // Keep the current selected doctor as first option
                    const currentOption = doctorSelect.querySelector('option[value="' + doctorSelect.value + '"]');
                    doctorSelect.innerHTML = '';
                    
                    // Add current doctor first
                    if (currentOption) {
                        doctorSelect.appendChild(currentOption);
                    }
                    
                    // Add other doctors
                    doctors.forEach(doctor => {
                        if (doctor.doctorId != doctorSelect.value) { // Don't add if already selected
                            const option = document.createElement('option');
                            option.value = doctor.doctorId;
                            option.textContent = doctor.username + " - " + doctor.specialty;
                            doctorSelect.appendChild(option);
                        }
                    });
                }
            })
            .catch(error => {
                console.error('Error loading doctors:', error);
            });
        }
        
        // Setup date/time validation
        function setupDateTimeValidation(appointmentId) {
            const appointmentDateInput = document.getElementById('appointmentDate_' + appointmentId);
            const appointmentTimeInput = document.getElementById('appointmentTime_' + appointmentId);
            
            if (appointmentDateInput) {
                // Set minimum date to tomorrow (not today)
                const tomorrow = new Date();
                tomorrow.setDate(tomorrow.getDate() + 1);
                const minDate = tomorrow.toISOString().split('T')[0];
                appointmentDateInput.min = minDate;
                
                // Validate on change
                appointmentDateInput.addEventListener('change', function() {
                    validateDateTime(appointmentId);
                });
            }
            
            if (appointmentTimeInput) {
                // Validate on change
                appointmentTimeInput.addEventListener('change', function() {
                    validateDateTime(appointmentId);
                });
            }
        }
        
        // Validate date and time combination
        function validateDateTime(appointmentId) {
            const appointmentDateInput = document.getElementById('appointmentDate_' + appointmentId);
            const appointmentTimeInput = document.getElementById('appointmentTime_' + appointmentId);
            
            if (appointmentDateInput && appointmentTimeInput) {
                const selectedDate = appointmentDateInput.value;
                const selectedTime = appointmentTimeInput.value;
                
                if (selectedDate && selectedTime) {
                    const selectedDateTime = new Date(selectedDate + 'T' + selectedTime + ':00');
                    const now = new Date();
                    
                    if (selectedDateTime <= now) {
                        appointmentDateInput.classList.add('is-invalid');
                        appointmentTimeInput.classList.add('is-invalid');
                        showMessage('Appointment must be scheduled for the future', 'error');
                    } else {
                        appointmentDateInput.classList.remove('is-invalid');
                        appointmentTimeInput.classList.remove('is-invalid');
                    }
                }
            }
        }
        
        // Validate form
        function validateForm(appointmentId) {
            let isValid = true;
            
            // Validate Parent ID (12 digits)
            const parentIdInput = document.getElementById('parentIdInfo_' + appointmentId);
            if (parentIdInput) {
                const parentIdValue = parentIdInput.value.trim();
                if (!/^\d{12}$/.test(parentIdValue)) {
                    parentIdInput.classList.add('is-invalid');
                    isValid = false;
                } else {
                    parentIdInput.classList.remove('is-invalid');
                }
            }
            
            // Validate appointment date
            const appointmentDateInput = document.getElementById('appointmentDate_' + appointmentId);
            const appointmentTimeInput = document.getElementById('appointmentTime_' + appointmentId);
            
            if (appointmentDateInput && appointmentTimeInput) {
                const selectedDate = appointmentDateInput.value;
                const selectedTime = appointmentTimeInput.value;
                
                if (selectedDate && selectedTime) {
                    const selectedDateTime = new Date(selectedDate + 'T' + selectedTime + ':00');
                    const now = new Date();
                    
                    if (selectedDateTime <= now) {
                        appointmentDateInput.classList.add('is-invalid');
                        appointmentTimeInput.classList.add('is-invalid');
                        isValid = false;
                    } else {
                        appointmentDateInput.classList.remove('is-invalid');
                        appointmentTimeInput.classList.remove('is-invalid');
                    }
                } else {
                    if (!selectedDate) {
                        appointmentDateInput.classList.add('is-invalid');
                        isValid = false;
                    }
                    if (!selectedTime) {
                        appointmentTimeInput.classList.add('is-invalid');
                        isValid = false;
                    }
                }
            }
            
            if (!isValid) {
                showMessage('Please fix the validation errors before submitting', 'error');
            }
            
            return isValid;
        }
        
        // Sort appointments by ID (descending - newest first)
        document.addEventListener('DOMContentLoaded', function() {
            const appointmentCards = document.querySelectorAll('.appointment-card');
            const container = document.querySelector('.col-12');
            
            if (appointmentCards.length > 0) {
                // Convert to array and sort by appointment ID
                const sortedCards = Array.from(appointmentCards).sort((a, b) => {
                    const idA = parseInt(a.querySelector('[id*="appointmentId_"]').id.split('_')[1]);
                    const idB = parseInt(b.querySelector('[id*="appointmentId_"]').id.split('_')[1]);
                    return idB - idA; // Descending order (newest first)
                });
                
                // Re-append sorted cards
                sortedCards.forEach(card => {
                    container.appendChild(card);
                });
            }
            
            // Setup date and time inputs
            document.querySelectorAll('input[type="date"]').forEach(input => {
                if (input.id.includes('appointmentDate_')) {
                    const appointmentId = input.id.split('_')[1];
                    setupDateTimeValidation(appointmentId);
                }
            });
        });
    </script>
    <jsp:include page="../includes/footer.jsp" />

</body>
</html>

