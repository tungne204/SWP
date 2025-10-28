<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="entity.Doctor" %>
<%
    User acc = (User) session.getAttribute("acc");
    if (acc == null) {
        response.sendRedirect("Login");
        return;
    }
    
    // Get Doctor info if user is a Doctor
    Doctor doctorInfo = (Doctor) request.getAttribute("doctorInfo");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Hồ Sơ Của Tôi - Medilab Pediatric Clinic</title>
    
    <!-- Include all CSS files -->
    <jsp:include page="includes/head-includes.jsp"/>
    
    <style>
        .profile-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 40px;
        }
        
        .profile-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #0d6efd;
        }
        
        .profile-header h1 {
            font-size: 1.8rem !important;
            margin-bottom: 8px;
        }
        
        .profile-header p {
            font-size: 0.95rem;
            margin: 0;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #0d6efd;
            margin-bottom: 15px;
        }
        
        .profile-info {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 15px;
            margin-bottom: 20px;
            padding: 15px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .profile-info:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
            font-size: 0.95rem;
        }
        
        .info-value {
            color: #212529;
            word-wrap: break-word;
            font-size: 1rem;
            font-weight: 500;
        }
        
        .btn-edit {
            background: #0d6efd;
            color: white;
            border: none;
            padding: 10px 30px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-edit:hover {
            background: #0b5ed7;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .edit-mode .info-value-input {
            display: block;
        }
        
        .edit-mode .info-value-display {
            display: none;
        }
        
        .view-mode .info-value-input {
            display: none;
        }
        
        .view-mode .info-value-display {
            display: block;
        }
        
        .info-value-input input {
            width: 100%;
            padding: 8px;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            font-size: 1rem;
        }
        
        .avatar-upload {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }
        
        .avatar-upload-btn {
            position: absolute;
            bottom: 10px;
            right: 10px;
            background: #0d6efd;
            color: white;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            transition: all 0.3s;
        }
        
        .avatar-upload-btn:hover {
            background: #0b5ed7;
            transform: scale(1.1);
        }
        
        #avatarFile {
            display: none;
        }
        
        .alert {
            display: none;
        }
        
        .hidden {
            display: none !important;
        }
    </style>
</head>

<body class="index-page">

<!-- Header -->
<jsp:include page="includes/header.jsp"/>

