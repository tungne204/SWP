<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý kết quả xét nghiệm</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <jsp:include page="../includes/head-includes.jsp"/>

        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f6fa;
            }

            /* ===== HEADER ===== */
            .header {
                width: 100%;
                background: white;
                padding: 15px 25px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                position: sticky;
                top: 0;
                z-index: 100;
            }

            /* ===== LAYOUT CHÍNH ===== */
            .main-layout {
                display: flex;
                min-height: calc(100vh - 70px);
            }

            /* Sidebar bên trái */
            .sidebar {
                width: 250px;
                background-color: #2c3e50;
                color: white;
                min-height: calc(100vh - 70px);
                position: sticky;
                top: 70px; /* bằng chiều cao header */
            }

            /* Nội dung bên phải */
            .main-content {
                flex: 1;
                padding: 25px;
            }

            /* ===== NỘI DUNG TRANG ===== */
            .container {
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

            .alert {
                padding: 15px 20px;
                margin-bottom: 20px;
                border-radius: 5px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .alert-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .alert-error {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .btn {
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

            .btn-primary {
                background: #3498db;
                color: white;
            }
            .btn-primary:hover {
                background: #2980b9;
            }
            .btn-success {
                background: #27ae60;
                color: white;
            }
            .btn-success:hover {
                background: #229954;
            }
            .btn-danger {
                background: #e74c3c;
                color: white;
            }
            .btn-danger:hover {
                background: #c0392b;
            }
            .btn-sm {
                padding: 6px 12px;
                font-size: 13px;
            }

            .header-actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            thead {
                background: #fffff;
                color: black;
                font-size: 15px;
            }
            th, td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            tbody tr:hover {
                background: #f8f9fa;
            }

            .actions {
                display: flex;
                gap: 8px;
            }
            .badge {
                padding: 4px 8px;
                border-radius: 3px;
                font-size: 12px;
                font-weight: 600;
            }
            .badge-info {
                background: #3498db;
                color: white;
            }
            .no-data {
                text-align: center;
                padding: 40px;
                color: #7f8c8d;
                font-style: italic;
            }

            @media (max-width: 768px) {
                .sidebar {
                    display: none;
                }
                .main-content {
                    width: 100%;
                    padding: 15px;
                }
            }
            form input[type="text"], form select {
                min-width: 200px;
                height: 36px;
            }

            form button, form a.btn {
                height: 38px;
            }

            .pagination a, .pagination span {
                padding: 8px 14px;
                border-radius: 5px;
                text-decoration: none;
                font-weight: 500;
            }

            .pagination a:hover {
                background-color: #dfe6e9;
            }

        </style>
    </head>

    <body>

        <!-- HEADER -->
        <jsp:include page="../includes/header.jsp" />

        <!-- LAYOUT CHÍNH -->
        <div class="main-layout">
            <!-- SIDEBAR -->
            <% if (acc != null && acc.getRoleId() == 4) { %>
            <jsp:include page="../includes/sidebar-medicalassistant.jsp" />

            <% } %>

            <% if (acc != null && acc.getRoleId() == 2) { %>
            <jsp:include page="../includes/sidebar-doctor.jsp" />

            <% } %>


            <!-- NỘI DUNG CHÍNH -->
            <div class="main-content">
                <div class="container">
                    <div class="header-actions">
                        <h1><i class="fas fa-flask"></i> Quản lý kết quả xét nghiệm</h1>

                        <!-- 🔍 Form tìm kiếm & lọc -->
                        <form method="get" action="testresult" style="display: flex; flex-wrap: wrap; gap: 10px; align-items: center;">
                            <input type="hidden" name="action" value="list">

                            <input type="text" name="search" value="${searchQuery}" placeholder="Tìm theo tên, loại, kết quả..."
                                   style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;">

                            <select name="testType" style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                                <option value="">-- Tất cả loại xét nghiệm --</option>
                                <c:forEach var="type" items="${testTypes}">
                                    <option value="${type}" ${type == testTypeFilter ? 'selected' : ''}>${type}</option>
                                </c:forEach>
                            </select>

                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i> Tìm kiếm
                            </button>
                            <% if (acc != null && acc.getRoleId() == 4) { %>
                            <a href="testresult?action=add" class="btn btn-success">
                                <i class="fas fa-plus"></i> Thêm mới
                            </a>
                            <
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
                                    <% if (acc != null && acc.getRoleId() == 4) { %>
                                <th>Thao tác</th>
                                    <% } %>

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
                                            <% if (acc != null && acc.getRoleId() == 4) { %>
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
                                        <td colspan="8" class="no-data">
                                            <i class="fas fa-inbox" style="font-size: 48px; display: block; margin-bottom: 10px;"></i>
                                            Chưa có kết quả xét nghiệm nào. Nhấn “Thêm kết quả xét nghiệm mới” để tạo mới.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    <!-- PHÂN TRANG -->
                    <c:if test="${totalPages > 1}">
                        <div style="margin-top: 25px; display: flex; justify-content: center; gap: 6px; flex-wrap: wrap;">
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span style="padding: 8px 14px; background: #3498db; color: white; border-radius: 5px;">
                                            ${i}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="testresult?action=list&page=${i}&search=${searchQuery}&testType=${testTypeFilter}"
                                           style="padding: 8px 14px; background: #ecf0f1; border-radius: 5px;
                                           color: #2c3e50; text-decoration: none;">
                                            ${i}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </c:if>

                </div>
            </div>
        </div>
        <!-- ✅ Script Bootstrap để dropdown avatar hoạt động -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    </body>
</html>
