<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="../includes/head-includes.jsp" %>
        <title>Edit Test Result</title>
        <style>
            :root {
                --sidebar-width: 250px;
                --header-height: 60px;
                --bg: #f8f9fa;
            }

            /* ===== RESET ===== */
            html, body {
                height: 100%;
                margin: 0;
                background-color: var(--bg);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            /* ===== FIXED HEADER ===== */
            #header-fixed {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: var(--header-height);
                z-index: 4000 !important;
                background-color: #0d6efd;
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            }

            /* ===== LAYOUT ===== */
            .layout {
                display: flex;
                min-height: 100vh;
                margin-top: var(--header-height);
                position: relative;
                overflow: visible !important;
            }

            .sidebar-wrap {
                width: var(--sidebar-width);
                flex-shrink: 0;
                position: fixed;
                top: var(--header-height);
                left: 0;
                bottom: 0;
                background: #f8f9fb;
                border-right: 1px solid #e6e6e6;
                overflow-y: auto;
                z-index: 2000;
            }

            .main-content {
                flex: 1;
                margin-left: var(--sidebar-width);
                background: var(--bg);
                padding: 40px;
                overflow: visible !important;
                position: relative;
                z-index: 1;
            }

            /* ===== CARD ===== */
            .container {
                max-width: 800px;
                margin: 0 auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            h1 {
                color: #2c3e50;
                margin-bottom: 30px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .info-box {
                background: #e8f4f8;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                border-left: 4px solid #3498db;
            }

            .info-box p {
                margin: 5px 0;
                color: #2c3e50;
            }

            .info-box strong {
                color: #3498db;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                color: #34495e;
                font-weight: 600;
            }

            label .required {
                color: #e74c3c;
            }

            input[type="text"],
            input[type="date"],
            input[type="number"],
            select,
            textarea {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            input:focus,
            select:focus,
            textarea:focus {
                outline: none;
                border-color: #3498db;
            }

            textarea {
                resize: vertical;
                min-height: 100px;
            }

            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                transition: all 0.3s;
                font-weight: 600;
            }

            .btn-primary {
                background: #3498db;
                color: white;
            }

            .btn-primary:hover {
                background: #2980b9;
            }

            .btn-secondary {
                background: #95a5a6;
                color: white;
            }

            .btn-secondary:hover {
                background: #7f8c8d;
            }

            .form-actions {
                display: flex;
                gap: 10px;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #ddd;
            }

            .help-text {
                font-size: 13px;
                color: #7f8c8d;
                margin-top: 5px;
            }

            /* ===== FIX DROPDOWN CLICK ===== */
            #header {
                position: relative !important;
                z-index: 4001 !important;
            }

            .dropdown-menu {
                z-index: 5000 !important;
            }

            /* ===== RESPONSIVE ===== */
            @media (max-width: 768px) {
                .sidebar-wrap {
                    display: none;
                }
                .main-content {
                    margin-left: 0;
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>

        <!-- HEADER (Dính cố định) -->
        <header id="header-fixed">
            <%@ include file="../includes/header.jsp" %>
        </header>

        <!-- LAYOUT -->
        <div class="layout">
            <!-- SIDEBAR -->
            <div class="sidebar-wrap">
                <jsp:include page="../includes/sidebar-medicalassistant.jsp" />

            </div>

            <!-- MAIN CONTENT -->
            <main class="main-content">
                <div class="container">
                    <h1>
                        <i class="fas fa-edit"></i>
                        Edit Test Result 
                    </h1>

                    <div class="info-box">
                        <p><strong>Patient:</strong> ${testResult.patientName}</p>
                        <p><strong>Doctor:</strong> ${testResult.doctorName}</p>
                        <p><strong>Diagnosis:</strong> ${testResult.diagnosis}</p>
                    </div>

                    <form action="testresult" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="testId" value="${testResult.testId}">

                        <div class="form-group">
                            <label for="recordId">
                                Medical Record <span class="required">*</span>
                            </label>
                            <select id="recordId" name="recordId" required>
                                <c:forEach var="report" items="${medicalReports}">
                                    <option value="${report.recordId}"
                                            ${report.recordId == testResult.recordId ? 'selected' : ''}>
                                        Record #${report.recordId} - ${report.patientName} (${report.diagnosis})
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="help-text">Medical record associated with this test</div>
                        </div>

                        <div class="form-group">
                            <label for="testType">
                                Test Type <span class="required">*</span>
                            </label>
                            <select id="testType" name="testType" required>
                                <option value="">-- Chọn loại xét nghiệm --</option>
                                <c:forEach var="type" items="${testTypes}">
                                    <option value="${type}" ${type == testResult.testType ? 'selected' : ''}>${type}</option>
                                </c:forEach>
                            </select>
                            <div class="help-text">Loại xét nghiệm được lấy tự động từ cơ sở dữ liệu</div>

                            <div class="help-text">Type of medical test performed</div>
                        </div>

                        <div class="form-group">
                            <label for="result">
                                Test Result <span class="required">*</span>
                            </label>
                            <textarea id="result" name="result" maxlength="50" required>${testResult.result}</textarea>
                            <div class="help-text">Complete test results and findings</div>
                        </div>

                        <div class="form-group">
                            <label for="date">
                                Test Date <span class="required">*</span>
                            </label>
                            <input type="date" id="date" name="date" value="${testResult.date}" required>
                            <div class="help-text">Date when the test was conducted</div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Test Result
                            </button>
                            <a href="testresult?action=list" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

    </body>
</html>
