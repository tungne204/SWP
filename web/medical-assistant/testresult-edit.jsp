<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
    boolean showMA = (acc != null && acc.getRoleId() == 4); // Trợ lý xét nghiệm
%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <%@ include file="../includes/head-includes.jsp" %>
    <title>Chỉnh sửa kết quả xét nghiệm</title>
    <style>
      /* ===== Scope riêng cho trang EDIT ===== */
      .tr-edit {
        --sidebar-width: 280px;
        --header-height: 80px;
        --bg: #f8f9fa;
        margin: 0;
        background-color: var(--bg);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      }

      /* Đệm phía trên để tránh đè header fixed của site */
      .tr-edit .tr-main { padding-top: var(--header-height); }

      /* LAYOUT */
      .tr-edit .tr-layout {
        display: flex;
        min-height: calc(100vh - var(--header-height));
      }

      /* Sidebar cố định giống Home */
      .tr-edit .tr-sidebar {
        width: var(--sidebar-width);
        background: #ffffff;
        border-right: 1px solid #dee2e6;
        position: fixed;
        top: var(--header-height);
        left: 0;
        height: calc(100vh - var(--header-height));
        overflow-y: auto;
        z-index: 1000;
        box-shadow: 2px 0 10px rgba(0,0,0,0.06);
      }

      /* Nội dung chính */
      .tr-edit .tr-content {
        flex: 1;
        padding: 40px 24px;
        min-height: calc(100vh - var(--header-height));
      }
      /* Chỉ đẩy khi có sidebar */
      .tr-edit.has-sidebar .tr-content { margin-left: var(--sidebar-width); }

      /* CARD */
      .tr-edit .tr-card {
        max-width: 800px;
        margin: 0 auto;
        background: #fff;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }

      .tr-edit h1 {
        color: #2c3e50;
        margin-bottom: 24px;
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .tr-edit .info-box {
        background: #e8f4f8;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        border-left: 4px solid #3498db;
      }
      .tr-edit .info-box p { margin: 5px 0; color: #2c3e50; }
      .tr-edit .info-box strong { color: #3498db; }

      .tr-edit .form-group { margin-bottom: 20px; }
      .tr-edit label {
        display: block;
        margin-bottom: 8px;
        color: #34495e;
        font-weight: 600;
      }
      .tr-edit label .required { color: #e74c3c; }

      .tr-edit input[type="text"],
      .tr-edit input[type="date"],
      .tr-edit input[type="number"],
      .tr-edit select,
      .tr-edit textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 14px;
        transition: border-color 0.3s;
        background: #fff;
      }
      .tr-edit input:focus,
      .tr-edit select:focus,
      .tr-edit textarea:focus {
        outline: none;
        border-color: #3498db;
      }
      .tr-edit textarea { resize: vertical; min-height: 100px; }

      .tr-edit .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        transition: all 0.3s;
        font-weight: 600;
      }
      .tr-edit .btn-primary { background: #3498db; color: #fff; }
      .tr-edit .btn-primary:hover { background: #2980b9; }
      .tr-edit .btn-secondary { background: #95a5a6; color: #fff; }
      .tr-edit .btn-secondary:hover { background: #7f8c8d; }

      .tr-edit .form-actions {
        display: flex;
        gap: 10px;
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid #ddd;
      }

      .tr-edit .help-text {
        font-size: 13px;
        color: #7f8c8d;
        margin-top: 5px;
      }

      /* Dropdown menu nổi trên form khi mở từ header */
      .tr-edit .dropdown-menu { z-index: 1050; }

      /* Responsive */
      @media (max-width: 991px) {
        .tr-edit .tr-sidebar { display: none; }
        .tr-edit .tr-content { margin-left: 0 !important; padding: 20px 16px; }
        .tr-edit .form-actions { flex-direction: column; }
        .tr-edit .btn { width: 100%; justify-content: center; }
      }
    </style>
  </head>
  <body class="tr-edit <%= showMA ? "has-sidebar" : "" %>">
    <!-- Header chung (đã fixed trong header.jsp) -->
    <jsp:include page="../includes/header.jsp" />

    <main class="tr-main">
      <div class="tr-layout">
        <% if (showMA) { %>
          <div class="tr-sidebar">
            <jsp:include page="../includes/sidebar-medicalassistant.jsp" />
          </div>
        <% } %>

        <div class="tr-content">
          <div class="tr-card">
            <h1><i class="fas fa-edit"></i> Chỉnh sửa kết quả xét nghiệm</h1>

            <div class="info-box">
              <p><strong>Bệnh nhân:</strong> ${testResult.patientName}</p>
              <p><strong>Bác sĩ:</strong> ${testResult.doctorName}</p>
              <p><strong>Chẩn đoán:</strong> ${testResult.diagnosis}</p>
            </div>

            <form action="testresult" method="post">
              <input type="hidden" name="action" value="update" />
              <input type="hidden" name="testId" value="${testResult.testId}" />

              <div class="form-group">
                <label for="recordId">Hồ sơ y tế <span class="required">*</span></label>
                <select id="recordId" name="recordId" required>
                  <c:forEach var="report" items="${medicalReports}">
                    <option value="${report.recordId}"
                      ${report.recordId == testResult.recordId ? 'selected' : ''}>
                      Hồ sơ #${report.recordId} - ${report.patientName} (${report.diagnosis})
                    </option>
                  </c:forEach>
                </select>
                <div class="help-text">Hồ sơ y tế gắn với xét nghiệm này</div>
              </div>

              <div class="form-group">
                <label for="testType">Loại xét nghiệm <span class="required">*</span></label>
                <select id="testType" name="testType" required>
                  <option value="">-- Chọn loại xét nghiệm --</option>
                  <c:forEach var="type" items="${testTypes}">
                    <option value="${type}" ${type == testResult.testType ? 'selected' : ''}>${type}</option>
                  </c:forEach>
                </select>
                <div class="help-text">Danh sách loại xét nghiệm được lấy tự động từ cơ sở dữ liệu</div>
                <div class="help-text">Chọn đúng loại xét nghiệm đã thực hiện</div>
              </div>

              <div class="form-group">
                <label for="result">Kết quả xét nghiệm <span class="required">*</span></label>
                <textarea id="result" name="result" maxlength="50" required>${testResult.result}</textarea>
                <div class="help-text">Nhập đầy đủ kết quả và ghi chú chuyên môn liên quan</div>
              </div>

              <div class="form-group">
                <label for="date">Ngày xét nghiệm <span class="required">*</span></label>
                <input
                  type="date"
                  id="date"
                  name="date"
                  value="<fmt:formatDate value='${testResult.date}' pattern='yyyy-MM-dd'/>"
                  required
                />
                <div class="help-text">Ngày thực hiện xét nghiệm</div>
              </div>

              <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                  <i class="fas fa-save"></i> Cập nhật kết quả
                </button>
                <a href="testresult?action=list" class="btn btn-secondary">
                  <i class="fas fa-times"></i> Hủy
                </a>
              </div>
            </form>
          </div>
        </div>
      </div>
    </main>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
      crossorigin="anonymous"></script>
  </body>
</html>
