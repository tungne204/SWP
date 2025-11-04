<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
    boolean showMA = (acc != null && acc.getRoleId() == 4); // Medical assistant
    boolean hasSidebar = showMA; // Trang này chỉ hiển thị sidebar cho trợ lý xét nghiệm
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm kết quả xét nghiệm</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <jsp:include page="../includes/head-includes.jsp"/>

        <style>
            /* ===== Scope RIÊNG cho trang Create TestResult ===== */
            .tr-create {
                --sidebar-width: 280px;
                --header-height: 80px;
                --bg: #f5f6fa;
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: var(--bg);
            }

            /* Đệm phía trên để tránh đè lên header fixed dùng chung */
            .tr-create .tr-main {
                padding-top: var(--header-height);
            }

            /* Layout chính */
            .tr-create .tr-layout {
                display: flex;
                min-height: calc(100vh - var(--header-height));
            }

            /* Sidebar cố định giống Home */
            .tr-create .tr-sidebar {
                width: var(--sidebar-width);
                background: #ffffff;
                border-right: 1px solid #dee2e6;
                position: fixed;
                top: var(--header-height);
                left: 0;
                height: calc(100vh - var(--header-height));
                overflow-y: auto;
                z-index: 1000;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.06);
            }

            /* Nội dung chính */
            .tr-create .tr-content {
                flex: 1;
                padding: 24px;
                min-height: calc(100vh - var(--header-height));
            }
            /* Chỉ đẩy nội dung khi có sidebar */
            .tr-create.has-sidebar .tr-content {
                margin-left: var(--sidebar-width);
            }

            /* Card bọc form */
            .tr-create .card {
                background: #fff;
                border-radius: 10px;
                padding: 30px 35px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
                max-width: 850px;
                margin: 0 auto;
            }

            .tr-create h2 {
                color: #2c3e50;
                font-size: 22px;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 25px;
            }

            .tr-create .form-group { margin-bottom: 20px; }

            .tr-create label {
                display: block;
                margin-bottom: 8px;
                color: #34495e;
                font-weight: 600;
            }

            .tr-create .required { color: #e74c3c; }

            .tr-create input[type="text"],
            .tr-create input[type="number"],
            .tr-create input[type="date"],
            .tr-create select,
            .tr-create textarea {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
                transition: border-color 0.3s;
                background: #fff;
            }

            .tr-create input:focus,
            .tr-create select:focus,
            .tr-create textarea:focus {
                outline: none;
                border-color: #3498db;
            }

            .tr-create textarea {
                resize: vertical;
                min-height: 100px;
            }

            .tr-create .help-text {
                font-size: 13px;
                color: #7f8c8d;
                margin-top: 5px;
            }

            .tr-create .form-actions {
                display: flex;
                gap: 10px;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #ddd;
            }

            .tr-create .btn {
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

            .tr-create .btn-success { background: #27ae60; color: #fff; }
            .tr-create .btn-success:hover { background: #229954; }
            .tr-create .btn-secondary { background: #95a5a6; color: #fff; }
            .tr-create .btn-secondary:hover { background: #7f8c8d; }

            /* Responsive */
            @media (max-width: 991px) {
                .tr-create .tr-sidebar { display: none; }
                .tr-create .tr-content { margin-left: 0 !important; }
                .tr-create .form-actions { flex-direction: column; }
                .tr-create .btn { width: 100%; justify-content: center; }
            }

            /* Bảo đảm dropdown avatar nổi trên form khi cần (không đụng #header chung) */
            .tr-create .dropdown-menu { z-index: 1050; }
        </style>
    </head>

    <body class="tr-create <%= hasSidebar ? "has-sidebar" : "" %>">
        <!-- Header dùng chung (đã fixed trong header.jsp) -->
        <jsp:include page="../includes/header.jsp" />

        <main class="tr-main">
            <div class="tr-layout">
                <% if (showMA) { %>
                    <div class="tr-sidebar">
                        <jsp:include page="../includes/sidebar-medicalassistant.jsp" />
                    </div>
                <% } %>

                <div class="tr-content">
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
                                <div class="help-text">Danh sách loại xét nghiệm được lấy tự động từ cơ sở dữ liệu</div>
                                <div class="help-text">Chọn loại xét nghiệm đã được thực hiện</div>
                            </div>

                            <div class="form-group">
                                <label for="result">
                                    Kết quả xét nghiệm <span class="required">*</span>
                                </label>
                                <textarea id="result" name="result" maxlength="50" required
                                          placeholder="Nhập kết quả chi tiết của xét nghiệm..."></textarea>
                                <div class="help-text">Nhập toàn bộ kết quả và ghi chú chuyên môn liên quan</div>
                            </div>

                            <div class="form-group">
                                <label for="date">
                                    Ngày xét nghiệm <span class="required">*</span>
                                </label>
                                <input type="date" id="date" name="date" required
                                       max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                                <div class="help-text">Ngày tiến hành thực hiện xét nghiệm</div>
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
                </div>
            </div>
        </main>

        <script>
            // Tự động đặt ngày hiện tại làm mặc định
            document.getElementById('date').valueAsDate = new Date();
        </script>

        <!-- Bootstrap bundle -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
                crossorigin="anonymous"></script>
    </body>
</html>
