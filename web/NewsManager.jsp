<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,entity.News" %>
<%
    List<News> list = (List<News>) request.getAttribute("newsList");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý tin tức</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="text-center mb-4 fw-bold">📰 Quản lý tin tức</h2>

    <div class="text-end mb-3">
        <a href="news?action=add" class="btn btn-success">➕ Thêm bài viết</a>
    </div>

    <table class="table table-hover table-bordered align-middle text-center">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Tiêu đề</th>
            <th>Ngày đăng</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <% if (list != null && !list.isEmpty()) {
            for (News n : list) { %>
                <tr>
                    <td><%= n.getNewsId() %></td>
                    <td class="text-start"><%= n.getTitle() %></td>
                    <td><%= n.getCreatedDate() %></td>
                    <td><%= n.isStatus() ? "Hiển thị" : "Ẩn" %></td>
                    <td>
                        <a href="news?action=edit&id=<%=n.getNewsId()%>" class="btn btn-warning btn-sm">✏ Sửa</a>
                        <a href="news?action=delete&id=<%=n.getNewsId()%>" class="btn btn-danger btn-sm"
                           onclick="return confirm('Bạn có chắc muốn xóa bài viết này?');">🗑 Xóa</a>
                    </td>
                </tr>
        <%  } } else { %>
                <tr><td colspan="5">Chưa có bài viết nào.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

</body>
</html>
