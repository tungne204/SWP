<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .sidebar-nav {
        padding: 20px 0;
    }

    .nav-section {
        margin-bottom: 30px;
    }

    .nav-section-title {
        font-size: 12px;
        font-weight: 600;
        color: #6c757d;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 10px;
        padding: 0 20px;
    }

    .nav-item {
        margin-bottom: 5px;
    }

    .nav-link {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        color: #495057;
        text-decoration: none;
        transition: all 0.3s ease;
        border-left: 3px solid transparent;
    }

    .nav-link:hover {
        background-color: #f8f9fa;
        color: var(--primary-color);
        border-left-color: var(--primary-color);
    }

    .nav-link.active {
        background-color: rgba(63, 187, 192, 0.1);
        color: var(--primary-color);
        border-left-color: var(--primary-color);
        font-weight: 500;
    }

    .nav-link i {
        width: 20px;
        margin-right: 12px;
        font-size: 16px;
    }

    .nav-link-text {
        flex: 1;
    }

    .nav-badge {
        background: #dc3545;
        color: white;
        font-size: 10px;
        padding: 2px 6px;
        border-radius: 10px;
        margin-left: auto;
    }
</style>

<c:set var="currentGroup" value="${empty param.group ? 'customers' : param.group}" />

<c:url var="dashboardUrl" value="/admin/dashboard" />
<c:url var="customersUrl" value="/admin/users">
    <c:param name="action" value="list"/>
    <c:param name="group" value="customers"/>
</c:url>
<c:url var="staffUrl" value="/admin/users">
    <c:param name="action" value="list"/>
    <c:param name="group" value="staff"/>
</c:url>

<div class="sidebar-fixed">
    <nav class="sidebar-nav">
        <!-- Bảng điều khiển -->
        <div class="nav-section">
            <div class="nav-section-title">Bảng điều khiển</div>
            <div class="nav-item">
                <a href="${dashboardUrl}" class="nav-link">
                    <i class="bi bi-speedometer2"></i>
                    <span class="nav-link-text">Trang tổng quan</span>
                </a>
            </div>
        </div>

        <!-- Danh sách người dùng -->
        <div class="nav-section">
            <div class="nav-section-title">Danh sách người dùng</div>

            <!-- Danh sách khách -->
            <div class="nav-item">
                <a href="${customersUrl}" class="nav-link <c:if test='${currentGroup eq "customers"}'>active</c:if>">
                    <i class="bi bi-people"></i>
                    <span class="nav-link-text">Danh sách khách</span>
                </a>
            </div>

            <!-- Danh sách nhân viên -->
            <div class="nav-item">
                <a href="${staffUrl}" class="nav-link <c:if test='${currentGroup eq "staff"}'>active</c:if>">
                    <i class="bi bi-person-badge"></i>
                    <span class="nav-link-text">Danh sách nhân viên</span>
                </a>
            </div>
        </div>
    </nav>
</div>

<!-- Nếu chưa có trong head-includes.jsp thì thêm -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
