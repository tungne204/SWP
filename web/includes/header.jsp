<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>

<style>
    /* Header Styling - Đảm bảo đồng nhất trên tất cả các trang */
    #header {
        background-color: #0d6efd !important;
        border-bottom: none !important;
        padding: 12px 0 !important;
        height: auto !important;
        min-height: 70px !important;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1) !important;
        z-index: 1050 !important;
    }
    
    #header .branding {
        height: auto !important;
        min-height: 70px !important;
        display: flex !important;
        align-items: center !important;
    }
    
    #header .sitename {
        font-size: 1.4rem !important;
        font-weight: 700 !important;
        color: #ffffff !important;
        margin: 0 !important;
    }
    
    #header .navmenu {
        margin: 0 !important;
        padding: 0 !important;
    }
    
    #header .navmenu a {
        color: #ffffff !important;
        font-size: 1rem !important;
        font-weight: 500 !important;
        text-decoration: none !important;
        padding: 8px 16px !important;
        transition: all 0.3s ease !important;
    }
    
    #header .navmenu a:hover {
        opacity: 0.8 !important;
    }
    
    #header .btn-light {
        background-color: #ffffff !important;
        color: #0d6efd !important;
        border: none !important;
        padding: 8px 20px !important;
        font-weight: 600 !important;
        transition: all 0.3s ease !important;
    }
    
    #header .btn-light:hover {
        background-color: #f8f9fa !important;
        transform: translateY(-2px) !important;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1) !important;
    }
    
    #header .btn-outline-light {
        background-color: transparent !important;
        color: #ffffff !important;
        border: 2px solid #ffffff !important;
        padding: 8px 20px !important;
        font-weight: 600 !important;
        transition: all 0.3s ease !important;
    }
    
    #header .btn-outline-light:hover {
        background-color: #ffffff !important;
        color: #0d6efd !important;
        transform: translateY(-2px) !important;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2) !important;
    }
    
    #header .user-avatar {
        width: 32px !important;
        height: 32px !important;
        border-radius: 50% !important;
        object-fit: cover !important;
        border: 2px solid #007bff !important;
    }
</style>

<header id="header" class="header sticky-top">
  <div class="branding d-flex align-items-center">
    <div class="container-fluid px-4 d-flex align-items-center justify-content-between">

      <!-- Logo -->
      <a href="${pageContext.request.contextPath}/" class="logo d-flex align-items-center text-decoration-none">
        <h1 class="sitename">Medilab</h1>
      </a>

      <!-- Nav -->
      <nav id="navmenu" class="navmenu">
        <ul class="d-flex align-items-center list-unstyled mb-0">
          <li>
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/doctorList">Bác Sĩ</a>
          </li>
          <!-- Hiển thị menu "Cuộc hẹn của tôi" cho Patient (roleId = 3) -->
          <% if (acc != null && acc.getRoleId() == 3) { %>
          <li>
            <a href="${pageContext.request.contextPath}/Appointment-List">Cuộc hẹn của tôi</a>
          </li>
          <% } %>
          <% if (acc != null && acc.getRoleId() == 3) { %>
          <li>
            <a href="${pageContext.request.contextPath}/medical-report">Đơn thuốc của tôi</a>
          </li>
          <% } %>
          <li>
            <a href="${pageContext.request.contextPath}/blog">Blog</a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/contact">Liên hệ</a>
          </li>
        </ul>
      </nav>

      <!-- Login / Dropdown -->
      <% if (acc == null) { %>
        <div class="d-flex gap-2 align-items-center">
          <a class="cta-btn d-none d-sm-block btn btn-outline-light" href="${pageContext.request.contextPath}/Register">Đăng Ký</a>
          <a class="cta-btn d-none d-sm-block btn btn-light" href="${pageContext.request.contextPath}/Login">Đăng Nhập</a>
        </div>
      <% } else { %>
        <div class="dropdown ms-4">
          <button class="btn btn-light dropdown-toggle d-flex align-items-center" type="button" 
                  id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
            <img src="<%= acc.getAvatar() != null && !acc.getAvatar().isEmpty() ? acc.getAvatar() : request.getContextPath() + "/assets/img/avata.jpg" %>" 
                 alt="Avatar" class="user-avatar me-2">
            Hello, <%= acc.getUsername() %>
          </button>
          <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="userMenu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/viewProfile">Hồ sơ cá nhân</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/Change_password">Đổi mật khẩu</a></li>
            
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">Đăng Xuất</a></li>
          </ul>
        </div>
      <% } %>

    </div>
  </div>
</header>

