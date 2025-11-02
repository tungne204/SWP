<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${blog != null ? 'Chỉnh sửa' : 'Thêm mới'} Blog - Phòng khám Nhi</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>

        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f6fa;
            }

            /* ===== HEADER ===== */
            .header {
                width: 100%;
                background: white;
                padding: 15px 25px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                position: sticky;
                top: 0;
                z-index: 100;
            }

            /* ===== LAYOUT ===== */
            .main-layout {
                display: flex;
                min-height: calc(100vh - 70px);
            }

            .sidebar {
                width: 250px;
                background-color: #2c3e50;
                color: white;
                position: sticky;
                top: 70px;
                min-height: calc(100vh - 70px);
                overflow-y: auto;
                overflow-x: hidden;
                scrollbar-width: thin;
                scrollbar-color: #888 #2c3e50;
            }

            .sidebar::-webkit-scrollbar {
                width: 6px;
            }
            .sidebar::-webkit-scrollbar-thumb {
                background-color: #888;
                border-radius: 3px;
            }
            .sidebar::-webkit-scrollbar-thumb:hover {
                background-color: #aaa;
            }
            .sidebar::-webkit-scrollbar-track {
                background-color: #2c3e50;
            }

            .main-content {
                flex: 1;
                padding: 25px;
            }

            /* ===== FORM STYLE ===== */
            .form-container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .required {
                color: red;
            }

            #imagePreview img {
                max-width: 300px;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>

        <!-- HEADER -->
        <jsp:include page="../includes/header.jsp" />

        <div class="main-layout">
            <!-- SIDEBAR -->
            <% 
         if (acc != null) {
             if (acc.getRoleId() == 1) { 
            %>
            <jsp:include page="../includes/sidebar-admin.jsp" />
            <% 
                    } else if (acc.getRoleId() == 2) { 
            %>
            <jsp:include page="../includes/sidebar-doctor.jsp" />
            <% 
                    } else if (acc.getRoleId() == 4) { 
            %>
            <jsp:include page="../includes/sidebar-medicalassistant.jsp" />
            <%
                    } else if (acc.getRoleId() == 5) {
            %>
            <jsp:include page="../includes/sidebar-receptionist.jsp" />
            <%
                    }
                }
            %>

            <!-- MAIN CONTENT -->
            <div class="main-content">
                <div class="container">
                    <div class="form-container">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2>
                                <i class="fas fa-${blog != null ? 'edit' : 'plus-circle'}"></i>
                                ${blog != null ? 'Chỉnh sửa' : 'Thêm mới'} bài viết
                            </h2>
                            <a href="blog?action=list" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                        </div>

                        <form action="blog" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                            <input type="hidden" name="action" value="${blog != null ? 'update' : 'insert'}">
                            <c:if test="${blog != null}">
                                <input type="hidden" name="blogId" value="${blog.blogId}">
                            </c:if>

                            <!-- Tiêu đề -->
                            <div class="mb-3">
                                <label for="title" class="form-label">Tiêu đề <span class="required">*</span></label>
                                <input type="text" class="form-control" id="title" name="title"
                                       value="${blog.title}" required maxlength="255">
                            </div>

                            <!-- Danh mục -->
                            <div class="mb-3">
                                <label for="category" class="form-label">Danh mục <span class="required">*</span></label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat}" ${blog.category eq cat ? 'selected' : ''}>${cat}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Ảnh offline -->
                            <div class="mb-3">
                                <label for="thumbnailFile" class="form-label">Tải ảnh từ máy</label>
                                <input type="file" class="form-control" id="thumbnailFile" name="thumbnailFile" accept="image/*"
                                       onchange="previewFile(this)">
                            </div>

                            <!-- Hoặc URL ảnh -->
                            <div class="mb-3">
                                <label for="thumbnailUrl" class="form-label">Hoặc URL ảnh online</label>
                                <input type="url" class="form-control" id="thumbnailUrl" name="thumbnailUrl"
                                       value="${blog.thumbnail}"
                                       placeholder="https://example.com/image.jpg"
                                       onchange="previewImage(this.value)">
                            </div>

                            <!-- Preview -->
                            <div id="imagePreview" class="mt-3">
                                <c:if test="${not empty blog.thumbnail}">
                                    <img src="${blog.thumbnail}" class="img-thumbnail" alt="Preview">
                                </c:if>
                            </div>

                            <!-- Nội dung -->
                            <div class="mb-3 mt-4">
                                <label for="content" class="form-label">Nội dung <span class="required">*</span></label>
                                <textarea class="form-control" id="content" name="content" rows="10" required>${blog.content}</textarea>
                            </div>

                            <!-- Trạng thái -->
                            <div class="form-check form-switch mb-4">
                                <input class="form-check-input" type="checkbox" id="status"
                                       name="status" value="1"
                                       ${blog == null || blog.status ? 'checked' : ''}>
                                <label class="form-check-label" for="status">
                                    <span id="statusLabel">${blog == null || blog.status ? 'Công khai' : 'Nháp'}</span>
                                </label>
                            </div>

                            <div class="d-flex justify-content-end">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> ${blog != null ? 'Cập nhật' : 'Thêm mới'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                           // CKEditor khởi tạo
                                           CKEDITOR.replace('content', {height: 400});

                                           // Preview ảnh offline
                                           function previewFile(input) {
                                               const preview = document.getElementById('imagePreview');
                                               const file = input.files[0];
                                               if (file) {
                                                   const reader = new FileReader();
                                                   reader.onload = e => {
                                                       preview.innerHTML = `<img src="${e.target.result}" class="img-thumbnail" alt="Preview">`;
                                                   };
                                                   reader.readAsDataURL(file);
                                               }
                                           }

                                           // Preview ảnh online
                                           function previewImage(url) {
                                               const preview = document.getElementById('imagePreview');
                                               if (url) {
                                                   preview.innerHTML = `<img src="${url}" class="img-thumbnail" 
                        onerror="this.src='https://via.placeholder.com/300x200?text=Invalid+URL'">`;
                                               } else {
                                                   preview.innerHTML = '';
                                               }
                                           }

                                           // Cập nhật label trạng thái
                                           document.getElementById('status').addEventListener('change', function () {
                                               document.getElementById('statusLabel').textContent =
                                                       this.checked ? 'Công khai' : 'Nháp';
                                           });

                                           // Kiểm tra dữ liệu trước khi gửi
                                           function validateForm() {
                                               const title = document.getElementById('title').value.trim();
                                               const category = document.getElementById('category').value.trim();
                                               const content = CKEDITOR.instances.content.getData().trim();

                                               if (!title) {
                                                   alert('Vui lòng nhập tiêu đề!');
                                                   return false;
                                               }
                                               if (!category) {
                                                   alert('Vui lòng chọn danh mục!');
                                                   return false;
                                               }
                                               if (!content) {
                                                   alert('Vui lòng nhập nội dung!');
                                                   return false;
                                               }
                                               return true;
                                           }
        </script>
    </body>
</html>
