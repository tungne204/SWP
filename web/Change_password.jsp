<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
    if (acc == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap/bootstrap.min.css" rel="stylesheet">
    <jsp:include page="includes/head-includes.jsp"/>
</head>

<body class="bg-light">
    <jsp:include page="includes/header.jsp"/>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header text-center">
                    <h3>Đổi mật khẩu</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/Change_password" method="post">

                        <div class="mb-3">
                            <label for="oldPassword" class="form-label">Mật khẩu hiện tại</label>
                            <input type="password" name="oldPassword" class="form-control" value="<%= request.getParameter("oldPassword") != null ? request.getParameter("oldPassword") : "" %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">Mật khẩu mới</label>
                            <input type="password" name="newPassword" class="form-control" value="<%= request.getParameter("newPassword") != null ? request.getParameter("newPassword") : "" %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                            <input type="password" name="confirmPassword" class="form-control" value="<%= request.getParameter("confirmPassword") != null ? request.getParameter("confirmPassword") : "" %>" required>
                        </div>
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                        <% } %>
                        <% if (request.getAttribute("success") != null) { %>
                            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
                        <% } %>
                        <button type="submit" class="btn btn-primary w-100">Cập nhật mật khẩu </button>
                        <a href="${pageContext.request.contextPath}/" class="back-link"><i class="bi bi-arrow-left"></i> Trở về trang chủ </a>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
s