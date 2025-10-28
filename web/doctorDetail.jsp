<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="entity.Doctor" %>
<%@page import="entity.User" %>
<%
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Thông tin Bác sĩ - Medilab Pediatric Clinic</title>
    
    <!-- Include all CSS files -->
    <jsp:include page="includes/head-includes.jsp"/>
    
    <style>
        #doctor-detail-page {
            padding: 120px 0 80px;
            background: #f8f9fa;
            min-height: calc(100vh - 200px);
        }
        
        .doctor-detail-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.1);
        }
        
        .doctor-header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .doctor-avatar-detail {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #0d6efd;
            margin-bottom: 20px;
        }
        
        .doctor-header h1 {
            font-size: 2.2rem;
            font-weight: 700;
            color: #212529;
            margin-bottom: 10px;
        }
        
        .doctor-header p {
            font-size: 1.1rem;
            color: #6c757d;
        }
        
        .info-section {
            margin-top: 30px;
        }
        
        .info-item {
            display: grid;
            grid-template-columns: 200px 1fr;
            padding: 15px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
            font-size: 1rem;
        }
        
        .info-value {
            color: #212529;
            word-wrap: break-word;
            font-size: 1rem;
        }
        
        .intro-box {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #0d6efd;
        }
        
        .intro-box h4 {
            color: #212529;
            margin-bottom: 15px;
        }
        
        .intro-box p {
            color: #495057;
            line-height: 1.8;
            white-space: pre-wrap;
        }
        
        .certificate-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #0d6efd;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }
        
        .certificate-link:hover {
            color: #0a58ca;
        }
        
        .back-link {
            margin-bottom: 30px;
        }
    </style>
</head>

<body class="index-page">

    <!-- Header -->
    <jsp:include page="includes/header.jsp"/>

    <main id="main">
        <section id="doctor-detail-page">
            <div class="container">
                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/doctorList" class="btn btn-outline-primary">
                        <i class="bi bi-arrow-left me-2"></i>Quay lại danh sách bác sĩ
                    </a>
                </div>

                <% if (doctor != null) { %>
                <div class="doctor-detail-card">
                    <div class="doctor-header">
                        <img src="<%= request.getContextPath() %>/<%= doctor.getAvatar() %>" 
                             alt="<%= doctor.getUsername() %>" 
                             class="doctor-avatar-detail"
                             onerror="this.src='<%= request.getContextPath() %>/assets/img/avata.jpg'">
                        <h1><%= doctor.getUsername() %></h1>
                        <p>Bác sĩ chuyên khoa</p>
                    </div>

                    <div class="info-section">
                        <div class="info-item">
                            <span class="info-label">Tên đăng nhập:</span>
                            <span class="info-value"><%= doctor.getUsername() %></span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Email:</span>
                            <span class="info-value"><%= doctor.getEmail() != null ? doctor.getEmail() : "Chưa cập nhật" %></span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Số điện thoại:</span>
                            <span class="info-value"><%= doctor.getPhone() != null ? doctor.getPhone() : "Chưa cập nhật" %></span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Số năm kinh nghiệm:</span>
                            <span class="info-value"><%= doctor.getExperienceYears() > 0 ? doctor.getExperienceYears() + " năm" : "Chưa cập nhật" %></span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Chứng chỉ:</span>
                            <span class="info-value">
                                <% if (doctor.getCertificate() != null && !doctor.getCertificate().isEmpty()) { %>
                                    <a href="<%= request.getContextPath() %>/<%= doctor.getCertificate() %>" 
                                       target="_blank" 
                                       class="certificate-link"
                                       onclick="viewCertificate(event, '<%= request.getContextPath() %>/<%= doctor.getCertificate() %>')">
                                        <i class="bi bi-file-earmark-pdf"></i> Xem chứng chỉ
                                    </a>
                                <% } else { %>
                                    Chưa cập nhật
                                <% } %>
                            </span>
                        </div>
                    </div>

                    <% if (doctor.getIntroduce() != null && !doctor.getIntroduce().isEmpty()) { %>
                    <div class="intro-box">
                        <h4>Giới thiệu</h4>
                        <p><%= doctor.getIntroduce() %></p>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="text-center">
                    <h2>Không tìm thấy thông tin bác sĩ</h2>
                    <a href="${pageContext.request.contextPath}/doctorList" class="btn btn-primary mt-3">
                        Quay lại danh sách
                    </a>
                </div>
                <% } %>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <jsp:include page="includes/footer.jsp"/>

    <!-- Include all JS files -->
    <jsp:include page="includes/footer-includes.jsp"/>
    
    <!-- Certificate Modal -->
    <div class="modal fade" id="certificateModal" tabindex="-1" aria-labelledby="certificateModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="certificateModalLabel">Chứng chỉ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <iframe id="certificateFrame" src="" style="width: 100%; height: 600px; border: none;"></iframe>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function viewCertificate(event, certificateUrl) {
            event.preventDefault();
            const iframe = document.getElementById('certificateFrame');
            iframe.src = certificateUrl;
            
            // Show modal using Bootstrap
            const modal = new bootstrap.Modal(document.getElementById('certificateModal'));
            modal.show();
        }
    </script>

</body>

</html>

