<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.lang.Math" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khuyến Mãi Sắp Hết Hạn - Phòng Khám Nhi</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 20px;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        
        .expiring-card {
            border-left: 5px solid #ffc107;
        }
        
        .critical-expiring {
            border-left: 5px solid #dc3545;
            animation: pulse 2s infinite;
        }
        
        .warning-expiring {
            border-left: 5px solid #fd7e14;
        }
        
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(220, 53, 69, 0); }
            100% { box-shadow: 0 0 0 0 rgba(220, 53, 69, 0); }
        }
        
        .badge-expiring {
            background-color: #dc3545;
            color: white;
            animation: blink 1s infinite;
        }
        
        .badge-warning {
            background-color: #fd7e14;
            color: white;
        }
        
        @keyframes blink {
            0%, 50% { opacity: 1; }
            51%, 100% { opacity: 0.5; }
        }
        
        .promotion-code {
            background-color: #e9ecef;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-weight: bold;
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
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-secondary:hover { background: #7f8c8d; }
        .btn-outline-primary { background: transparent; color: #3498db; border: 1px solid #3498db; }
        .btn-outline-primary:hover { background: #3498db; color: white; }
        .btn-outline-warning { background: transparent; color: #f1c40f; border: 1px solid #f1c40f; }
        .btn-outline-warning:hover { background: #f1c40f; color: black; }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 5px;
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

        .text-white { color: white !important; }
        .bg-danger { background-color: #dc3545 !important; }
        .bg-warning { background-color: #ffc107 !important; }
        .bg-info { background-color: #17a2b8 !important; }
        .text-warning { color: #ffc107 !important; }
        .me-2 { margin-right: 0.5rem !important; }
        .mb-4 { margin-bottom: 1.5rem !important; }
        .d-flex { display: flex !important; }
        .justify-content-between { justify-content: space-between !important; }
        .align-items-center { align-items: center !important; }
        .flex-fill { flex: 1 1 auto !important; }
        .gap-2 { gap: 0.5rem !important; }
        .row { display: flex; flex-wrap: wrap; margin: 0 -15px; }
        .col-md-4, .col-md-6, .col-lg-4 { padding: 0 15px; }
        .col-md-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
        .col-md-6 { flex: 0 0 50%; max-width: 50%; }
        .col-lg-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
        .h-100 { height: 100% !important; }
        .mb-0 { margin-bottom: 0 !important; }
        .mb-2 { margin-bottom: 0.5rem !important; }
        .mb-3 { margin-bottom: 1rem !important; }
        .fa-2x { font-size: 2em; }
        .fa-3x { font-size: 3em; }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { padding: 15px; }
            .col-md-4, .col-md-6, .col-lg-4 { flex: 0 0 100%; max-width: 100%; }
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
                <h1>
                    <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                    Khuyến Mãi Sắp Hết Hạn
                </h1>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div></div>
                    <div class="d-flex gap-2">
                        <a href="admin/discount?action=list" class="btn btn-outline-primary">
                            <i class="fas fa-arrow-left me-1"></i>
                            Quay Lại Danh Sách
                        </a>
                        <a href="admin/discount?action=add" class="btn btn-primary">
                            <i class="fas fa-plus me-1"></i>
                            Thêm Khuyến Mãi Mới
                        </a>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${sessionScope.successMessage}
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        ${sessionScope.errorMessage}
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card text-white bg-danger">
                            <div style="padding: 20px;">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4 style="margin: 0 0 10px 0;">Hết Hạn Trong 3 Ngày</h4>
                                        <h2 class="mb-0">
                                            <c:set var="criticalCount" value="0"/>
                                            <c:forEach var="promotion" items="${expiringPromotions}">
                                                <jsp:useBean id="now" class="java.util.Date"/>
                                                <c:set var="timeDiff" value="${promotion.validTo.time - now.time}"/>
                                                <c:set var="daysDiff" value="${timeDiff / (1000 * 60 * 60 * 24)}"/>
                                                <c:if test="${daysDiff <= 3}">
                                                    <c:set var="criticalCount" value="${criticalCount + 1}"/>
                                                </c:if>
                                            </c:forEach>
                                            ${criticalCount}
                                        </h2>
                                    </div>
                                    <div style="align-self: center;">
                                        <i class="fas fa-exclamation-triangle fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-warning">
                            <div style="padding: 20px;">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4 style="margin: 0 0 10px 0;">Hết Hạn Trong 7 Ngày</h4>
                                        <h2 class="mb-0">
                                            <c:set var="warningCount" value="0"/>
                                            <c:forEach var="promotion" items="${expiringPromotions}">
                                                <jsp:useBean id="now2" class="java.util.Date"/>
                                                <c:set var="timeDiff" value="${promotion.validTo.time - now2.time}"/>
                                                <c:set var="daysDiff" value="${timeDiff / (1000 * 60 * 60 * 24)}"/>
                                                <c:if test="${daysDiff > 3 && daysDiff <= 7}">
                                                    <c:set var="warningCount" value="${warningCount + 1}"/>
                                                </c:if>
                                            </c:forEach>
                                            ${warningCount}
                                        </h2>
                                    </div>
                                    <div style="align-self: center;">
                                        <i class="fas fa-clock fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-info">
                            <div style="padding: 20px;">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4 style="margin: 0 0 10px 0;">Tổng Sắp Hết Hạn</h4>
                                        <h2 class="mb-0">${expiringPromotions.size()}</h2>
                                    </div>
                                    <div style="align-self: center;">
                                        <i class="fas fa-list fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Expiring Promotions List -->
                <div class="card">
                    <div style="background: white; padding: 15px; border-bottom: 1px solid #dee2e6;">
                        <h5 class="mb-0">
                            <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                            Danh Sách Khuyến Mãi Sắp Hết Hạn
                        </h5>
                    </div>
                    <div style="padding: 20px;">
                        <c:choose>
                            <c:when test="${empty expiringPromotions}">
                                <div class="empty-state">
                                    <i class="fas fa-smile"></i>
                                    <h4>Tuyệt vời!</h4>
                                    <p>Hiện tại không có khuyến mãi nào sắp hết hạn.</p>
                                    <a href="admin/discount?action=add" class="btn btn-primary">
                                        <i class="fas fa-plus me-1"></i>
                                        Tạo Khuyến Mãi Mới
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row">
                                    <c:forEach var="promotion" items="${expiringPromotions}">
                                        <div class="col-md-6 col-lg-4 mb-4">
                                            <jsp:useBean id="currentDate" class="java.util.Date"/>
                                            <c:set var="timeDifference" value="${promotion.validTo.time - currentDate.time}"/>
                                            <c:set var="daysRemaining" value="${Math.floor(timeDifference / (1000 * 60 * 60 * 24))}"/>
                                            
                                            <div class="card h-100 ${daysRemaining <= 3 ? 'critical-expiring' : 'warning-expiring'}">
                                                <div style="padding: 20px;">
                                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                                        <h6 style="margin: 0;">${promotion.code}</h6>
                                                        <span style="padding: 5px 8px; border-radius: 5px; font-size: 0.85rem;" class="${daysRemaining <= 3 ? 'badge-expiring' : 'badge-warning'}">
                                                            <c:choose>
                                                                <c:when test="${daysRemaining <= 0}">Đã hết hạn</c:when>
                                                                <c:when test="${daysRemaining == 1}">Còn 1 ngày</c:when>
                                                                <c:otherwise>Còn ${daysRemaining} ngày</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    
                                                    <div class="mb-2">
                                                        <strong>Mã:</strong> 
                                                        <span class="promotion-code">${promotion.code}</span>
                                                    </div>
                                                    
                                                    <div class="mb-2">
                                                        <strong>Phần trăm giảm giá:</strong>
                                                        ${promotion.percentage}%
                                                    </div>
                                                    
                                                    <div class="mb-2">
                                                        <strong>Ngày bắt đầu:</strong>
                                                        <fmt:formatDate value="${promotion.validFrom}" pattern="dd/MM/yyyy"/>
                                                    </div>
                                                    
                                                    <div class="mb-3">
                                                        <strong>Ngày hết hạn:</strong>
                                                        <fmt:formatDate value="${promotion.validTo}" pattern="dd/MM/yyyy"/>
                                                    </div>
                                                    
                                                    <div class="d-flex gap-2">
                                                        <a href="admin/discount?action=view&id=${promotion.discountId}" 
                                                           class="btn btn-outline-primary flex-fill" style="font-size: 0.875rem;">
                                                            <i class="fas fa-eye me-1"></i>
                                                            Xem
                                                        </a>
                                                        <a href="admin/discount?action=edit&id=${promotion.discountId}" 
                                                           class="btn btn-outline-warning flex-fill" style="font-size: 0.875rem;">
                                                            <i class="fas fa-edit me-1"></i>
                                                            Sửa
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            </div>
        </div>
    </main>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto-refresh page every 5 minutes to update expiring status
        setTimeout(function() {
            location.reload();
        }, 300000); // 5 minutes
        
        // Show notification for critical expiring promotions
        document.addEventListener('DOMContentLoaded', function() {
            const criticalCards = document.querySelectorAll('.critical-expiring');
            if (criticalCards.length > 0) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Cảnh báo!',
                    text: `Có ${criticalCards.length} khuyến mãi sắp hết hạn trong 3 ngày tới!`,
                    confirmButtonText: 'Đã hiểu',
                    confirmButtonColor: '#dc3545'
                });
            }
        });
    </script>
</body>
</html>