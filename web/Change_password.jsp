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
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header text-center">
                    <h3>🔑 Change Password</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/Change_password" method="post">

                        <div class="mb-3">
                            <label for="oldPassword" class="form-label">Current Password</label>
                            <input type="password" name="oldPassword" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <input type="password" name="newPassword" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm New Password</label>
                            <input type="password" name="confirmPassword" class="form-control" required>
                        </div>
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                        <% } %>
                        <% if (request.getAttribute("success") != null) { %>
                            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
                        <% } %>
                        <button type="submit" class="btn btn-primary w-100">Update Password</button>
                        <a href="${pageContext.request.contextPath}/" class="back-link"><i class="bi bi-arrow-left"></i> Back to Home</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
s