<main class="main" style="padding-top: 100px;">
    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-header">
                <div class="avatar-upload">
                    <img id="avatarImg" src="<%= acc.getAvatar() != null && !acc.getAvatar().isEmpty() ? acc.getAvatar() : request.getContextPath() + "/assets/img/avata.jpg" %>" 
                         alt="Avatar" class="profile-avatar">
                    <div class="avatar-upload-btn" id="avatarUploadBtn" style="display: none;">
                        <i class="bi bi-camera"></i>
                    </div>
                    <input type="file" id="avatarFile" accept="image/*">
                </div>
                <h1 class="fw-bold text-primary">Hồ Sơ Của Tôi</h1>
                <p class="text-muted">Xem và quản lý thông tin cá nhân của bạn</p>
            </div>
            
            <!-- Alert messages -->
            <div id="alertSuccess" class="alert alert-success alert-dismissible fade show" role="alert">
                <span id="alertMessage"></span>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            
            <form id="profileForm">
                <div class="profile-details">
                    <div class="profile-info">
                        <span class="info-label">Tên đăng nhập:</span>
                        <span class="info-value-display"><%= acc.getUsername() %></span>
                        <input type="text" name="username" value="<%= acc.getUsername() %>" 
                               class="info-value-input form-control" id="usernameInput" required>
                    </div>
                    
                    <div class="profile-info">
                        <span class="info-label">Email:</span>
                        <span class="info-value"><%= acc.getEmail() %></span>
                    </div>
                    
                    <div class="profile-info">
                        <span class="info-label">Số điện thoại:</span>
                        <span class="info-value-display"><%= acc.getPhone() != null ? acc.getPhone() : "Chưa cập nhật" %></span>
                        <input type="text" name="phone" value="<%= acc.getPhone() != null ? acc.getPhone() : "" %>" 
                               class="info-value-input form-control" id="phoneInput" placeholder="Nhập số điện thoại (10 số)"
                               maxlength="10" pattern="[0-9]*">
                    </div>
                    
                    <div class="profile-info">
                        <span class="info-label">Vai trò:</span>
                        <span class="info-value">
                            <% 
                                int roleId = acc.getRoleId();
                                String roleName = "";
                                switch(roleId) {
                                    case 1: roleName = "Quản trị viên"; break;
                                    case 2: roleName = "Bác sĩ"; break;
                                    case 3: roleName = "Người dùng"; break;
                                    case 4: roleName = "Y tá"; break;
                                    case 5: roleName = "Lễ tân"; break;
                                    default: roleName = "Không xác định";
                                }
                            %>
                            <%= roleName %>
                        </span>
                    </div>
                    
                    <!-- Doctor specific info -->
                    <% if (acc.getRoleId() == 2 && doctorInfo != null) { %>
                    <div class="profile-info" style="border-top: 2px solid #0d6efd; margin-top: 20px; padding-top: 20px;">
                        <span class="info-label"><strong>Thông tin Bác sĩ:</strong></span>
                        <span class="info-value"></span>
                    </div>
                    
                    <div class="profile-info">
                        <span class="info-label">Số năm kinh nghiệm:</span>
                        <span class="info-value-display"><%= doctorInfo.getExperienceYears() > 0 ? doctorInfo.getExperienceYears() + " năm" : "Chưa cập nhật" %></span>
                        <input type="number" name="experienceYears" value="<%= doctorInfo.getExperienceYears() %>" 
                               class="info-value-input form-control" id="experienceYearsInput" min="0" placeholder="Nhập số năm">
                    </div>
                    
                    <div class="profile-info">
                        <span class="info-label">Chứng chỉ:</span>
                        <span class="info-value-display">
                            <% if (doctorInfo.getCertificate() != null && !doctorInfo.getCertificate().isEmpty()) { %>
                                <button type="button" class="btn btn-link p-0" onclick="viewCertificate('<%= request.getContextPath() %>/<%= doctorInfo.getCertificate() %>')" 
                                        style="text-decoration: none; color: #0d6efd;">
                                    <i class="bi bi-file-earmark-pdf"></i> Xem chứng chỉ
                                </button>
                            <% } else { %>
                                Chưa cập nhật
                            <% } %>
                        </span>
                        <input type="file" name="certificate" accept=".pdf,.jpg,.jpeg,.png" 
                               class="info-value-input form-control" id="certificateFile">
                    </div>
                    
                    <div class="profile-info" style="grid-template-columns: 1fr;">
                        <span class="info-label">Giới thiệu:</span>
                        <span class="info-value-display" style="white-space: pre-wrap;"><%= doctorInfo.getIntroduce() != null && !doctorInfo.getIntroduce().isEmpty() ? doctorInfo.getIntroduce() : "Chưa cập nhật" %></span>
                        <textarea name="introduce" rows="4" 
                                  class="info-value-input form-control" id="introduceInput" 
                                  placeholder="Nhập giới thiệu về bản thân"><%= doctorInfo.getIntroduce() != null ? doctorInfo.getIntroduce() : "" %></textarea>
                    </div>
                    <% } %>
                </div>
            </form>
            
            <!-- Certificate Modal -->
            <div class="modal fade" id="certificateModal" tabindex="-1" aria-labelledby="certificateModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="certificateModalLabel">Chứng chỉ</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body text-center">
                            <iframe id="certificateFrame" src="" style="width: 100%; height: 600px; border: none;"></iframe>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="text-center mt-4">
                <button id="editBtn" class="btn btn-primary me-2">
                    <i class="bi bi-pencil-square me-1"></i> Chỉnh sửa
                </button>
                <button id="saveBtn" class="btn btn-success me-2 hidden">
                    <i class="bi bi-check-circle me-1"></i> Lưu thay đổi
                </button>
                <button id="cancelBtn" class="btn btn-outline-secondary me-2 hidden">
                    <i class="bi bi-x-circle me-1"></i> Hủy
                </button>
               
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="includes/footer.jsp"/>

