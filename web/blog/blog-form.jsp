<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${blog != null ? 'Chỉnh sửa' : 'Thêm mới'} Blog - Phòng khám Nhi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- CKEditor -->
        <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
        <style>
            .form-container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
            }
            .required {
                color: red;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container mt-5 mb-5">
            <div class="row">
                <div class="col-lg-10 offset-lg-1">
                    <div class="form-container">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2>
                                <i class="fas fa-${blog != null ? 'edit' : 'plus-circle'}"></i>
                                ${blog != null ? 'Chỉnh sửa' : 'Thêm mới'} bài viết
                            </h2>
                            <a href="blog?action=list" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                        </div>

                        <!-- Form -->
                        <form action="blog" method="post" onsubmit="return validateForm()">
                            <input type="hidden" name="action" value="${blog != null ? 'update' : 'insert'}">
                            <c:if test="${blog != null}">
                                <input type="hidden" name="blogId" value="${blog.blogId}">
                            </c:if>

                            <!-- Title -->
                            <div class="mb-3">
                                <label for="title" class="form-label">
                                    Tiêu đề <span class="required">*</span>
                                </label>
                                <input type="text" class="form-control" id="title" name="title" 
                                       value="${blog.title}" required maxlength="255"
                                       placeholder="Nhập tiêu đề bài viết">
                            </div>

                            <!-- Category -->
                            <div class="mb-3">
                                <label for="category" class="form-label">
                                    Danh mục <span class="required">*</span>
                                </label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat}" ${blog.category eq cat ? 'selected' : ''}>
                                            ${cat}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>


                            <!-- Thumbnail URL -->
                            <div class="mb-3">
                                <label for="thumbnail" class="form-label">
                                    URL hình ảnh
                                </label>
                                <input type="url" class="form-control" id="thumbnail" name="thumbnail" 
                                       value="${blog.thumbnail}"
                                       placeholder="https://example.com/image.jpg"
                                       onchange="previewImage(this.value)">
                                <small class="form-text text-muted">
                                    Nhập URL hình ảnh từ internet
                                </small>
                                <!-- Image Preview -->
                                <div id="imagePreview" class="mt-2">
                                    <c:if test="${not empty blog.thumbnail}">
                                        <img src="${blog.thumbnail}" class="img-thumbnail" 
                                             style="max-width: 300px;" alt="Preview">
                                    </c:if>
                                </div>
                            </div>

                            <!-- Content -->
                            <div class="mb-3">
                                <label for="content" class="form-label">
                                    Nội dung <span class="required">*</span>
                                </label>
                                <textarea class="form-control" id="content" name="content" 
                                          rows="10" required>${blog.content}</textarea>
                            </div>

                            <!-- Status -->
                            <div class="mb-4">
                                <label class="form-label">Trạng thái</label>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="status" 
                                           name="status" value="1" 
                                           ${blog == null || blog.status ? 'checked' : ''}>
                                    <label class="form-check-label" for="status">
                                        <span id="statusLabel">
                                            ${blog == null || blog.status ? 'Công khai' : 'Nháp'}
                                        </span>
                                    </label>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="blog?action=list" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> ${blog != null ? 'Cập nhật' : 'Thêm mới'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.ckeditor.com/4.25.1-lts/standard/ckeditor.js"></script>

        <script>
                                           // Initialize CKEditor
                                           CKEDITOR.replace('content', {
                                               height: 400,
                                               removeButtons: 'Save,NewPage,ExportPdf,Preview,Print,Templates,Find,Replace,SelectAll,Scayt,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,CreateDiv,BidiLtr,BidiRtl,Language,Anchor,Flash,Smiley,SpecialChar,PageBreak,Iframe,Maximize,ShowBlocks,About',
                                               removePlugins: 'exportpdf'
                                           });

                                           // Status toggle
                                           document.getElementById('status').addEventListener('change', function () {
                                               document.getElementById('statusLabel').textContent =
                                                       this.checked ? 'Công khai' : 'Nháp';
                                           });

                                           // Image preview
                                           function previewImage(url) {
                                               const previewDiv = document.getElementById('imagePreview');
                                               if (url) {
                                                   previewDiv.innerHTML = `<img src="${url}" class="img-thumbnail" 
                                                style="max-width: 300px;" alt="Preview" 
                                                onerror="this.src='https://via.placeholder.com/300x200?text=Invalid+URL'">`;
                                               } else {
                                                   previewDiv.innerHTML = '';
                                               }
                                           }

                                           // Form validation
                                           function validateForm() {
                                               const title = document.getElementById('title').value.trim();
                                               const category = document.getElementById('category').value.trim();
                                               const content = CKEDITOR.instances.content.getData().trim();

                                               if (!title) {
                                                   alert('Vui lòng nhập tiêu đề bài viết!');
                                                   return false;
                                               }

                                               if (!category) {
                                                   alert('Vui lòng chọn hoặc nhập danh mục!');
                                                   return false;
                                               }

                                               if (!content) {
                                                   alert('Vui lòng nhập nội dung bài viết!');
                                                   return false;
                                               }

                                               return true;
                                           }
        </script>
    </body>
</html>