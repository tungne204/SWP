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
      <a href="${pageContext.request.contextPath}/Home.jsp" class="logo d-flex align-items-center text-decoration-none">
        <h1 class="sitename m-0">Medilab</h1>
      </a>

      <!-- Nav -->
      <nav id="navmenu" class="navmenu">
        <ul class="d-flex align-items-center list-unstyled mb-0">
          <li>
            <a href="${pageContext.request.contextPath}/Home.jsp"
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
    background-color: #ffffff !important; /* Nền trắng */
    border-bottom: 1px solid #e0e0e0;
    padding: 8px 0;
  }

  /* Logo */
  #header .sitename {
    font-size: 1.4rem;
    font-weight: 700;
    color: #0d6efd;
  }

  /* Navigation link */
  #header .navmenu a {
    color: #000 !important; /* ✅ Màu đen cho Home */
    font-size: 1rem;
    font-weight: 500;
    transition: 0.3s;
  }

  #header .navmenu a:hover,
  #header .navmenu a.active {
    color: #0d6efd !important; /* Xanh khi hover/active */
    text-decoration: underline;
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
