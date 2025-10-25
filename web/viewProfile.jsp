<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
    if (acc == null) {
        response.sendRedirect("Login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>View Profile - Medilab</title>
    <meta name="description" content="">
    <meta name="keywords" content="">

    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon">
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&family=Poppins:wght@100;200;300;400;500;600;700;800;900&family=Raleway:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    <!-- Vendor CSS Files -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" 
          rel="stylesheet" 
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" 
          crossorigin="anonymous">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="assets/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">

    <!-- Main CSS File -->
    <link href="assets/css/main.css" rel="stylesheet">
    
    <style>
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .profile-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .avatar-container {
            position: relative;
            display: inline-block;
            margin-bottom: 1rem;
        }
        
        .avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #007bff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .avatar-upload-btn {
            position: absolute;
            bottom: 10px;
            right: 10px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .avatar-upload-btn:hover {
            background: #0056b3;
            transform: scale(1.1);
        }
        
        .profile-info {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #333;
            min-width: 120px;
        }
        
        .info-value {
            color: #666;
            flex: 1;
            text-align: right;
        }
        
        .edit-btn {
            background: #007bff;
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .edit-btn:hover {
            background: #0056b3;
            color: white;
            text-decoration: none;
        }
        
        .back-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            margin-right: 1rem;
        }
        
        .back-btn:hover {
            background: #545b62;
            color: white;
            text-decoration: none;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        
        .role-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .edit-input {
            width: 200px;
            margin-left: auto;
            text-align: right;
        }
        
        .info-item {
            position: relative;
        }
        
        .loading {
            display: none;
            color: #007bff;
            font-style: italic;
        }
    </style>
</head>

<body>
    <div class="profile-container">
        <div class="profile-header">
            <div class="avatar-container">
                <img src="<%= acc.getAvatar() != null && !acc.getAvatar().isEmpty() ? acc.getAvatar() : request.getContextPath() + "/assets/img/avata.jpg" %>" 
                     alt="Avatar" class="avatar" id="avatarImg">
                <button class="avatar-upload-btn" onclick="document.getElementById('avatarInput').click()" title="Change Avatar">
                    <i class="bi bi-camera"></i>
                </button>
                <input type="file" id="avatarInput" accept="image/*" style="display: none;" onchange="uploadAvatar(this)">
            </div>
            <h2><%= acc.getUsername() %></h2>
            <p class="text-muted">User Profile</p>
        </div>

        <div class="profile-info">
            <div class="info-item">
                <span class="info-label">Username:</span>
                <span class="info-value" id="username-display"><%= acc.getUsername() %></span>
                <input type="text" class="form-control edit-input" id="username-input" value="<%= acc.getUsername() %>" style="display: none;" placeholder="Nhập username">
            </div>
            
            <div class="info-item">
                <span class="info-label">Email:</span>
                <span class="info-value"><%= acc.getEmail() %></span>
            </div>
            
            <div class="info-item">
                <span class="info-label">Phone:</span>
                <span class="info-value" id="phone-display"><%= acc.getPhone() != null ? acc.getPhone() : "Not provided" %></span>
                <input type="text" class="form-control edit-input" id="phone-input" value="<%= acc.getPhone() != null ? acc.getPhone() : "" %>" style="display: none;" placeholder="Nhập số điện thoại (10 chữ số)">
            </div>
            
            <div class="info-item">
                <span class="info-label">Role:</span>
                <span class="info-value">
                    <span class="role-badge"><%= acc.getRoleName() != null ? acc.getRoleName() : "Patient" %></span>
                </span>
            </div>
        </div>

        <div class="text-center mt-4">
            <a href="Home.jsp" class="back-btn">
                <i class="bi bi-arrow-left"></i> Back to Home
            </a>
            <button class="edit-btn" id="editBtn" onclick="toggleEdit()">
                <i class="bi bi-pencil"></i> Edit Profile
            </button>
            <button class="edit-btn" id="saveBtn" onclick="saveProfile()" style="display: none; background: #28a745;">
                <i class="bi bi-check"></i> Cập nhật hồ sơ
            </button>
            <button class="edit-btn" id="cancelBtn" onclick="cancelEdit()" style="display: none; background: #dc3545;">
                <i class="bi bi-x"></i> Hủy
            </button>
        </div>
    </div>

    <!-- Simple Notification -->
    <div id="simpleNotification" style="display: none; position: fixed; top: 20px; right: 20px; background: #28a745; color: white; padding: 15px 20px; border-radius: 5px; z-index: 9999; box-shadow: 0 2px 10px rgba(0,0,0,0.2);">
        <span id="notificationMessage"></span>
        <button onclick="hideNotification()" style="background: none; border: none; color: white; font-size: 18px; margin-left: 10px; cursor: pointer;">&times;</button>
    </div>

    <!-- Vendor JS Files -->
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/vendor/aos/aos.js"></script>

    <script>
        let isEditing = false;
        let originalData = {};
        
        function uploadAvatar(input) {
            if (input.files && input.files[0]) {
                const file = input.files[0];
                
                // Validate file type
                if (!file.type.startsWith('image/')) {
                    alert('Please select an image file.');
                    return;
                }
                
                // Validate file size (max 5MB)
                if (file.size > 5 * 1024 * 1024) {
                    alert('File size must be less than 5MB.');
                    return;
                }
                
                const formData = new FormData();
                formData.append('avatar', file);
                
                // Show loading
                const avatarImg = document.getElementById('avatarImg');
                const originalSrc = avatarImg.src;
                avatarImg.style.opacity = '0.5';
                
                fetch('uploadAvatar', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        avatarImg.src = data.avatarPath + '?t=' + new Date().getTime();
                        alert('Avatar updated successfully!');
                    } else {
                        alert('Error updating avatar: ' + data.message);
                        avatarImg.src = originalSrc;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error uploading avatar. Please try again.');
                    avatarImg.src = originalSrc;
                })
                .finally(() => {
                    avatarImg.style.opacity = '1';
                });
            }
        }
        
        function toggleEdit() {
            if (!isEditing) {
                // Lưu dữ liệu gốc
                originalData.username = document.getElementById('username-input').value;
                originalData.phone = document.getElementById('phone-input').value;
                
                // Hiển thị input fields
                document.getElementById('username-display').style.display = 'none';
                document.getElementById('username-input').style.display = 'block';
                document.getElementById('phone-display').style.display = 'none';
                document.getElementById('phone-input').style.display = 'block';
                
                // Hiển thị buttons
                document.getElementById('editBtn').style.display = 'none';
                document.getElementById('saveBtn').style.display = 'inline-block';
                document.getElementById('cancelBtn').style.display = 'inline-block';
                
                isEditing = true;
            }
        }
        
        function cancelEdit() {
            // Khôi phục dữ liệu gốc
            document.getElementById('username-input').value = originalData.username;
            document.getElementById('phone-input').value = originalData.phone;
            
            // Ẩn input fields
            document.getElementById('username-display').style.display = 'block';
            document.getElementById('username-input').style.display = 'none';
            document.getElementById('phone-display').style.display = 'block';
            document.getElementById('phone-input').style.display = 'none';
            
            // Hiển thị buttons
            document.getElementById('editBtn').style.display = 'inline-block';
            document.getElementById('saveBtn').style.display = 'none';
            document.getElementById('cancelBtn').style.display = 'none';
            
            isEditing = false;
        }
        
        function saveProfile() {
            const username = document.getElementById('username-input').value.trim();
            const phone = document.getElementById('phone-input').value.trim();
            
            // Validation
            if (!username) {
                showNotification('Username không được để trống', 'error');
                return;
            }
            
            if (phone && phone.length > 0) {
                const phoneDigits = phone.replaceAll(/[^0-9]/g, '');
                if (phoneDigits.length !== 10) {
                    showNotification('Số điện thoại phải có đúng 10 chữ số', 'error');
                    return;
                }
            }
            
            // Show loading
            const saveBtn = document.getElementById('saveBtn');
            saveBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang cập nhật...';
            saveBtn.disabled = true;
            
            const formData = new FormData();
            formData.append('username', username);
            formData.append('phone', phone);
            
            fetch('editProfile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'username=' + encodeURIComponent(username) + '&phone=' + encodeURIComponent(phone || '')
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Cập nhật hiển thị
                    document.getElementById('username-display').textContent = username;
                    document.getElementById('phone-display').textContent = phone || 'Not provided';
                    
                    // Ẩn input fields
                    document.getElementById('username-display').style.display = 'block';
                    document.getElementById('username-input').style.display = 'none';
                    document.getElementById('phone-display').style.display = 'block';
                    document.getElementById('phone-input').style.display = 'none';
                    
                    // Hiển thị buttons
                    document.getElementById('editBtn').style.display = 'inline-block';
                    document.getElementById('saveBtn').style.display = 'none';
                    document.getElementById('cancelBtn').style.display = 'none';
                    
                    isEditing = false;
                    showNotification(data.message, 'success');
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Lỗi hệ thống. Vui lòng thử lại.', 'error');
            })
            .finally(() => {
                saveBtn.innerHTML = '<i class="bi bi-check"></i> Cập nhật hồ sơ';
                saveBtn.disabled = false;
            });
        }
        
        // Function để hiển thị thông báo đơn giản
        function showNotification(message, type = 'success') {
            const notification = document.getElementById('simpleNotification');
            const messageSpan = document.getElementById('notificationMessage');
            
            if (!notification || !messageSpan) {
                console.log('Notification: ' + message);
                return;
            }
            
            // Đặt màu theo loại
            if (type === 'error') {
                notification.style.background = '#dc3545';
            } else if (type === 'warning') {
                notification.style.background = '#ffc107';
                notification.style.color = '#000';
            } else {
                notification.style.background = '#28a745';
                notification.style.color = '#fff';
            }
            
            // Hiển thị thông báo
            messageSpan.textContent = message;
            notification.style.display = 'block';
            
            // Tự động ẩn sau 4 giây
            setTimeout(() => {
                hideNotification();
            }, 4000);
        }
        
        // Function để ẩn thông báo
        function hideNotification() {
            const notification = document.getElementById('simpleNotification');
            if (notification) {
                notification.style.display = 'none';
            }
        }
    </script>
</body>
</html>
