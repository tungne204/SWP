<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<h2>Hồ sơ đã có Medical Report (chưa thanh toán)</h2>
<table border="1" cellpadding="8" cellspacing="0">
  <thead>
    <tr>
      <th>Record ID</th>
      <th>Appointment</th>
      <th>Chẩn đoán</th>
      <th>Thanh toán</th>
      <th>Trạng thái</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach var="mr" items="${medicalReports}">
    <tr>
      <td>${mr.recordId}</td>
      <td>#${mr.appointmentId}</td>
      <td>${mr.diagnosis}</td>
      <td>
        <form action="${pageContext.request.contextPath}/reception/payment/create" method="post" style="display:flex;gap:8px">
          <input type="hidden" name="recordId" value="${mr.recordId}"/>
          <input type="hidden" name="appointmentId" value="${mr.appointmentId}"/>
          <input type="number" name="amount" min="1000" step="1000" required placeholder="Nhập số tiền (VND)"/>
          <button type="submit">Thu tiền (VNPay)</button>
        </form>
      </td>
      <td>
        <c:choose>
          <c:when test="${mr.paid}">ĐÃ THANH TOÁN</c:when>
          <c:otherwise>CHƯA THANH TOÁN</c:otherwise>
        </c:choose>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>
