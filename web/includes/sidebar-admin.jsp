<style>
    .sidebar-nav {
        padding: 20px 0;
    }
    
    .nav-section {
        margin-bottom: 30px;
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
        <!-- Bảng điều khiển -->
        <div class="nav-section">
            <div class="nav-section-title">Bảng điều khiển</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/" class="nav-link">
                    <i class="bi bi-speedometer2"></i>
                    <span class="nav-link-text">Trang tổng quan</span>
                </a>
            </div>
        </div>
      <div class="nav-section">
            <div class="nav-section-title">Danh sách người dùng</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
                    <i class="bi bi-clipboard-data"></i>
                    <span class="nav-link-text">Danh sách user</span>
                </a>
            </div>
           
        </div>
        
        <!-- Quản lý khuyến mãi -->
        <div class="nav-section">
            <div class="nav-section-title">Quản lý khuyến mãi</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager/discount?action=list" class="nav-link">
                    <i class="bi bi-percent"></i>
                    <span class="nav-link-text">Danh sách khuyến mãi</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager/discount?action=add" class="nav-link">
                    <i class="bi bi-plus-circle"></i>
                    <span class="nav-link-text">Thêm khuyến mãi</span>
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/manager/discount?action=expiring" class="nav-link">
                    <i class="bi bi-exclamation-triangle"></i>
                    <span class="nav-link-text">Khuyến mãi sắp hết hạn</span>
                </a>
            </div>
        </div>
        
    </nav>
</div>