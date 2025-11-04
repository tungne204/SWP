<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm kết quả xét nghiệm</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <jsp:include page="../includes/head-includes.jsp"/>
        <style>
            :root {
                --sidebar-width: 250px;
                --header-height: 60px;
                --bg: #f5f6fa;
            }

            html, body {
                height: 100%;
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: var(--bg);
            }

            /* ===== HEADER CỐ ĐỊNH ===== */
            #header-fixed {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: var(--header-height);
                z-index: 3000 !important;
                background: #0d6efd;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            /* ===== LAYOUT CHUNG ===== */
            .layout {
                display: flex;
                min-height: 100vh;
                margin-top: var(--header-height);
            }

            /* ===== SIDEBAR ===== */
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
                z-index: 500;
            }

            /* ===== NỘI DUNG CHÍNH ===== */
            .main-content {
                margin-left: var(--sidebar-width);
                flex: 1;
                background: var(--bg);
                min-height: calc(100vh - var(--header-height));
                position: relative;
                z-index: 1;
            }

            .content-wrapper {
                padding: 40px;
            }

            .card {
                background: #fff;
                border-radius: 10px;
                padding: 30px 35px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
                max-width: 850px;
                margin: 0 auto;
            }

            h2 {
                color: #2c3e50;
                font-size: 22px;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 25px;
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

            .required {
                color: #e74c3c;
            }

            input[type="text"],
            input[type="number"],
            input[type="date"],
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

            .help-text {
                font-size: 13px;
                color: #7f8c8d;
                margin-top: 5px;
            }

            .form-actions {
                display: flex;
                gap: 10px;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #ddd;
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

            .btn-success {
                background: #27ae60;
                color: white;
            }

            .btn-success:hover {
                background: #229954;
            }

            .btn-secondary {
                background: #95a5a6;
                color: white;
            }

            .btn-secondary:hover {
                background: #7f8c8d;
            }

            /* ===== RESPONSIVE ===== */
            @media (max-width: 900px) {
                .sidebar-wrap {
                    display: none;
                }
                .main-content {
                    margin-left: 0;
                }
                .content-wrapper {
                    padding: 20px;
                }
                .form-actions {
                    flex-direction: column;
                }
                .btn {
                    width: 100%;
                    justify-content: center;
                }
            }

            /* ===== FIX DROPDOWN AVATAR ===== */
            #header {
                position: relative !important;
                z-index: 4000 !important;
            }

            .dropdown-menu {
                z-index: 5000 !important;
            }

            .layout, .main-content {
                overflow: visible !important;
                position: relative !important;
                z-index: 1 !important;
            }
        </style>
    </head>

    <body>
        <!-- HEADER -->
        <header id="header-fixed">
            <%@ include file="../includes/header.jsp" %>
        </header>

        <!-- LAYOUT -->
        <div class="layout">
            <!-- SIDEBAR -->
            <div class="sidebar-wrap">
                <jsp:include page="../includes/sidebar-medicalassistant.jsp" />

            </div>

            <!-- NỘI DUNG CHÍNH -->
            <div class="main-content">
                <main class="content-wrapper">
                    <div class="card">
                        <h2>
                            <i class="fas fa-plus-circle"></i>
                            Thêm kết quả xét nghiệm mới
                        </h2>

                        <form action="testresult" method="post">
                            <input type="hidden" name="action" value="insert">
                            <c:if test="${preselectedRecordId != null}">
                                <input type="hidden" name="returnTo" value="viewReport"/>
                            </c:if>


                            <div class="form-group">
                                <label for="recordId">
                                    Hồ sơ y tế <span class="required">*</span>
                                </label>
                                <select id="recordId" name="recordId" required>
                                    <option value="">-- Chọn hồ sơ y tế --</option>
                                    <c:forEach var="report" items="${medicalReports}">
                                        <option value="${report.recordId}"
                                                <c:if test="${preselectedRecordId != null && preselectedRecordId == report.recordId}">selected</c:if>>
                                            Hồ sơ #${report.recordId} - ${report.patientName} (${report.diagnosis})
                                        </option>
                                    </c:forEach>

                                </select>
                                <div class="help-text">
                                    Chọn hồ sơ y tế có yêu cầu thực hiện xét nghiệm này
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="testType">
                                    Loại xét nghiệm <span class="required">*</span>
                                </label>
                                <select id="testType" name="testType" required>
                                    <option value="">-- Chọn loại xét nghiệm --</option>
                                    <c:forEach var="type" items="${testTypes}">
                                        <option value="${type}">${type}</option>
                                    </c:forEach>
                                </select>
                                <div class="help-text">
                                    Danh sách loại xét nghiệm được lấy tự động từ cơ sở dữ liệu
                                </div>

                                <div class="help-text">
                                    Chọn loại xét nghiệm đã được thực hiện
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="result">
                                    Kết quả xét nghiệm <span class="required">*</span>
                                </label>
                                <textarea id="result" name="result" maxlength="50" required
                                          placeholder="Nhập kết quả chi tiết của xét nghiệm..."></textarea>
                                <div class="help-text">
                                    Nhập toàn bộ kết quả và ghi chú chuyên môn liên quan
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="date">
                                    Ngày xét nghiệm <span class="required">*</span>
                                </label>
                                <input type="date" id="date" name="date" required
                                       max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                                <div class="help-text">
                                    Ngày tiến hành thực hiện xét nghiệm
                                </div>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save"></i> Lưu kết quả
                                </button>
                                <c:if test="${preselectedRecordId != null}">
                                    <button type="submit" class="btn btn-secondary"
                                            onclick="document.querySelector('input[name=returnTo]')?.setAttribute('value', 'viewReport');">
                                        <i class="fas fa-arrow-left"></i> Lưu & quay lại hồ sơ
                                    </button>
                                </c:if>

                                <a href="testresult?action=list" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Hủy bỏ
                                </a>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <script>
            // Tự động đặt ngày hiện tại làm mặc định
            document.getElementById('date').valueAsDate = new Date();
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    </body>
</html>
