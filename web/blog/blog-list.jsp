<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách Blog - Phòng khám Nhi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .blog-card {
                transition: transform 0.3s, box-shadow 0.3s;
                height: 100%;
            }
            .blog-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            }
            .blog-thumbnail {
                height: 200px;
                object-fit: cover;
                width: 100%;
            }
            .blog-excerpt {
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
            }
            .category-badge {
                position: absolute;
                top: 10px;
                right: 10px;
                z-index: 1;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <div class="row mb-4">
                <div class="col-md-12">
                    <h1 class="text-center text-primary">
                        <i class="fas fa-blog"></i> Blog Y tế Nhi
                    </h1>
                    <p class="text-center text-muted">Chia sẻ kiến thức chăm sóc sức khỏe trẻ em</p>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="row mb-4">
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
                            <option value="${cat}" ${selectedCategory eq cat ? 'selected' : ''}>
                                ${cat}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <c:if test="${sessionScope.acc.roleId == 1 || sessionScope.acc.roleId == 2}"><div class="col-md-2">

                        <a href="blog?action=add" class="btn btn-success w-100">
                            <i class="fas fa-plus"></i> Thêm mới
                        </a>

                    </div></c:if>>


                </div>

                <!-- Alert Messages -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Blog Cards -->
            <div class="row">
                <c:forEach var="blog" items="${blogs}">
                    <div class="col-md-4 mb-4">
                        <div class="card blog-card">
                            <div class="position-relative">
                                <c:choose>
                                    <c:when test="${not empty blog.thumbnail}">
                                        <img src="${blog.thumbnail}" class="card-img-top blog-thumbnail" 
                                             alt="${blog.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://via.placeholder.com/400x200?text=No+Image" 
                                             class="card-img-top blog-thumbnail" alt="No Image">
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
                                        <small class="text-muted">
                                            <i class="fas fa-user"></i> ${blog.authorName}
                                        </small>
                                        <small class="text-muted">
                                            <i class="fas fa-eye"></i> ${blog.views}
                                        </small>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">
                                            <fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy"/>
                                        </small>
                                        <div>
                                            <a href="blog?action=view&id=${blog.blogId}" 
                                               class="btn btn-sm btn-primary">
                                                <i class="fas fa-eye"></i> Xem
                                            </a>
                                            <c:if test="${sessionScope.acc.roleId == 1 || sessionScope.acc.userId == blog.authorId}">

                                                <a href="blog?action=edit&id=${blog.blogId}" 
                                                   class="btn btn-sm btn-warning">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="blog?action=delete&id=${blog.blogId}" 
                                                   class="btn btn-sm btn-danger"
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

            <!-- Empty State -->
            <c:if test="${empty blogs}">
                <div class="text-center py-5">
                    <i class="fas fa-inbox fa-5x text-muted mb-3"></i>
                    <h4 class="text-muted">Không tìm thấy bài viết nào</h4>
                </div>
            </c:if>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="blog?action=list&page=${currentPage - 1}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="blog?action=list&page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="blog?action=list&page=${currentPage + 1}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                       function filterByCategory(category) {
                                                           if (category) {
                                                               window.location.href = 'blog?action=category&cat=' + encodeURIComponent(category);
                                                           } else {
                                                               window.location.href = 'blog?action=list';
                                                           }
                                                       }
        </script>
    </body>
</html>