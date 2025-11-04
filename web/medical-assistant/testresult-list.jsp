<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
    boolean showMA = (acc != null && acc.getRoleId() == 4); // Medical assistant
    boolean showDoctor = (acc != null && acc.getRoleId() == 2); // Doctor
    boolean hasSidebar = showMA || showDoctor;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý kết quả xét nghiệm</title>

        <!-- Icon & head includes dùng chung -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <jsp:include page="../includes/head-includes.jsp"/>

        <style>
            /* ===== Scope riêng cho trang TestResult ===== */
            .tr-page {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f6fa;
            }

            /* tránh trùng header chung (fixed ~80px như Home) */
            .tr-page .tr-main {
                padding-top: 80px;
            }

            /* Layout chính */
            .tr-page .tr-layout {
                display: flex;
                min-height: calc(100vh - 80px);
            }

            /* Sidebar giống Home: fixed trái 280px khi có */
            .tr-page .tr-sidebar {
                width: 280px;
                background: #ffffff;
                border-right: 1px solid #dee2e6;
                position: fixed;
                top: 80px;
                left: 0;
                height: calc(100vh - 80px);
                overflow-y: auto;
                z-index: 1000;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.06);
            }

            /* Nội dung chính */
            .tr-page .tr-content {
                flex: 1;
                padding: 24px;
                min-height: calc(100vh - 80px);
            }
            /* Chỉ đẩy nội dung sang phải khi có sidebar */
            .tr-page.has-sidebar .tr-content {
                margin-left: 280px;
            }

            /* Card bọc nội dung */
            .tr-page .tr-card {
                background: #ffffff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            }

            /* Tiêu đề */
            .tr-page h1 {
                color: #2c3e50;
                margin-bottom: 24px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            /* Alert */
            .tr-page .alert {
                padding: 15px 20px;
                margin-bottom: 20px;
                border-radius: 5px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .tr-page .alert-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .tr-page .alert-error {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            /* Button */
            .tr-page .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                transition: all 0.3s;
            }
            .tr-page .btn-primary { background: #3498db; color: #fff; }
            .tr-page .btn-primary:hover { background: #2980b9; }
            .tr-page .btn-success { background: #27ae60; color: #fff; }
            .tr-page .btn-success:hover { background: #229954; }
            .tr-page .btn-danger { background: #e74c3c; color: #fff; }
            .tr-page .btn-danger:hover { background: #c0392b; }
            .tr-page .btn-sm { padding: 6px 12px; font-size: 13px; }

            /* Header actions (tiêu đề + form) */
            .tr-page .header-actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 12px;
                flex-wrap: wrap;
                margin-bottom: 14px;
            }

            /* Form inputs */
            .tr-page form input[type="text"],
            .tr-page form select {
                min-width: 200px;
                height: 36px;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            .tr-page form button,
            .tr-page form a.btn {
                height: 38px;
            }

            /* Bảng */
            .tr-page table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 14px;
            }
            .tr-page thead {
                background: #ffffff;
                color: #000;
                font-size: 15px;
            }
            .tr-page th,
            .tr-page td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #e9ecef;
            }
            .tr-page tbody tr:hover {
                background: #f8f9fa;
            }

            /* Badge */
            .tr-page .badge {
                padding: 4px 8px;
                border-radius: 3px;
                font-size: 12px;
                font-weight: 600;
            }
            .tr-page .badge-info {
                background: #3498db;
                color: #fff;
            }

            /* Hành động */
            .tr-page .actions {
                display: flex;
                gap: 8px;
            }

            /* Trạng thái rỗng */
            .tr-page .no-data {
                text-align: center;
                padding: 40px;
                color: #7f8c8d;
                font-style: italic;
            }

            /* Phân trang */
            .tr-page .pagination { display: flex; justify-content: center; flex-wrap: wrap; gap: 6px; margin-top: 25px; }
            .tr-page .pagination a,
            .tr-page .pagination span {
                padding: 8px 14px;
                border-radius: 5px;
                text-decoration: none;
                font-weight: 500;
            }
            .tr-page .pagination a {
                background: #ecf0f1;
                color: #2c3e50;
            }
            .tr-page .pagination a:hover { background-color: #dfe6e9; }
            .tr-page .pagination span {
                background: #3498db;
                color: #fff;
            }

            /* Responsive */
            @media (max-width: 991px) {
                .tr-page .tr-sidebar { display: none; }
                .tr-page .tr-content { margin-left: 0 !important; }
            }
        </style>
    </head>

    <body class="tr-page <%= hasSidebar ? "has-sidebar" : "" %>">

        <!-- HEADER dùng chung -->
        <jsp:include page="../includes/header.jsp" />

        <!-- LAYOUT trang xét nghiệm -->
        <main class="tr-main">
            <div class="tr-layout">

                <% if (showMA) { %>
                    <div class="tr-sidebar">
                        <jsp:include page="../includes/sidebar-medicalassistant.jsp" />
                    </div>
                <% } %>

                <% if (showDoctor) { %>
                    <div class="tr-sidebar">
                        <jsp:include page="../includes/sidebar-doctor.jsp" />
                    </div>
                <% } %>

                <div class="tr-content">
                    <div class="tr-card">

                        <div class="header-actions">
                            <h1><i class="fas fa-flask"></i> Quản lý kết quả xét nghiệm</h1>

                            <!-- 🔍 Form tìm kiếm & lọc -->
                            <form method="get" action="testresult" style="display:flex;flex-wrap:wrap;gap:10px;align-items:center;">
                                <input type="hidden" name="action" value="list">

                                <input type="text" name="search" value="${searchQuery}"
                                       placeholder="Tìm theo tên, loại, kết quả...">

                                <select name="testType">
                                    <option value="">-- Tất cả loại xét nghiệm --</option>
                                    <c:forEach var="type" items="${testTypes}">
                                        <option value="${type}" ${type == testTypeFilter ? 'selected' : ''}>${type}</option>
                                    </c:forEach>
                                </select>

                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>

                                <% if (showMA) { %>
                                <a href="testresult?action=add" class="btn btn-success">
                                    <i class="fas fa-plus"></i> Thêm mới
                                </a>
                                <% } %>
                            </form>
                        </div>

                        <!-- Thông báo -->
                        <c:if test="${not empty sessionScope.message}">
                            <div class="alert alert-${sessionScope.messageType}">
                                <i class="fas ${sessionScope.messageType == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
                                ${sessionScope.message}
                            </div>
                            <c:remove var="message" scope="session"/>
                            <c:remove var="messageType" scope="session"/>
                        </c:if>

                        <!-- Bảng kết quả xét nghiệm -->
                        <table>
                            <thead>
                                <tr>
                                    <th>Mã xét nghiệm</th>
                                    <th>Tên bệnh nhân</th>
                                    <th>Bác sĩ</th>
                                    <th>Loại xét nghiệm</th>
                                    <th>Kết quả</th>
                                    <th>Ngày xét nghiệm</th>
                                    <th>Chẩn đoán</th>
                                    <% if (showMA) { %><th>Thao tác</th><% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty testResults}">
                                        <c:forEach var="test" items="${testResults}">
                                            <tr>
                                                <td><span class="badge badge-info">#${test.testId}</span></td>
                                                <td>${test.patientName}</td>
                                                <td>${test.doctorName}</td>
                                                <td>${test.testType}</td>
                                                <td>${test.result}</td>
                                                <td>${test.date}</td>
                                                <td>${test.diagnosis}</td>
                                                <% if (showMA) { %>
                                                <td>
                                                    <div class="actions">
                                                        <a href="testresult?action=edit&id=${test.testId}" class="btn btn-primary btn-sm">
                                                            <i class="fas fa-edit"></i> Sửa
                                                        </a>
                                                        <a href="testresult?action=delete&id=${test.testId}" class="btn btn-danger btn-sm"
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa kết quả xét nghiệm này không?');">
                                                            <i class="fas fa-trash"></i> Xóa
                                                        </a>
                                                    </div>
                                                </td>
                                                <% } %>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="<%= showMA ? 8 : 7 %>" class="no-data">
                                                <i class="fas fa-inbox" style="font-size: 48px; display: block; margin-bottom: 10px;"></i>
                                                Chưa có kết quả xét nghiệm nào. Nhấn “Thêm kết quả xét nghiệm mới” để tạo mới.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>

                        <!-- PHÂN TRANG (dùng c:url để tránh lỗi chèn JSTL trong thuộc tính) -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination">
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span>${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url var="pageUrl" value="testresult">
                                                <c:param name="action" value="list"/>
                                                <c:param name="page" value="${i}"/>
                                                <c:param name="search" value="${searchQuery}"/>
                                                <c:param name="testType" value="${testTypeFilter}"/>
                                                <c:if test="${recordId != null}">
                                                    <c:param name="recordId" value="${recordId}"/>
                                                </c:if>
                                            </c:url>
                                            <a href="${pageUrl}">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </c:if>

                    </div> <!-- /.tr-card -->
                </div> <!-- /.tr-content -->
            </div> <!-- /.tr-layout -->
        </main>

        <!-- Bootstrap bundle để dropdown/avatar hoạt động -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
                crossorigin="anonymous"></script>
    </body>
</html>
