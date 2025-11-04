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
    <title>Chi tiết đơn thuốc #${report.recordId} - Medilab</title>

    <!-- Bootstrap + FontAwesome giống trang danh sách -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Dùng chung với Home (AOS/glightbox/...) -->
    <jsp:include page="/includes/head-includes.jsp"/>

    <style>
      /* ===== Scope RIÊNG cho trang "chi tiết đơn thuốc" — không đụng header/sidebar ===== */
      .rx-page {
        margin: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #f5f6fa;
      }

      /* Đẩy nội dung xuống dưới header cố định (~80px) */
      .rx-page .rx-main {
        padding-top: 80px;
      }

      /* Layout chính */
      .rx-page .rx-layout {
        display: flex;
        min-height: calc(100vh - 80px);
      }

      /* Sidebar: y như trang danh sách (giữ nguyên class & include) */
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
      .rx-page.has-sidebar .rx-content {
        margin-left: 280px;
      }

      /* Card chuẩn */
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
      .rx-page .rx-detail-header {
        background: #fff;
        border-left: 6px solid #3498db;
        border-radius: 10px;
        padding: 20px 22px;
        margin-bottom: 22px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        color: #34495e;
      }
      .rx-page .rx-detail-header h1 {
        margin: 0;
        font-size: 1.6rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #2c3e50;
      }
      .rx-page .rx-detail-header .breadcrumb {
        margin: 8px 0 0 0;
      }
      .rx-page .rx-detail-header .breadcrumb a {
        color: #3498db;
        text-decoration: none;
      }
      .rx-page .rx-detail-header .breadcrumb a:hover {
        color: #2c3e50;
      }

      /* Label/Value */
      .rx-page .info-label {
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 6px;
        display: flex;
        align-items: center;
        gap: 6px;
      }
      .rx-page .info-label i {
        color: #3498db;
      }
      .rx-page .info-value {
        background: #f8fafc;
        border-left: 4px solid #3498db;
        border-radius: 6px;
        padding: 10px 14px;
        font-size: 15px;
        color: #2c3e50;
      }

      /* Prescription */
      .rx-page .prescription-box {
        background: #fdfefe;
        border: 1px solid #e3e8ee;
        border-radius: 8px;
        padding: 16px;
        white-space: pre-line;
        line-height: 1.7;
        color: #2c3e50;
      }

      /* Badge */
      .rx-page .badge.bg-warning { background-color: #f39c12 !important; color: #fff !important; }

      /* Nút */
      .rx-page .btn {
        border: none;
        border-radius: 6px;
        font-weight: 500;
        padding: 8px 16px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all .25s ease;
      }
      .rx-page .btn-primary { background: #3498db; color: #fff; }
      .rx-page .btn-primary:hover { background: #2980b9; }
      .rx-page .btn-success { background: #27ae60; color: #fff; }
      .rx-page .btn-success:hover { background: #229954; }
      .rx-page .btn-secondary { background: #7f8c8d; color: #fff; }
      .rx-page .btn-secondary:hover { background: #636e72; }

      /* Bảng kết quả XN */
      .rx-page .table-striped>tbody>tr:nth-of-type(odd)>* {
        --bs-table-accent-bg: #fafbfc;
      }
      .rx-page .table thead th { background: #fff; color: #000; }

      /* Tránh trắng trang nếu AOS/glightbox đang lazy */
      .rx-page .section, .rx-page [data-aos] {
        opacity: 1 !important; visibility: visible !important; transform: none !important;
      }

      /* Responsive */
      @media (max-width: 991px) {
        .rx-page .rx-sidebar { display: none; }
        .rx-page .rx-content { margin-left: 0 !important; }
      }

      /* In */
      @media print {
        .rx-page .no-print { display: none !important; }
        .rx-page, .rx-page .rx-content, .rx-page .rx-card { background: #fff; box-shadow: none; }
      }
    </style>
  </head>

  <body class="rx-page <%= hasSidebar ? "has-sidebar" : "" %>">
    <!-- Header cố định dùng chung (KHÔNG đổi) -->
    <jsp:include page="/includes/header.jsp" />

    <!-- Layout -->
    <main class="rx-main">
      <div class="rx-layout">

        <% if (showDoctor) { %>
          <div class="rx-sidebar">
            <jsp:include page="/includes/sidebar-doctor.jsp" />
          </div>
        <% } %>

        <div class="rx-content">
          <!-- Header section -->
          <div class="rx-detail-header">
            <h1><i class="fas fa-file-medical"></i> Chi tiết đơn thuốc</h1>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                  <a href="medical-report?action=list"><i class="fas fa-list"></i> Danh sách</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">Chi tiết</li>
              </ol>
            </nav>
          </div>

          <!-- Actions -->
          <div class="mb-3 no-print d-flex justify-content-between flex-wrap gap-3">
            <% if (showDoctor) { %>
              <div class="d-flex gap-2">
                <a href="medical-report?action=edit&id=${report.recordId}" class="btn btn-success">
                  <i class="fas fa-edit"></i> Chỉnh sửa
                </a>
                <button onclick="window.print()" class="btn btn-primary">
                  <i class="fas fa-print"></i> In đơn thuốc
                </button>
              </div>
            <% } %>
          </div>

          <!-- Patient & Doctor info -->
          <div class="row">
            <div class="col-md-6">
              <div class="card rx-card">
                <div class="card-header"><i class="fas fa-user-injured"></i> Thông tin bệnh nhân</div>
                <div class="card-body">
                  <div class="mb-3">
                    <div class="info-label">Mã hồ sơ</div>
                    <div class="info-value"><strong>#${report.recordId}</strong></div>
                  </div>
                  <div class="mb-3">
                    <div class="info-label">Họ và tên</div>
                    <div class="info-value">${report.patientName}</div>
                  </div>
                  <div>
                    <div class="info-label">Ngày khám</div>
                    <div class="info-value">${report.appointmentDate}</div>
                  </div>
                </div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="card rx-card">
                <div class="card-header"><i class="fas fa-user-md"></i> Thông tin bác sĩ</div>
                <div class="card-body">
                  <div class="mb-3">
                    <div class="info-label">Bác sĩ phụ trách</div>
                    <div class="info-value">BS. ${report.doctorName}</div>
                  </div>
                  <div>
                    <div class="info-label">Yêu cầu xét nghiệm</div>
                    <div class="info-value">
                      <c:choose>
                        <c:when test="${report.testRequest}">
                          <span class="badge bg-warning"><i class="fas fa-check-circle"></i> Có</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge bg-secondary"><i class="fas fa-times-circle"></i> Không</span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Diagnosis -->
          <div class="card rx-card">
            <div class="card-header"><i class="fas fa-stethoscope"></i> Chẩn đoán</div>
            <div class="card-body">
              <div class="info-value">${report.diagnosis}</div>
            </div>
          </div>

          <!-- Prescription -->
          <div class="card rx-card">
            <div class="card-header"><i class="fas fa-prescription"></i> Đơn thuốc</div>
            <div class="card-body">
              <div class="prescription-box">${report.prescription}</div>
              <div class="alert alert-info mt-4 no-print">
                <strong><i class="fas fa-info-circle"></i> Lưu ý:</strong>
                <ul class="mt-2 mb-0">
                  <li>Dùng thuốc đúng liều theo chỉ định</li>
                  <li>Không tự ý thay đổi liều</li>
                  <li>Bảo quản thuốc nơi khô ráo, tránh ánh nắng trực tiếp</li>
                  <li>Nếu có phản ứng bất thường, liên hệ bác sĩ ngay</li>
                  <li>Phụ huynh cần giám sát khi trẻ dùng thuốc</li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Test Results -->
          <div class="card rx-card">
            <div class="card-header"><i class="fas fa-vials"></i> Kết quả xét nghiệm</div>
            <div class="card-body">
              <c:choose>
                <c:when test="${empty testResults}">
                  <div class="alert alert-info mb-0">
                    Chưa có kết quả xét nghiệm cho hồ sơ này.
                    <c:if test="${report.testRequest}">
                      <a class="btn btn-sm btn-primary ms-2"
                         href="testresult?action=add&recordId=${report.recordId}">
                        <i class="fas fa-plus"></i> Thêm kết quả
                      </a>
                    </c:if>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="table-responsive">
                    <table class="table table-striped align-middle">
                      <thead>
                        <tr>
                          <th>#</th>
                          <th>Loại XN</th>
                          <th>Kết quả</th>
                          <th>Ngày</th>
                          <th>Consultation ID</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="r" items="${testResults}" varStatus="st">
                          <tr>
                            <td>${st.index + 1}</td>
                            <td>${r.testType}</td>
                            <td>${r.result}</td>
                            <td>${r.date}</td>
                            <td><c:out value="${r.consultationId}"/></td>
                          </tr>
                        </c:forEach>
                      </tbody>
                    </table>
                  </div>

                  <div class="d-flex gap-2">
                    <a class="btn btn-primary" href="testresult?action=list&recordId=${report.recordId}">
                      <i class="fas fa-list"></i> Xem danh sách xét nghiệm
                    </a>
                    <c:if test="${report.testRequest}">
                      <%-- Bật nếu muốn thêm nhanh tại đây
                      <a class="btn btn-success" href="testresult?action=add&recordId=${report.recordId}">
                        <i class="fas fa-plus"></i> Thêm kết quả
                      </a> --%>
                    </c:if>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <!-- Print signatures -->
          <div class="card rx-card d-none d-print-block">
            <div class="card-body text-center">
              <div class="row mt-5">
                <div class="col-6">
                  <p><strong>Người nhận đơn</strong></p>
                  <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
                  <div style="height:80px;"></div>
                </div>
                <div class="col-6">
                  <p><strong>Bác sĩ khám bệnh</strong></p>
                  <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
                  <div style="height:80px;"></div>
                  <p><strong>BS. ${report.doctorName}</strong></p>
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
      // Nếu AOS có sẵn thì init (đồng bộ với trang danh sách)
      if (window.AOS && typeof AOS.init === 'function') {
        AOS.init({ once: true, duration: 600 });
      }
    </script>
  </body>
</html>
