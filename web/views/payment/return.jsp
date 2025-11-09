<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ page
import="entity.User" %> <% User acc = (User) session.getAttribute("acc"); %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Kết quả thanh toán - Medilab</title>

    <!-- Include all CSS files -->
    <jsp:include page="/includes/head-includes.jsp" />

    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      /* Đảm bảo header được fixed ở trên cùng */
      #header {
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        right: 0 !important;
        width: 100% !important;
        z-index: 1050 !important;
      }

      body {
        font-family: var(--default-font, "Roboto", sans-serif);
        background-color: #f1f7fc;
        min-height: 100vh;
        padding-top: 80px;
        display: flex;
        flex-direction: column;
      }

      .payment-wrapper {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 40px 20px;
      }

      .payment-result-container {
        background: #ffffff;
        border-radius: 20px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        max-width: 600px;
        width: 100%;
        padding: 50px 40px;
        text-align: center;
        animation: slideUp 0.5s ease-out;
        border: 1px solid #e0e0e0;
      }

      @keyframes slideUp {
        from {
          opacity: 0;
          transform: translateY(30px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .result-icon {
        width: 120px;
        height: 120px;
        margin: 0 auto 30px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 60px;
        animation: scaleIn 0.6s ease-out 0.2s both;
      }

      @keyframes scaleIn {
        from {
          transform: scale(0);
        }
        to {
          transform: scale(1);
        }
      }

      .result-icon.success {
        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        color: #ffffff;
      }

      .result-icon.failure {
        background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
        color: #ffffff;
      }

      .result-title {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 20px;
        color: #2c3e50;
      }

      .result-message {
        font-size: 18px;
        color: #555;
        margin-bottom: 40px;
        line-height: 1.6;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 10px;
        border-left: 4px solid var(--accent-color, #1977cc);
      }

      .btn-back {
        display: inline-block;
        padding: 14px 40px;
        background: var(--accent-color, #1977cc);
        color: #ffffff;
        text-decoration: none;
        border-radius: 50px;
        font-weight: 600;
        font-size: 16px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(25, 119, 204, 0.3);
        border: none;
      }

      .btn-back:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(25, 119, 204, 0.5);
        color: #ffffff;
        background: #1565a0;
        opacity: 0.95;
      }

      .btn-back:active {
        transform: translateY(0);
      }

      .success-message {
        color: #11998e;
      }

      .failure-message {
        color: #eb3349;
      }

      .decorative-line {
        height: 4px;
        background: var(--accent-color, #1977cc);
        border-radius: 2px;
        margin: 30px 0;
      }

      @media (max-width: 576px) {
        .payment-result-container {
          padding: 30px 20px;
        }

        .result-title {
          font-size: 24px;
        }

        .result-message {
          font-size: 16px;
        }

        .result-icon {
          width: 100px;
          height: 100px;
          font-size: 50px;
        }
      }
    </style>
  </head>
  <body>
    <!-- Header -->
    <jsp:include page="/includes/header.jsp" />

    <div class="payment-wrapper">
      <div class="payment-result-container">
        <c:choose>
          <c:when test="${message != null && message.contains('thành công')}">
            <div class="result-icon success">
              <i class="fas fa-check"></i>
            </div>
            <h1 class="result-title success-message">Thanh toán thành công!</h1>
          </c:when>
          <c:otherwise>
            <div class="result-icon failure">
              <i class="fas fa-times"></i>
            </div>
            <h1 class="result-title failure-message">Thanh toán thất bại</h1>
          </c:otherwise>
        </c:choose>

        <div class="decorative-line"></div>

        <div class="result-message">
          <c:choose>
            <c:when test="${message != null}"> ${message} </c:when>
            <c:otherwise>
              Không có thông tin về kết quả thanh toán.
            </c:otherwise>
          </c:choose>
        </div>

        <a
          href="${pageContext.request.contextPath}/reception/medical-reports"
          class="btn-back"
        >
          <i class="fas fa-arrow-left me-2"></i>
          Quay lại danh sách
        </a>
      </div>
    </div>

    <!-- Footer -->
    <jsp:include page="/includes/footer.jsp" />

    <!-- Include all JS files -->
    <jsp:include page="/includes/footer-includes.jsp" />
  </body>
</html>
