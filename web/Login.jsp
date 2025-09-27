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
            <button type="button" class="btn btn-google" id="google-login-btn">
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

<!-- Google OAuth JavaScript SDK -->
<script src="https://accounts.google.com/gsi/client" async defer></script>

<script>
// Google OAuth configuration
window.onload = function () {
    // Lấy Google Client ID từ server
    fetch('google-config')
        .then(response => response.json())
        .then(data => {
            if (data.configured && data.clientId) {
                google.accounts.id.initialize({
                    client_id: data.clientId,
                    callback: handleCredentialResponse
                });
                
                // Render Google Sign-In button
                google.accounts.id.renderButton(
                    document.getElementById("google-login-btn"),
                    { 
                        theme: "outline", 
                        size: "large",
                        width: "100%",
                        text: "signin_with",
                        shape: "rectangular"
                    }
                );
            } else {
                // Hiển thị thông báo cấu hình chưa hoàn tất
                document.getElementById("google-login-btn").innerHTML = 
                    '<i class="bi bi-exclamation-triangle"></i> Google Login chưa được cấu hình';
                document.getElementById("google-login-btn").disabled = true;
                document.getElementById("google-login-btn").style.opacity = "0.5";
            }
        })
        .catch(error => {
            console.error('Error loading Google config:', error);
            document.getElementById("google-login-btn").innerHTML = 
                '<i class="bi bi-exclamation-triangle"></i> Lỗi cấu hình Google';
            document.getElementById("google-login-btn").disabled = true;
        });
};

// Handle Google OAuth response
function handleCredentialResponse(response) {
    // Decode JWT token
    const responsePayload = decodeJwtResponse(response.credential);
    
    // Send to server for verification and login
    fetch('google-oauth-callback', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            credential: response.credential,
            email: responsePayload.email,
            name: responsePayload.name,
            picture: responsePayload.picture
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Redirect based on user role
            window.location.href = data.redirectUrl;
        } else {
            // Show error message
            showMessage(data.message, 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showMessage('Đăng nhập thất bại. Vui lòng thử lại.', 'error');
    });
}

// Decode JWT response
function decodeJwtResponse(token) {
    var base64Url = token.split('.')[1];
    var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    var jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));
    return JSON.parse(jsonPayload);
}

// Show message function
function showMessage(message, type) {
    const alertClass = type === 'error' ? 'alert-danger' : 'alert-success';
    const messageDiv = document.createElement('div');
    messageDiv.className = `alert ${alertClass} text-center`;
    messageDiv.textContent = message;
    
    // Insert after the form title
    const container = document.querySelector('.login-container');
    const title = container.querySelector('h3');
    title.parentNode.insertBefore(messageDiv, title.nextSibling);
    
    // Remove message after 5 seconds
    setTimeout(() => {
        messageDiv.remove();
    }, 5000);
}
</script>
</body>
</html>
