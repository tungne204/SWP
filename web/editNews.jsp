<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="entity.News" %>
<%
    News news = (News) request.getAttribute("news");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa bài viết</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h3 class="mb-4 fw-bold">✏ Sửa bài viết</h3>

    <form action="news" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="newsId" value="<%= news.getNewsId() %>">

        <div class="mb-3">
            <label>Tiêu đề</label>
            <input name="title" class="form-control" value="<%= news.getTitle() %>">
        </div>

        <div class="mb-3">
            <label>Phụ đề</label>
            <input name="subtitle" class="form-control" value="<%= news.getSubtitle() %>">
        </div>

        <div class="mb-3">
            <label>Ảnh thumbnail (URL)</label>
            <input name="thumbnail" class="form-control" value="<%= news.getThumbnail() %>">
        </div>

        <div class="mb-3">
            <label>Nội dung</label>
            <textarea name="content" rows="6" class="form-control"><%= news.getContent() %></textarea>
        </div>

        <div class="mb-3">
            <label>ID Danh mục</label>
            <input name="categoryId" type="number" class="form-control" value="<%= news.getCategoryId() %>">
        </div>

        <button type="submit" class="btn btn-warning">💾 Cập nhật</button>
        <a href="news?action=list" class="btn btn-secondary">🔙 Quay lại</a>
    </form>
</div>
</body>
</html>
