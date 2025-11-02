<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${blog.title} - Phòng khám Nhi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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

            /* ===== LAYOUT ===== */
            .main-layout {
                display: flex;
                min-height: calc(100vh - 70px);
            }

            .sidebar {
                width: 250px;
                background-color: #2c3e50;
                color: white;
                position: sticky;
                top: 70px;
                min-height: calc(100vh - 70px);
                overflow-y: auto;  /* 🔹 Thanh cuộn riêng */
                overflow-x: hidden;
                scrollbar-width: thin;
                scrollbar-color: #888 #2c3e50;
            }
            .sidebar::-webkit-scrollbar {
                width: 6px;
            }
            .sidebar::-webkit-scrollbar-thumb {
                background-color: #888;
                border-radius: 3px;
            }
            .sidebar::-webkit-scrollbar-thumb:hover {
                background-color: #aaa;
            }
            .sidebar::-webkit-scrollbar-track {
                background-color: #2c3e50;
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

            /* ===== BLOG STYLE ===== */
            .blog-header-img {
                width: 100%;
                max-height: 500px;
                object-fit: cover;
                border-radius: 10px;
            }

            .blog-content {
                font-size: 1.1rem;
                line-height: 1.8;
                text-align: justify;
            }

            .blog-meta {
                border-left: 4px solid #0d6efd;
                padding-left: 20px;
                background-color: #f8f9fa;
                padding: 15px 20px;
                border-radius: 5px;
            }

            .share-buttons a {
                margin: 0 5px;
            }

            .related-section {
                background: #f8f9fa;
                padding: 25px;
                border-radius: 8px;
                margin-top: 40px;
            }

            h1 {
                color: #2c3e50;
                font-weight: 600;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }
        </style>
    </head>
    <body>

        <!-- HEADER -->
        <jsp:include page="../includes/header.jsp" />

        <div class="main-layout">

            <!-- SIDEBAR -->
            <% 
        if (acc != null) {
            if (acc.getRoleId() == 1) { 
            %>
            <jsp:include page="../includes/sidebar-admin.jsp" />
            <% 
                    } else if (acc.getRoleId() == 2) { 
            %>
            <jsp:include page="../includes/sidebar-doctor.jsp" />
            <% 
                    } else if (acc.getRoleId() == 4) { 
            %>
            <jsp:include page="../includes/sidebar-medicalassistant.jsp" />
            <%
                    } else if (acc.getRoleId() == 5) {
            %>
            <jsp:include page="../includes/sidebar-receptionist.jsp" />
            <%
                    }
                }
            %>


            <!-- MAIN CONTENT -->
            <div class="main-content">
                <div class="container">

                    <!-- Back Button -->
                    <div class="mb-4">
                        <a href="blog?action=list" class="btn btn-outline-primary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>

                    <!-- Blog Header -->
                    <article>
                        <h1 class="mb-4">${blog.title}</h1>

                        <!-- Blog Meta -->
                        <div class="blog-meta mb-4">
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
                                <img src="${blog.thumbnail}" class="blog-header-img" alt="${blog.title}">
                            </div>
                        </c:if>

                        <!-- Blog Content -->
                        <div class="blog-content mb-5">
                            ${blog.content}
                        </div>

                        <!-- Action Buttons -->
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

                        <!-- Share Buttons -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <i class="fas fa-share-alt"></i> Chia sẻ bài viết
                                </h5>
                                <div class="share-buttons">
                                    <a href="https://www.facebook.com/sharer/sharer.php?u=${pageContext.request.requestURL}"
                                       target="_blank" class="btn btn-primary">
                                        <i class="fab fa-facebook"></i> Facebook
                                    </a>
                                    <a href="https://twitter.com/intent/tweet?url=${pageContext.request.requestURL}&text=${blog.title}"
                                       target="_blank" class="btn btn-info text-white">
                                        <i class="fab fa-twitter"></i> Twitter
                                    </a>
                                    <a href="mailto:?subject=${blog.title}&body=Xem bài viết tại: ${pageContext.request.requestURL}"
                                       class="btn btn-secondary">
                                        <i class="fas fa-envelope"></i> Email
                                    </a>
                                </div>
                            </div>
                        </div>
                    </article>

                    <!-- Related Posts Section -->
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
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
