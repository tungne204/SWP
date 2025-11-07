<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ page import="entity.User" %> <%
User acc = (User) session.getAttribute("acc"); %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Laboratory Test Form - Medilab</title>

    <!-- Include all CSS files -->
    <jsp:include page="../../includes/head-includes.jsp" />

    <style>
      /* Sidebar Layout */
      .sidebar-container {
        width: 280px;
        background: white;
        border-right: 1px solid #dee2e6;
        position: fixed;
        top: 80px;
        left: 0;
        height: calc(100vh - 80px);
        overflow-y: auto;
        z-index: 1000;
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
      }

      .main-content {
        flex: 1;
        margin-left: 280px;
        padding: 20px;
        min-height: calc(100vh - 80px);
        padding-top: 100px;
      }

      /* Responsive */
      @media (max-width: 991px) {
        .sidebar-container {
          display: none;
        }
        .main-content {
          margin-left: 0;
        }
      }

      /* Scope CSS chỉ cho content, không ảnh hưởng header/sidebar */
      .main-content * {
        box-sizing: border-box;
      }

      .main {
        background: #ffffff;
      }

      .main-content {
        background: #ffffff;
      }

      .main-content .container {
        max-width: 900px;
        margin: 0 auto;
        background: white;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        margin-bottom: 20px;
      }

      .main-content .container .header {
        background: linear-gradient(135deg, #1977cc 0%, #2c4964 100%);
        color: white;
        padding: 30px;
      }

      .main-content .container .header h1 {
        margin-bottom: 10px;
      }

      .main-content .container .appointment-info {
        background: rgba(255, 255, 255, 0.1);
        padding: 15px;
        border-radius: 10px;
        margin-top: 15px;
      }

      .main-content .container .appointment-info p {
        margin: 5px 0;
      }

      .main-content .container .content {
        padding: 30px;
      }

      .main-content .container .info-box {
        background: #e3f2fd;
        border-left: 4px solid #1977cc;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 25px;
      }

      .main-content .container .info-box h3 {
        color: #2c4964;
        margin-bottom: 10px;
      }

      .main-content .container .form-group {
        margin-bottom: 25px;
      }

      .main-content .container label {
        display: block;
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 8px;
      }

      .main-content .container input[type="text"],
      .main-content .container textarea,
      .main-content .container select {
        width: 100%;
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        font-size: 14px;
        transition: border 0.3s;
      }

      .main-content .container input:focus,
      .main-content .container textarea:focus,
      .main-content .container select:focus {
        outline: none;
        border-color: #1977cc;
      }

      .main-content .container textarea {
        resize: vertical;
        min-height: 150px;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      }

      .main-content .container .btn {
        padding: 15px 30px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s;
      }

      .main-content .container .btn-success {
        background: #1977cc;
        color: white;
        width: 100%;
      }

      .main-content .container .btn-success:hover {
        background: #1565a0;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(25, 119, 204, 0.4);
      }

      .main-content .container .btn-secondary {
        background: #95a5a6;
        color: white;
        text-decoration: none;
        display: inline-block;
        margin-top: 15px;
      }

      .main-content .container .btn-secondary:hover {
        background: #7f8c8d;
      }

      .main-content .container .back-link {
        display: inline-block;
        color: white;
        text-decoration: none;
        margin-bottom: 15px;
        transition: opacity 0.3s;
      }

      .main-content .container .back-link:hover {
        opacity: 0.8;
      }

      .main-content .container .existing-tests {
        margin-top: 30px;
        border-top: 2px solid #e0e0e0;
        padding-top: 25px;
      }

      .main-content .container .existing-tests h3 {
        color: #2c3e50;
        margin-bottom: 15px;
      }

      .main-content .container .test-item {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 15px;
        border-left: 4px solid #3498db;
      }

      .main-content .container .test-item h4 {
        color: #2c3e50;
        margin-bottom: 8px;
      }

      .main-content .container .test-item p {
        margin: 5px 0;
        color: #555;
      }

      .main-content .container .alert {
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 8px;
      }

      .main-content .container .alert-warning {
        background: #fff3cd;
        color: #856404;
        border-left: 4px solid #ffc107;
      }
      .main-content .container .readonly {
        background: #f3f4f6;
        border-color: #d1d5db;
        color: #374151;
      }
    </style>
    <script>
      function validateForm() {
        const testResult = document.getElementById("testResult").value.trim();
        if (!testResult) {
          alert("Please fill in the test result!");
          return false;
        }
        return confirm(
          "Submit this test result and return patient to the doctor?"
        );
      }
    </script>
  </head>
  <body class="index-page">
    <!-- Header -->
    <jsp:include page="../../includes/header.jsp" />

    <main class="main" style="padding-top: 80px">
      <%-- Show sidebar for Medical Assistant --%> <% if (acc != null &&
      acc.getRoleId() == 4) { %>
      <div class="container-fluid p-0">
        <div class="row g-0">
          <div class="sidebar-container">
            <%@ include file="../../includes/sidebar-medicalassistant.jsp" %>
          </div>
          <div class="main-content">
            <% } %>

            <div class="container">
              <div class="header">
                <a
                  href="${pageContext.request.contextPath}/appointments"
                  class="back-link"
                >
                  ← Back to Testing List
                </a>
                <h1>🧪 Laboratory Test Form</h1>
                <div class="appointment-info">
                  <p>
                    <strong>Appointment ID:</strong>
                    #${appointment.appointmentId}
                  </p>
                  <p><strong>Patient ID:</strong> ${appointment.patientId}</p>
                  <p>
                    <strong>Date & Time:</strong>
                    <fmt:formatDate
                      value="${appointment.dateTime}"
                      pattern="dd/MM/yyyy HH:mm"
                    />
                  </p>
                </div>
              </div>

              <div class="content">
                <c:if test="${not empty sessionScope.message}">
                  <div class="alert alert-${sessionScope.messageType}">
                    ${sessionScope.message}
                  </div>
                  <c:remove var="message" scope="session" />
                  <c:remove var="messageType" scope="session" />
                </c:if>

                <div class="info-box">
                  <h3>📋 Diagnosis from Doctor</h3>
                  <p>
                    ${medicalReport != null ? medicalReport.diagnosis : 'No
                    diagnosis available'}
                  </p>
                </div>

                <form
                  method="post"
                  action="${pageContext.request.contextPath}/appointments"
                  onsubmit="return validateForm()"
                >
                  <input type="hidden" name="action" value="submitTest" />
                  <input
                    type="hidden"
                    name="appointmentId"
                    value="${appointment.appointmentId}"
                  />

                  <div class="form-group">
                    <label for="testTypeDisplay"
                      >Test Type (Loại xét nghiệm) *</label
                    >
                    <input
                      type="text"
                      id="testTypeDisplay"
                      class="readonly"
                      value="${requestedTestType}"
                      readonly
                    />

                    <!-- Nếu vẫn muốn post kèm cho chắc (dù backend không dùng) -->
                    <input
                      type="hidden"
                      name="testType"
                      value="${requestedTestType}"
                    />

                    <!-- Gửi kèm giá trị cho backend (nếu code backend vẫn đọc name='testType') -->
                    <input
                      type="hidden"
                      name="testType"
                      value="${medicalReport != null ? medicalReport.requestedTestType : ''}"
                    />
                  </div>

                  <div class="form-group">
                    <label for="testResult"
                      >Test Result (Kết quả xét nghiệm) *</label
                    >
                    <textarea
                      id="testResult"
                      name="testResult"
                      placeholder="Enter detailed test results here...
                                  Example:
                                  - WBC: 12,000/mm³ (High)
                                  - RBC: 4.5 million/mm³ (Normal)
                                  - Hemoglobin: 13.5 g/dL (Normal)
                                  - Platelet: 250,000/mm³ (Normal)"
                      required
                    ></textarea>
                  </div>

                  <div class="alert alert-warning">
                    <strong>⚠️ Important:</strong> After submitting this test
                    result, the patient will be automatically moved back to the
                    waiting queue for the doctor to review and continue
                    examination.
                  </div>

                  <button type="submit" class="btn btn-success">
                    ✓ Submit Test Result & Return to Doctor
                  </button>

                  <a
                    href="${pageContext.request.contextPath}/medicalassistant"
                    class="btn btn-secondary"
                  >
                    Cancel
                  </a>
                </form>

                <c:if test="${not empty existingTests}">
                  <div class="existing-tests">
                    <h3>Previous Test Results</h3>
                    <c:forEach var="test" items="${existingTests}">
                      <div class="test-item">
                        <h4>${test.testType}</h4>
                        <p>
                          <strong>Date:</strong>
                          <fmt:formatDate
                            value="${test.date}"
                            pattern="dd/MM/yyyy"
                          />
                        </p>
                        <p><strong>Result:</strong></p>
                        <p style="white-space: pre-wrap">${test.result}</p>
                      </div>
                    </c:forEach>
                  </div>
                </c:if>
              </div>
            </div>

            <%-- Close layout for Medical Assistant --%> <% if (acc != null &&
            acc.getRoleId() == 4) { %>
          </div>
        </div>
      </div>
      <% } %>
    </main>

    <!-- Include all JS files -->
    <jsp:include page="../../includes/footer-includes.jsp" />
  </body>
</html>
