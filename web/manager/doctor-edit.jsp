<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa Bác sĩ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 10px;
        }
        .form-card {
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        .required::after {
            content: " *";
            color: red;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container py-4">
        <!-- Header -->
        <div class="page-header">
            <div class="container">
                <div class="d-flex align-items-center">
                    <a href="${pageContext.request.contextPath}/manager/doctors?action=view&id=${doctor.doctorId}" 
                       class="btn btn-light me-3">
                        <i class="fas fa-arrow-left"></i>
                    </a>
                    <div>
                        <h1 class="mb-0">Chỉnh sửa Bác sĩ</h1>
                        <p class="mb-0 mt-2">Cập nhật thông tin bác sĩ</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card form-card">
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/manager/doctors" 
                              method="post" 
                              onsubmit="return validateForm()">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="doctorId" value="${doctor.doctorId}">
                            <input type="hidden" name="userId" value="${doctor.userId}">

                            <h5 class="mb-4">
                                <i class="fas fa-user-circle text-primary me-2"></i>
                                Thông tin cá nhân
                            </h5>

                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label required">Họ và tên</label>
                                <div class="col-sm-9">
                                    <input type="text" 
                                           class="form-control" 
                                           name="username" 
                                           id="username"
                                           value="${doctor.user.username}" 
                                           required>
                                    <div class="invalid-feedback">Vui lòng nhập họ tên bác sĩ</div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label required">Email</label>
                                <div class="col-sm-9">
                                    <input type="email" 
                                           class="form-control" 
                                           name="email" 
                                           id="email"
                                           value="${doctor.user.email}" 
                                           required>
                                    <div class="invalid-feedback">Vui lòng nhập email hợp lệ</div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label required">Số điện thoại</label>
                                <div class="col-sm-9">
                                    <input type="tel" 
                                           class="form-control" 
                                           name="phone" 
                                           id="phone"
                                           value="${doctor.user.phone}" 
                                           pattern="[0-9]{10}"
                                           required>
                                    <div class="form-text">Nhập 10 chữ số</div>
                                    <div class="invalid-feedback">Vui lòng nhập số điện thoại hợp lệ (10 chữ số)</div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <h5 class="mb-4">
                                <i class="fas fa-stethoscope text-primary me-2"></i>
                                Thông tin chuyên môn
                            </h5>

                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label required">Chuyên khoa</label>
                                <div class="col-sm-9">
                                    <select class="form-select" name="specialty" id="specialty" required>
                                        <option value="">-- Chọn chuyên khoa --</option>
                                        <option value="Nhi khoa" ${doctor.specialty == 'Nhi khoa' ? 'selected' : ''}>Nhi khoa</option>
                                        <option value="Nhi tiêu hóa" ${doctor.specialty == 'Nhi tiêu hóa' ? 'selected' : ''}>Nhi tiêu hóa</option>
                                        <option value="Nhi hô hấp" ${doctor.specialty == 'Nhi hô hấp' ? 'selected' : ''}>Nhi hô hấp</option>
                                        <option value="Nhi tim mạch" ${doctor.specialty == 'Nhi tim mạch' ? 'selected' : ''}>Nhi tim mạch</option>
                                        <option value="Nhi thần kinh" ${doctor.specialty == 'Nhi thần kinh' ? 'selected' : ''}>Nhi thần kinh</option>
                                        <option value="Nhi da liễu" ${doctor.specialty == 'Nhi da liễu' ? 'selected' : ''}>Nhi da liễu</option>
                                        <option value="Khác" ${doctor.specialty == 'Khác' ? 'selected' : ''}>Khác</option>
                                    </select>
                                    <div class="invalid-feedback">Vui lòng chọn chuyên khoa</div>
                                </div>
                            </div>

                            <div class="row mt-4">
                                <div class="col-sm-9 offset-sm-3">
                                    <button type="submit" class="btn btn-primary me-2">
                                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                                    </button>
                                    <a href="${pageContext.request.contextPath}/manager/doctors?action=view&id=${doctor.doctorId}" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-times me-2"></i>Hủy
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function validateForm() {
            let isValid = true;
            const form = document.querySelector('form');
            
            // Clear previous validation
            form.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
            
            // Validate username
            const username = document.getElementById('username');
            if (!username.value.trim()) {
                username.classList.add('is-invalid');
                isValid = false;
            }
            
            // Validate email
            const email = document.getElementById('email');
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email.value)) {
                email.classList.add('is-invalid');
                isValid = false;
            }
            
            // Validate phone
            const phone = document.getElementById('phone');
            const phonePattern = /^[0-9]{10}$/;
            if (!phonePattern.test(phone.value)) {
                phone.classList.add('is-invalid');
                isValid = false;
            }
            
            // Validate specialty
            const specialty = document.getElementById('specialty');
            if (!specialty.value) {
                specialty.classList.add('is-invalid');
                isValid = false;
            }
            
            return isValid;
        }
    </script>
</body>
</html>