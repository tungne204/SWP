<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
    java.util.Date currentDate = new java.util.Date();
    java.util.Calendar cal = java.util.Calendar.getInstance();
    cal.setTime(currentDate);
    cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
    cal.set(java.util.Calendar.MINUTE, 0);
    cal.set(java.util.Calendar.SECOND, 0);
    cal.set(java.util.Calendar.MILLISECOND, 0);
    java.util.Date now = cal.getTime();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khuyến Mãi - Phòng Khám Nhi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <jsp:include page="../includes/head-includes.jsp"/>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
        }

        .header {
            width: 100%;
            background: white;
            padding: 15px 25px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .main-layout {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        .sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: white;
            min-height: calc(100vh - 70px);
            position: sticky;
            top: 70px;
        }

        .main-content {
            flex: 1;
            padding: 25px;
        }

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

        .search-box form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            margin-bottom: 20px;
        }

        .search-box input,
        .search-box select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            height: 36px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn-primary { background: #3498db; color: white; }
        .btn-primary:hover { background: #2980b9; }
        .btn-success { background: #27ae60; color: white; }
        .btn-success:hover { background: #229954; }
        .btn-warning { background: #f1c40f; color: black; }
        .btn-warning:hover { background: #d4ac0d; }
        .btn-danger { background: #e74c3c; color: white; }
        .btn-danger:hover { background: #c0392b; }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border-bottom: 1px solid #ddd;
            padding: 10px;
        }
        thead {
            background: #f8f9fa;
            color: #2c3e50;
        }
        tbody tr:hover { background: #f9f9f9; }

        .status-badge {
            padding: 5px 8px;
            border-radius: 5px;
            font-size: 0.85rem;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-expired {
            background-color: #f1c40f;
            color: #856404;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-style: italic;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { padding: 15px; }
        }
    </style>
</head>

<body>
<jsp:include page="../includes/header.jsp" />

<div class="main-layout">
    <% if (acc != null && acc.getRoleId() == 1) { %>
    <jsp:include page="../includes/sidebar-admin.jsp" />
    <% } %>

    <div class="main-content">
        <div class="container">
            <h1><i class="fas fa-tags"></i> Quản lý khuyến mãi</h1>

            <!-- Success/Error Messages -->
            <c:if test="${param.success == '1'}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> Tạo khuyến mãi thành công!
                </div>
            </c:if>
            <c:if test="${param.updated == '1'}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> Cập nhật khuyến mãi thành công!
                </div>
            </c:if>
            <c:if test="${param.deleted == '1'}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> Xóa khuyến mãi thành công!
                </div>
            </c:if>
            <c:if test="${param.error == '1'}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> Có lỗi xảy ra. Vui lòng thử lại!
                </div>
            </c:if>

            <!-- Bộ lọc và thêm mới -->
            <div class="search-box">
                <form method="get" action="${pageContext.request.contextPath}/admin/discount">
                    <input type="hidden" name="action" value="list">
                    <input type="text" name="search" placeholder="Tìm theo mã khuyến mãi..." value="${searchKeyword}">
                    <select name="sort">
                        <option value="DESC" ${sortOrder == 'DESC' ? 'selected' : ''}>Mới nhất</option>
                        <option value="ASC" ${sortOrder == 'ASC' ? 'selected' : ''}>Cũ nhất</option>
                    </select>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </form>
                <a href="${pageContext.request.contextPath}/admin/discount?action=add" class="btn btn-success">
                    <i class="fas fa-plus"></i> Thêm khuyến mãi
                </a>
            </div>

            <!-- Bảng danh sách -->
            <table class="table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Mã khuyến mãi</th>
                    <th>Giảm giá (%)</th>
                    <th>Ngày bắt đầu</th>
                    <th>Ngày kết thúc</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty promotions}">
                        <tr><td colspan="6" class="no-data">Không tìm thấy khuyến mãi nào.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="promotion" items="${promotions}">
                            <tr>
                                <td><strong>${promotion.discountId}</strong></td>
                                <td><code>${promotion.code}</code></td>
                                <td>${promotion.percentage}%</td>
                                <td><fmt:formatDate value="${promotion.validFrom}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${promotion.validTo}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/discount?action=view&id=${promotion.discountId}" class="btn btn-primary btn-sm">
                                        <i class="fas fa-eye"></i> Xem
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/discount?action=edit&id=${promotion.discountId}" class="btn btn-warning btn-sm">
                                        <i class="fas fa-edit"></i> Sửa
                                    </a>
                                    <button class="btn btn-danger btn-sm" onclick="deletePromotion(${promotion.discountId}, '${promotion.code}')">
                                        <i class="fas fa-trash"></i> Xóa
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>

            <!-- Phân trang -->
            <c:if test="${totalPages > 1}">
                <div style="margin-top: 25px; display: flex; justify-content: center; gap: 6px;">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span style="padding: 8px 14px; background: #3498db; color: white; border-radius: 5px;">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?action=list&page=${i}&search=${searchKeyword}&sort=${sortOrder}"
                                   style="padding: 8px 14px; background: #ecf0f1; border-radius: 5px; color: #2c3e50; text-decoration: none;">
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

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function deletePromotion(discountId, discountCode) {
        Swal.fire({
            title: 'Xác nhận xóa khuyến mãi',
            html: `Bạn có chắc muốn xóa khuyến mãi <strong>`+discountCode+`</strong>?`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#e74c3c',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '${pageContext.request.contextPath}/admin/discount?action=delete&id=' + discountId;
            }
        });
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>