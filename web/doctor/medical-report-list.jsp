<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
    boolean showDoctor = (acc != null && acc.getRoleId() == 2); // Bác sĩ có sidebar
    boolean hasSidebar = showDoctor;
%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn thuốc - Phòng khám nhi</title>

    <!-- Bootstrap + FontAwesome (nếu head-includes.jsp đã có thì có thể bỏ 2 dòng dưới) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Dùng chung với Home (AOS/glightbox/...): tuyệt đối đường dẫn -->
    <jsp:include page="/includes/head-includes.jsp"/>

    <style>
      /* ===== Scope riêng cho trang "đơn thuốc" ===== */
      .rx-page {
        margin: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #f5f6fa;
      }

      /* đẩy nội dung xuống dưới header fixed (~80px như Home) */
      .rx-page .rx-main {
        padding-top: 80px;
      }

      /* Layout chính */
      .rx-page .rx-layout {
        display: flex;
        min-height: calc(100vh - 80px);
      }

      /* Sidebar trái như Home (khi có role phù hợp) */
      .rx-page .rx-sidebar {
        width: 280px;
        background: #ffffff;
        border-right: 1px solid #dee2e6;
        position: fixed;
        top: 80px;
        left: 0;
        height: calc(100vh - 80px);
        overflow-y: auto;
        z-index: 1000;
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.06);
      }

      /* Nội dung chính */
      .rx-page .rx-content {
        flex: 1;
        padding: 24px;
        min-height: calc(100vh - 80px);
      }
      /* Chỉ đẩy nội dung sang phải khi có sidebar */
      .rx-page.has-sidebar .rx-content {
        margin-left: 280px;
      }

      /* Card bọc */
      .rx-page .rx-card {
        background: #ffffff;
        padding: 24px 24px 16px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.06);
        margin-bottom: 16px;
      }

      /* Tiêu đề khu vực */
      .rx-page .rx-title {
        color: #2c3e50;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 700;
      }

      .rx-page .rx-header-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        flex-wrap: wrap;
      }

      /* Form tìm kiếm */
      .rx-page .rx-search form input[type="text"],
      .rx-page .rx-search form select {
        min-width: 200px;
        height: 36px;
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 6px;
      }
      .rx-page .rx-search form .btn {
        height: 38px;
      }

      /* Bảng */
      .rx-page .table thead tr {
        background: #ffffff !important;
        color: #000 !important;
      }
      .rx-page .table tbody tr:hover {
        background: #f8f9fa;
      }
      .rx-page .text-truncate {
        vertical-align: middle;
      }

      /* Badge */
      .rx-page .badge {
        font-weight: 600;
      }

      /* Nút hành động */
      .rx-page .btn-action {
        padding: 6px 10px;
      }

      /* Trạng thái rỗng */
      .rx-page .table-empty {
        text-align: center;
        padding: 40px 10px;
        color: #7f8c8d;
        font-style: italic;
      }

      /* Phân trang (nhẹ giống TestResult) */
      .rx-page .pagination .page-link {
        border-radius: 6px;
        color: #2c3e50;
      }
      .rx-page .pagination .page-item.active .page-link {
        background: #3498db;
        border-color: #3498db;
      }

      /* Responsive: ẩn sidebar ở mobile, bỏ margin-left */
      @media (max-width: 991px) {
        .rx-page .rx-sidebar { display: none; }
        .rx-page .rx-content { margin-left: 0 !important; }
      }

      /* Chặn tình trạng trắng trang khi AOS chưa init */
      .rx-page .section,
      .rx-page [data-aos] {
        opacity: 1 !important;
        visibility: visible !important;
        transform: none !important;
      }
    </style>
  </head>

  <body class="rx-page <%= hasSidebar ? "has-sidebar" : "" %>">

    <!-- Header cố định dùng chung -->
    <jsp:include page="/includes/header.jsp" />

    <!-- LAYOUT -->
    <main class="rx-main">
      <div class="rx-layout">

        <% if (showDoctor) { %>
          <div class="rx-sidebar">
            <jsp:include page="/includes/sidebar-doctor.jsp" />
          </div>
        <% } %>

        <div class="rx-content">
          <!-- Thông báo -->
          <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert">
              <i class="fas fa-${sessionScope.messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
              ${sessionScope.message}
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="message" scope="session"/>
            <c:remove var="messageType" scope="session"/>
          </c:if>

          <!-- Header actions -->
          <div class="rx-card">
            <div class="rx-header-actions">
              <h5 class="rx-title"><i class="fas fa-list"></i> Danh sách đơn thuốc</h5>

              <div class="rx-search">
                <form class="d-flex gap-2" method="get" action="medical-report">
                  <input type="hidden" name="action" value="list">
                  <input type="text" name="keyword" class="form-control" style="width:220px"
                         placeholder="Tìm bệnh nhân hoặc ngày (YYYY-MM-DD)" value="${keyword}">
                  <select name="filterType" class="form-select" style="width:180px">
                    <option value="all" ${filterType == 'all' ? 'selected' : ''}>Tất cả</option>
                    <option value="hasTest" ${filterType == 'hasTest' ? 'selected' : ''}>Có xét nghiệm</option>
                    <option value="noTest" ${filterType == 'noTest' ? 'selected' : ''}>Không xét nghiệm</option>
                  </select>
                  <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Tìm kiếm
                  </button>
                </form>
              </div>

              <% if (showDoctor) { %>
                <a href="medical-report?action=add" class="btn btn-success">
                  <i class="fas fa-plus"></i> Thêm đơn thuốc
                </a>
              <% } %>
            </div>
          </div>

          <!-- Bảng -->
          <div class="rx-card">
            <div class="table-responsive">
              <table class="table table-hover align-middle">
                <thead>
                  <tr>
                    <th>Mã hồ sơ</th>
                    <th>Bệnh nhân</th>
                    <th>Ngày khám</th>
                    <th>Chẩn đoán</th>
                    <th>Đơn thuốc</th>
                    <th>Xét nghiệm</th>
                    <% if (showDoctor) { %><th>Thao tác</th><% } %>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="report" items="${reports}">
                    <tr>
                      <td><span class="badge text-bg-light">#${report.recordId}</span></td>
                      <td><i class="fas fa-user-injured text-primary"></i> ${report.patientName}</td>
                      <td><i class="far fa-calendar"></i> ${report.appointmentDate}</td>
                      <td>
                        <span class="text-truncate d-inline-block" style="max-width: 220px;" title="${report.diagnosis}">
                          ${report.diagnosis}
                        </span>
                      </td>
                      <td>
                        <span class="text-truncate d-inline-block" style="max-width: 280px;" title="${report.prescription}">
                          ${report.prescription}
                        </span>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${report.testRequest}">
                            <span class="badge text-bg-warning"><i class="fas fa-flask"></i> Có</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge text-bg-secondary">Không</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <% if (showDoctor) { %>
                      <td>
                        <div class="btn-group" role="group">
                          <a href="medical-report?action=view&id=${report.recordId}"
                             class="btn btn-info btn-action" title="Xem chi tiết">
                            <i class="fas fa-eye"></i>
                          </a>
                          <a href="medical-report?action=edit&id=${report.recordId}"
                             class="btn btn-warning btn-action" title="Chỉnh sửa">
                            <i class="fas fa-edit"></i>
                          </a>
                          <a href="testresult?action=list&recordId=${report.recordId}"
                             class="btn btn-outline-secondary btn-action" title="Xem xét nghiệm">
                            <i class="fas fa-vial"></i>
                          </a>
                          <button type="button" class="btn btn-danger btn-action"
                                  onclick="confirmDelete(${report.recordId})" title="Xóa">
                            <i class="fas fa-trash"></i>
                          </button>
                        </div>
                      </td>
                      <% } %>
                    </tr>
                  </c:forEach>

                  <c:if test="${empty reports}">
                    <tr>
                      <td colspan="<%= showDoctor ? 7 : 6 %>" class="table-empty">
                        <i class="fas fa-inbox" style="font-size: 46px; display:block; margin-bottom: 10px;"></i>
                        Chưa có đơn thuốc nào
                      </td>
                    </tr>
                  </c:if>
                </tbody>
              </table>

              <!-- Phân trang -->
              <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                  <ul class="pagination justify-content-center mt-3">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                      <a class="page-link"
                         href="medical-report?action=list&page=${currentPage-1}&keyword=${keyword}&filterType=${filterType}">
                        &laquo; Trước
                      </a>
                    </li>

                    <c:forEach begin="1" end="${totalPages}" var="p">
                      <li class="page-item ${p == currentPage ? 'active' : ''}">
                        <a class="page-link"
                           href="medical-report?action=list&page=${p}&keyword=${keyword}&filterType=${filterType}">
                          ${p}
                        </a>
                      </li>
                    </c:forEach>

                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                      <a class="page-link"
                         href="medical-report?action=list&page=${currentPage+1}&keyword=${keyword}&filterType=${filterType}">
                        Sau &raquo;
                      </a>
                    </li>
                  </ul>
                </nav>
              </c:if>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- Modal xác nhận xóa (chỉ cho bác sĩ) -->
    <% if (showDoctor) { %>
    <div class="modal fade" id="deleteModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header bg-danger text-white">
            <h5 class="modal-title"><i class="fas fa-exclamation-triangle"></i> Xác nhận xóa</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <p>Bạn có chắc chắn muốn xóa đơn thuốc này không?</p>
            <p class="text-danger"><strong>Lưu ý:</strong> Hành động này không thể hoàn tác!</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
              <i class="fas fa-trash"></i> Xóa
            </a>
          </div>
        </div>
      </div>
    </div>
    <% } %>

    <!-- JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
      function confirmDelete(recordId) {
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        document.getElementById('confirmDeleteBtn').href = 'medical-report?action=delete&id=' + recordId;
        deleteModal.show();
      }
      // Tự ẩn alert
      setTimeout(function () {
        const alert = document.querySelector('.alert');
        if (alert) {
          alert.classList.remove('show');
          setTimeout(() => alert.remove(), 150);
        }
      }, 5000);

      // Nếu AOS có sẵn thì init (tránh trắng trang khi chưa cache)
      if (window.AOS && typeof AOS.init === 'function') {
        AOS.init({ once: true, duration: 600 });
      }
    </script>
  </body>
</html>
