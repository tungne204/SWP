<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,entity.News" %>
<%
    // Danh sách tin tức được servlet gửi sang
    List<News> list = (List<News>) request.getAttribute("newsList");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tin tức - Medilab</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- ✅ Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- ✅ Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
        }
        .news-card {
            transition: all 0.25s ease-in-out;
        }
        .news-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .news-img {
            width: 100%;
            height: 220px;
            object-fit: cover;
        }
        .section-title {
            font-weight: 700;
            color: #f4623a;
            border-left: 5px solid #f4623a;
            padding-left: 12px;
        }
        .category-tag {
            font-size: 13px;
            background-color: #f4623a;
            color: white;
            padding: 3px 8px;
            border-radius: 5px;
        }
        .read-more {
            color: #f4623a;
            text-decoration: none;
        }
        .read-more:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

<!-- Header -->
<header class="py-4 text-center bg-white shadow-sm mb-5">
    <h1 class="fw-bold text-uppercase" style="color:#f4623a;">Tin tức Medilab</h1>
    <p class="text-muted mb-0">Cập nhật tin tức và xu hướng y học mới nhất</p>
</header>

<!-- Content -->
<div class="container mb-5">
    <% if (list == null || list.isEmpty()) { %>
        <div class="alert alert-warning text-center">Hiện chưa có bài viết nào!</div>
    <% } else { %>
        <div class="row g-4">
            <% for (News n : list) { %>
                <div class="col-lg-4 col-md-6">
                    <div class="card news-card border-0 shadow-sm h-100">
                        <img src="<%= n.getThumbnail() %>" alt="Ảnh tin" class="news-img card-img-top">
                        <div class="card-body">
                            <h5 class="card-title fw-bold"><%= n.getTitle() %></h5>
                            <% if (n.getSubtitle() != null && !n.getSubtitle().isEmpty()) { %>
                                <p class="text-muted small mb-3"><%= n.getSubtitle() %></p>
                            <% } %>
                            <span class="category-tag">Sức khỏe</span>
                            <p class="mt-3 small text-muted">
                                🕓 <%= n.getCreatedDate() != null ? n.getCreatedDate().toString().substring(0, 16) : "" %>
                            </p>
                            <a href="newsdetail?id=<%= n.getNewsId() %>" class="read-more fw-semibold">Đọc thêm →</a>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<!-- Footer -->
<footer class="text-center py-4 mt-5 border-top bg-white">
    <p class="text-muted mb-0">© 2025 Medilab - All rights reserved.</p>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
