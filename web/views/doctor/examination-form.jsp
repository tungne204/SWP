<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Examination Form - Medilab</title>
        
        <!-- Include all CSS files -->
        <jsp:include page="../../includes/head-includes.jsp"/>
        
        <style>
            /* Sidebar Layout */
            .sidebar-container {
                width: 280px;
                background: white;
                border-right: 1px solid #dee2e6;
                position: fixed;
                top: 80px;
                left: 0;
                height: calc(100vh - 80px);
                overflow-y: auto;
                z-index: 1000;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            }

            .main-content {
                flex: 1;
                margin-left: 280px;
                padding: 20px;
                min-height: calc(100vh - 80px);
                padding-top: 100px;
            }

            /* Responsive */
            @media (max-width: 991px) {
                .sidebar-container {
                    display: none;
                }
                .main-content {
                    margin-left: 0;
                }
            }
            
            /* Scope CSS chỉ cho content, không ảnh hưởng header/sidebar */
            .main-content * {
                box-sizing: border-box;
            }
            
            .main {
                background: #ffffff;
            }
            
            .main-content {
                background: #ffffff;
            }

            .main-content .container {
                max-width: 900px;
                margin: 0 auto;
                background: white;
                border-radius: 15px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 20px;
            }

            .main-content .container .header {
                background: linear-gradient(135deg, #1977cc 0%, #2c4964 100%);
                color: white;
                padding: 30px;
            }

            .main-content .container .header h1 {
                margin-bottom: 10px;
            }

            .main-content .container .patient-info {
                background: rgba(255,255,255,0.1);
                padding: 15px;
                border-radius: 10px;
                margin-top: 15px;
            }

            .main-content .container .patient-info p {
                margin: 5px 0;
            }

            .main-content .container .content {
                padding: 30px;
            }

            .main-content .container .form-group {
                margin-bottom: 25px;
            }

            .main-content .container label {
                display: block;
                font-weight: bold;
                color: #2c3e50;
                margin-bottom: 8px;
            }

            .main-content .container input[type="text"],
            .main-content .container textarea,
            .main-content .container select {
                width: 100%;
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 14px;
                transition: border 0.3s;
            }

            .main-content .container input:focus,
            .main-content .container textarea:focus,
            .main-content .container select:focus {
                outline: none;
                border-color: #1977cc;
            }

            .main-content .container textarea {
                resize: vertical;
                min-height: 120px;
            }

            .main-content .container .btn-group {
                display: flex;
                gap: 15px;
                margin-top: 30px;
            }

            .main-content .container .btn {
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

            .main-content .container .btn-primary {
                background: #1977cc;
                color: white;
            }

            .main-content .container .btn-primary:hover {
                background: #1565a0;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(25, 119, 204, 0.4);
            }

            .main-content .container .btn-warning {
                background: #f39c12;
                color: white;
            }

            .main-content .container .btn-warning:hover {
                background: #e67e22;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(243, 156, 18, 0.4);
            }

            .main-content .container .btn-success {
                background: #27ae60;
                color: white;
            }

            .main-content .container .btn-success:hover {
                background: #229954;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(39, 174, 96, 0.4);
            }

            .main-content .container .btn-secondary {
                background: #95a5a6;
                color: white;
            }

            .main-content .container .btn-secondary:hover {
                background: #7f8c8d;
            }

            .main-content .container .status-badge {
                display: inline-block;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: bold;
            }

            .main-content .container .status-in-progress {
                background: #1977cc;
                color: white;
            }

            .main-content .container .test-options {
                display: none;
                background: #f1f7fc;
                padding: 20px;
                border-radius: 8px;
                margin-top: 15px;
            }

            .main-content .container .test-options.show {
                display: block;
            }

            .main-content .container .back-link {
                display: inline-block;
                color: white;
                text-decoration: none;
                margin-bottom: 15px;
                transition: opacity 0.3s;
            }

            .main-content .container .back-link:hover {
                opacity: 0.8;
            }

            .main-content .container .test-results-section {
                margin-top: 30px;
                padding: 20px;
                background: #f1f7fc;
                border-radius: 8px;
                border-left: 4px solid #1977cc;
            }

            .main-content .container .test-results-section h3 {
                color: #1977cc;
                margin-bottom: 15px;
                font-size: 18px;
            }

            .main-content .container .test-result-item {
                background: white;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 15px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .main-content .container .test-result-item h4 {
                color: #2c3e50;
                margin-bottom: 10px;
                font-size: 16px;
            }

            .main-content .container .test-result-item p {
                margin: 5px 0;
                color: #555;
            }

            .main-content .container .test-result-item .test-type {
                font-weight: bold;
                color: #1977cc;
            }

            .main-content .container .test-result-item .test-date {
                color: #7f8c8d;
                font-size: 13px;
            }

            .main-content .container .test-result-item .test-result-content {
                margin-top: 10px;
                padding: 10px;
                background: #f8f9fa;
                border-radius: 5px;
                white-space: pre-wrap;
                word-wrap: break-word;
            }
        </style>
        <script>
            function toggleTestOptions() {
                const box = document.getElementById('testOptions');
                const testType = document.getElementById('testType');
                box.classList.toggle('show');
                const opened = box.classList.contains('show');
                testType.disabled = !opened;
                if (!opened)
                    testType.value = '';
            }

            // Validate dựa trên nút submit
            function handleSubmit(e) {
                const submitter = e.submitter;                 // nút vừa được bấm
                const action = submitter ? submitter.value : null;

                if (action === 'complete') {
                    const diag = document.getElementById('diagnosis').value.trim();
                    const pres = document.getElementById('prescription').value.trim();

                    if (!diag) {
                        alert('Vui lòng nhập chẩn đoán (Diagnosis) trước khi hoàn tất!');
                        e.preventDefault();
                        return false;
                    }
                    if (!pres) {
                        alert('Vui lòng nhập đơn thuốc (Prescription) trước khi hoàn tất!');
                        e.preventDefault();
                        return false;
                    }

                    // tránh select ẩn chặn submit
                    const testType = document.getElementById('testType');
                    if (testType)
                        testType.disabled = true;

                    return confirm('Xác nhận hoàn tất khám?');
                }

                if (action === 'requestTest') {
                    // Nếu đang mở khối test thì yêu cầu chọn test type
                    const box = document.getElementById('testOptions');
                    if (box.classList.contains('show')) {
                        const testType = document.getElementById('testType').value;
                        if (!testType) {
                            alert('Vui lòng chọn loại xét nghiệm.');
                            e.preventDefault();
                            return false;
                        }
                    }
                    // Không cần diagnosis/prescription khi request test
                    return true;
                }

                return true;
            }
        </script>


    </head>
    <body class="index-page">
        <!-- Header -->
        <jsp:include page="../../includes/header.jsp"/>
        
        <main class="main" style="padding-top: 80px;">
            <%-- Show sidebar for Doctor --%>
            <% if (acc != null && acc.getRoleId() == 2) { %>
            <div class="container-fluid p-0">
                <div class="row g-0">
                    <div class="sidebar-container">
                        <%@ include file="../../includes/sidebar-doctor.jsp" %>
                    </div>
                    <div class="main-content">
                        <% } %>
        
        <div class="container">
            <div class="header">
                <a href="${pageContext.request.contextPath}/appointments" class="back-link">
                    ← Quay lại danh sách chờ
                </a>
                <h1>Examination Form</h1>
                <div class="patient-info">
                    <p><strong>Appointment ID:</strong> #${appointment.appointmentId}</p>
                    <p><strong>Patient Name:</strong> ${patient != null ? patient.fullName : 'N/A'}</p>
                    <p><strong>Date & Time:</strong> 
                        <fmt:formatDate value="${appointment.dateTime}" 
                                        pattern="dd/MM/yyyy HH:mm"/>
                    </p>
                    <p><strong>Status:</strong> 
                        <span class="status-badge status-${appointment.status.toLowerCase().replace(' ', '-')}">
                            ${appointment.status}
                        </span>
                    </p>
                    <c:if test="${not empty appointment.symptoms}">
                        <div style="margin-top: 15px; padding: 15px; background: rgba(255,255,255,0.2); border-radius: 8px; border-left: 4px solid #fff;">
                            <p style="margin-bottom: 8px;"><strong>📋 Symptoms (Triệu chứng):</strong></p>
                            <p style="white-space: pre-wrap; word-wrap: break-word; margin: 0;">${appointment.symptoms}</p>
                        </div>
                    </c:if>
                </div>
            </div>
            <c:if test="${not empty sessionScope.message}">
                <div style="margin-bottom:16px;padding:12px;border-radius:8px;
                     background:${sessionScope.messageType eq 'error' ? '#fdecea' : '#e8f5e9'};
                     color:${sessionScope.messageType eq 'error' ? '#b71c1c' : '#1b5e20'}">
                    ${sessionScope.message}
                </div>
                <c:remove var="message" scope="session"/>
                <c:remove var="messageType" scope="session"/>
            </c:if>


            <div class="content">
                <c:if test="${appointment.status == 'Waiting'}">
                    <form method="post" action="${pageContext.request.contextPath}/appointments">
                        <input type="hidden" name="action" value="start">
                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            🩺 Start Examination
                        </button>
                    </form>
                </c:if>

                <c:if test="${appointment.status == 'In Progress' || appointment.status == 'Waiting'}">
                    <!-- Hiển thị kết quả xét nghiệm nếu có -->
                    <c:if test="${not empty testResults}">
                        <div class="test-results-section">
                            <h3>📋 Test Results (Kết quả xét nghiệm)</h3>
                            <c:forEach var="testResult" items="${testResults}">
                                <div class="test-result-item">
                                    <h4>
                                        <span class="test-type">${testResult.testType}</span>
                                    </h4>
                                    <p class="test-date">
                                        <strong>Date:</strong> 
                                        <fmt:formatDate value="${testResult.date}" pattern="dd/MM/yyyy"/>
                                    </p>
                                    <div class="test-result-content">
                                        <strong>Result:</strong><br/>
                                        ${testResult.result}
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/appointments"
                          onsubmit="return handleSubmit(event)" novalidate>
                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

                        <div class="form-group">
                            <label for="diagnosis">Diagnosis (Chẩn đoán)</label>
                            <textarea id="diagnosis" name="diagnosis"
                                      placeholder="Enter diagnosis...">${medicalReport != null ? medicalReport.diagnosis : ''}</textarea>
                        </div>

                        <div class="form-group">
                            <label for="prescription">Prescription (Đơn thuốc) *</label>
                            <textarea id="prescription" name="prescription"
                                      placeholder="Enter prescription..." required>${medicalReport != null ? medicalReport.prescription : ''}</textarea>
                        </div>

                        <div class="btn-group">
                            <!-- Chỉ hiển thị nút Request Test khi status là In Progress -->
                            <c:if test="${appointment.status == 'In Progress'}">
                                <button type="button" class="btn btn-warning" onclick="toggleTestOptions()">
                                    🧪 Request Test
                                </button>
                            </c:if>

                            <!-- BỎ onclick=validateComplete() -->
                            <button type="submit" name="action" value="complete" class="btn btn-success">
                                ✓ Complete Examination
                            </button>
                        </div>

                        <!-- Chỉ hiển thị test options khi status là In Progress -->
                        <c:if test="${appointment.status == 'In Progress'}">
                            <div id="testOptions" class="test-options">
                                <div class="form-group">
                                    <label for="testType">Test Type (Loại xét nghiệm) *</label>
                                    <select id="testType" name="testType" required>
                                        <option value="">-- Chọn loại xét nghiệm --</option>
                                        <option value="Xét nghiệm máu">Xét nghiệm máu</option>
                                        <option value="Xét nghiệm nước tiểu">Xét nghiệm nước tiểu</option>
                                        <option value="Chụp X-quang">Chụp X-quang</option>
                                        <option value="Siêu âm">Siêu âm</option>
                                        <option value="Nội soi">Nội soi</option>
                                        <option value="CT Scan">CT Scan</option>
                                        <option value="MRI">MRI</option>
                                        <option value="ECG">ECG (Điện tâm đồ)</option>
                                        <option value="Khác">Khác</option>
                                    </select>
                                </div>
                                <button type="submit" name="action" value="requestTest"
                                        class="btn btn-warning" formnovalidate>
                                    Send Test Request
                                </button>
                            </div>
                        </c:if>
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
        
                        <%-- Close layout for Doctor --%>
                        <% if (acc != null && acc.getRoleId() == 2) { %>
                    </div>
                </div>
            </div>
            <% } %>
        </main>
        
        <!-- Include all JS files -->
        <jsp:include page="../../includes/footer-includes.jsp"/>
    </body>
</html>