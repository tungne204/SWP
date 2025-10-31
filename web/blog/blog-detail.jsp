<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${blog.title} - Phòng khám Nhi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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
    </style>
</head>
<body>
    <div class="container mt-5 mb-5">
        <!-- Back Button -->
        <div class="mb-4">
            <a href="blog?action=list" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách
            </a>
        </div>

        <!-- Blog Header -->
        <div class="row">
            <div class="col-lg-10 offset-lg-1">
                <article>
                    <h1 class="mb-4">${blog.title}</h1>
                    
                    <!-- Blog Meta Information -->
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
                        <div class="mb-4">
                            <img src="${blog.thumbnail}" class="blog-header-img" alt="${blog.title}">
                        </div>
                    </c:if>

                    <!-- Blog Content -->
                    <div class="blog-content mb-5">
                        ${blog.content}
                    </div>

                    <!-- Action Buttons -->
                    <c:if test="${sessionScope.roleId == 1 || sessionScope.userId == blog.authorId}">
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
                    <div class="card">
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
                                   target="_blank" class="btn btn-info">
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
            </div>
        </div>

        <!-- Related Posts Section (Optional) -->
        <div class="row mt-5">
            <div class="col-lg-10 offset-lg-1">
                <h3 class="mb-4">
                    <i class="fas fa-newspaper"></i> Bài viết liên quan
                </h3>
                <div class="alert alert-info">
                    <a href="blog?action=category&cat=${blog.category}" class="alert-link">
                        Xem thêm bài viết trong danh mục "${blog.category}" 
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>