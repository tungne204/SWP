<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
    String userRole = "";
    if (acc != null && acc.getRole() != null) {
        userRole = acc.getRole().getRoleName();
    }
%>

<!-- Favicons -->
<link href="${pageContext.request.contextPath}/assets/img/favicon.png" rel="icon">
<link href="${pageContext.request.contextPath}/assets/img/apple-touch-icon.png" rel="apple-touch-icon">

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<!-- Main CSS -->
<link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">

<!-- Unified Layout Styles -->
<style>
    :root {
        --primary-color: #3fbbc0;
        --primary-dark: #2a9fa4;
        --secondary-color: #2c4964;
        --sidebar-width: 250px;
        --header-height: 70px;
    }
    
    body {
        margin: 0;
        padding: 0;
        font-family: 'Roboto', sans-serif;
        background: linear-gradient(135deg, #e8f5f6 0%, #d4eef0 100%);
        min-height: 100vh;
    }
    
    .layout-container {
        display: flex;
        min-height: 100vh;
    }
    
    .header-fixed {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: var(--header-height);
        background: white;
        border-bottom: 1px solid #e0e0e0;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        z-index: 1000;
        display: flex;
        align-items: center;
        padding: 0 20px;
    }
    
    .sidebar-fixed {
        position: fixed;
        top: var(--header-height);
        left: 0;
        width: var(--sidebar-width);
        height: calc(100vh - var(--header-height));
        background: white;
        border-right: 1px solid #e0e0e0;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        z-index: 999;
        overflow-y: auto;
    }
    
    .main-content {
        margin-left: var(--sidebar-width);
        margin-top: var(--header-height);
        padding: 20px;
        width: calc(100% - var(--sidebar-width));
        min-height: calc(100vh - var(--header-height));
        overflow: auto;
    }
    
    .logo {
        font-size: 24px;
        font-weight: bold;
        color: var(--primary-color);
        text-decoration: none;
    }
    
    .user-info {
        margin-left: auto;
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .role-badge {
        background: var(--primary-color);
        color: white;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        text-transform: uppercase;
    }
</style>

<header class="header-fixed">
    <!-- Logo -->
    <a href="${pageContext.request.contextPath}/" class="logo">
        <i class="bi bi-hospital"></i> Medilab Clinic
    </a>
    
    <!-- User Info -->
    <div class="user-info">
        <% if (acc != null) { %>
            <span class="role-badge"><%= userRole %></span>
            <div class="dropdown">
                <button class="btn btn-outline-primary btn-sm dropdown-toggle" type="button"
                        id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-person-circle"></i> <%= acc.getUsername() %>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userMenu">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/viewProfile.jsp">
                        <i class="bi bi-person"></i> View Profile</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/Change_password">
                        <i class="bi bi-key"></i> Change Password</a></li>
                    <% if ("Patient".equals(userRole)) { %>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient-appointment">
                            <i class="bi bi-calendar"></i> My Appointments</a></li>
                    <% } %>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right"></i> Logout</a></li>
                </ul>
            </div>
        <% } else { %>
            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/Login">
                <i class="bi bi-box-arrow-in-right"></i> Login
            </a>
        <% } %>
    </div>
</header>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

