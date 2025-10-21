<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>

<!-- Favicons -->
<link href="${pageContext.request.contextPath}/assets/img/favicon.png" rel="icon">
<link href="${pageContext.request.contextPath}/assets/img/apple-touch-icon.png" rel="apple-touch-icon">

<!-- ✅ Bootstrap core CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<!-- Main CSS -->
<link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">

<header id="header" class="header sticky-top">
  <div class="branding d-flex align-items-center">
    <div class="container-fluid px-4 d-flex align-items-center justify-content-between">

      <!-- Logo -->
      <a href="${pageContext.request.contextPath}/" class="logo d-flex align-items-center text-decoration-none">
        <h1 class="sitename m-0">Medilab</h1>
      </a>

      <!-- Nav -->
      <nav id="navmenu" class="navmenu">
        <ul class="d-flex align-items-center list-unstyled mb-0">
          <li>
            <a href="${pageContext.request.contextPath}/"
               class="active text-dark text-decoration-none px-3">Home</a>
          </li>
        </ul>
      </nav>

      <!-- Login / Dropdown -->
      <% if (acc == null) { %>
        <a class="btn btn-light btn-sm fw-semibold" href="${pageContext.request.contextPath}/Login">Login</a>
      <% } else { %>
        <div class="dropdown">
          <button class="btn btn-light btn-sm dropdown-toggle fw-semibold" type="button"
                  id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
            Hello, <%= acc.getUsername() %>
          </button>
          <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="userMenu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/viewProfile.jsp">View Profile</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/Change_password">Change Password</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient-appointment">My Appointments</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger fw-semibold" href="${pageContext.request.contextPath}/logout">Logout</a></li>
          </ul>
        </div>
      <% } %>

    </div>
  </div>
</header>

<!-- ✅ Bootstrap Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
  /* Header */
  #header {
    background-color: #0d6efd !important; /* ✅ Nền xanh */
    border-bottom: none;
    padding: 8px 0;
  }

  /* Logo */
  #header .sitename {
    font-size: 1.4rem;
    font-weight: 700;
    color: #ffffff !important; /* ✅ Chữ Medilab trắng */
  }

  /* Navigation link */
  #header .navmenu a {
    color: #ffffff !important; /* ✅ Chữ Home trắng */
    font-size: 1rem;
    font-weight: 500;
    position: relative; /* Để tạo hiệu ứng gạch */
    text-decoration: none !important;
    transition: color 0.3s ease;
  }

  /* Gạch chân trắng khi hover/active */
  #header .navmenu a::after {
    content: '';
    position: absolute;
    left: 0;
    bottom: -4px;
    width: 0;
    height: 2px;
    background-color: #ffffff;
    transition: width 0.3s ease;
  }

  #header .navmenu a:hover::after,
  #header .navmenu a.active::after {
    width: 100%; /* ✅ Hiện gạch trắng chạy từ trái sang phải */
  }

  /* Dropdown */
  .dropdown-menu {
    border-radius: 8px;
    border: none;
    margin-top: 0.5rem;
  }

  .dropdown-item:hover {
    background-color: #eaf1ff;
  }
</style>