<!-- Include all JS files -->
<jsp:include page="includes/footer-includes.jsp"/>

<script>
    const contextPath = '<%= request.getContextPath() %>';
    let isEditMode = false;
    let originalAvatar = '<%= acc.getAvatar() != null && !acc.getAvatar().isEmpty() ? acc.getAvatar() : request.getContextPath() + "/assets/img/avata.jpg" %>';
    
    // Initialize originalIntroduce for Doctor
    const introduceInputElement = document.getElementById('introduceInput');
    const originalIntroduce = introduceInputElement ? introduceInputElement.value : '';
    
    // Toggle Edit Mode
    document.getElementById('editBtn').addEventListener('click', function() {
        enterEditMode();
    });
    
    document.getElementById('cancelBtn').addEventListener('click', function() {
        exitEditMode();
    });
    
    document.getElementById('saveBtn').addEventListener('click', function() {
        saveProfile();
    });
    
    // Avatar Upload
    document.getElementById('avatarUploadBtn').addEventListener('click', function() {
        document.getElementById('avatarFile').click();
    });
    
    document.getElementById('avatarFile').addEventListener('change', function(e) {
        if (e.target.files && e.target.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('avatarImg').src = e.target.result;
            };
            reader.readAsDataURL(e.target.files[0]);
        }
    });
    
    // Phone input - only allow numbers
    document.getElementById('phoneInput').addEventListener('input', function(e) {
        // Remove any non-numeric characters
        e.target.value = e.target.value.replace(/[^0-9]/g, '');
    });
    
    function enterEditMode() {
        isEditMode = true;
        document.querySelector('.profile-card').classList.add('edit-mode');
        document.querySelector('.profile-card').classList.remove('view-mode');
        
        // Show/hide buttons
        document.getElementById('editBtn').classList.add('hidden');
        document.getElementById('saveBtn').classList.remove('hidden');
        document.getElementById('cancelBtn').classList.remove('hidden');
        
        // Show avatar upload button
        document.getElementById('avatarUploadBtn').style.display = 'flex';
    }
    
    function exitEditMode() {
        isEditMode = false;
        document.querySelector('.profile-card').classList.remove('edit-mode');
        document.querySelector('.profile-card').classList.add('view-mode');
        
        // Show/hide buttons
        document.getElementById('editBtn').classList.remove('hidden');
        document.getElementById('saveBtn').classList.add('hidden');
        document.getElementById('cancelBtn').classList.add('hidden');
        
        // Hide avatar upload button
        document.getElementById('avatarUploadBtn').style.display = 'none';
        
        // Reset form
        document.getElementById('usernameInput').value = '<%= acc.getUsername() %>';
        document.getElementById('phoneInput').value = '<%= acc.getPhone() != null ? acc.getPhone() : "" %>';
        document.getElementById('avatarImg').src = originalAvatar;
        document.getElementById('avatarFile').value = '';
        
        // Reset Doctor fields if exists
        const experienceYearsInput = document.getElementById('experienceYearsInput');
        if (experienceYearsInput) {
            experienceYearsInput.value = '<%= acc.getRoleId() == 2 && doctorInfo != null ? doctorInfo.getExperienceYears() : 0 %>';
        }
        
        const introduceInput = document.getElementById('introduceInput');
        if (introduceInput) {
            introduceInput.value = originalIntroduce;
        }
        
        const certificateFile = document.getElementById('certificateFile');
        if (certificateFile) {
            certificateFile.value = '';
        }
    }
    
    function showAlert(message, type = 'success') {
        const alert = document.getElementById('alertSuccess');
        const messageSpan = document.getElementById('alertMessage');
        
        alert.className = 'alert alert-' + type + ' alert-dismissible fade show';
        messageSpan.textContent = message;
        alert.style.display = 'block';
        
        // Auto hide after 3 seconds
        setTimeout(() => {
            alert.style.display = 'none';
        }, 3000);
    }
    
    async function saveProfile() {
        const username = document.getElementById('usernameInput').value.trim();
        const phone = document.getElementById('phoneInput').value.trim();
        
        // Client-side validation
        if (!username || username === '') {
            showAlert('Tên đăng nhập không được để trống', 'danger');
            return;
        }
        
        if (phone && phone !== '') {
            // Remove all non-numeric characters
            const cleanPhone = phone.replace(/[^0-9]/g, '');
            if (cleanPhone.length !== 10) {
                showAlert('Số điện thoại phải có đúng 10 chữ số', 'danger');
                return;
            }
        }
        
        // Upload avatar first if changed
        const avatarFile = document.getElementById('avatarFile').files[0];
        if (avatarFile) {
            const uploadResponse = await uploadAvatar(avatarFile);
            if (!uploadResponse.success) {
                showAlert(uploadResponse.message, 'danger');
                return;
            }
            originalAvatar = uploadResponse.avatarPath;
        }
        
        // Upload certificate if changed (for Doctor only)
        const certificateFile = document.getElementById('certificateFile');
        if (certificateFile && certificateFile.files && certificateFile.files[0]) {
            const uploadResponse = await uploadCertificate(certificateFile.files[0]);
            if (!uploadResponse.success) {
                showAlert(uploadResponse.message, 'danger');
                return;
            }
        }
        
        // Prepare data as URL-encoded format
        const params = new URLSearchParams();
        params.append('username', username);
        params.append('phone', phone);
        
        // Add Doctor info if Doctor
        const experienceYearsInput = document.getElementById('experienceYearsInput');
        if (experienceYearsInput) {
            params.append('experienceYears', experienceYearsInput.value);
        }
        
        const introduceInput = document.getElementById('introduceInput');
        if (introduceInput) {
            params.append('introduce', introduceInput.value);
        }
        
        try {
            const response = await fetch(contextPath + '/editProfile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            });
            
            const result = await response.json();
            
            if (result.success) {
                showAlert(result.message || 'Cập nhật hồ sơ thành công!', 'success');
                exitEditMode();
                
                // Reload page after 1 second
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            } else {
                showAlert(result.message || 'Cập nhật hồ sơ thất bại', 'danger');
            }
        } catch (error) {
            showAlert('Lỗi khi cập nhật hồ sơ: ' + error.message, 'danger');
        }
    }
    
    async function uploadAvatar(file) {
        const formData = new FormData();
        formData.append('avatar', file);
        
        try {
            const response = await fetch(contextPath + '/uploadAvatar', {
                method: 'POST',
                body: formData
            });
            
            return await response.json();
        } catch (error) {
            return { success: false, message: 'Error uploading avatar' };
        }
    }
    
    async function uploadCertificate(file) {
        const formData = new FormData();
        formData.append('certificate', file);
        
        try {
            const response = await fetch(contextPath + '/uploadCertificate', {
                method: 'POST',
                body: formData
            });
            
            return await response.json();
        } catch (error) {
            return { success: false, message: 'Error uploading certificate' };
        }
    }
    
    // Initialize as view mode
    document.querySelector('.profile-card').classList.add('view-mode');
    
    // View certificate in modal
    window.viewCertificate = function(certificateUrl) {
        const iframe = document.getElementById('certificateFrame');
        iframe.src = certificateUrl;
        
        // Show modal using Bootstrap
        const modal = new bootstrap.Modal(document.getElementById('certificateModal'));
        modal.show();
    };
</script>

</body>

</html>

