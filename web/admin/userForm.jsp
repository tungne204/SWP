<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo người dùng</title>

    <!-- CSS & head chung -->
    <jsp:include page="../includes/head-includes.jsp"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* ===== Layout giống trang Home - Medilab ===== */
        .main { padding-top: 80px; } /* header fixed ~80px */

        .sidebar-container {
            width: 280px;
            background: #fff;
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
            .sidebar-container { display: none; }
            .main-content { margin-left: 0; }
        }

        /* ===== Card & Form ===== */
        .card { background:#fff; border-radius:10px; padding:24px; box-shadow:0 2px 10px rgba(0,0,0,0.08); }
        .page-title { display:flex; align-items:center; gap:10px; margin-bottom:16px; color:#2c3e50; }
        .page-title h2 { margin:0; font-size:22px; font-weight:700; }

        .form-row { display:flex; gap:16px; flex-wrap:wrap; }
        .form-row .col { flex:1; min-width:240px; }
        label { font-weight:600; margin-bottom:6px; display:block; }
        input, select { width:100%; padding:10px; border:1px solid #ddd; border-radius:6px; }

        .hint { color:#6c757d; font-size:0.9rem; margin-top:4px; }

        .actions { display:flex; gap:10px; margin-top:16px; }
        .btn { padding:10px 16px; border:none; border-radius:6px; text-decoration:none; display:inline-flex; align-items:center; gap:8px; cursor:pointer; }
        .btn-primary{ background:#3498db; color:#fff; }
        .btn-primary:hover{ background:#2980b9; }
        .btn-secondary{ background:#ecf0f1; color:#2c3e50; }
        .btn-secondary:hover{ background:#dfe4ea; }

        /* Bootstrap-like alerts (dùng class nếu đã có bootstrap), fallback màu sắc */
        .alert { padding:12px 16px; border-radius:6px; margin-bottom:12px; }
        .alert-success { background:#d4edda; color:#155724; border:1px solid #c3e6cb; }
        .alert-danger { background:#f8d7da; color:#721c24; border:1px solid #f5c6cb; }
    </style>
</head>
<body class="index-page">
    <!-- Header GIỮ NGUYÊN -->
    <jsp:include page="../includes/header.jsp" />

    <main class="main">
        <div class="container-fluid p-0">
            <div class="row g-0">

                <!-- Sidebar admin: GIỮ NGUYÊN include, chỉ bọc giống Home -->
                <c:if test="${not empty sessionScope.acc and sessionScope.acc.roleId == 1}">
                    <div class="sidebar-container">
                        <jsp:include page="../includes/sidebar-admin.jsp" />
                    </div>
                </c:if>

                <!-- Content -->
                <div class="main-content">
                    <div class="page-title">
                        <i class="fas fa-user-plus"></i>
                        <h2>
                            <c:choose>
                                <c:when test="${group eq 'staff'}">Tạo nhân viên</c:when>
                                <c:otherwise>Tạo khách hàng</c:otherwise>
                            </c:choose>
                        </h2>
                    </div>

                    <!-- Thông báo -->
                    <c:if test="${not empty sessionScope.message}">
                        <div class="alert ${sessionScope.messageType eq 'success' ? 'alert-success' : 'alert-danger'}" role="alert">
                            ${sessionScope.message}
                        </div>
                        <c:remove var="message" scope="session"/>
                        <c:remove var="messageType" scope="session"/>
                    </c:if>

                    <div class="card">
                        <c:url var="postUrl" value="/admin/users">
                            <c:param name="action" value="create"/>
                            <c:param name="group" value="${group}"/>
                        </c:url>

                        <form method="post" action="${postUrl}">
                            <div class="form-row">
                                <div class="col">
                                    <label>Username *</label>
                                    <input type="text" name="username" required />
                                </div>
                                <div class="col">
                                    <label>Email *</label>
                                    <input type="email" name="email" required />
                                </div>
                            </div>

                            <div class="form-row" style="margin-top:12px;">
                                <div class="col">
                                    <label>Phone</label>
                                    <input type="text" name="phone" />
                                    <div class="hint">Có thể để trống</div>
                                </div>

                                <c:choose>
                                    <c:when test="${group eq 'staff'}">
                                        <div class="col">
                                            <label>Vai trò *</label>
                                            <select name="roleId" required>
                                                <c:forEach var="r" items="${roles}">
                                                    <option value="${r.roleId}">${r.roleName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col">
                                            <label>Vai trò</label>
                                            <input type="text" value="Patient" disabled />
                                            <div class="hint">Tự động gán role Patient cho khách</div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="form-row" style="margin-top:12px;">
                                <div class="col">
                                    <label>Mật khẩu *</label>
                                    <input type="password" name="password" required />
                                </div>
                                <div class="col">
                                    <label>Xác nhận mật khẩu *</label>
                                    <input type="password" name="confirm" required />
                                </div>
                            </div>

                            <div class="actions">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Lưu</button>
                                <c:url var="backUrl" value="/admin/users">
                                    <c:param name="action" value="list"/>
                                    <c:param name="group" value="${group}"/>
                                </c:url>
                                <a class="btn btn-secondary" href="${backUrl}"><i class="fas fa-arrow-left"></i> Quay lại</a>
                            </div>
                        </form>
                    </div>
                </div><!-- /.main-content -->
            </div><!-- /.row -->
        </div><!-- /.container-fluid -->
    </main>

    <!-- Bootstrap bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
</body>
</html>
