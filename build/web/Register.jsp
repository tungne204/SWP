<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Medilab</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <jsp:include page="includes/head-includes.jsp"/>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .register-container {
            max-width: 420px;
            margin: 50px auto;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .register-header {
            background: #0d6efd;
            color: #fff;
            text-align: center;
            padding: 25px;
        }
        .register-header h3 {
            margin: 0;
        }
        .register-form {
            padding: 30px;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #0d6efd;
        }
        .toggle-password {
            cursor: pointer;
        }
    </style>
</head>
<body>
<jsp:include page="includes/header.jsp"/>
<div class="register-container">
    <!-- Header -->
    <div class="register-header">
        <h3>Tạo tài khoản</h3>
        <p class="mb-0">Tham gia ngay hôm nay</p>
    </div>

    <!-- Form -->
    <div class="register-form">
        <!-- Hiển thị thông báo lỗi/thành công -->
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger text-center"><%= error %></div>
        <% } %>

        <% String success = (String) request.getAttribute("successMessage"); %>
        <% if (success != null) { %>
            <div class="alert alert-success text-center"><%= success %></div>
        <% } %>

        <form action="Register" method="post" id="registerForm">
            <!-- Full Name -->
            <div class="mb-3">
                <label class="form-label">Họ và tên</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" name="fullname" class="form-control" placeholder="Nhập họ và tên" required>
                </div>
            </div>

            <!-- Email -->
            <div class="mb-3">
                <label class="form-label">Email</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="Nhập email" required>
                </div>
            </div>

            <!-- Phone -->
            <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-phone"></i></span>
                    <input type="tel" name="phone" class="form-control"
                           placeholder="Enter your phone (10 digits)"
                           pattern="\d{10}" title="Số điện thoại phải có 10 số" required>
                </div>
            </div>

            <!-- Password -->
            <div class="mb-3">
                <label class="form-label">Mât khẩu</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" 
                           name="password" 
                           class="form-control" 
                           id="password" 
                           placeholder="Nhập mật khẩu của bạn (tối thiểu 6 ký tự)" 
                           minlength="6" 
                           required>
                    <span class="input-group-text toggle-password" onclick="togglePassword('password')">
                        <i class="bi bi-eye"></i>
                    </span>
                </div>
                <small class="text-muted">Mật khẩu phải có ít nhất 6 ký tự </small>
            </div>

            <!-- Confirm Password -->
            <div class="mb-3">
                <label class="form-label">Xác nhận mật khẩu</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" 
                           name="confirmPassword" 
                           class="form-control" 
                           id="confirmPassword" 
                           placeholder="Xác nhận mật khẩu" 
                           minlength="6" 
                           required>
                    <span class="input-group-text toggle-password" onclick="togglePassword('confirmPassword')">
                        <i class="bi bi-eye"></i>
                    </span>
                </div>
            </div>

            <!-- Submit -->
            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-primary">Đăng ký</button>
            </div>

            <!-- Login Link -->
            <p class="text-center">Đã có tài khoản?
                <a href="Login">Đăng nhập</a>
            </p>
        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function togglePassword(id) {
        const input = document.getElementById(id);
        const type = input.getAttribute("type") === "password" ? "text" : "password";
        input.setAttribute("type", type);
    }

    // Form validation for password length
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        // Validate password length
        if (password.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters long!');
            return false;
        }

        // Validate password match
        if (password !== confirmPassword) {
            e.preventDefault();
            alert('Passwords do not match!');
            return false;
        }
    });
</script>
</body>
</html>
