<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Medilab</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <jsp:include page="includes/head-includes.jsp"/>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .forgot-container {
            max-width: 400px;
            margin: 80px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-align: center;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #0d6efd;
        }
        .btn-primary {
            background-color: #0d6efd;
            border: none;
        }
        .back-link {
            margin-top: 15px;
            display: inline-block;
            text-decoration: none;
            color: #0d6efd;
        }
        .back-link i {
            margin-right: 5px;
        }
    </style>
</head>
<body>
<jsp:include page="includes/header.jsp"/>
<div class="forgot-container">
    <h4 class="mb-2">Quên mật khẩu</h4>
    <p class="text-muted">Nhập gmail để lấy lại mật khẩu </p>

    <form action="Forgot_password" method="post">
        <!-- Email -->
        <div class="mb-3 text-start">
            <label for="email" class="form-label">Địa chỉ email</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your Gmail address" required>
            </div>
        </div>

        <!-- Submit -->
        <div class="d-grid mb-3">
            <button type="submit" class="btn btn-primary">Reset mật khẩu</button>
        </div>

        <!-- Back to login -->
        <a href="Login" class="back-link"><i class="bi bi-arrow-left"></i> Trở lại trang đăng nhập</a>
    </form>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger mt-3">
        <%= request.getAttribute("error") %>
    </div>
<% } %>

<% if (request.getAttribute("message") != null) { %>
    <div class="alert alert-success mt-3">
        <%= request.getAttribute("message") %>
    </div>
<% } %>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
