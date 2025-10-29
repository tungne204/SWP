<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm bài viết mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h3 class="mb-4 fw-bold">📝 Thêm bài viết mới</h3>

    <form action="news" method="post">
        <input type="hidden" name="action" value="insert">

        <div class="mb-3">
            <label>Tiêu đề</label>
            <input name="title" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Phụ đề</label>
            <input name="subtitle" class="form-control">
        </div>

        <div class="mb-3">
            <label>Ảnh thumbnail (URL)</label>
            <input name="thumbnail" class="form-control">
        </div>

        <div class="mb-3">
            <label>Nội dung</label>
            <textarea name="content" rows="6" class="form-control"></textarea>
        </div>

        <div class="mb-3">
            <label>ID Danh mục</label>
            <input name="categoryId" type="number" class="form-control" value="1">
        </div>

        <button type="submit" class="btn btn-success">💾 Lưu</button>
        <a href="news?action=list" class="btn btn-secondary">🔙 Hủy</a>
    </form>
</div>
</body>
</html>
