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
    <title>${report != null ? 'Chỉnh sửa' : 'Thêm mới'} đơn thuốc - Medilab</title>

    <!-- Bootstrap + FontAwesome (đồng bộ với trang danh sách) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- Dùng chung với Home (AOS/glightbox/...): tuyệt đối đường dẫn -->
    <jsp:include page="/includes/head-includes.jsp"/>

    <style>
      /* ===== Scope riêng cho trang form đơn thuốc: KHÔNG ảnh hưởng header/sidebar ===== */
      .rx-page {
        margin: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #f5f6fa;
      }

      /* Đẩy nội dung xuống dưới header fixed (~80px) */
      .rx-page .rx-main { padding-top: 80px; }

      /* Layout chính */
      .rx-page .rx-layout {
        display: flex;
        min-height: calc(100vh - 80px);
      }

      /* Sidebar trái như trang danh sách */
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
        box-shadow: 2px 0 10px rgba(0,0,0,0.06);
      }

      /* Nội dung chính; chỉ đẩy phải khi có sidebar */
      .rx-page .rx-content {
        flex: 1;
        min-height: calc(100vh - 80px);
        padding: 24px;
      }
      .rx-page.has-sidebar .rx-content { margin-left: 280px; }

      /* Card bọc */
      .rx-page .rx-card {
        background: #ffffff;
        border-radius: 10px;
        border: none;
        box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        margin-bottom: 22px;
      }
      .rx-page .rx-card .card-header {
        background: #34495e;
        color: #fff;
        border-radius: 10px 10px 0 0;
        padding: 14px 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 700;
      }
      .rx-page .rx-card .card-body {
        background: #fcfcfc;
        padding: 22px 25px;
      }

      /* Header khu vực (breadcrumb + tiêu đề) */
      .rx-page .rx-form-header {
        background: #fff;
        border-left: 6px solid #3498db;
        border-radius: 10px;
        padding: 20px 22px;
        margin-bottom: 22px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        color: #34495e;
      }
      .rx-page .rx-form-header h1 {
        margin: 0;
        font-size: 1.6rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #2c3e50;
      }
      .rx-page .rx-form-header .breadcrumb { margin: 8px 0 0 0; }
      .rx-page .rx-form-header .breadcrumb a { color: #3498db; text-decoration: none; }
      .rx-page .rx-form-header .breadcrumb a:hover { color: #2c3e50; }

      /* Form */
      .rx-page .form-label {
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 6px;
        display: flex;
        align-items: center;
        gap: 6px;
      }
      .rx-page .form-label i { color: #3498db; }
      .rx-page .required::after { content: " *"; color: #e74c3c; }

      .rx-page .form-control,
      .rx-page .form-select {
        border: 2px solid #e3e6ea;
        border-radius: 8px;
        padding: 10px 14px;
        transition: all 0.3s ease;
      }
      .rx-page .form-control:focus,
      .rx-page .form-select:focus {
        border-color: #3498db;
        box-shadow: 0 0 0 0.15rem rgba(52, 152, 219, 0.25);
      }
      .rx-page textarea.form-control { min-height: 120px; resize: vertical; }
      .rx-page .form-text { color: #7f8c8d; font-size: 0.9rem; margin-top: 6px; }

      /* Alert */
      .rx-page .alert-info {
        background: #eaf3fc; color: #2c3e50;
        border-left: 4px solid #3498db; border-radius: 8px; padding: 1rem 1.4rem;
      }
      .rx-page .alert-warning {
        background: #fff3cd; color: #856404;
        border-left: 4px solid #f1c40f; border-radius: 8px; padding: 1rem 1.4rem;
      }

      /* Buttons */
      .rx-page .btn { border: none; border-radius: 6px; font-weight: 500; padding: 8px 16px; display: inline-flex; align-items: center; gap: 8px; transition: all .25s ease; }
      .rx-page .btn-primary { background: #3498db; color: #fff; }
      .rx-page .btn-primary:hover { background: #2980b9; }
      .rx-page .btn-secondary { background: #7f8c8d; color: #fff; }
      .rx-page .btn-secondary:hover { background: #636e72; }

      /* Guide */
      .rx-page .guide-section { background: #f8f9fa; border-radius: 8px; padding: 1rem; }
      .rx-page .guide-section h6 { font-weight: 600; color: #34495e; }
      .rx-page .guide-example {
        background: #fff; border: 1px solid #e3e6ea; border-radius: 6px; padding: 1rem;
        font-family: 'Courier New', monospace; line-height: 1.6; font-size: 0.9rem;
      }

      /* Responsive: ẩn sidebar ở mobile, bỏ margin-left */
      @media (max-width: 991px) {
        .rx-page .rx-sidebar { display: none; }
        .rx-page .rx-content { margin-left: 0 !important; }
      }

      /* Chặn trắng trang khi AOS chưa init */
      .rx-page .section, .rx-page [data-aos] {
        opacity: 1 !important; visibility: visible !important; transform: none !important;
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
          <!-- Thông báo (nếu có) -->
          <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert">
              <i class="fas fa-${sessionScope.messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
              ${sessionScope.message}
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="message" scope="session"/>
            <c:remove var="messageType" scope="session"/>
          </c:if>

          <!-- Header form -->
          <div class="rx-form-header">
            <h1><i class="fas fa-file-medical"></i> ${report != null ? 'Chỉnh sửa' : 'Thêm mới'} đơn thuốc</h1>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="medical-report?action=list"><i class="fas fa-list"></i> Danh sách</a></li>
                <li class="breadcrumb-item active" aria-current="page">${report != null ? 'Chỉnh sửa' : 'Thêm mới'}</li>
              </ol>
            </nav>
          </div>

          <!-- Form đơn thuốc -->
          <div class="card rx-card">
            <div class="card-header"><i class="fas fa-clipboard-list"></i> Thông tin đơn thuốc</div>
            <div class="card-body">
              <form action="medical-report" method="post" id="medicalReportForm">
                <input type="hidden" name="action" value="${report != null ? 'update' : 'insert'}">
                <c:if test="${report != null}">
                  <input type="hidden" name="recordId" value="${report.recordId}">
                </c:if>

                <!-- Chọn appointment (chỉ khi thêm mới) -->
                <c:if test="${report == null}">
                  <div class="mb-4">
                    <label class="form-label required"><i class="fas fa-calendar-check"></i> Chọn lịch khám</label>
                    <select class="form-select" name="appointmentId" required>
                      <option value="">-- Chọn lịch khám --</option>
                      <c:forEach var="apt" items="${appointments}">
                        <option value="${apt.appointmentId}">#${apt.appointmentId} - ${apt.patientName} - ${apt.dateTime}</option>
                      </c:forEach>
                    </select>
                    <c:if test="${empty appointments}">
                      <div class="alert alert-warning mt-2">
                        <i class="fas fa-info-circle me-2"></i> Không có lịch khám nào chưa có đơn thuốc
                      </div>
                    </c:if>
                  </div>
                </c:if>

                <!-- Thông tin bệnh nhân (khi chỉnh sửa) -->
                <c:if test="${report != null}">
                  <div class="row mb-4">
                    <div class="col-md-6">
                      <div class="alert alert-info">
                        <strong><i class="fas fa-user-injured me-2"></i>Bệnh nhân:</strong> ${report.patientName}
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="alert alert-info">
                        <strong><i class="far fa-calendar me-2"></i>Ngày khám:</strong> ${report.appointmentDate}
                      </div>
                    </div>
                  </div>
                </c:if>

                <!-- Chẩn đoán -->
                <div class="mb-4">
                  <label class="form-label required"><i class="fas fa-stethoscope"></i> Chẩn đoán</label>
                  <textarea class="form-control" name="diagnosis" maxlength="255" required>${report != null ? report.diagnosis : ''}</textarea>
                  <div class="form-text">Mô tả tình trạng bệnh của bệnh nhân.</div>
                </div>

                <!-- Đơn thuốc -->
                <div class="mb-4">
                  <label class="form-label required"><i class="fas fa-prescription"></i> Đơn thuốc</label>
                  <textarea class="form-control" name="prescription" maxlength="255" required>${report != null ? report.prescription : ''}</textarea>
                  <div class="form-text">Ghi rõ tên thuốc, liều lượng, cách dùng.</div>
                </div>

                <!-- Yêu cầu xét nghiệm -->
                <div class="mb-4">
                  <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" name="testRequest" ${report != null && report.testRequest ? 'checked' : ''}>
                    <label class="form-check-label"><i class="fas fa-flask me-2"></i>Yêu cầu xét nghiệm</label>
                  </div>
                </div>

                <!-- Buttons -->
                <div class="d-flex justify-content-between mt-4 pt-3 border-top">
                  <a href="medical-report?action=list" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Quay lại</a>
                  <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> ${report != null ? 'Cập nhật' : 'Thêm mới'}</button>
                </div>
              </form>
            </div>
          </div>

          <!-- Hướng dẫn kê đơn -->
          <div class="card rx-card">
            <div class="card-header"><i class="fas fa-info-circle"></i> Hướng dẫn kê đơn</div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-6 mb-3 mb-md-0">
                  <div class="guide-section">
                    <h6><i class="fas fa-check-circle me-2"></i>Lưu ý:</h6>
                    <ul class="small mb-0">
                      <li>Ghi rõ tên thuốc, liều lượng</li>
                      <li>Kiểm tra dị ứng thuốc trước khi kê</li>
                      <li>Không kê thuốc trùng hoạt chất</li>
                    </ul>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="guide-section">
                    <h6><i class="fas fa-lightbulb me-2"></i>Mẫu kê đơn:</h6>
                    <div class="guide-example">
                      1. Paracetamol 500mg - 1 viên x 3 lần/ngày<br>
                      2. Amoxicillin 250mg - 1 viên x 2 lần/ngày<br>
                      3. Siro ho - 5ml x 3 lần/ngày
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div><!-- /.rx-content -->
      </div><!-- /.rx-layout -->
    </main>

    <!-- JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Tự ẩn alert sau 5s (nếu có)
      setTimeout(function () {
        const alert = document.querySelector('.alert');
        if (alert) {
          alert.classList.remove('show');
          setTimeout(() => alert.remove(), 150);
        }
      }, 5000);

      // Nếu AOS có sẵn thì init (đồng bộ trang danh sách)
      if (window.AOS && typeof AOS.init === 'function') {
        AOS.init({ once: true, duration: 600 });
      }
    </script>
  </body>
</html>
