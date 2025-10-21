<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card p-4 shadow" style="max-width:400px; margin:auto;">
        <h4 class="mb-3">Reset Password</h4>
        <form action="ResetPasswordServlet" method="post">
            <input type="hidden" name="token" value="${token}">
            <div class="mb-3">
                <label>Mật khẩu mới</label>
                <input type="password" name="newPassword" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Xác nhận mật khẩu</label>
                <input type="password" name="confirmPassword" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Đổi mật khẩu</button>
        </form>
        <c:if test="${not empty error}">
            <div class="alert alert-danger mt-2">${error}</div>
        </c:if>
    </div>
</div>
</body>
</html>
