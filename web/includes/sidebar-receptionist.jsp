<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .sidebar-nav {
    padding: 20px 0 0 0;
  }

  .nav-section {
    margin-bottom: 30px;
  }

  .nav-section:last-child {
    margin-bottom: 0;
    padding-bottom: 20px;
  }

  .nav-section-title {
    font-size: 12px;
    font-weight: 600;
    color: #6c757d;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 10px;
    padding: 0 20px;
  }

  .nav-item {
    margin-bottom: 5px;
  }

  .nav-link {
    display: flex;
    align-items: center;
    padding: 12px 20px;
    color: #495057;
    text-decoration: none;
    transition: all 0.3s ease;
    border-left: 3px solid transparent;
  }

  .nav-link:hover {
    background-color: #f8f9fa;
    color: var(--primary-color);
    border-left-color: var(--primary-color);
  }

  .nav-link.active {
    background-color: rgba(63, 187, 192, 0.1);
    color: var(--primary-color);
    border-left-color: var(--primary-color);
    font-weight: 500;
  }

  .nav-link i {
    width: 20px;
    margin-right: 12px;
    font-size: 16px;
  }

  .nav-link-text {
    flex: 1;
  }

  .nav-badge {
    background: #dc3545;
    color: white;
    font-size: 10px;
    padding: 2px 6px;
    border-radius: 10px;
    margin-left: auto;
  }
</style>

<div class="sidebar-fixed">
  <nav class="sidebar-nav">
    <!-- Dashboard Section -->
    <div class="nav-section">
      <br />
      <br />
      <div class="nav-section-title">Bảng điều khiển</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/" class="nav-link">
          <i class="bi bi-speedometer2"></i>
          <span class="nav-link-text">Trang tổng quan</span>
        </a>
      </div>
    </div>

    <!-- Patient Management -->
    <div class="nav-section">
      <div class="nav-section-title">Quản lý bệnh nhân</div>
      <div class="nav-item">
        <a
          href="${pageContext.request.contextPath}/receptionist"
          class="nav-link"
        >
          <i class="bi bi-person-plus"></i>
          <span class="nav-link-text">Tiếp nhận bệnh nhân</span>
        </a>
      </div>
    </div>

    <!-- Appointments -->
    <div class="nav-section">
      <div class="nav-section-title">Cuộc hẹn</div>
      <div class="nav-item">
        <a
          href="${pageContext.request.contextPath}/appointments"
          class="nav-link"
        >
          <i class="bi bi-calendar-check"></i>
          <span class="nav-link-text">Danh sách cuộc hẹn</span>
        </a>
      </div>
    </div>

    <!-- Queue Management -->
    <div class="nav-section">
      <div class="nav-section-title">Quản lý hàng chờ</div>
      <div class="nav-item">
        <a
          href="${pageContext.request.contextPath}/patient-queue"
          class="nav-link"
        >
          <i class="bi bi-people"></i>
          <span class="nav-link-text">Màn hình chờ</span>
        </a>
      </div>
      <div class="nav-item">
        <a
          href="${pageContext.request.contextPath}/patient-queue?action=public-view"
          class="nav-link"
          target="_blank"
        >
          <i class="bi bi-display"></i>
          <span class="nav-link-text">Hàng chờ công khai</span>
        </a>
      </div>
    </div>

    <!-- Revenue Management -->
    <div class="nav-section">
      <div class="nav-section-title">Quản lý doanh thu</div>
      <div class="nav-item">
        <a
          href="${pageContext.request.contextPath}/receptionist/revenue"
          class="nav-link"
        >
          <i class="bi bi-cash-stack"></i>
          <span class="nav-link-text">Doanh thu</span>
        </a>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="nav-section">
      <div class="nav-section-title">Thao tác nhanh</div>
      <div class="nav-item">
        <a
          href="${pageContext.request.contextPath}/reception/medical-reports"
          class="nav-link"
        >
          <i class="bi bi-plus-circle"></i>
          <span class="nav-link-text">Thanh toán đơn thuốc</span>
        </a>
      </div>
      <div class="nav-item">
        <a
          href="${pageContext.request.contextPath}/blog?action=add"
          class="nav-link"
        >
          <i class="bi bi-journal-text"></i>
          <span class="nav-link-text">Tạo bài viết</span>
        </a>
      </div>
    </div>

    <!-- Contact Management -->
    <div class="nav-section">
      <div class="nav-section-title">Contact Management</div>
      <div class="nav-item">
        <a
          href="${pageContext.request.contextPath}/manage-contacts"
          class="nav-link"
        >
          <i class="bi bi-envelope-check"></i>
          <span class="nav-link-text">Quản lý liên hệ</span>
        </a>
      </div>
    </div>
  </nav>
</div>
