<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Medilab</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-container {
            max-width: 400px;
            margin: 80px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .btn-google {
            border: 1px solid #ddd;
            background: #fff;
        }
        .btn-google img {
            width: 18px;
            margin-right: 8px;
        }
        .divider {
            text-align: center;
            margin: 10px 0;
            color: #aaa;
        }
        .divider {
    display: flex;
    align-items: center;
    text-align: center;
    margin: 20px 0;
    color: #6c757d; /* màu xám Bootstrap */
    font-size: 0.9rem;
}
.divider::before,
.divider::after {
    content: "";
    flex: 1;
    border-bottom: 1px solid #dee2e6;
}
.divider:not(:empty)::before {
    margin-right: 10px;
}
.divider:not(:empty)::after {
    margin-left: 10px;
}

        
    </style>
</head>
<body>

<div class="login-container">
    <h3 class="text-center mb-2">Welcome Back</h3>
    <p class="text-center text-muted">Sign in to continue to your account</p>
<!-- Hiển thị thông báo lỗi/thành công -->
<% String error = (String) request.getAttribute("error"); %>
<% if (error != null) { %>
    <div class="alert alert-danger text-center"><%= error %></div>
<% } %>

<% String success = (String) request.getAttribute("successMessage"); %>
<% if (success != null) { %>
    <div class="alert alert-success text-center"><%= success %></div>
<% } %>

    <form action="login" method="post">
        <!-- Email -->
        <div class="mb-3">
            <label for="email" class="form-label">Email Address</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
            </div>
        </div>

        <!-- Password -->
        <div class="mb-2">
            <label for="password" class="form-label">Password</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
            </div>
        </div>

        <div class="d-flex justify-content-end mb-3">
            <a href="Forgot_password.jsp" class="text-decoration-none">Forgot password?</a>
        </div>

        <!-- Sign In button -->
        <div class="d-grid">
            <button type="submit" class="btn btn-primary">Sign In</button>
        </div>

        <!-- Divider -->
        <div class="divider">Or continue with</div>

        <!-- Google login -->
        <div class="d-grid mb-3">
            <button type="button" class="btn btn-google">
                <img src="https://www.svgrepo.com/show/475656/google-color.svg" alt="Google"> Google
            </button>
        </div>

        <!-- Sign Up -->
        <p class="text-center">Don't have an account? <a href="Register.jsp">Sign up</a></p>
        <p class="text-center">Go back to home page <a href="Home.jsp">HOME</a></p>
    </form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
</body>
</html>
