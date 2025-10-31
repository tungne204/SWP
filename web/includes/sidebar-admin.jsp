<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        
      <div class="nav-section">
            <div class="nav-section-title">Danh sách người dùng</div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
                    <i class="bi bi-clipboard-data"></i>
                    <span class="nav-link-text">Danh sách user</span>
                </a>
            </div>
           
        </div>
        
        
        
       
        
    </nav>
</div>