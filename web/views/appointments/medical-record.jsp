<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ page import="entity.User" %> <%
User acc = (User) session.getAttribute("acc"); %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hồ sơ bệnh án - Medilab Pediatric Clinic</title>

    <jsp:include page="../../includes/head-includes.jsp" />

    <style>
      /* Print styles */
      @page {
        size: A4;
        margin: 1.5cm;
      }

      /* Medical record container styles */
      .medical-record-container {
        font-family: "Times New Roman", Times, serif;
        max-width: 21cm;
        margin: 20px auto;
        background: white;
        padding: 2cm;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }

      /* Header với logo */
      .record-header {
        text-align: center;
        border-bottom: 3px double #000;
        padding-bottom: 15px;
        margin-bottom: 20px;
      }

      .hospital-name {
        font-size: 14pt;
        font-weight: bold;
        text-transform: uppercase;
        margin: 5px 0;
      }

      .hospital-info {
        font-size: 11pt;
        margin: 3px 0;
      }

      .record-title {
        font-size: 18pt;
        font-weight: bold;
        text-transform: uppercase;
        margin: 20px 0;
        text-align: center;
      }

      .record-number {
        text-align: center;
        font-size: 11pt;
        margin-bottom: 20px;
      }

      /* Form sections */
      .form-section {
        margin: 15px 0;
      }

      .section-title {
        font-weight: bold;
        font-size: 12pt;
        text-transform: uppercase;
        margin: 15px 0 10px 0;
        border-bottom: 1px solid #000;
        padding-bottom: 3px;
      }

      .info-row {
        display: flex;
        margin: 8px 0;
        font-size: 11pt;
        line-height: 1.6;
      }

      .info-label {
        font-weight: bold;
        min-width: 150px;
      }

      .info-value {
        flex: 1;
        border-bottom: 1px dotted #666;
        padding: 0 5px;
      }

      .info-value-plain {
        flex: 1;
        padding: 0 5px;
      }

      /* Two column layout */
      .two-columns {
        display: flex;
        gap: 20px;
      }

      .column {
        flex: 1;
      }

      /* Text areas */
      .textarea-section {
        margin: 10px 0;
        min-height: 80px;
        border: 1px solid #999;
        padding: 10px;
        font-size: 11pt;
        line-height: 1.8;
        white-space: pre-wrap;
      }

      /* Table for test results */
      .results-table {
        width: 100%;
        border-collapse: collapse;
        margin: 10px 0;
        font-size: 11pt;
      }

      .results-table th,
      .results-table td {
        border: 1px solid #000;
        padding: 8px;
        text-align: left;
      }

      .results-table th {
        background: #f0f0f0;
        font-weight: bold;
      }

      /* Signature section */
      .signature-section {
        display: flex;
        justify-content: space-between;
        margin-top: 40px;
        page-break-inside: avoid;
      }

      .signature-box {
        text-align: center;
        width: 45%;
      }

      .signature-title {
        font-weight: bold;
        margin-bottom: 5px;
      }

      .signature-subtitle {
        font-style: italic;
        font-size: 10pt;
        margin-bottom: 60px;
      }

      .signature-name {
        font-weight: bold;
        margin-top: 10px;
      }

      /* Action buttons - scoped to avoid affecting header/sidebar */
      .action-buttons {
        text-align: center;
        margin: 20px 0 30px 0;
        padding: 20px;
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
      }

      .action-buttons .btn {
        padding: 12px 30px;
        margin: 0 10px;
        border: none;
        border-radius: 12px;
        cursor: pointer;
        font-size: 15px;
        font-weight: 600;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        font-family: 'Roboto', sans-serif;
      }

      .action-buttons .btn i {
        font-size: 16px;
      }

      .action-buttons .btn-print {
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        color: white;
      }

      .action-buttons .btn-print:hover {
        background: linear-gradient(135deg, #218838 0%, #1aa179 100%);
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(40, 167, 69, 0.3);
      }

      .action-buttons .btn-print:active {
        transform: translateY(0);
        box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
      }

      .action-buttons .btn-back {
        background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
        color: white;
      }

      .action-buttons .btn-back:hover {
        background: linear-gradient(135deg, #5a6268 0%, #495057 100%);
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(108, 117, 125, 0.3);
        color: white;
      }

      .action-buttons .btn-back:active {
        transform: translateY(0);
        box-shadow: 0 2px 8px rgba(108, 117, 125, 0.3);
      }

      /* Print specific styles */
      @media print {
        .medical-record-page {
          background: white;
        }

        .medical-record-container {
          box-shadow: none;
          padding: 0;
          margin: 0;
        }

        .action-buttons,
        .no-print {
          display: none !important;
        }

        .medical-record-page .main-wrapper {
          display: block !important;
        }

        .medical-record-page .content-area {
          margin-left: 0 !important;
          padding: 0 !important;
        }

        .signature-section {
          margin-top: 60px;
        }
      }

      /* Layout styles for sidebar integration - minimal override */
      .medical-record-page .main-wrapper {
        display: flex;
        min-height: 100vh;
      }

      .medical-record-page .content-area {
        margin-left: 280px;
        flex: 1;
        padding: 20px;
        padding-top: 80px;
        min-height: 100vh;
        padding-bottom: 40px;
        background: #f5f5f5;
      }

      /* Responsive */
      @media (max-width: 768px) {
        .medical-record-container {
          padding: 1cm;
          margin: 10px;
        }

        .two-columns {
          flex-direction: column;
        }

        .signature-section {
          flex-direction: column;
          gap: 40px;
        }

        .signature-box {
          width: 100%;
        }

        .medical-record-page .content-area {
          margin-left: 0;
        }

        .action-buttons {
          padding: 15px;
        }

        .action-buttons .btn {
          display: flex;
          width: 100%;
          max-width: 300px;
          margin: 10px auto;
          justify-content: center;
        }
      }

      /* Animation for message */
      @keyframes slideDown {
        from {
          opacity: 0;
          transform: translateY(-20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      /* Success/Error message styles */
      .alert-message {
        max-width: 21cm;
        margin: 0 auto 20px auto;
        padding: 15px 20px;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        animation: slideDown 0.3s ease-out;
      }

      .alert-message.success {
        background: linear-gradient(135deg, #f0fff4 0%, #d4edda 100%);
        border-left: 5px solid #28a745;
      }

      .alert-message.error {
        background: linear-gradient(135deg, #fff5f5 0%, #ffe0e0 100%);
        border-left: 5px solid #dc3545;
      }

      .alert-message .alert-content {
        display: flex;
        align-items: center;
        gap: 12px;
      }

      .alert-message.success .alert-icon {
        font-size: 24px;
        color: #28a745;
      }

      .alert-message.error .alert-icon {
        font-size: 24px;
        color: #dc3545;
      }

      .alert-message.success .alert-text {
        font-size: 16px;
        font-weight: 600;
        color: #155724;
      }

      .alert-message.error .alert-text {
        font-size: 16px;
        font-weight: 600;
        color: #721c24;
      }
    </style>
  </head>

  <body class="medical-record-page">
    <!-- Header -->
    <jsp:include page="../../includes/header.jsp" />

    <!-- Main wrapper -->
    <div class="main-wrapper">
      <!-- Sidebar -->
      <jsp:include page="../../includes/sidebar-doctor.jsp" />

      <!-- Content area -->
      <div class="content-area">
        <div class="action-buttons no-print">
        <button onclick="window.print()" class="btn btn-print">
          <i class="fas fa-print"></i> In hồ sơ bệnh án
        </button>
        <a
          href="${pageContext.request.contextPath}/appointments"
          class="btn btn-back"
        >
          <i class="fas fa-arrow-left"></i> Quay lại
        </a>
      </div>

      <!-- Display success/error message -->
      <c:if test="${not empty sessionScope.message}">
        <div class="alert-message ${sessionScope.messageType eq 'error' ? 'error' : 'success'} no-print">
          <div class="alert-content">
            <i class="fas ${sessionScope.messageType eq 'error' ? 'fa-exclamation-circle' : 'fa-check-circle'} alert-icon"></i>
            <span class="alert-text">${sessionScope.message}</span>
          </div>
        </div>
        <c:remove var="message" scope="session"/>
        <c:remove var="messageType" scope="session"/>
      </c:if>

      <div class="medical-record-container">
        <!-- Header -->
        <div class="record-header">
          <div class="hospital-name">PHÒNG KHÁM NHI KHOA MEDILAB</div>
          <div class="hospital-info">Địa chỉ: Mường Khương - Lào Cai</div>
          <div class="hospital-info">
            Điện thoại: 0839638666 - Email: quanganh@gmail.com
          </div>
        </div>

        <!-- Title -->
        <div class="record-title">HỒ SƠ BỆNH ÁN</div>
        <div class="record-number">
          Số: ${medicalReport != null ? medicalReport.recordId :
          appointment.appointmentId}/HSBA
          <br />
          <c:choose>
            <c:when test="${not empty sessionScope.examinationCompletedTime}">
              <fmt:formatDate
                value="${sessionScope.examinationCompletedTime}"
                pattern="'Ngày 'dd' tháng 'MM' năm 'yyyy"
              />
            </c:when>
            <c:otherwise>
              <jsp:useBean id="currentDate" class="java.util.Date" />
              <fmt:formatDate
                value="${currentDate}"
                pattern="'Ngày 'dd' tháng 'MM' năm 'yyyy"
              />
            </c:otherwise>
          </c:choose>
        </div>

        <!-- I. THÔNG TIN BỆNH NHÂN -->
        <div class="form-section">
          <div class="section-title">I. THÔNG TIN BỆNH NHÂN</div>

          <div class="info-row">
            <span class="info-label">Họ và tên:</span>
            <span class="info-value">${patient.fullName}</span>
            <span class="info-label" style="margin-left: 20px">Mã BN:</span>
            <span class="info-value" style="max-width: 150px"
              >${patient.patientId}</span
            >
          </div>

          <div class="info-row">
            <span class="info-label">Ngày sinh:</span>
            <span class="info-value">
              <fmt:formatDate value="${patient.dob}" pattern="dd/MM/yyyy" />
            </span>
            <span class="info-label" style="margin-left: 20px">Tuổi:</span>
            <span class="info-value" style="max-width: 100px">
              <c:set var="today" value="<%= new java.util.Date() %>" />
              <fmt:formatDate
                value="${patient.dob}"
                pattern="yyyy"
                var="birthYear"
              />
              <fmt:formatDate
                value="${today}"
                pattern="yyyy"
                var="currentYear"
              />
              ${currentYear - birthYear}
            </span>
          </div>

          <div class="info-row">
            <span class="info-label">Địa chỉ:</span>
            <span class="info-value">${patient.address}</span>
          </div>

          <div class="info-row">
            <span class="info-label">Điện thoại:</span>
            <span class="info-value">${patient.phone}</span>
            <span class="info-label" style="margin-left: 20px">Email:</span>
            <span class="info-value">${patient.email}</span>
          </div>

          <c:if test="${not empty patient.parentName}">
            <div class="info-row">
              <span class="info-label">Phụ huynh:</span>
              <span class="info-value">${patient.parentName}</span>
            </div>
          </c:if>

          <div class="info-row">
            <span class="info-label">Bảo hiểm y tế:</span>
            <span class="info-value">${patient.insuranceInfo}</span>
          </div>
        </div>

        <!-- II. THÔNG TIN KHÁM BỆNH -->
        <div class="form-section">
          <div class="section-title">II. THÔNG TIN KHÁM BỆNH</div>

          <div class="info-row">
            <span class="info-label">Ngày giờ khám:</span>
            <span class="info-value">
              <c:choose>
                <c:when
                  test="${not empty sessionScope.examinationCompletedTime}"
                >
                  <fmt:formatDate
                    value="${sessionScope.examinationCompletedTime}"
                    pattern="HH:mm - dd/MM/yyyy"
                  />
                  <c:remove var="examinationCompletedTime" scope="session" />
                </c:when>
                <c:otherwise>
                  <jsp:useBean id="now" class="java.util.Date" />
                  <fmt:formatDate value="${now}" pattern="HH:mm - dd/MM/yyyy" />
                </c:otherwise>
              </c:choose>
            </span>
          </div>

          <div class="info-row">
            <span class="info-label">Bác sĩ khám:</span>
            <span class="info-value">BS. ${doctor.username}</span>
          </div>

          <!-- Lý do khám/Triệu chứng -->
          <div style="margin-top: 15px">
            <div style="font-weight: bold; margin-bottom: 5px">
              Lý do khám / Triệu chứng:
            </div>
            <div class="textarea-section">
              <c:choose>
                <c:when test="${not empty appointment.symptoms}">
                  ${appointment.symptoms}
                </c:when>
                <c:otherwise> (Không có ghi chú) </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>

        <!-- III. CHẨN ĐOÁN VÀ ĐIỀU TRỊ -->
        <c:if test="${medicalReport != null}">
          <div class="form-section">
            <div class="section-title">III. CHẨN ĐOÁN VÀ ĐIỀU TRỊ</div>

            <div style="margin-top: 15px">
              <div style="font-weight: bold; margin-bottom: 5px">
                Chẩn đoán:
              </div>
              <div class="textarea-section">${medicalReport.diagnosis}</div>
            </div>

            <c:if test="${not empty medicalReport.prescription}">
              <div style="margin-top: 15px">
                <div style="font-weight: bold; margin-bottom: 5px">
                  Đơn thuốc:
                </div>
                <div class="textarea-section">
                  ${medicalReport.prescription}
                </div>
              </div>
            </c:if>

            <!-- Test Results -->
            <c:if test="${not empty testResults}">
              <div style="margin-top: 20px">
                <div style="font-weight: bold; margin-bottom: 10px">
                  Kết quả xét nghiệm:
                </div>
                <table class="results-table">
                  <thead>
                    <tr>
                      <th style="width: 50px">STT</th>
                      <th>Loại xét nghiệm</th>
                      <th>Kết quả</th>
                      <th style="width: 120px">Ngày thực hiện</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach
                      var="test"
                      items="${testResults}"
                      varStatus="status"
                    >
                      <tr>
                        <td style="text-align: center">${status.index + 1}</td>
                        <td>${test.testType}</td>
                        <td>${test.result}</td>
                        <td>
                          <fmt:formatDate
                            value="${test.date}"
                            pattern="dd/MM/yyyy"
                          />
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </c:if>

            <!-- Lời dặn của bác sĩ -->
            <div
              style="
                margin-top: 20px;
                padding: 15px;
                background: #f9f9f9;
                border-left: 4px solid #1977cc;
              "
            >
              <div style="font-weight: bold; margin-bottom: 10px">
                <i class="fas fa-exclamation-circle"></i> Lời dặn của bác sĩ:
              </div>
              <ul style="margin: 0; padding-left: 20px; line-height: 1.8">
                <li>Dùng thuốc đúng liều lượng và thời gian theo chỉ định</li>
                <li>Không tự ý thay đổi hoặc ngừng thuốc</li>
                <li>
                  Theo dõi sức khỏe trẻ, nếu có biến chứng hãy liên hệ ngay với
                  bác sĩ
                </li>
                <li>
                  Tái khám theo lịch hẹn hoặc khi có triệu chứng bất thường
                </li>
                <li>Bảo quản thuốc nơi khô ráo, tránh ánh nắng trực tiếp</li>
              </ul>
            </div>
          </div>
        </c:if>

        <!-- Signature Section -->
        <div class="signature-section">
          <div class="signature-box">
            <div class="signature-title">NGƯỜI NHẬN HỒ SƠ</div>
            <div class="signature-subtitle">(Ký và ghi rõ họ tên)</div>
            <div class="signature-name">
              <c:choose>
                <c:when test="${not empty patient.parentName}">
                  ${patient.parentName}
                </c:when>
                <c:otherwise> ${patient.fullName} </c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="signature-box">
            <div class="signature-title">BÁC SĨ KHÁM BỆNH</div>
            <div class="signature-subtitle">(Ký và đóng dấu)</div>
            <div class="signature-name">BS. ${doctor.username}</div>
          </div>
        </div>

        <!-- Footer note -->
        <div
          style="
            margin-top: 30px;
            padding-top: 15px;
            border-top: 1px solid #ddd;
            font-size: 10pt;
            text-align: center;
            color: #666;
          "
        >
          <p style="margin: 5px 0">
            <strong>Lưu ý:</strong> Hồ sơ bệnh án này có giá trị pháp lý. Vui
            lòng bảo quản cẩn thận.
          </p>
          <p style="margin: 5px 0">
            Phòng khám Nhi khoa Medilab - Chăm sóc sức khỏe toàn diện cho bé yêu
          </p>
        </div>
      </div>
      <!-- End content-area -->
    </div>
    <!-- End main-wrapper -->

    <jsp:include page="../../includes/footer-includes.jsp" />
  </body>
</html>
