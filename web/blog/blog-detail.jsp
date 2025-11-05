<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${blog.title} - Phòng khám Nhi</title>

    <!-- Dùng head-includes chung như Home -->
    <jsp:include page="../includes/head-includes.jsp"/>

    <!-- (tuỳ chọn) FontAwesome nếu chưa có trong head-includes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

    <style>
        /* ===== Scope RIÊNG cho trang Blog Detail ===== */
        .tr-blogd {
            --sidebar-width: 280px;
            --header-height: 80px;
            --bg: #f5f6fa;
            margin: 0;
            background: var(--bg);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Chừa khoảng cho header fixed (Home dùng padding-top: 80px) */
        .tr-blogd .main {
            padding-top: var(--header-height);
        }

        /* Sidebar giống Home (nền trắng, viền xám, cố định) */
        .tr-blogd .sidebar-container {
            width: var(--sidebar-width);
            background: #ffffff;
            border-right: 1px solid #dee2e6;
            position: fixed;
            top: var(--header-height);
            left: 0;
            height: calc(100vh - var(--header-height));
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        }

        /* Nội dung chính */
        .tr-blogd .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 20px;
            min-height: calc(100vh - var(--header-height));
            padding-bottom: 100px;
        }

        /* Card bọc nội dung để không đụng .container Bootstrap */
        .tr-blogd .tr-cardwrap {
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .tr-blogd h1 {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 20px;
        }

        /* ===== BLOG STYLE ===== */
        .tr-blogd .blog-header-img {
            width: 100%;
            max-height: 500px;
            object-fit: cover;
            border-radius: 10px;
        }

        .tr-blogd .blog-content {
            font-size: 1.06rem;
            line-height: 1.8;
            text-align: justify;
        }

        .tr-blogd .blog-meta {
            border-left: 4px solid #0d6efd;
            padding-left: 20px;
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .tr-blogd .share-buttons a {
            margin: 0 5px 5px 0;
        }

        .tr-blogd .related-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
            margin-top: 30px;
        }

        .tr-blogd .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        /* Responsive: ẩn sidebar, bỏ margin-left giống Home */
        @media (max-width: 991px) {
            .tr-blogd .sidebar-container { display: none; }
            .tr-blogd .main-content { margin-left: 0; }
        }
    </style>
</head>
<body class="tr-blogd">
    <!-- Header dùng chung (đã fixed trong header.jsp) -->
    <jsp:include page="../includes/header.jsp" />

    <main class="main">
        <%-- Khối layout theo vai trò, GIỐNG Home: mỗi vai trò mở 1 container-fluid riêng --%>

        <% if (acc != null && acc.getRoleId() == 5) { %>
        <div class="container-fluid p-0">
            <div class="row g-0">
                <div class="sidebar-container">
                    <jsp:include page="../includes/sidebar-receptionist.jsp" />
                </div>
                <div class="main-content">
                    <% } %>

                    <% if (acc != null && acc.getRoleId() == 2) { %>
                    <div class="container-fluid p-0">
                        <div class="row g-0">
                            <div class="sidebar-container">
                                <jsp:include page="../includes/sidebar-doctor.jsp" />
                            </div>
                            <div class="main-content">
                                <% } %>

                                <% if (acc != null && acc.getRoleId() == 4) { %>
                                <div class="container-fluid p-0">
                                    <div class="row g-0">
                                        <div class="sidebar-container">
                                            <jsp:include page="../includes/sidebar-medicalassistant.jsp" />
                                        </div>
                                        <div class="main-content">
                                            <% } %>

                                            <% if (acc != null && acc.getRoleId() == 1) { %>
                                            <div class="container-fluid p-0">
                                                <div class="row g-0">
                                                    <div class="sidebar-container">
                                                        <jsp:include page="../includes/sidebar-admin.jsp" />
                                                    </div>
                                                    <div class="main-content">
                                                        <% } %>

                                                        <!-- ======= NỘI DUNG CHI TIẾT BLOG ======= -->
                                                        <div class="tr-cardwrap">

                                                            <!-- Back Button -->
                                                            <div class="mb-4">
                                                                <a href="blog?action=list" class="btn btn-outline-primary">
                                                                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                                                                </a>
                                                            </div>

                                                            <!-- Title -->
                                                            <h1>${blog.title}</h1>

                                                            <!-- Meta -->
                                                            <div class="blog-meta">
                                                                <div class="row">
                                                                    <div class="col-md-6">
                                                                        <p class="mb-2">
                                                                            <i class="fas fa-user text-primary"></i>
                                                                            <strong>Tác giả:</strong> ${blog.authorName}
                                                                        </p>
                                                                        <p class="mb-0">
                                                                            <i class="fas fa-calendar text-primary"></i>
                                                                            <strong>Ngày đăng:</strong>
                                                                            <fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                                        </p>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <p class="mb-2">
                                                                            <i class="fas fa-folder text-primary"></i>
                                                                            <strong>Danh mục:</strong> ${blog.category}
                                                                        </p>
                                                                        <p class="mb-0">
                                                                            <i class="fas fa-eye text-primary"></i>
                                                                            <strong>Lượt xem:</strong> ${blog.views}
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                                <c:if test="${not empty blog.updatedDate}">
                                                                    <p class="mt-2 mb-0 text-muted">
                                                                        <i class="fas fa-edit"></i>
                                                                        <em>Cập nhật lần cuối:
                                                                            <fmt:formatDate value="${blog.updatedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                                        </em>
                                                                    </p>
                                                                </c:if>
                                                            </div>

                                                            <!-- Thumbnail -->
                                                            <c:if test="${not empty blog.thumbnail}">
                                                                <div class="mb-4 text-center">
                                                                    <img src="${blog.thumbnail}" class="blog-header-img" alt="${blog.title}" loading="lazy">
                                                                </div>
                                                            </c:if>

                                                            <!-- Content -->
                                                            <div class="blog-content mb-4">
                                                                ${blog.content}
                                                            </div>

                                                            <!-- Actions (author hoặc lễ tân) -->
                                                            <c:if test="${acc != null && (acc.roleId == 5 || acc.userId == blog.authorId)}">
                                                                <div class="mb-4">
                                                                    <a href="blog?action=edit&id=${blog.blogId}" class="btn btn-warning">
                                                                        <i class="fas fa-edit"></i> Chỉnh sửa
                                                                    </a>
                                                                    <a href="blog?action=delete&id=${blog.blogId}"
                                                                       class="btn btn-danger"
                                                                       onclick="return confirm('Bạn có chắc muốn xóa bài viết này?')">
                                                                        <i class="fas fa-trash"></i> Xóa
                                                                    </a>
                                                                </div>
                                                            </c:if>

                                                            <!-- Share Buttons (FIXED) -->
<div class="card mb-4">
  <div class="card-body">
    <h5 class="card-title">
      <i class="fas fa-share-alt"></i> Chia sẻ bài viết
    </h5>

    <%-- Xây URL tuyệt đối an toàn từ requestURL + queryString --%>
    <c:set var="absUrl" value="${pageContext.request.requestURL}" />
    <c:if test="${not empty pageContext.request.queryString}">
      <c:set var="absUrl" value="${absUrl}?${pageContext.request.queryString}" />
    </c:if>

    <div class="share-buttons d-flex flex-wrap">
      <a href="https://www.facebook.com/sharer/sharer.php?u=${absUrl}"
         target="_blank" class="btn btn-primary me-2 mb-2">
        <i class="fab fa-facebook"></i> Facebook
      </a>
      <a href="https://twitter.com/intent/tweet?url=${absUrl}&text=${blog.title}"
         target="_blank" class="btn btn-info text-white me-2 mb-2">
        <i class="fab fa-twitter"></i> Twitter
      </a>
      <a href="mailto:?subject=${blog.title}&body=Xem bài viết tại: ${absUrl}"
         class="btn btn-secondary mb-2">
        <i class="fas fa-envelope"></i> Email
      </a>
    </div>
  </div>
</div>


                                                            <!-- Related -->
                                                            <div class="related-section">
                                                                <h4 class="mb-3"><i class="fas fa-newspaper"></i> Bài viết liên quan</h4>
                                                                <div class="alert alert-info mb-0">
                                                                    <a href="blog?action=category&cat=${blog.category}" class="alert-link">
                                                                        Xem thêm bài viết trong danh mục "${blog.category}"
                                                                        <i class="fas fa-arrow-right"></i>
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!-- ======= /NỘI DUNG CHI TIẾT BLOG ======= -->

                                                    <%-- Đóng layout theo vai trò giống Home --%>
                                                    <% if (acc != null && acc.getRoleId() == 1) { %>
                                                    </div></div></div>
                                                    <% } %>

                                                    <% if (acc != null && acc.getRoleId() == 4) { %>
                                                    </div></div></div>
                                                    <% } %>

                                                    <% if (acc != null && acc.getRoleId() == 2) { %>
                                                    </div></div>
                                                    <% } %>

                                                    <% if (acc != null && acc.getRoleId() == 5) { %>
                                                    </div></div>
                                                    <% } %>
    </main>

    <!-- JS bundle (nếu chưa có trong head-includes) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
</body>
</html>
