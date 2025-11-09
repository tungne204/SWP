<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết khuyến mãi - Phòng Khám Nhi</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
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

        .container-box {
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

        .info-label { font-weight: 600; color: #6c757d; margin-bottom: 5px; }
        .info-value { font-size: 1.05rem; color: #212529; margin-bottom: 20px; }

        .status-box {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 25px;
        }
        .status-active-box { background-color: #d4edda; border-left: 5px solid #28a745; }
        .status-inactive-box { background-color: #f8d7da; border-left: 5px solid #dc3545; }
        .status-expiring-box { background-color: #fff3cd; border-left: 5px solid #ffc107; }

        .discount-display {
            text-align: center;
            padding: 2rem;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border-radius: 15px;
            margin: 2rem 0;
        }

        .discount-value {
            font-size: 3rem;
            font-weight: 700;
            margin: 0;
        }

        .discount-type {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-top: 0.5rem;
        }

        .btn {
            padding: 8px 14px;
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
        .btn-success:hover { background: #1e8449; }
        .btn-warning { background: #f1c40f; color: black; }
        .btn-warning:hover { background: #d4ac0d; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-danger:hover { background: #c82333; }
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-secondary:hover { background: #7f8c8d; }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { padding: 15px; }
            .discount-value { font-size: 2rem; }
        }
    </style>
</head>

<body>
    <!-- HEADER -->
    <jsp:include page="../includes/header.jsp" />

    <div class="main-layout">
        <!-- SIDEBAR -->
        <% if (acc != null && acc.getRoleId() == 1) { %>
            <jsp:include page="../includes/sidebar-admin.jsp" />
        <% } %>

        <!-- MAIN CONTENT -->
        <div class="main-content">
            <div class="container-box">

                <h1><i class="fas fa-tag"></i> Chi tiết khuyến mãi</h1>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <!-- Promotion Detail -->
                <c:if test="${not empty promotion}">
                    <!-- Check if promotion is expiring soon -->
                    <%
                        java.util.Date currentDate = new java.util.Date();
                        java.util.Calendar cal = java.util.Calendar.getInstance();
                        cal.setTime(currentDate);
                        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
                        cal.set(java.util.Calendar.MINUTE, 0);
                        cal.set(java.util.Calendar.SECOND, 0);
                        cal.set(java.util.Calendar.MILLISECOND, 0);
                        java.util.Date currentDateOnly = cal.getTime();
                        request.setAttribute("currentDateOnly", currentDateOnly);
                    %>
                    <c:set var="currentDate" value="${currentDateOnly}" />
                    <c:set var="daysDiff" value="${(promotion.validTo.time - currentDate.time) / (1000 * 60 * 60 * 24)}" />
                    <c:if test="${daysDiff <= 7 && daysDiff > 0}">
                        <div class="status-box status-expiring-box">
                            <h5 class="mb-0">
                                <i class="fas fa-exclamation-triangle text-warning"></i>
                                <strong>Cảnh báo:</strong> Khuyến mãi này sẽ hết hạn trong <fmt:formatNumber value="${daysDiff}" maxFractionDigits="0"/> ngày!
                            </h5>
                        </div>
                    </c:if>

                    <!-- Status Display -->
                    <c:choose>
                        <c:when test="${currentDate.time < promotion.validFrom.time}">
                            <div class="status-box status-inactive-box">
                                <h5 class="mb-0">
                                    <i class="fas fa-clock text-info"></i> Khuyến mãi chưa bắt đầu
                                </h5>
                            </div>
                        </c:when>
                        <c:when test="${currentDate.time > promotion.validTo.time}">
                            <div class="status-box status-inactive-box">
                                <h5 class="mb-0">
                                    <i class="fas fa-times-circle text-danger"></i> Khuyến mãi đã hết hạn
                                </h5>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="status-box status-active-box">
                                <h5 class="mb-0">
                                    <i class="fas fa-check-circle text-success"></i> Khuyến mãi đang hoạt động
                                </h5>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Discount Display -->
                    <div class="discount-display">
                        <div class="discount-value">
                            ${promotion.percentage}%
                        </div>
                        <div class="discount-type">
                            Giảm giá theo phần trăm
                        </div>
                    </div>

                    <!-- Information Details -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-tag text-primary"></i> Mã khuyến mãi</div>
                            <div class="info-value"><strong>${promotion.code}</strong></div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-hashtag text-primary"></i> ID khuyến mãi</div>
                            <div class="info-value"><span class="badge bg-primary">${promotion.discountId}</span></div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-percentage text-primary"></i> Phần trăm giảm giá</div>
                            <div class="info-value">
                                <i class="fas fa-percentage text-success"></i>
                                ${promotion.percentage}%
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-calendar-alt text-primary"></i> Ngày bắt đầu</div>
                            <div class="info-value">
                                <i class="fas fa-calendar-alt text-success"></i>
                                <fmt:formatDate value="${promotion.validFrom}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-calendar-alt text-primary"></i> Ngày kết thúc</div>
                            <div class="info-value">
                                <i class="fas fa-calendar-alt text-danger"></i>
                                <fmt:formatDate value="${promotion.validTo}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-label"><i class="fas fa-toggle-on text-primary"></i> Trạng thái</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${currentDate.time < promotion.validFrom.time}">
                                        <span class="badge bg-secondary fs-6">
                                            <i class="fas fa-clock"></i> Chưa bắt đầu
                                        </span>
                                    </c:when>
                                    <c:when test="${currentDate.time > promotion.validTo.time}">
                                        <span class="badge bg-danger fs-6">
                                            <i class="fas fa-times-circle"></i> Đã hết hạn
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success fs-6">
                                            <i class="fas fa-check-circle"></i> Đang hoạt động
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/admin/discount?action=list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/admin/discount?action=edit&id=${promotion.discountId}" 
                               class="btn btn-primary">
                                <i class="fas fa-edit"></i> Chỉnh sửa
                            </a>
                            
                            <button type="button" class="btn btn-danger" 
                                    onclick="deletePromotion(${promotion.discountId})">
                                <i class="fas fa-trash"></i> Xóa
                            </button>
                        </div>
                    </div>
                </c:if>

                <c:if test="${empty promotion}">
                    <div class="alert alert-warning text-center">
                        <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                        <h5>Không tìm thấy thông tin khuyến mãi!</h5>
                        <a href="${pageContext.request.contextPath}/admin/discount?action=list"
                           class="btn btn-primary mt-3">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function deletePromotion(discountId) {
            Swal.fire({
                title: 'Xác nhận xóa',
                text: 'Bạn có chắc chắn muốn xóa khuyến mãi này?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Xóa',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Create form and submit
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin/discount';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'delete';
                    
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'id';
                    idInput.value = discountId;
                    
                    form.appendChild(actionInput);
                    form.appendChild(idInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
</body>
</html>