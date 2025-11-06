<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Examination Form</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 20px;
                min-height: 100vh;
            }

            .container {
                max-width: 900px;
                margin: 0 auto;
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                overflow: hidden;
            }

            .header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
            }

            .header h1 {
                margin-bottom: 10px;
            }

            .patient-info {
                background: rgba(255,255,255,0.1);
                padding: 15px;
                border-radius: 10px;
                margin-top: 15px;
            }

            .patient-info p {
                margin: 5px 0;
            }

            .content {
                padding: 30px;
            }

            .form-group {
                margin-bottom: 25px;
            }

            label {
                display: block;
                font-weight: bold;
                color: #2c3e50;
                margin-bottom: 8px;
            }

            input[type="text"],
            textarea,
            select {
                width: 100%;
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 14px;
                transition: border 0.3s;
            }

            input:focus,
            textarea:focus,
            select:focus {
                outline: none;
                border-color: #667eea;
            }

            textarea {
                resize: vertical;
                min-height: 120px;
            }

            .btn-group {
                display: flex;
                gap: 15px;
                margin-top: 30px;
            }

            .btn {
                flex: 1;
                padding: 15px 25px;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                transition: all 0.3s;
                text-align: center;
            }

            .btn-primary {
                background: #667eea;
                color: white;
            }

            .btn-primary:hover {
                background: #5568d3;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }

            .btn-warning {
                background: #f39c12;
                color: white;
            }

            .btn-warning:hover {
                background: #e67e22;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(243, 156, 18, 0.4);
            }

            .btn-success {
                background: #27ae60;
                color: white;
            }

            .btn-success:hover {
                background: #229954;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(39, 174, 96, 0.4);
            }

            .btn-secondary {
                background: #95a5a6;
                color: white;
            }

            .btn-secondary:hover {
                background: #7f8c8d;
            }

            .status-badge {
                display: inline-block;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: bold;
            }

            .status-in-progress {
                background: #3498db;
                color: white;
            }

            .test-options {
                display: none;
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-top: 15px;
            }

            .test-options.show {
                display: block;
            }

            .back-link {
                display: inline-block;
                color: white;
                text-decoration: none;
                margin-bottom: 15px;
                transition: opacity 0.3s;
            }

            .back-link:hover {
                opacity: 0.8;
            }
        </style>
        <script>
            function showTestOptions() {
                document.getElementById('testOptions').classList.add('show');
            }

            function validateComplete() {
                const diagnosis = document.getElementById('diagnosis').value.trim();
                const prescription = document.getElementById('prescription').value.trim();
                const testTypeElement = document.getElementById('testType');

                if (!diagnosis || !prescription) {
                    alert('Please fill in both diagnosis and prescription before completing!');
                    return false;
                }

                // Ensure hidden test select does not block submit
                if (testTypeElement) {
                    testTypeElement.required = false;
                    testTypeElement.disabled = true;
                }

                return confirm('Are you sure you want to complete this examination? This action cannot be undone.');
            }
            function showTestOptions() {
                const testOptions = document.getElementById('testOptions');
                testOptions.classList.toggle('show');  // Toggle visibility

                const testTypeElement = document.getElementById('testType');
                if (testOptions.classList.contains('show')) {
                    // Make selectable and required only when visible (requesting test)
                    testTypeElement.disabled = false;
                    testTypeElement.required = true;
                    testTypeElement.focus();
                } else {
                    // Prevent browser validation when hidden
                    testTypeElement.required = false;
                    testTypeElement.disabled = true;
                    testTypeElement.value = '';
                }
            }
        </script>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <a href="${pageContext.request.contextPath}/doctor" class="back-link">
                    ← Back to Waiting List
                </a>
                <h1>Examination Form</h1>
                <div class="patient-info">
                    <p><strong>Appointment ID:</strong> #${appointment.appointmentId}</p>
                    <p><strong>Patient ID:</strong> ${appointment.patientId}</p>
                    <p><strong>Date & Time:</strong> 
                        <fmt:formatDate value="${appointment.dateTime}" 
                                        pattern="dd/MM/yyyy HH:mm"/>
                    </p>
                    <p><strong>Status:</strong> 
                        <span class="status-badge status-${appointment.status.toLowerCase().replace(' ', '-')}">
                            ${appointment.status}
                        </span>
                    </p>
                </div>
            </div>

            <div class="content">
                <c:if test="${appointment.status == 'Waiting'}">
                    <form method="post" action="${pageContext.request.contextPath}/doctor">
                        <input type="hidden" name="action" value="start">
                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            🩺 Start Examination
                        </button>
                    </form>
                </c:if>

                <c:if test="${appointment.status == 'In Progress'}">
                    <form method="post" action="${pageContext.request.contextPath}/doctor">
                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

                        <div class="form-group">
                            <label for="diagnosis">Diagnosis (Chẩn đoán) *</label>
                            <textarea id="diagnosis" name="diagnosis" 
                                      placeholder="Enter diagnosis..."
                                      required>${medicalReport != null ? medicalReport.diagnosis : ''}</textarea>
                        </div>

                        <div class="form-group">
                            <label for="prescription">Prescription (Đơn thuốc) *</label>
                            <textarea id="prescription" name="prescription" 
                                      placeholder="Enter prescription..."
                                      required>${medicalReport != null ? medicalReport.prescription : ''}</textarea>
                        </div>

                        <div class="btn-group">
                            <button type="button" class="btn btn-warning" 
                                    onclick="showTestOptions()">
                                🧪 Request Test
                            </button>
                            <button type="submit" name="action" value="complete" 
                                    class="btn btn-success" onclick="return validateComplete()">
                                ✓ Complete Examination
                            </button>
                        </div>

                        <div id="testOptions" class="test-options">
                            <h3>Request Laboratory Test</h3>
                            <div class="form-group">
                                <label for="testType">Test Type</label>
                                <select id="testType" name="testType" disabled>
                                    <option value="">-- Select Test Type --</option>
                                    <option value="Xét nghiệm máu công thức">Complete Blood Count</option>
                                    <option value="X-quang phổi">Chest X-ray</option>
                                    <option value="Xét nghiệm CRP">CRP Test</option>
                                    <option value="NS1 Dengue">NS1 Dengue Test</option>
                                    <option value="Xét nghiệm nước tiểu">Urinalysis</option>
                                    <option value="Công thức máu">Blood Formula</option>
                                    <option value="Soi tai">Otoscopy</option>
                                    <option value="Cấy nước tiểu">Urine Culture</option>
                                </select>

                            </div>
                            <button type="submit" name="action" value="requestTest" class="btn btn-warning">
                                Send Test Request
                            </button>
                        </div>

                    </form>
                </c:if>

                <c:if test="${appointment.status == 'Testing'}">
                    <div style="text-align: center; padding: 40px; background: #fff3cd;
                         border-radius: 10px;">
                        <h2 style="color: #856404;">⏳ Waiting for Test Results</h2>
                        <p style="margin-top: 15px; color: #856404;">
                            The patient is currently undergoing laboratory tests. 
                            Please wait for the medical assistant to complete the tests.
                        </p>
                    </div>
                </c:if>

                <c:if test="${appointment.status == 'Completed'}">
                    <div style="text-align: center; padding: 40px; background: #d4edda;
                         border-radius: 10px;">
                        <h2 style="color: #155724;">✓ Examination Completed</h2>
                        <p style="margin-top: 15px; color: #155724;">
                            This examination has been completed successfully.
                        </p>
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>