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
    <title>Danh sách Blog - Phòng khám Nhi</title>

    <%-- Dùng head-includes chung như Home --%>
    <jsp:include page="../includes/head-includes.jsp"/>

    <%-- (tuỳ chọn) FontAwesome nếu chưa có trong head-includes --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

    <style>
        /* ===== Scope RIÊNG cho trang Blog ===== */
        .tr-blog {
            --sidebar-width: 280px;
            --header-height: 80px;
            --bg: #f5f6fa;
            margin: 0;
            background: var(--bg);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Chừa khoảng cho header fixed (như Home: padding-top: 80px) */
        .tr-blog .main {
            padding-top: var(--header-height);
        }

        /* Sidebar giống Home */
        .tr-blog .sidebar-container {
            width: var(--sidebar-width);
            background: #ffffff;                 /* như Home */
            border-right: 1px solid #dee2e6;     /* như Home */
            position: fixed;
            top: var(--header-height);
            left: 0;
            height: calc(100vh - var(--header-height));
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1); /* như Home */
        }

        /* Khu vực nội dung giống Home */
        .tr-blog .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 20px;
            min-height: calc(100vh - var(--header-height));
            padding-bottom: 100px;
        }

        /* Card bọc nội dung (không đụng .container của Bootstrap) */
        .tr-blog .tr-cardwrap {
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .tr-blog h1 {
            color: #2c3e50;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Blog card */
        .tr-blog .blog-card {
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
            border: 1px solid #eee;
            border-radius: 10px;
            overflow: hidden;
        }
        .tr-blog .blog-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }

        .tr-blog .blog-thumbnail {
            height: 200px;
            object-fit: cover;
            width: 100%;
            background-color: #f0f0f0;
            transition: opacity 0.3s ease-in-out;
            opacity: 0;
        }
        .tr-blog .blog-thumbnail.loaded { opacity: 1; }

        .tr-blog .category-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 1;
        }

        .tr-blog .blog-excerpt {
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }

        .tr-blog .btn-sm { padding: 6px 12px; font-size: 13px; }

        /* Phân trang */
        .tr-blog .pagination {
            display: flex; gap: 6px; flex-wrap: wrap; margin-top: 20px;
        }
        .tr-blog .pagination a, .tr-blog .pagination span {
            padding: 8px 14px; border-radius: 5px; text-decoration: none; font-weight: 500;
        }
        .tr-blog .pagination a:hover { background-color: #dfe6e9; }
        .tr-blog .active-page { background: #3498db; color: #fff; }

        /* Responsive: ẩn sidebar, bỏ margin-left như Home */
        @media (max-width: 991px) {
            .tr-blog .sidebar-container { display: none; }
            .tr-blog .main-content { margin-left: 0; }
        }
    </style>
</head>

<body class="tr-blog">
    <!-- Header dùng chung (đã fixed trong header.jsp) -->
    <jsp:include page="../includes/header.jsp"/>

    <main class="main">
        <%-- Khối layout theo vai trò, giống Home: mỗi vai trò mở một container-fluid riêng --%>

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

                                                        <!-- ======= NỘI DUNG BLOG ======= -->
                                                        <div class="tr-cardwrap">
                                                            <h1><i class="fas fa-blog"></i> Danh sách Blog</h1>

                                                            <!-- Search + Filter -->
                                                            <div class="row g-2 mb-4">
                                                                <div class="col-md-6">
                                                                    <form action="blog" method="get" class="d-flex">
                                                                        <input type="hidden" name="action" value="search">
                                                                        <input type="text" name="keyword" class="form-control me-2"
                                                                               placeholder="Tìm kiếm bài viết..." value="${keyword}">
                                                                        <button type="submit" class="btn btn-primary">
                                                                            <i class="fas fa-search"></i>
                                                                        </button>
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
                                                                <c:if test="${acc != null && acc.roleId == 5}">
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
                                                                        <div class="card blog-card h-100">
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
                                                                                        <div class="d-flex gap-2">
                                                                                            <a href="blog?action=view&id=${blog.blogId}" class="btn btn-sm btn-primary">
                                                                                                <i class="fas fa-eye"></i> Xem
                                                                                            </a>
                                                                                            <c:if test="${acc != null && (acc.roleId == 5 || acc.userId == blog.authorId)}">
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

                                                            <!-- Pagination: giữ keyword & category nếu có -->
                                                            <c:if test="${totalPages > 1}">
                                                                <div class="pagination">
                                                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                                                        <c:choose>
                                                                            <c:when test="${i == currentPage}">
                                                                                <span class="active-page">${i}</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:url var="pageUrl" value="blog">
                                                                                    <c:param name="action" value="${empty selectedCategory ? (empty keyword ? 'list' : 'search') : 'category'}"/>
                                                                                    <c:param name="page" value="${i}"/>
                                                                                    <c:if test="${not empty keyword}">
                                                                                        <c:param name="keyword" value="${keyword}"/>
                                                                                    </c:if>
                                                                                    <c:if test="${not empty selectedCategory}">
                                                                                        <c:param name="cat" value="${selectedCategory}"/>
                                                                                    </c:if>
                                                                                </c:url>
                                                                                <a href="${pageUrl}">${i}</a>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        <!-- ======= /NỘI DUNG BLOG ======= -->

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

    <!-- Giữ script lazy-load ảnh -->
    <script>
        function filterByCategory(category) {
            const base = '${pageContext.request.contextPath}/blog';
            const url = new URL(base, window.location.origin);
            if (category) {
                url.searchParams.set('action', 'category');
                url.searchParams.set('cat', category);
            } else {
                url.searchParams.set('action', 'list');
            }
            window.location.href = url.toString();
        }

        document.addEventListener("DOMContentLoaded", () => {
            document.querySelectorAll(".blog-thumbnail").forEach(img => {
                if (img.complete) img.classList.add("loaded");
                else img.addEventListener("load", () => img.classList.add("loaded"));
            });
        });
    </script>

    <%-- Giữ bundle JS chuẩn (nếu chưa có trong head-includes) --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
</body>
</html>
