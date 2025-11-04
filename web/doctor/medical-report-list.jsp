<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý đơn thuốc - Phòng khám nhi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <jsp:include page="../includes/head-includes.jsp"/>
        <style>
            /* Giữ nguyên toàn bộ CSS bạn đã gửi ở trên */
            body {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f6fa;
            }

            /* ... các đoạn CSS giữ nguyên ... */

            .table > thead > tr {
                background-color: #34495e !important;
                color: white !important;
                text-transform: uppercase;
            }
            /* ===== LAYOUT CHUNG ===== */
            .layout {
                display: flex;
                min-height: 100vh;
                margin-top: 60px; /* chiều cao header */
            }

            .sidebar-wrap {
                width: 250px;
                flex-shrink: 0;
                background: #f8f9fb;
                border-right: 1px solid #e6e6e6;
                position: fixed;
                top: 60px;
                bottom: 0;
                overflow-y: auto;
                z-index: 1000;
            }

            .main-content {
                margin-left: 250px;
                flex: 1;
                padding: 30px;
                background: #f5f6fa;
            }

        </style>
    </head>
    <body>
        <!-- HEADER CỐ ĐỊNH -->
        <header id="header-fixed">
            <jsp:include page="../includes/header.jsp" />
        </header>

        <!-- LAYOUT CHÍNH -->
        <div class="layout">
            <!-- SIDEBAR -->
            <% if (acc != null && acc.getRoleId() == 2) { %>
            <div class="sidebar-wrap">
                <jsp:include page="../includes/sidebar-doctor.jsp" />
            </div>

            <% } %>


            <!-- MAIN CONTENT -->
            <main class="main-content">
                <div class="container">

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

                    <!-- Card tiêu đề -->
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-list"></i> Danh sách đơn thuốc
                                </h5>

                                <form class="d-flex gap-2" method="get" action="medical-report">
                                    <input type="hidden" name="action" value="list">
                                    <input type="text" name="keyword" class="form-control" style="width:200px"
                                           placeholder="Tìm bệnh nhân hoặc ngày khám (YYYY-MM-DD)" value="${keyword}">
                                    <select name="filterType" class="form-select" style="width:160px">
                                        <option value="all" ${filterType == 'all' ? 'selected' : ''}>Tất cả</option>
                                        <option value="hasTest" ${filterType == 'hasTest' ? 'selected' : ''}>Có xét nghiệm</option>
                                        <option value="noTest" ${filterType == 'noTest' ? 'selected' : ''}>Không xét nghiệm</option>
                                    </select>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search"></i> Tìm kiếm
                                    </button>
                                </form>
                                <% if (acc != null && acc.getRoleId() == 2) { %>
                                <a href="medical-report?action=add" class="btn btn-success">
                                    <i class="fas fa-plus"></i> Thêm đơn thuốc
                                </a>

                                <% } %>

                            </div>
                        </div>

                    </div>

                    <!-- Bảng danh sách -->
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Mã hồ sơ</th>
                                            <th>Bệnh nhân</th>
                                            <th>Ngày khám</th>
                                            <th>Chẩn đoán</th>
                                            <th>Đơn thuốc</th>
                                            <th>Xét nghiệm</th>
                                                <% if (acc != null && acc.getRoleId() == 2) { %>
                                            <th>Thao tác</th>

                                            <% } %>

                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="report" items="${reports}">
                                            <tr>
                                                <td><strong>#${report.recordId}</strong></td>
                                                <td><i class="fas fa-user-injured text-primary"></i> ${report.patientName}</td>
                                                <td><i class="far fa-calendar"></i> ${report.appointmentDate}</td>
                                                <td>
                                                    <span class="text-truncate d-inline-block" style="max-width: 150px;" title="${report.diagnosis}">
                                                        ${report.diagnosis}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="text-truncate d-inline-block" style="max-width: 200px;" title="${report.prescription}">
                                                        ${report.prescription}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${report.testRequest}">
                                                            <span class="badge bg-warning">
                                                                <i class="fas fa-flask"></i> Có
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Không</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="medical-report?action=view&id=${report.recordId}" class="btn btn-info btn-action" title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <% if (acc != null && acc.getRoleId() == 2) { %>
                                                        <a href="medical-report?action=edit&id=${report.recordId}" class="btn btn-warning btn-action" title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>

                                                        <% } %>
                                                        <a href="testresult?action=list&recordId=${report.recordId}" class="btn btn-outline-secondary btn-action" title="Xem XN của hồ sơ này">
                                                            <i class="fas fa-vial"></i>
                                                        </a>

<!--                                                        <a href="testresult?action=add&recordId=${report.recordId}" class="btn btn-outline-primary btn-action" title="Thêm kết quả xét nghiệm">
                                                            <i class="fas fa-plus"></i>
                                                        </a>-->

                                                        <% if (acc != null && acc.getRoleId() == 2) { %>
                                                        <button type="button" class="btn btn-danger btn-action"
                                                                onclick="confirmDelete(${report.recordId})"
                                                                title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>

                                                        <% } %>

                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty reports}">
                                            <tr>
                                                <td colspan="7" class="table-empty">
                                                    <i class="fas fa-inbox"></i>
                                                    Chưa có đơn thuốc nào
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                                <!-- Pagination -->
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
        </div>

        <!-- Modal xác nhận xóa -->
        <% if (acc != null && acc.getRoleId() == 2) { %>
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


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                    function confirmDelete(recordId) {
                                                                        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                                                                        document.getElementById('confirmDeleteBtn').href = 'medical-report?action=delete&id=' + recordId;
                                                                        deleteModal.show();
                                                                    }

                                                                    setTimeout(function () {
                                                                        const alert = document.querySelector('.alert');
                                                                        if (alert) {
                                                                            alert.classList.remove('show');
                                                                            setTimeout(() => alert.remove(), 150);
                                                                        }
                                                                    }, 5000);
        </script>
    </body>

</html>
