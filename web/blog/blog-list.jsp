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
        <title>Danh sách Blog - Phòng khám Nhi</title>
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

            h1 {
                color: #2c3e50;
                margin-bottom: 30px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            /* ===== BLOG CARD GRID ===== */
            .blog-card {
                transition: transform 0.3s, box-shadow 0.3s;
                height: 100%;
                border: 1px solid #eee;
                border-radius: 10px;
                overflow: hidden;
            }
            .blog-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            }

            .blog-thumbnail {
                height: 200px;
                object-fit: cover;
                width: 100%;
                background-color: #f0f0f0;
                transition: opacity 0.3s ease-in-out;
                opacity: 0;
            }
            .blog-thumbnail.loaded {
                opacity: 1;
            }

            .category-badge {
                position: absolute;
                top: 10px;
                right: 10px;
                z-index: 1;
            }

            .blog-excerpt {
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
            }

            .alert-success, .alert-danger {
                margin-bottom: 20px;
            }

            .btn-sm {
                padding: 6px 12px;
                font-size: 13px;
            }

            .pagination a, .pagination span {
                padding: 8px 14px;
                border-radius: 5px;
                text-decoration: none;
                font-weight: 500;
            }
            .pagination a:hover {
                background-color: #dfe6e9;
            }
            .active-page {
                background: #3498db;
                color: white;
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
                    <h1><i class="fas fa-blog"></i> Danh sách Blog</h1>

                    <!-- Search + Filter -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <form action="blog" method="get" class="d-flex">
                                <input type="hidden" name="action" value="search">
                                <input type="text" name="keyword" class="form-control me-2"
                                       placeholder="Tìm kiếm bài viết..." value="${keyword}">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </form>
                        </div>
                        <div class="col-md-4">
                            <select class="form-select" onchange="filterByCategory(this.value)">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat}" ${selectedCategory eq cat ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <c:if test="${acc.roleId == 5}">
                            <div class="col-md-2">
                                <a href="blog?action=add" class="btn btn-success w-100">
                                    <i class="fas fa-plus"></i> Thêm mới
                                </a>
                            </div>
                        </c:if>
                    </div>

                    <!-- Alert -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">${message}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <!-- Blog Cards -->
                    <div class="row">
                        <c:forEach var="blog" items="${blogs}">
                            <div class="col-md-4 mb-4">
                                <div class="card blog-card">
                                    <div class="position-relative">
                                        <c:choose>
                                            <c:when test="${not empty blog.thumbnail}">
                                                <img src="${blog.thumbnail}" class="card-img-top blog-thumbnail" alt="${blog.title}" loading="lazy">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://via.placeholder.com/400x200?text=No+Image"
                                                     class="card-img-top blog-thumbnail loaded" alt="No Image">
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty blog.category}">
                                            <span class="badge bg-primary category-badge">${blog.category}</span>
                                        </c:if>
                                    </div>
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title">${blog.title}</h5>
                                        <p class="card-text blog-excerpt text-muted">${blog.excerpt}</p>
                                        <div class="mt-auto">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <small class="text-muted"><i class="fas fa-user"></i> ${blog.authorName}</small>
                                                <small class="text-muted"><i class="fas fa-eye"></i> ${blog.views}</small>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <small class="text-muted"><fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy"/></small>
                                                <div>
                                                    <a href="blog?action=view&id=${blog.blogId}" class="btn btn-sm btn-primary">
                                                        <i class="fas fa-eye"></i> Xem
                                                    </a>
                                                    <c:if test="${acc.roleId == 5 || acc.userId == blog.authorId}">
                                                        <a href="blog?action=edit&id=${blog.blogId}" class="btn btn-sm btn-warning">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="blog?action=delete&id=${blog.blogId}" class="btn btn-sm btn-danger"
                                                           onclick="return confirm('Bạn có chắc muốn xóa bài viết này?')">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Empty -->
                    <c:if test="${empty blogs}">
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-5x text-muted mb-3"></i>
                            <h4 class="text-muted">Không tìm thấy bài viết nào</h4>
                        </div>
                    </c:if>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="active-page">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="blog?action=list&page=${i}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </c:if>

                </div>
            </div>
        </div>

        <script>
            function filterByCategory(category) {
                if (category) {
                    window.location.href = 'blog?action=category&cat=' + encodeURIComponent(category);
                } else {
                    window.location.href = 'blog?action=list';
                }
            }

            document.addEventListener("DOMContentLoaded", () => {
                document.querySelectorAll(".blog-thumbnail").forEach(img => {
                    img.addEventListener("load", () => {
                        img.classList.add("loaded");
                    });
                });
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    </body>
</html>
