<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>${pageTitle} - Medilab Pediatric Clinic</title>
    
    <!-- Include all CSS files -->
    <jsp:include page="../../includes/head-includes.jsp"/>

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
        padding-bottom: 100px;
      }

      @media (max-width: 991px) {
        .sidebar-container {
          display: none;
        }
        .main-content {
          margin-left: 0;
        }
      }

      /* Appointment List Styles */
      .appointment-container {
        background: var(--background-color, #f1f7fc);
        min-height: calc(100vh - 80px);
        padding: 20px 0;
      }

      .appointment-card {
        background: var(--surface-color, #ffffff);
        border-radius: 10px;
        box-shadow: 0px 2px 15px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        margin-bottom: 20px;
      }

      .appointment-header {
        padding: 24px 28px;
        background: var(--accent-color, #1977cc);
        color: var(--contrast-color, #ffffff);
      }

      .appointment-header h1 {
        color: var(--contrast-color, #ffffff);
        font-weight: 700;
        margin: 0;
        font-size: 1.8rem;
      }

      .appointment-content {
        padding: 24px 28px;
      }
      .alert {
        padding: 14px;
        border-radius: 8px;
        margin-bottom: 16px;
      }
      .alert-success {
        background: #d4edda;
        color: #155724;
        border-left: 4px solid #28a745;
      }
      .alert-error {
        background: #f8d7da;
        color: #721c24;
        border-left: 4px solid #dc3545;
      }
      
      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 8px;
      }
      thead {
        background: var(--accent-color, #1977cc);
        color: var(--contrast-color, #ffffff);
      }
      thead th {
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.85rem;
        letter-spacing: 0.5px;
      }
      th,
      td {
        padding: 14px;
        border-bottom: 1px solid #e9ecef;
        text-align: left;
      }
      tbody tr {
        transition: all 0.3s ease;
      }
      tbody tr:hover {
        background: #f8f9fa;
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
      }
      .status {
        padding: 6px 12px;
        border-radius: 16px;
        font-size: 12px;
        font-weight: 700;
        display: inline-block;
      }
      .status-pending {
        background: #fff3cd;
        color: #856404;
      }
      .status-confirmed {
        background: #d1ecf1;
        color: #0c5460;
      }
      .status-waiting {
        background: #ffeaa7;
        color: #b04b00;
      }
      .status-in-progress {
        background: #d4edda;
        color: #155724;
      }
      .status-testing {
        background: #cce5ff;
        color: #004085;
      }
      .status-completed {
        background: #e2f0d9;
        color: #1b5e20;
      }
      .status-cancelled {
        background: #f8d7da;
        color: #721c24;
      }
      .btn {
        padding: 8px 16px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
      }
      .btn-primary {
        background: var(--accent-color, #1977cc);
        color: var(--contrast-color, #ffffff);
      }
      .btn-primary:hover {
        background: #0d6efd;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
      }
      .btn-green {
        background: #28a745;
        color: #fff;
      }
      .btn-green:hover {
        background: #218838;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
      }
      .btn-red {
        background: #dc3545;
        color: #fff;
      }
      .btn-red:hover {
        background: #c82333;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
      }
      .btn-secondary {
        background: #6c757d;
        color: #fff;
      }
      .btn-secondary:hover {
        background: #5a6268;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
      }
      .actions {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
      }
      .muted {
        font-size: 12px;
        color: rgba(255, 255, 255, 0.8);
      }
      
      .text-muted {
        color: #6c757d;
        font-size: 0.9rem;
      }
      .filter-section {
        background: var(--surface-color, #ffffff);
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        box-shadow: 0px 2px 15px rgba(0, 0, 0, 0.1);
      }
      .filter-form {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 12px;
        margin-bottom: 12px;
      }
      .filter-form input,
      .filter-form select {
        padding: 10px 14px;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        font-size: 14px;
        transition: all 0.3s ease;
      }
      .filter-form input:focus,
      .filter-form select:focus {
        outline: none;
        border-color: var(--accent-color, #1977cc);
        box-shadow: 0 0 0 3px rgba(25, 119, 204, 0.1);
      }
      .filter-actions {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
      }
      .pagination {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 8px;
        margin-top: 20px;
        padding: 16px;
      }
      .pagination a,
      .pagination span {
        padding: 8px 12px;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        text-decoration: none;
        color: var(--accent-color, #1977cc);
        background: var(--surface-color, #ffffff);
        transition: all 0.3s ease;
      }
      .pagination a:hover {
        background: var(--accent-color, #1977cc);
        color: var(--contrast-color, #ffffff);
        transform: translateY(-2px);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      }
      .pagination .active {
        background: var(--accent-color, #1977cc);
        color: var(--contrast-color, #ffffff);
        border-color: var(--accent-color, #1977cc);
      }
      .pagination .disabled {
        color: #9ca3af;
        cursor: not-allowed;
        pointer-events: none;
      }
      .page-info {
        margin: 0 12px;
        color: #6b7280;
        font-size: 14px;
      }
    </style>
  </head>
  <body class="index-page">
    <!-- Header -->
    <jsp:include page="../../includes/header.jsp"/>

    <main class="main" style="padding-top: 80px;">
      <div class="container-fluid p-0">
        <div class="row g-0">
          <%-- Show sidebar based on role --%>
          <% if (acc != null && acc.getRoleId() == 5) { %>
            <div class="sidebar-container">
              <%@ include file="../../includes/sidebar-receptionist.jsp" %>
            </div>
          <% } %>
          
          <div class="main-content">
            <div class="appointment-container">
              <div class="container">
                <div class="appointment-card">
                  <div class="appointment-header">
                    <h1>${pageTitle}</h1>
                    <div class="muted">
                      You are signed in as <strong>Receptionist</strong>
                    </div>
                  </div>

                  <div class="appointment-content">
                    <c:if test="${not empty sessionScope.message}">
                      <div class="alert alert-${sessionScope.messageType}">
                        ${sessionScope.message}
                      </div>
                      <c:remove var="message" scope="session" />
                      <c:remove var="messageType" scope="session" />
                    </c:if>

                    <!-- Search and Filter Section -->
                    <div class="filter-section">
                      <form method="get" action="${pageContext.request.contextPath}/receptionist" id="filterForm">
                        <div class="filter-form">
                          <input
                            type="text"
                            name="search"
                            placeholder="Search by name or phone..."
                            value="${not empty searchKeyword ? searchKeyword : ''}"
                          />
                          <input
                            type="date"
                            name="dateFrom"
                            placeholder="From Date"
                            value="${not empty dateFrom ? dateFrom : ''}"
                          />
                          <input
                            type="date"
                            name="dateTo"
                            placeholder="To Date"
                            value="${not empty dateTo ? dateTo : ''}"
                          />
                        </div>
                        <div class="filter-actions">
                          <button type="submit" class="btn btn-primary">🔍 Search & Filter</button>
                          <a
                            href="${pageContext.request.contextPath}/receptionist"
                            class="btn btn-secondary"
                            >🔄 Reset</a
                          >
                          <a
                            href="${pageContext.request.contextPath}/receptionist/checkin-form"
                            class="btn btn-success"
                            style="background-color: #28a745; color: white;"
                            >➕ Đăng Ký Bệnh Nhân Mới</a
                          >
                        </div>
                        <input type="hidden" name="page" value="1" id="pageInput" />
                      </form>
                    </div>

                    <c:choose>
                      <c:when test="${not empty appointments}">
                        <table>
                          <thead>
                            <tr>
                              <th>#</th>
                              <th>Appointment ID</th>
                              <th>Patient Name</th>
                              <th>Phone</th>
                              <th>Doctor Name</th>
                              <th>Date &amp; Time</th>
                              <th>Status</th>
                              <th style="width: 220px">Action</th>
                            </tr>
                          </thead>
                          <tbody>
                            <c:forEach var="apt" items="${appointments}" varStatus="st">
                              <tr>
                                <td><strong>${(currentPage - 1) * pageSize + st.index + 1}</strong></td>
                                <td>#${apt.appointmentId}</td>
                                <td>
                                  <c:choose>
                                    <c:when test="${not empty apt.patientName}">
                                      ${apt.patientName}
                                    </c:when>
                                    <c:otherwise>Patient #${apt.patientId}</c:otherwise>
                                  </c:choose>
                                  <c:if test="${apt.patientId != null}">
                                    <br><small class="text-muted">ID: ${apt.patientId}</small>
                                  </c:if>
                                </td>
                                <td>
                                  <c:choose>
                                    <c:when test="${not empty apt.patientPhone}">
                                      ${apt.patientPhone}
                                    </c:when>
                                    <c:otherwise>
                                      <span class="text-muted">N/A</span>
                                    </c:otherwise>
                                  </c:choose>
                                </td>
                                <td>
                                  <c:choose>
                                    <c:when test="${not empty apt.doctorName}">
                                      ${apt.doctorName}
                                    </c:when>
                                    <c:otherwise>Doctor #${apt.doctorId}</c:otherwise>
                                  </c:choose>
                                  <c:if test="${apt.doctorId != null}">
                                    <br><small class="text-muted">ID: ${apt.doctorId}</small>
                                  </c:if>
                                </td>
                                <td>
                                  <fmt:formatDate
                                    value="${apt.dateTime}"
                                    pattern="dd/MM/yyyy HH:mm"
                                  />
                                  <div class="text-muted">
                                    <fmt:formatDate
                                      value="${apt.dateTime}"
                                      pattern="EEEE"
                                    />
                                  </div>
                                </td>
                                <td>
                                  <span
                                    class="status status-${fn:toLowerCase(apt.status).replace(' ', '-')}"
                                  >
                                    ${apt.status}
                                  </span>
                                </td>
                                <td>
                                  <div class="actions">
                                    <!-- Only show Check In when actually Confirmed -->
                                    <c:if test="${apt.status == 'Confirmed'}">
                                      <form
                                        method="post"
                                        action="${pageContext.request.contextPath}/receptionist"
                                        style="display: inline;"
                                      >
                                        <input type="hidden" name="action" value="checkin" />
                                        <input
                                          type="hidden"
                                          name="appointmentId"
                                          value="${apt.appointmentId}"
                                        />
                                        <button type="submit" class="btn btn-green">
                                          Check In
                                        </button>
                                      </form>
                                    </c:if>
                                  </div>
                                </td>
                              </tr>
                            </c:forEach>
                          </tbody>
                        </table>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                          <c:set var="queryParams" value="" />
                          <c:if test="${not empty searchKeyword}">
                            <c:set var="queryParams" value="${queryParams}&search=${fn:escapeXml(searchKeyword)}" />
                          </c:if>
                          <c:if test="${not empty dateFrom}">
                            <c:set var="queryParams" value="${queryParams}&dateFrom=${fn:escapeXml(dateFrom)}" />
                          </c:if>
                          <c:if test="${not empty dateTo}">
                            <c:set var="queryParams" value="${queryParams}&dateTo=${fn:escapeXml(dateTo)}" />
                          </c:if>
                          
                          <div class="pagination">
                            <c:choose>
                              <c:when test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}${queryParams}">« Previous</a>
                              </c:when>
                              <c:otherwise>
                                <span class="disabled">« Previous</span>
                              </c:otherwise>
                            </c:choose>

                            <c:forEach var="i" begin="1" end="${totalPages}">
                              <c:choose>
                                <c:when test="${i == currentPage}">
                                  <span class="active">${i}</span>
                                </c:when>
                                <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                  <a href="?page=${i}${queryParams}">${i}</a>
                                </c:when>
                                <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                  <span>...</span>
                                </c:when>
                              </c:choose>
                            </c:forEach>

                            <c:choose>
                              <c:when test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}${queryParams}">Next »</a>
                              </c:when>
                              <c:otherwise>
                                <span class="disabled">Next »</span>
                              </c:otherwise>
                            </c:choose>

                            <span class="page-info"
                              >Page ${currentPage} of ${totalPages} (${totalRecords} total)</span
                            >
                          </div>
                        </c:if>
                      </c:when>
                      <c:otherwise>
                        <div style="text-align: center; padding: 72px 16px; color: #6b7280">
                          <div style="font-size: 72px; opacity: 0.3; margin-bottom: 12px">
                            📋
                          </div>
                          <h3>No appointments found</h3>
                          <p>There are no confirmed appointments matching your search criteria.</p>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- Footer -->
    <jsp:include page="../../includes/footer.jsp"/>

    <!-- Include all JS files -->
    <jsp:include page="../../includes/footer-includes.jsp"/>

    <script>
      // Update page number when clicking pagination links
      document.addEventListener("DOMContentLoaded", function () {
        const filterForm = document.getElementById("filterForm");
        if (filterForm) {
          const pageInput = document.getElementById("pageInput");
          const paginationLinks = document.querySelectorAll(".pagination a");
          paginationLinks.forEach(function (link) {
            link.addEventListener("click", function (e) {
              e.preventDefault();
              const url = new URL(this.href);
              const page = url.searchParams.get("page");
              if (pageInput) {
                pageInput.value = page;
              }
              window.location.href = this.href;
            });
          });
        }
      });
    </script>
  </body>
</html>
