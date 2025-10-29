<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa Bằng cấp</title>
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
                    <a href="${pageContext.request.contextPath}/doctors1?action=view&id=${qualification.doctorId}" 
                       class="btn btn-light me-3">
                        <i class="fas fa-arrow-left"></i>
                    </a>
                    <div>
                        <h1 class="mb-0">Chỉnh sửa Bằng cấp</h1>
                        <p class="mb-0 mt-2">Cập nhật thông tin bằng cấp</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card form-card">
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/doctors1" 
                              method="post" 
                              onsubmit="return validateForm()">
                            <input type="hidden" name="action" value="updateQualification">
                            <input type="hidden" name="qualificationId" value="${qualification.qualificationId}">
                            <input type="hidden" name="doctorId" value="${qualification.doctorId}">

                            <div class="mb-3">
                                <label for="degreeName" class="form-label required">Tên bằng cấp</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="degreeName" 
                                       name="degreeName" 
                                       value="${qualification.degreeName}"
                                       placeholder="Ví dụ: Bác sĩ Nhi khoa" 
                                       required>
                                <div class="invalid-feedback">Vui lòng nhập tên bằng cấp</div>
                            </div>

                            <div class="mb-3">
                                <label for="institution" class="form-label required">Cơ sở đào tạo</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="institution" 
                                       name="institution" 
                                       value="${qualification.institution}"
                                       placeholder="Ví dụ: Đại học Y Hà Nội" 
                                       required>
                                <div class="invalid-feedback">Vui lòng nhập cơ sở đào tạo</div>
                            </div>

                            <div class="mb-3">
                                <label for="yearObtained" class="form-label required">Năm tốt nghiệp</label>
                                <input type="number" 
                                       class="form-control" 
                                       id="yearObtained" 
                                       name="yearObtained" 
                                       value="${qualification.yearObtained}"
                                       min="1950" 
                                       max="2025" 
                                       placeholder="Ví dụ: 2015" 
                                       required>
                                <div class="invalid-feedback">Vui lòng nhập năm tốt nghiệp hợp lệ (1950-2025)</div>
                            </div>

                            <div class="mb-3">
                                <label for="certificateNumber" class="form-label">Số chứng chỉ</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="certificateNumber" 
                                       name="certificateNumber" 
                                       value="${qualification.certificateNumber}"
                                       placeholder="Ví dụ: BS-NH-2015-001">
                                <div class="form-text">Không bắt buộc</div>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">Mô tả</label>
                                <textarea class="form-control" 
                                          id="description" 
                                          name="description" 
                                          rows="3" 
                                          placeholder="Mô tả chi tiết về bằng cấp (không bắt buộc)">${qualification.description}</textarea>
                                <div class="form-text">Tối đa 500 ký tự</div>
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/doctors1?action=view&id=${qualification.doctorId}" 
                                   class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i>Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                </button>
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
            
            // Validate degree name
            const degreeName = document.getElementById('degreeName');
            if (!degreeName.value.trim()) {
                degreeName.classList.add('is-invalid');
                isValid = false;
            }
            
            // Validate institution
            const institution = document.getElementById('institution');
            if (!institution.value.trim()) {
                institution.classList.add('is-invalid');
                isValid = false;
            }
            
            // Validate year
            const yearObtained = document.getElementById('yearObtained');
            const year = parseInt(yearObtained.value);
            const currentYear = new Date().getFullYear();
            if (!year || year < 1950 || year > currentYear) {
                yearObtained.classList.add('is-invalid');
                isValid = false;
            }
            
            // Validate description length
            const description = document.getElementById('description');
            if (description.value.length > 500) {
                description.classList.add('is-invalid');
                alert('Mô tả không được vượt quá 500 ký tự');
                isValid = false;
            }
            
            return isValid;
        }
    </script>
</body>
</html>