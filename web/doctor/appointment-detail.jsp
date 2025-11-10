<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chi tiết lịch hẹn #${appointment.appointmentId} - Medilab</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap"
      rel="stylesheet"
    />

    <style>
      :root {
        --primary-color: #3fbbc0;
        --secondary-color: #2a9ca1;
        --dark-color: #2c4964;
        --light-bg: #f8f9fa;
        --success-color: #4caf50;
        --warning-color: #ffc107;
        --danger-color: #dc3545;
        --info-color: #17a2b8;
      }

      * {
        font-family: "Roboto", sans-serif;
      }

      body {
        background-color: var(--light-bg);
        color: #444444;
      }

      /* Header Section */
      .header-section {
        background: linear-gradient(
          135deg,
          var(--primary-color) 0%,
          var(--secondary-color) 100%
        );
        color: white;
        padding: 2.5rem 0 2rem;
        margin-bottom: 2rem;
        box-shadow: 0 4px 15px rgba(63, 187, 192, 0.3);
      }

      .header-section h1 {
        font-family: "Poppins", sans-serif;
        font-weight: 600;
        font-size: 2rem;
        margin-bottom: 1rem;
      }

      .breadcrumb {
        background: transparent;
        padding: 0;
        margin: 0;
      }

      .breadcrumb-item a {
        color: white;
        text-decoration: none;
        transition: opacity 0.3s;
      }

      .breadcrumb-item a:hover {
        opacity: 0.8;
      }

      .breadcrumb-item.active {
        color: rgba(255, 255, 255, 0.7);
      }

      .breadcrumb-item + .breadcrumb-item::before {
        color: rgba(255, 255, 255, 0.7);
      }

      /* Card Styling */
      .card {
        border: none;
        border-radius: 10px;
        box-shadow: 0 2px 20px rgba(0, 0, 0, 0.08);
        margin-bottom: 2rem;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
      }

      .card:hover {
        transform: translateY(-3px);
        box-shadow: 0 5px 30px rgba(0, 0, 0, 0.12);
      }

      .card-header {
        border: none;
        border-radius: 10px 10px 0 0 !important;
        padding: 1.25rem 1.5rem;
        font-family: "Poppins", sans-serif;
      }

      .card-header h5,
      .card-header h6 {
        font-weight: 500;
        margin: 0;
      }

      .card-header.bg-primary {
        background: linear-gradient(
          135deg,
          var(--primary-color),
          var(--secondary-color)
        ) !important;
      }

      .card-header.bg-info {
        background: linear-gradient(
          135deg,
          var(--info-color),
          #138496
        ) !important;
      }

      .card-header.bg-success {
        background: linear-gradient(
          135deg,
          var(--success-color),
          #388e3c
        ) !important;
      }

      .card-header.bg-secondary {
        background: linear-gradient(135deg, #6c757d, #5a6268) !important;
      }

      /* Alert Styling */
      .alert {
        border: none;
        border-radius: 10px;
        padding: 1.25rem 1.5rem;
        box-shadow: 0 2px 15px rgba(0, 0, 0, 0.08);
        border-left: 5px solid;
      }

      .alert-success {
        background-color: #d4edda;
        color: #155724;
        border-left-color: var(--success-color);
      }

      .alert-warning {
        background-color: #fff3cd;
        color: #856404;
        border-left-color: var(--warning-color);
      }

      .alert-heading {
        font-family: "Poppins", sans-serif;
        font-weight: 500;
        margin-bottom: 0.5rem;
      }

      /* Info Label & Value */
      .info-label {
        font-weight: 600;
        color: var(--dark-color);
        margin-bottom: 0.5rem;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }

      .info-label i {
        color: var(--primary-color);
        margin-right: 0.5rem;
      }

      .info-value {
        background-color: #f8f9fa;
        padding: 1rem 1.25rem;
        border-radius: 8px;
        border-left: 4px solid var(--primary-color);
        font-size: 1rem;
        color: #333;
        transition: all 0.3s ease;
      }

      .info-value:hover {
        background-color: #e9ecef;
        border-left-color: var(--secondary-color);
      }

      .info-value strong {
        color: var(--primary-color);
        font-weight: 600;
      }

      /* Button Styling */
      .btn {
        border-radius: 25px;
        padding: 0.6rem 1.5rem;
        font-weight: 500;
        transition: all 0.3s ease;
        border: none;
      }

      .btn i {
        margin-right: 0.5rem;
      }

      .btn-primary {
        background: linear-gradient(
          135deg,
          var(--primary-color),
          var(--secondary-color)
        );
      }

      .btn-primary:hover {
        background: linear-gradient(
          135deg,
          var(--secondary-color),
          var(--primary-color)
        );
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(63, 187, 192, 0.4);
      }

      .btn-success {
        background: linear-gradient(135deg, var(--success-color), #388e3c);
      }

      .btn-success:hover {
        background: linear-gradient(135deg, #388e3c, var(--success-color));
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(76, 175, 80, 0.4);
      }

      .btn-secondary {
        background: linear-gradient(135deg, #6c757d, #5a6268);
      }

      .btn-secondary:hover {
        background: linear-gradient(135deg, #5a6268, #6c757d);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(108, 117, 125, 0.4);
      }

      /* Badge Styling */
      .badge {
        border-radius: 20px;
        padding: 0.5rem 1.2rem;
        font-weight: 500;
        font-size: 0.9rem;
      }

      .badge.bg-success {
        background: linear-gradient(
          135deg,
          var(--success-color),
          #388e3c
        ) !important;
      }

      .badge.bg-warning {
        background: linear-gradient(
          135deg,
          var(--warning-color),
          #ff9800
        ) !important;
        color: #333 !important;
      }

      /* Medical Report Section */
      .medical-report-section {
        background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
        padding: 1.5rem;
        border-radius: 10px;
        border: 2px solid var(--success-color);
      }

      .medical-report-section h6 {
        font-family: "Poppins", sans-serif;
        font-weight: 600;
        margin-bottom: 1rem;
      }

      .medical-report-section h6 i {
        margin-right: 0.5rem;
      }

      .diagnosis-box {
        background: white;
        padding: 1.25rem;
        border-radius: 8px;
        border-left: 4px solid var(--success-color);
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
      }

      /* Action Buttons Section */
      .action-buttons {
        background: white;
        padding: 1.25rem;
        border-radius: 10px;
        box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
      }

      /* Guidelines Section */
      .guidelines-item {
        padding: 0.75rem;
        margin-bottom: 0.75rem;
        border-radius: 8px;
        background: #f8f9fa;
        transition: all 0.3s ease;
      }

      .guidelines-item:hover {
        background: #e9ecef;
        transform: translateX(5px);
      }

      .guidelines-item i {
        margin-right: 0.75rem;
        font-size: 1.1rem;
      }

      /* Animations */
      @keyframes fadeInUp {
        from {
          opacity: 0;
          transform: translateY(30px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .card {
        animation: fadeInUp 0.5s ease-out;
      }

      .card:nth-child(1) {
        animation-delay: 0.1s;
      }
      .card:nth-child(2) {
        animation-delay: 0.2s;
      }
      .card:nth-child(3) {
        animation-delay: 0.3s;
      }
      .card:nth-child(4) {
        animation-delay: 0.4s;
      }

      /* Responsive */
      @media (max-width: 768px) {
        .header-section h1 {
          font-size: 1.5rem;
        }

        .header-section {
          padding: 2rem 0 1.5rem;
        }

        .btn {
          padding: 0.5rem 1rem;
          font-size: 0.9rem;
        }

        .action-buttons .d-flex {
          flex-direction: column;
          gap: 1rem;
        }

        .action-buttons .d-flex > * {
          width: 100%;
        }
      }

      /* Text Colors */
      .text-primary-custom {
        color: var(--primary-color) !important;
      }

      .text-success-custom {
        color: var(--success-color) !important;
      }
    </style>
  </head>
  <body>
    <!-- Header -->
    <div class="header-section">
      <div class="container">
        <h1>
          <i class="fas fa-calendar-check"></i>
          Chi tiết lịch hẹn #${appointment.appointmentId}
        </h1>
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item">
              <a href="appointment?action=list">
                <i class="fas fa-home"></i> Danh sách lịch hẹn
              </a>
            </li>
            <li class="breadcrumb-item active">Chi tiết</li>
          </ol>
        </nav>
      </div>
    </div>

    <div class="container">
      <!-- Action buttons -->
      <div class="card">
        <div class="card-body action-buttons">
          <div class="d-flex justify-content-between align-items-center">
            <a href="appointment?action=list" class="btn btn-secondary">
              <i class="fas fa-arrow-left"></i> Quay lại
            </a>
            <div>
              <c:choose>
                <c:when test="${appointment.hasMedicalReport}">
                  <a
                    href="medical-report?action=view&id=${appointment.recordId}"
                    class="btn btn-success"
                  >
                    <i class="fas fa-prescription"></i> Xem đơn thuốc
                  </a>
                  <c:if test="${appointment.status == 'Completed'}">
                    <a
                      href="${pageContext.request.contextPath}/appointments/medical-record/${appointment.appointmentId}"
                      class="btn btn-primary"
                      target="_blank"
                    >
                      <i class="fas fa-print"></i> In hồ sơ bệnh án
                    </a>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <a
                    href="medical-report?action=add&appointmentId=${appointment.appointmentId}"
                    class="btn btn-primary"
                  >
                    <i class="fas fa-plus"></i> Kê đơn thuốc
                  </a>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>

      <!-- Status Card -->
      <div class="row">
        <div class="col-md-12">
          <c:choose>
            <c:when test="${appointment.hasMedicalReport}">
              <div class="alert alert-success">
                <h5 class="alert-heading">
                  <i class="fas fa-check-circle"></i> Đã khám xong
                </h5>
                <p class="mb-0">
                  Bệnh nhân đã được khám và kê đơn thuốc.
                  <strong>Chẩn đoán:</strong> ${appointment.diagnosis}
                </p>
              </div>
            </c:when>
            <c:otherwise>
              <div class="alert alert-warning">
                <h5 class="alert-heading">
                  <i class="fas fa-clock"></i> Chờ khám
                </h5>
                <p class="mb-0">
                  Bệnh nhân chưa được khám. Vui lòng thực hiện khám và kê đơn
                  thuốc.
                </p>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="row">
        <!-- Thông tin bệnh nhân -->
        <div class="col-md-6">
          <div class="card">
            <div class="card-header bg-primary text-white">
              <h5><i class="fas fa-child"></i> Thông tin bệnh nhân</h5>
            </div>
            <div class="card-body">
              <div class="mb-3">
                <div class="info-label">
                  <i class="fas fa-user"></i> Họ và tên
                </div>
                <div class="info-value">${appointment.patientName}</div>
              </div>
              <div class="mb-3">
                <div class="info-label">
                  <i class="fas fa-birthday-cake"></i> Ngày sinh
                </div>
                <div class="info-value">
                  <fmt:parseDate
                    value="${appointment.patientDob}"
                    pattern="yyyy-MM-dd"
                    var="parsedDob"
                  />
                  <fmt:formatDate value="${parsedDob}" pattern="dd/MM/yyyy" />
                </div>
              </div>
              <div class="mb-3">
                <div class="info-label">
                  <i class="fas fa-users"></i> Phụ huynh
                </div>
                <div class="info-value">
                  <c:choose>
                    <c:when test="${not empty appointment.parentName}">
                      ${appointment.parentName}
                    </c:when>
                    <c:otherwise>
                      <span class="text-muted">Chưa có thông tin</span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
              <div class="mb-3">
                <div class="info-label">
                  <i class="fas fa-map-marker-alt"></i> Địa chỉ
                </div>
                <div class="info-value">${appointment.patientAddress}</div>
              </div>
              <div class="mb-3">
                <div class="info-label">
                  <i class="fas fa-id-card"></i> Bảo hiểm y tế
                </div>
                <div class="info-value">
                  <c:choose>
                    <c:when test="${not empty appointment.patientInsurance}">
                      ${appointment.patientInsurance}
                    </c:when>
                    <c:otherwise>
                      <span class="text-muted">Không có BHYT</span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Thông tin lịch hẹn -->
        <div class="col-md-6">
          <div class="card">
            <div class="card-header bg-info text-white">
              <h5><i class="fas fa-calendar-alt"></i> Thông tin lịch hẹn</h5>
            </div>
            <div class="card-body">
              <div class="mb-3">
                <div class="info-label">
                  <i class="fas fa-hashtag"></i> Mã lịch hẹn
                </div>
                <div class="info-value">
                  <strong>#${appointment.appointmentId}</strong>
                </div>
              </div>
              <div class="mb-3">
                <div class="info-label">
                  <i class="far fa-calendar"></i> Ngày khám
                </div>
                <div class="info-value">
                  <fmt:formatDate
                    value="${appointment.dateTime}"
                    pattern="dd/MM/yyyy"
                  />
                </div>
              </div>
              <div class="mb-3">
                <div class="info-label">
                  <i class="far fa-clock"></i> Giờ khám
                </div>
                <div class="info-value">
                  <fmt:formatDate
                    value="${appointment.dateTime}"
                    pattern="HH:mm"
                  />
                </div>
              </div>
              <div class="mb-3">
                <div class="info-label">
                  <i class="fas fa-user-md"></i> Bác sĩ khám
                </div>
                <div class="info-value">BS. ${appointment.doctorName}</div>
              </div>
              <div class="mb-3">
                <div class="info-label">
                  <i class="fas fa-stethoscope"></i> Chuyên khoa
                </div>
                <div class="info-value">${appointment.doctorSpecialty}</div>
              </div>
              <div class="mb-3">
                <div class="info-label">
                  <i class="fas fa-info-circle"></i> Trạng thái
                </div>
                <div class="info-value">
                  <c:choose>
                    <c:when test="${appointment.hasMedicalReport}">
                      <span class="badge bg-success fs-6">
                        <i class="fas fa-check"></i> Đã khám
                      </span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-warning fs-6">
                        <i class="fas fa-clock"></i> Chờ khám
                      </span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Medical Report Info (nếu có) -->
      <c:if test="${appointment.hasMedicalReport}">
        <div class="card">
          <div class="card-header bg-success text-white">
            <h5><i class="fas fa-file-medical"></i> Thông tin khám bệnh</h5>
          </div>
          <div class="card-body medical-report-section">
            <div class="row">
              <div class="col-md-6">
                <h6 class="text-success-custom">
                  <i class="fas fa-notes-medical"></i> Chẩn đoán:
                </h6>
                <p class="diagnosis-box">${appointment.diagnosis}</p>
              </div>
              <div class="col-md-6">
                <h6 class="text-primary-custom">
                  <i class="fas fa-prescription"></i> Đơn thuốc:
                </h6>
                <a
                  href="medical-report?action=view&id=${appointment.recordId}"
                  class="btn btn-success"
                >
                  <i class="fas fa-eye"></i> Xem đầy đủ đơn thuốc
                </a>
              </div>
            </div>
          </div>
        </div>
      </c:if>

      <!-- Hướng dẫn -->
      <div class="card">
        <div class="card-header bg-secondary text-white">
          <h6><i class="fas fa-info-circle"></i> Hướng dẫn</h6>
        </div>
        <div class="card-body">
          <c:choose>
            <c:when test="${appointment.hasMedicalReport}">
              <div class="guidelines-item">
                <i class="fas fa-check text-success-custom"></i>
                Bệnh nhân đã được khám và có đơn thuốc.
              </div>
              <div class="guidelines-item">
                <i class="fas fa-info-circle text-primary-custom"></i>
                Bạn có thể xem lại đơn thuốc hoặc kết quả xét nghiệm (nếu có).
              </div>
            </c:when>
            <c:otherwise>
              <div class="guidelines-item">
                <i class="fas fa-arrow-right text-primary-custom"></i>
                Click nút "Kê đơn thuốc" để thực hiện khám bệnh.
              </div>
              <div class="guidelines-item">
                <i class="fas fa-arrow-right text-primary-custom"></i>
                Sau khi khám xong, đơn thuốc sẽ được lưu vào hệ thống.
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
