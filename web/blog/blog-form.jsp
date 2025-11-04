<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${blog != null ? 'Chỉnh sửa' : 'Thêm mới'} Blog - Phòng khám Nhi</title>

    <!-- Dùng cùng bộ CSS/JS như trang Home -->
    <jsp:include page="../includes/head-includes.jsp"/>

    <!-- CKEditor -->
    <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>

    <style>
      .page-blog-editor { background:#f5f6fa; font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
      .page-blog-editor .sidebar-container{
        width:280px;background:#fff;border-right:1px solid #dee2e6;position:fixed;top:80px;left:0;
        height:calc(100vh - 80px);overflow-y:auto;z-index:1000;box-shadow:2px 0 10px rgba(0,0,0,0.1);
      }
      .page-blog-editor .main-content{ margin-left:280px; padding:20px; min-height:calc(100vh - 80px); padding-bottom:100px; }
      @media(max-width:991px){ .page-blog-editor .sidebar-container{display:none;} .page-blog-editor .main-content{margin-left:0;} }
      .page-blog-editor .form-container{ background:#fff; padding:30px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1); max-width:960px; margin:0 auto; }
      .page-blog-editor .required{ color:#e74c3c; }
      .page-blog-editor #imagePreview img{ max-width:300px; border-radius:6px; }
      .page-blog-editor h2{ margin:0; font-weight:700; display:flex; align-items:center; gap:10px; color:#2c3e50; }
    </style>
  </head>

  <body class="index-page page-blog-editor">
    <!-- Header giống Home -->
    <jsp:include page="../includes/header.jsp"/>

    <main class="main" style="padding-top: 80px;">
      <!-- Hiển thị sidebar theo role như Home -->
      <c:choose>
        <c:when test="${acc != null && acc.roleId == 5}">
          <div class="container-fluid p-0">
            <div class="row g-0">
              <div class="sidebar-container">
                <%@ include file="../includes/sidebar-receptionist.jsp" %>
              </div>
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
                      <input type="hidden" name="action" value="${blog != null ? 'update' : 'insert'}" />
                      <c:if test="${blog != null}">
                        <input type="hidden" name="blogId" value="${blog.blogId}" />
                      </c:if>

                      <!-- Tiêu đề -->
                      <div class="mb-3">
                        <label for="title" class="form-label">Tiêu đề <span class="required">*</span></label>
                        <input type="text" class="form-control" id="title" name="title"
                               value="${blog.title}" required maxlength="255" />
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
                               onchange="previewFile(this)" />
                      </div>

                      <!-- Hoặc URL ảnh -->
                      <div class="mb-3">
                        <label for="thumbnailUrl" class="form-label">Hoặc URL ảnh online</label>
                        <input type="url" class="form-control" id="thumbnailUrl" name="thumbnailUrl"
                               value="${blog.thumbnail}"
                               placeholder="https://example.com/image.jpg"
                               onchange="previewImage(this.value)" />
                      </div>

                      <!-- Preview -->
                      <div id="imagePreview" class="mt-3">
                        <c:if test="${not empty blog.thumbnail}"><img src="${blog.thumbnail}" class="img-thumbnail" alt="Preview" /></c:if>
                      </div>

                      <!-- Nội dung -->
                      <div class="mb-3 mt-4">
                        <label for="content" class="form-label">Nội dung <span class="required">*</span></label>
                        <textarea class="form-control" id="content" name="content" rows="10" required>${blog.content}</textarea>
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
          </div>
        </c:when>

        <c:when test="${acc != null && acc.roleId == 2}">
          <div class="container-fluid p-0">
            <div class="row g-0">
              <div class="sidebar-container">
                <%@ include file="../includes/sidebar-doctor.jsp" %>
              </div>
              <div class="main-content">
                <!-- nội dung form giống trên -->
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
                      <input type="hidden" name="action" value="${blog != null ? 'update' : 'insert'}" />
                      <c:if test="${blog != null}">
                        <input type="hidden" name="blogId" value="${blog.blogId}" />
                      </c:if>

                      <div class="mb-3">
                        <label for="title" class="form-label">Tiêu đề <span class="required">*</span></label>
                        <input type="text" class="form-control" id="title" name="title"
                               value="${blog.title}" required maxlength="255" />
                      </div>

                      <div class="mb-3">
                        <label for="category" class="form-label">Danh mục <span class="required">*</span></label>
                        <select class="form-select" id="category" name="category" required>
                          <option value="">-- Chọn danh mục --</option>
                          <c:forEach var="cat" items="${categories}">
                            <option value="${cat}" ${blog.category eq cat ? 'selected' : ''}>${cat}</option>
                          </c:forEach>
                        </select>
                      </div>

                      <div class="mb-3">
                        <label for="thumbnailFile" class="form-label">Tải ảnh từ máy</label>
                        <input type="file" class="form-control" id="thumbnailFile" name="thumbnailFile" accept="image/*"
                               onchange="previewFile(this)" />
                      </div>

                      <div class="mb-3">
                        <label for="thumbnailUrl" class="form-label">Hoặc URL ảnh online</label>
                        <input type="url" class="form-control" id="thumbnailUrl" name="thumbnailUrl"
                               value="${blog.thumbnail}"
                               placeholder="https://example.com/image.jpg"
                               onchange="previewImage(this.value)" />
                      </div>

                      <div id="imagePreview" class="mt-3">
                        <c:if test="${not empty blog.thumbnail}"><img src="${blog.thumbnail}" class="img-thumbnail" alt="Preview" /></c:if>
                      </div>

                      <div class="mb-3 mt-4">
                        <label for="content" class="form-label">Nội dung <span class="required">*</span></label>
                        <textarea class="form-control" id="content" name="content" rows="10" required>${blog.content}</textarea>
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
          </div>
        </c:when>

        <c:when test="${acc != null && acc.roleId == 4}">
          <div class="container-fluid p-0">
            <div class="row g-0">
              <div class="sidebar-container">
                <%@ include file="../includes/sidebar-medicalassistant.jsp" %>
              </div>
              <div class="main-content">
                <!-- nội dung form giống trên -->
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
                      <input type="hidden" name="action" value="${blog != null ? 'update' : 'insert'}" />
                      <c:if test="${blog != null}">
                        <input type="hidden" name="blogId" value="${blog.blogId}" />
                      </c:if>

                      <div class="mb-3">
                        <label for="title" class="form-label">Tiêu đề <span class="required">*</span></label>
                        <input type="text" class="form-control" id="title" name="title"
                               value="${blog.title}" required maxlength="255" />
                      </div>

                      <div class="mb-3">
                        <label for="category" class="form-label">Danh mục <span class="required">*</span></label>
                        <select class="form-select" id="category" name="category" required>
                          <option value="">-- Chọn danh mục --</option>
                          <c:forEach var="cat" items="${categories}">
                            <option value="${cat}" ${blog.category eq cat ? 'selected' : ''}>${cat}</option>
                          </c:forEach>
                        </select>
                      </div>

                      <div class="mb-3">
                        <label for="thumbnailFile" class="form-label">Tải ảnh từ máy</label>
                        <input type="file" class="form-control" id="thumbnailFile" name="thumbnailFile" accept="image/*"
                               onchange="previewFile(this)" />
                      </div>

                      <div class="mb-3">
                        <label for="thumbnailUrl" class="form-label">Hoặc URL ảnh online</label>
                        <input type="url" class="form-control" id="thumbnailUrl" name="thumbnailUrl"
                               value="${blog.thumbnail}"
                               placeholder="https://example.com/image.jpg"
                               onchange="previewImage(this.value)" />
                      </div>

                      <div id="imagePreview" class="mt-3">
                        <c:if test="${not empty blog.thumbnail}"><img src="${blog.thumbnail}" class="img-thumbnail" alt="Preview" /></c:if>
                      </div>

                      <div class="mb-3 mt-4">
                        <label for="content" class="form-label">Nội dung <span class="required">*</span></label>
                        <textarea class="form-control" id="content" name="content" rows="10" required>${blog.content}</textarea>
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
          </div>
        </c:when>

        <c:when test="${acc != null && acc.roleId == 1}">
          <div class="container-fluid p-0">
            <div class="row g-0">
              <div class="sidebar-container">
                <%@ include file="../includes/sidebar-admin.jsp" %>
              </div>
              <div class="main-content">
                <!-- nội dung form giống trên -->
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
                      <input type="hidden" name="action" value="${blog != null ? 'update' : 'insert'}" />
                      <c:if test="${blog != null}">
                        <input type="hidden" name="blogId" value="${blog.blogId}" />
                      </c:if>

                      <div class="mb-3">
                        <label for="title" class="form-label">Tiêu đề <span class="required">*</span></label>
                        <input type="text" class="form-control" id="title" name="title"
                               value="${blog.title}" required maxlength="255" />
                      </div>

                      <div class="mb-3">
                        <label for="category" class="form-label">Danh mục <span class="required">*</span></label>
                        <select class="form-select" id="category" name="category" required>
                          <option value="">-- Chọn danh mục --</option>
                          <c:forEach var="cat" items="${categories}">
                            <option value="${cat}" ${blog.category eq cat ? 'selected' : ''}>${cat}</option>
                          </c:forEach>
                        </select>
                      </div>

                      <div class="mb-3">
                        <label for="thumbnailFile" class="form-label">Tải ảnh từ máy</label>
                        <input type="file" class="form-control" id="thumbnailFile" name="thumbnailFile" accept="image/*"
                               onchange="previewFile(this)" />
                      </div>

                      <div class="mb-3">
                        <label for="thumbnailUrl" class="form-label">Hoặc URL ảnh online</label>
                        <input type="url" class="form-control" id="thumbnailUrl" name="thumbnailUrl"
                               value="${blog.thumbnail}"
                               placeholder="https://example.com/image.jpg"
                               onchange="previewImage(this.value)" />
                      </div>

                      <div id="imagePreview" class="mt-3">
                        <c:if test="${not empty blog.thumbnail}"><img src="${blog.thumbnail}" class="img-thumbnail" alt="Preview" /></c:if>
                      </div>

                      <div class="mb-3 mt-4">
                        <label for="content" class="form-label">Nội dung <span class="required">*</span></label>
                        <textarea class="form-control" id="content" name="content" rows="10" required>${blog.content}</textarea>
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
          </div>
        </c:when>

        <%-- Trường hợp chưa đăng nhập/không có role: không hiển thị sidebar, vẫn giữ header --%>
        <c:otherwise>
          <div class="container py-4">
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
                <input type="hidden" name="action" value="${blog != null ? 'update' : 'insert'}" />
                <c:if test="${blog != null}">
                  <input type="hidden" name="blogId" value="${blog.blogId}" />
                </c:if>

                <div class="mb-3">
                  <label for="title" class="form-label">Tiêu đề <span class="required">*</span></label>
                  <input type="text" class="form-control" id="title" name="title"
                         value="${blog.title}" required maxlength="255" />
                </div>

                <div class="mb-3">
                  <label for="category" class="form-label">Danh mục <span class="required">*</span></label>
                  <select class="form-select" id="category" name="category" required>
                    <option value="">-- Chọn danh mục --</option>
                    <c:forEach var="cat" items="${categories}">
                      <option value="${cat}" ${blog.category eq cat ? 'selected' : ''}>${cat}</option>
                    </c:forEach>
                  </select>
                </div>

                <div class="mb-3">
                  <label for="thumbnailFile" class="form-label">Tải ảnh từ máy</label>
                  <input type="file" class="form-control" id="thumbnailFile" name="thumbnailFile" accept="image/*"
                         onchange="previewFile(this)" />
                </div>

                <div class="mb-3">
                  <label for="thumbnailUrl" class="form-label">Hoặc URL ảnh online</label>
                  <input type="url" class="form-control" id="thumbnailUrl" name="thumbnailUrl"
                         value="${blog.thumbnail}"
                         placeholder="https://example.com/image.jpg"
                         onchange="previewImage(this.value)" />
                </div>

                <div id="imagePreview" class="mt-3">
                  <c:if test="${not empty blog.thumbnail}">
                    <img src="${blog.thumbnail}" class="img-thumbnail" alt="Preview" />
                  </c:if>
                </div>

                <div class="mb-3 mt-4">
                  <label for="content" class="form-label">Nội dung <span class="required">*</span></label>
                  <textarea class="form-control" id="content" name="content" rows="10" required>${blog.content}</textarea>
                </div>

                <div class="d-flex justify-content-end">
                  <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> ${blog != null ? 'Cập nhật' : 'Thêm mới'}
                  </button>
                </div>
              </form>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </main>

   

    <script>
      CKEDITOR.replace('content', { height: 400 });

      function previewFile(input) {
        const preview = document.getElementById('imagePreview');
        const file = input.files[0];
        if (file) {
          const reader = new FileReader();
          reader.onload = e => { preview.innerHTML = '<img src="'+e.target.result+'" class="img-thumbnail" alt="Preview" />'; };
          reader.readAsDataURL(file);
        }
      }

      function previewImage(url) {
        const preview = document.getElementById('imagePreview');
        if (url) {
          preview.innerHTML = '<img src="'+url+'" class="img-thumbnail" onerror="this.src=\'https://via.placeholder.com/300x200?text=Invalid+URL\'" />';
        } else {
          preview.innerHTML = '';
        }
      }

      function validateForm() {
        const title = document.getElementById('title').value.trim();
        const category = document.getElementById('category').value.trim();
        const content = CKEDITOR.instances.content.getData().trim();
        if (!title) { alert('Vui lòng nhập tiêu đề!'); return false; }
        if (!category) { alert('Vui lòng chọn danh mục!'); return false; }
        if (!content) { alert('Vui lòng nhập nội dung!'); return false; }
        return true;
      }
    </script>
  </body>
</html>
