<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>News Manager Dashboard</title>

  <!-- Bootstrap + FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <style>
    body { background-color:#f5f6f8;font-family:'Poppins',sans-serif;}
    .sidebar{width:220px;background:#1e293b;min-height:100vh;position:fixed;color:white;}
    .sidebar h4{text-align:center;padding:15px;margin:0;background:#111827;}
    .sidebar a{color:#cbd5e1;display:block;padding:12px 20px;text-decoration:none;}
    .sidebar a:hover,.sidebar a.active{background:#0ea5e9;color:white;}
    .main{margin-left:240px;padding:25px;}
    .card{border:none;border-radius:10px;box-shadow:0 2px 5px rgba(0,0,0,0.05);}
    .nav-tabs .nav-link.active{background-color:#0ea5e9;color:white;}
  </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
  <h4>Admin Panel</h4>
  <a href="#" class="active"><i class="fa-solid fa-newspaper me-2"></i>News Manager</a>
  <a href="#"><i class="fa-solid fa-folder-open me-2"></i>Category</a>
  <a href="#"><i class="fa-solid fa-chart-line me-2"></i>Analytics</a>
  <a href="#"><i class="fa-solid fa-right-from-bracket me-2"></i>Logout</a>
</div>

<!-- Main -->
<div class="main">
  <h3 class="fw-bold mb-4"><i class="fa-solid fa-newspaper me-2"></i>News Manager</h3>

  <!-- Tabs -->
  <ul class="nav nav-tabs mb-4">
    <li class="nav-item">
      <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#dashboard">Dashboard</button>
    </li>
    <li class="nav-item">
      <button class="nav-link" data-bs-toggle="tab" data-bs-target="#news">News Management</button>
    </li>
  </ul>

  <div class="tab-content">

    <!-- 🟩 DASHBOARD -->
    <div class="tab-pane fade show active" id="dashboard">
      <div class="row mb-4">
        <div class="col-md-4"><div class="card p-3 text-center">
          <h5><i class="fa-regular fa-newspaper text-primary me-2"></i>Bài viết</h5>
          <h3 class="fw-bold text-dark">${articleCount}</h3></div></div>
        <div class="col-md-4"><div class="card p-3 text-center">
          <h5><i class="fa-solid fa-folder-open text-success me-2"></i>Danh mục</h5>
          <h3 class="fw-bold text-dark">${categoryCount}</h3></div></div>
        <div class="col-md-4"><div class="card p-3 text-center">
          <h5><i class="fa-regular fa-user text-warning me-2"></i>Người dùng</h5>
          <h3 class="fw-bold text-dark">${userCount}</h3></div></div>
      </div>
    </div>

    <!-- 🟦 NEWS MANAGEMENT -->
    <div class="tab-pane fade" id="news">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold text-primary">Quản lý tin tức</h5>
        <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#addModal">
          <i class="fa fa-plus-circle"></i> Thêm bài viết
        </button>
      </div>

      <table class="table table-striped table-bordered align-middle">
        <thead class="text-center">
          <tr>
            <th>ID</th>
            <th>Tiêu đề</th>
            <th>Thể loại</th>
            <th>Tác giả</th>
            <th>Trạng thái</th>
            <th>Ngày tạo</th>
            <th>Hành động</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="n" items="${listNews}">
          <tr>
            <td class="text-center">${n.newsId}</td>
            <td>${n.title}</td>
            <td class="text-center">${n.categoryId}</td>
            <td class="text-center">${n.authorId}</td>
            <td class="text-center">
              <c:choose>
                <c:when test="${n.status}">
                  <span class="badge bg-success">Hiển thị</span>
                </c:when>
                <c:otherwise>
                  <span class="badge bg-secondary">Ẩn</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td class="text-center">${n.createdDate}</td>
            <td class="text-center">
              <button class="btn btn-warning btn-sm me-1"
                      data-bs-toggle="modal"
                      data-bs-target="#editModal"
                      data-id="${n.newsId}"
                      data-title="${n.title}"
                      data-subtitle="${n.subtitle}"
                      data-slug="${n.slug}"
                      data-content="${n.content}"
                      data-thumbnail="${n.thumbnail}"
                      data-category="${n.categoryId}"
                      data-status="${n.status}">
                Sửa
              </button>
              <a href="newsManager?action=delete&id=${n.newsId}" class="btn btn-danger btn-sm"
                 onclick="return confirm('Xác nhận xóa bài viết này?')">Xóa</a>
              <a href="newsManager?action=toggle&id=${n.newsId}&status=${n.status}"
                 class="btn btn-secondary btn-sm">${n.status ? 'Ẩn' : 'Hiện'}</a>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- 🟢 MODAL: THÊM -->
<div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="newsManager" method="post">
        <div class="modal-header">
          <h5 class="modal-title">Thêm bài viết mới</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input name="title" class="form-control mb-2" placeholder="Tiêu đề" required>
          <input name="subtitle" class="form-control mb-2" placeholder="Phụ đề">
          <input name="slug" class="form-control mb-2" placeholder="Slug (ví dụ: phong-benh-mua-lanh)">
          <textarea name="content" class="form-control mb-2" rows="4" placeholder="Nội dung..."></textarea>
          <input name="thumbnail" class="form-control mb-2" placeholder="Đường dẫn ảnh (assets/img/...)">
          <input name="category_id" class="form-control mb-2" placeholder="ID danh mục" value="1">
          <label><input type="checkbox" name="status" checked> Hiển thị</label>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-success">Lưu</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 🟡 MODAL: SỬA -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="newsManager" method="post">
        <div class="modal-header">
          <h5 class="modal-title">Chỉnh sửa bài viết</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="news_id" id="edit_id">
          <input name="title" id="edit_title" class="form-control mb-2" placeholder="Tiêu đề" required>
          <input name="subtitle" id="edit_subtitle" class="form-control mb-2" placeholder="Phụ đề">
          <input name="slug" id="edit_slug" class="form-control mb-2" placeholder="Slug">
          <textarea name="content" id="edit_content" class="form-control mb-2" rows="4"></textarea>
          <input name="thumbnail" id="edit_thumbnail" class="form-control mb-2" placeholder="Đường dẫn ảnh">
          <input name="category_id" id="edit_category" class="form-control mb-2" placeholder="ID danh mục">
          <label><input type="checkbox" name="status" id="edit_status"> Hiển thị</label>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-primary">Cập nhật</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- JS: Gán dữ liệu vào modal Sửa -->
<script>
  const editModal = document.getElementById('editModal');
  editModal.addEventListener('show.bs.modal', event => {
    const btn = event.relatedTarget;
    document.getElementById('edit_id').value = btn.getAttribute('data-id');
    document.getElementById('edit_title').value = btn.getAttribute('data-title');
    document.getElementById('edit_subtitle').value = btn.getAttribute('data-subtitle');
    document.getElementById('edit_slug').value = btn.getAttribute('data-slug');
    document.getElementById('edit_content').value = btn.getAttribute('data-content');
    document.getElementById('edit_thumbnail').value = btn.getAttribute('data-thumbnail');
    document.getElementById('edit_category').value = btn.getAttribute('data-category');
    document.getElementById('edit_status').checked = btn.getAttribute('data-status') === 'true';
  });
</script>

</body>
</html>
