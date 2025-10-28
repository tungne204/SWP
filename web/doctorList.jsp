<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="entity.Doctor" %>
<%@page import="java.util.List" %>
<%@page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    String searchName = (String) request.getAttribute("searchName");
    String sortOrder = (String) request.getAttribute("sortOrder");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalDoctors = (Integer) request.getAttribute("totalDoctors");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Danh sách Bác sĩ - Medilab Pediatric Clinic</title>
    
    <!-- Include all CSS files -->
    <jsp:include page="includes/head-includes.jsp"/>
    
    <style>
        #doctors-page {
            padding: 120px 0 80px;
            background: #f8f9fa;
            min-height: calc(100vh - 200px);
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 60px;
        }
        
        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #212529;
            margin-bottom: 15px;
        }
        
        .page-header p {
            font-size: 1.1rem;
            color: #6c757d;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .doctor-card-list {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            cursor: pointer;
        }
        
        .doctor-card-list:hover {
            transform: translateY(-8px);
            box-shadow: 0 5px 25px rgba(0,0,0,0.15);
        }
        
        a:hover .doctor-card-list {
            transform: translateY(-8px);
        }
        
        .doctor-avatar-list {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
            border: 4px solid #0d6efd;
        }
        
        .doctor-name-list {
            font-size: 1.3rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 10px;
        }
        
        .doctor-experience-list {
            color: #6c757d;
            font-size: 0.95rem;
        }
        
        .search-filter-box {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 40px;
        }
        
        .search-filter-box .form-control,
        .search-filter-box .form-select {
            border-radius: 8px;
            border: 1px solid #dee2e6;
            padding: 10px 15px;
        }
        
        .search-filter-box .btn {
            padding: 10px 25px;
            border-radius: 8px;
        }
    </style>
</head>

<body class="index-page">

    <!-- Header -->
    <jsp:include page="includes/header.jsp"/>

    <main id="main">
        <section id="doctors-page">
            <div class="container">
                <div class="page-header">
                    <h1>Đội ngũ bác sĩ</h1>
                    <p>Đội ngũ bác sĩ của chúng tôi với những bác sĩ chuyên môn cao, tận tâm luôn sẵn sàng hỗ trợ bạn trong mọi tình huống!</p>
                </div>

                <!-- Search and Filter -->
                <div class="search-filter-box">
                    <form action="${pageContext.request.contextPath}/doctorList" method="GET" class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label for="searchName" class="form-label mb-2">Tìm kiếm theo tên</label>
                            <input type="text" class="form-control" id="searchName" name="searchName" 
                                   placeholder="Nhập tên bác sĩ..." value="<%= searchName != null ? searchName : "" %>">
                        </div>
                        <div class="col-md-3">
                            <label for="sortOrder" class="form-label mb-2">Sắp xếp theo kinh nghiệm</label>
                            <select class="form-select" id="sortOrder" name="sortOrder">
                                <option value="">Mặc định</option>
                                <option value="asc" <%= "asc".equals(sortOrder) ? "selected" : "" %>>Tăng dần</option>
                                <option value="desc" <%= "desc".equals(sortOrder) ? "selected" : "" %>>Giảm dần</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-search me-1"></i>Tìm kiếm
                            </button>
                        </div>
                        <div class="col-md-2">
                            <a href="${pageContext.request.contextPath}/doctorList" class="btn btn-outline-secondary w-100">
                                <i class="bi bi-x-circle me-1"></i>Bỏ lọc
                            </a>
                        </div>
                    </form>
                </div>

                <% if (doctors != null && !doctors.isEmpty()) { %>
                <div class="row gy-4">
                    <% for (Doctor doctor : doctors) { %>
                    <div class="col-lg-6 col-md-6">
                        <a href="${pageContext.request.contextPath}/doctorDetail?doctorId=<%= doctor.getDoctorId() %>" 
                           style="text-decoration: none; color: inherit;">
                            <div class="doctor-card-list">
                                <img src="<%= request.getContextPath() %>/<%= doctor.getAvatar() %>" 
                                     alt="<%= doctor.getUsername() %>" 
                                     class="doctor-avatar-list"
                                     onerror="this.src='<%= request.getContextPath() %>/assets/img/avata.jpg'">
                                <h3 class="doctor-name-list"><%= doctor.getUsername() %></h3>
                                <p class="doctor-experience-list"><%= doctor.getExperienceYears() %> năm kinh nghiệm</p>
                            </div>
                        </a>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="text-center">
                    <p class="text-muted">Chưa có bác sĩ nào trong hệ thống</p>
                </div>
                <% } %>
                
                <!-- Pagination -->
                <% if (totalPages != null && totalPages > 1) { %>
                <div class="d-flex justify-content-center mt-5">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <!-- Previous button -->
                            <% if (currentPage != null && currentPage > 1) { %>
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/doctorList?page=<%= currentPage - 1 %><%= searchName != null && !searchName.isEmpty() ? "&searchName=" + java.net.URLEncoder.encode(searchName, "UTF-8") : "" %><%= sortOrder != null && !sortOrder.isEmpty() ? "&sortOrder=" + sortOrder : "" %>">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                            <% } else { %>
                            <li class="page-item disabled">
                                <span class="page-link"><i class="bi bi-chevron-left"></i></span>
                            </li>
                            <% } %>
                            
                            <!-- Page numbers -->
                            <% for (int i = 1; i <= totalPages; i++) { %>
                                <% if (i == currentPage) { %>
                                <li class="page-item active">
                                    <span class="page-link"><%= i %></span>
                                </li>
                                <% } else { %>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/doctorList?page=<%= i %><%= searchName != null && !searchName.isEmpty() ? "&searchName=" + java.net.URLEncoder.encode(searchName, "UTF-8") : "" %><%= sortOrder != null && !sortOrder.isEmpty() ? "&sortOrder=" + sortOrder : "" %>">
                                        <%= i %>
                                    </a>
                                </li>
                                <% } %>
                            <% } %>
                            
                            <!-- Next button -->
                            <% if (currentPage != null && currentPage < totalPages) { %>
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/doctorList?page=<%= currentPage + 1 %><%= searchName != null && !searchName.isEmpty() ? "&searchName=" + java.net.URLEncoder.encode(searchName, "UTF-8") : "" %><%= sortOrder != null && !sortOrder.isEmpty() ? "&sortOrder=" + sortOrder : "" %>">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                            <% } else { %>
                            <li class="page-item disabled">
                                <span class="page-link"><i class="bi bi-chevron-right"></i></span>
                            </li>
                            <% } %>
                        </ul>
                    </nav>
                </div>
                <% } %>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <jsp:include page="includes/footer.jsp"/>

    <!-- Include all JS files -->
    <jsp:include page="includes/footer-includes.jsp"/>

</body>

</html>

