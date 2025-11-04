<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Email - Medilab</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .verify-container {
            max-width: 450px;
            margin: 50px auto;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .verify-header {
            background: #0d6efd;
            color: #fff;
            text-align: center;
            padding: 30px;
        }
        .verify-header h3 {
            margin: 0;
        }
        .verify-form {
            padding: 30px;
        }
        .verify-icon {
            font-size: 64px;
            color: #0d6efd;
            margin-bottom: 20px;
        }
        .code-input-group {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin: 20px 0;
        }
        .code-input {
            width: 60px;
            height: 70px;
            text-align: center;
            font-size: 32px;
            font-weight: bold;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .code-input:focus {
            outline: none;
            border-color: #0d6efd;
            box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
        }
        .resend-link {
            color: #0d6efd;
            text-decoration: none;
            cursor: pointer;
        }
        .resend-link:hover {
            text-decoration: underline;
        }
        .success-animation {
            animation: pulse 0.6s ease-in-out;
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
    </style>
</head>
<body>

<div class="verify-container">
    <!-- Header -->
    <div class="verify-header">
        <h3><i class="bi bi-envelope-check"></i> Xác nhận email của bạn</h3>
        <p class="mb-0 mt-2">Chúng tôi đã gửi một mã xác nhận đến email của bạn</p>
    </div>

    <!-- Form -->
    <div class="verify-form text-center">
        <!-- Icon -->
        <div class="verify-icon">
            <i class="bi bi-envelope-check-fill"></i>
        </div>

        <p class="text-muted mb-4">
            Hãy kiểm tra email và nhập mã số gồm 6 số
        </p>

        <!-- Error Message -->
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger mb-3"><%= error %></div>
        <% } %>

        <!-- Success Message -->
        <% String success = (String) request.getAttribute("successMessage"); %>
        <% String verified = (String) request.getAttribute("verified"); %>
        <% if (success != null && "true".equals(verified)) { %>
            <div class="alert alert-success success-animation mb-3">
                <i class="bi bi-check-circle-fill"></i> <%= success %>
            </div>
            <div class="d-grid mb-3">
                <a href="Login" class="btn btn-success btn-lg">
                    <i class="bi bi-arrow-right-circle"></i> Trở về trang đăng nhập
                </a>
            </div>
        <% } else if (success != null) { %>
            <div class="alert alert-success mb-3"><%= success %></div>
        <% } %>

        <!-- Verification Form - Only show if not verified -->
        <% if (verified == null || !verified.equals("true")) { %>
        <form action="VerifyEmail" method="post" id="verifyForm">
            <!-- Code Input -->
            <div class="mb-4">
                <input type="text" 
                       name="verificationCode" 
                       id="verificationCode" 
                       class="form-control form-control-lg text-center" 
                       placeholder="Enter 6-digit code"
                       maxlength="6"
                       pattern="[0-9]{6}"
                       autocomplete="off"
                       required>
                <small class="text-muted d-block mt-2">
                    Nhập code được gủi về email của bạn
                </small>
            </div>

            <!-- Submit Button -->
            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-primary btn-lg">
                    <i class="bi bi-check-circle"></i> Xác nhận email
                </button>
            </div>

           

            <!-- Back to Register -->
            <p class="mb-0">
                <a href="Register" class="text-decoration-none">
                    <i class="bi bi-arrow-left"></i> Trở về trang đăng ký
                </a>
            </p>
        </form>
        <% } %>

        <!-- Info Message -->
        <% if (verified == null || !verified.equals("true")) { %>
        <div class="alert alert-info mt-3 text-start">
            <small>
                <i class="bi bi-info-circle"></i> 
                <strong>Note:</strong> mã xác nhận sẽ hết hạn sau 15 phút
            </small>
        </div>
        <% } %>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-focus on verification code input
    document.addEventListener('DOMContentLoaded', function() {
        const codeInput = document.getElementById('verificationCode');
        if (codeInput) {
            codeInput.focus();
        }
    });

    // Only allow numbers in verification code
    document.getElementById('verificationCode').addEventListener('input', function(e) {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    // Form validation
    const verifyForm = document.getElementById('verifyForm');
    if (verifyForm) {
        verifyForm.addEventListener('submit', function(e) {
            const code = document.getElementById('verificationCode').value;
            if (code.length !== 6) {
                e.preventDefault();
                alert('Please enter a valid 6-digit code');
                return false;
            }
        });
    }


</script>
</body>
</html>

