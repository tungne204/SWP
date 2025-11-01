<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Home - Medilab Pediatric Clinic</title>
        <meta name="description" content="">
        <meta name="keywords" content="">

        <!-- Include all CSS files -->
        <jsp:include page="includes/head-includes.jsp"/>

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

            .main-content .section {
                position: relative;
                display: block !important;
                visibility: visible !important;
                opacity: 1 !important;
            }

            /* Ensure content is visible */
            .hero.section,
            .about.section {
                display: block !important;
                visibility: visible !important;
                opacity: 1 !important;
            }

            /* Responsive */
            @media (max-width: 991px) {
                .sidebar-container {
                    display: none;
                }
                .main-content {
                    margin-left: 0;
                }
            }

            /* Scrollbar for sidebar */
            .sidebar-fixed {
                padding-top: 20px;
            }

            .sidebar-fixed::-webkit-scrollbar {
                width: 6px;
            }

            .sidebar-fixed::-webkit-scrollbar-track {
                background: #f1f1f1;
            }

            .sidebar-fixed::-webkit-scrollbar-thumb {
                background: #888;
                border-radius: 3px;
            }

            .sidebar-fixed::-webkit-scrollbar-thumb:hover {
                background: #555;
            }

            /* Featured Doctors Section */
            #featured-doctors {
                padding: 80px 0;
                background: #f8f9fa;
            }

            .doctor-card {
                background: white;
                border-radius: 10px;
                padding: 30px;
                text-align: center;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                height: 100%;
                cursor: pointer;
            }

            .doctor-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            #featured-doctors-list a {
                text-decoration: none;
                color: inherit;
            }

            #featured-doctors-list a:hover {
                text-decoration: none;
                color: inherit;
            }

            .doctor-avatar {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                object-fit: cover;
                margin: 0 auto 20px;
                border: 4px solid #0d6efd;
            }

            .doctor-name {
                font-size: 1.3rem;
                font-weight: 600;
                color: #212529;
                margin-bottom: 10px;
            }

            .doctor-experience {
                color: #6c757d;
                font-size: 0.95rem;
            }
        </style>
    </head>

    <body class="index-page">

        <!-- Header -->
        <jsp:include page="includes/header.jsp"/>

        <main class="main" style="padding-top: 80px;">

            <%-- Show sidebar for Receptionist --%>
            <% if (acc != null && acc.getRoleId() == 5) { %>
            <div class="container-fluid p-0">
                <div class="row g-0">
                    <div class="sidebar-container">
                        <%@ include file="includes/sidebar-receptionist.jsp" %>
                    </div>
                    <div class="main-content">
                        <% } %>

                        <% if (acc != null && acc.getRoleId() == 2) { %>
                        <div class="container-fluid p-0">
                            <div class="row g-0">
                                <div class="sidebar-container">
                                    <%@ include file="includes/sidebar-doctor.jsp" %>
                                </div>
                                <div class="main-content">
                                    <% } %>
                                    <% if (acc != null && acc.getRoleId() == 4) { %>
                                    <div class="container-fluid p-0">
                                        <div class="row g-0">
                                            <div class="sidebar-container">
                                                <%@ include file="includes/sidebar-medicalassistant.jsp" %>
                                            </div>
                                            <div class="main-content">
                                                <% } %>
                                                 <% if (acc != null && acc.getRoleId() == 1) { %>
                                    <div class="container-fluid p-0">
                                        <div class="row g-0">
                                            <div class="sidebar-container">
                                                <%@ include file="includes/sidebar-admin.jsp" %>
                                            </div>
                                            <div class="main-content">
                                                <% } %>


                                                <!-- Hero Section -->
                                                <section id="hero" class="hero section light-background">
                                                    <img src="assets/img/hero-bg.jpg" alt="Hình nền Phòng khám Nhi Medilab" data-aos="fade-in">
                                                    <div class="container position-relative">
                                                        <div class="welcome position-relative" data-aos="fade-down" data-aos-delay="100">
                                                            <h2>CHÀO MỪNG ĐẾN VỚI PHÒNG KHÁM NHI MEDILAB</h2>
                                                            <p>Chúng tôi là đội ngũ y bác sĩ tận tâm, cung cấp dịch vụ chăm sóc sức khỏe chất lượng cao cho trẻ em.</p>
                                                        </div>

                                                        <div class="content row gy-4">
                                                            <div class="col-lg-4 d-flex align-items-stretch">
                                                                <div class="why-box" data-aos="zoom-out" data-aos-delay="200">
                                                                    <h3>Tại sao nên chọn Phòng khám Nhi Medilab?</h3>
                                                                    <p>Tại Medilab, chúng tôi tập trung vào việc mang lại sự chăm sóc tận tâm và chuyên biệt cho trẻ em ở mọi lứa tuổi. 
                                                                        Từ khám định kỳ đến điều trị chuyên sâu, đội ngũ của chúng tôi luôn đảm bảo sức khỏe và sự phát triển toàn diện cho trẻ trong môi trường an toàn, thân thiện.</p>
                                                                    <div class="text-center">
                                                                        <a href="#about" class="more-btn"><span>Tìm hiểu thêm</span> <i class="bi bi-chevron-right"></i></a>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="col-lg-8 d-flex align-items-stretch">
                                                                <div class="d-flex flex-column justify-content-center">
                                                                    <div class="row gy-4">
                                                                        <div class="col-xl-4 d-flex align-items-stretch">
                                                                            <div class="icon-box" data-aos="zoom-out" data-aos-delay="300">
                                                                                <i class="bi bi-clipboard-data"></i>
                                                                                <h4>Chăm sóc toàn diện cho trẻ</h4>
                                                                                <p>Chúng tôi cung cấp các dịch vụ chăm sóc dự phòng, theo dõi tăng trưởng và tư vấn sức khỏe cho trẻ và gia đình.</p>
                                                                            </div>
                                                                        </div>

                                                                        <div class="col-xl-4 d-flex align-items-stretch">
                                                                            <div class="icon-box" data-aos="zoom-out" data-aos-delay="400">
                                                                                <i class="bi bi-gem"></i>
                                                                                <h4>Bác sĩ nhi giàu kinh nghiệm</h4>
                                                                                <p>Đội ngũ bác sĩ của chúng tôi được đào tạo chuyên sâu, tận tâm với sức khỏe và sự phát triển của trẻ em.</p>
                                                                            </div>
                                                                        </div>

                                                                        <div class="col-xl-4 d-flex align-items-stretch">
                                                                            <div class="icon-box" data-aos="zoom-out" data-aos-delay="500">
                                                                                <i class="bi bi-inboxes"></i>
                                                                                <h4>Môi trường thân thiện & an toàn</h4>
                                                                                <p>Chúng tôi xây dựng không gian khám chữa bệnh ấm áp, giúp trẻ cảm thấy thoải mái và an tâm khi đến thăm khám.</p>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </section>

                                                <!-- About Section -->
                                                <section id="about" class="about section">
                                                    <div class="container">
                                                        <div class="row gy-4 gx-5">
                                                            <div class="col-lg-6 position-relative align-self-start" data-aos="fade-up" data-aos-delay="200">
                                                                <img src="assets/img/about.jpg" class="img-fluid" alt="Giới thiệu về Phòng khám Nhi Medilab">
                                                                <a href="https://www.youtube.com/watch?v=Y7f98aduVJ8" class="glightbox pulsating-play-btn"></a>
                                                            </div>

                                                            <div class="col-lg-6 content" data-aos="fade-up" data-aos-delay="100">
                                                                <h3>Giới thiệu về Phòng khám Nhi Medilab</h3>
                                                                <p>Tại Medilab, chúng tôi cam kết mang đến dịch vụ chăm sóc sức khỏe toàn diện, phù hợp với từng giai đoạn phát triển của trẻ – từ sơ sinh đến tuổi thiếu niên.</p>
                                                                <ul>
                                                                    <li>
                                                                        <i class="fa-solid fa-vial-circle-check"></i>
                                                                        <div>
                                                                            <h5>Dịch vụ chăm sóc sức khỏe toàn diện cho trẻ</h5>
                                                                            <p>Từ khám tổng quát, tiêm chủng, đến các điều trị chuyên khoa nhi chuyên sâu.</p>
                                                                        </div>
                                                                    </li>
                                                                    <li>
                                                                        <i class="fa-solid fa-pump-medical"></i>
                                                                        <div>
                                                                            <h5>Trang thiết bị & cơ sở vật chất hiện đại</h5>
                                                                            <p>Ứng dụng công nghệ tiên tiến để đảm bảo chẩn đoán chính xác và điều trị hiệu quả nhất.</p>
                                                                        </div>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </section>

                                                <!-- Featured Doctors Section -->
                                                <section id="featured-doctors" class="section">
                                                    <div class="container">
                                                        <div class="section-header">
                                                            <span class="sub-title">Đội ngũ chuyên gia</span>
                                                            <h2>Các bác sĩ tiêu biểu</h2>
                                                            <p>Đội ngũ bác sĩ giàu kinh nghiệm, tận tâm chăm sóc sức khỏe cho trẻ em</p>
                                                        </div>

                                                        <div class="row gy-4" id="featured-doctors-list">
                                                            <!-- Doctors will be loaded via AJAX -->
                                                        </div>

                                                        <div class="text-center mt-4">
                                                            <a href="${pageContext.request.contextPath}/doctorList" class="btn btn-primary">
                                                                Xem tất cả bác sĩ
                                                            </a>
                                                        </div>
                                                    </div>
                                                </section>

                                                <!-- More sections can be added here... -->

                                                <%-- Close layout for Receptionist --%>
                                                <% if (acc != null && acc.getRoleId() == 5) { %>
                                            </div>
                                        </div>
                                    </div>
                                    <% } %>

                                    </main>

                                    <!-- Footer -->
                                    <jsp:include page="includes/footer.jsp"/>

                                    <!-- Include all JS files -->
                                    <jsp:include page="includes/footer-includes.jsp"/>

                                    <script>
                                        // Load featured doctors
                                        document.addEventListener('DOMContentLoaded', function () {
                                            const contextPath = '<%= request.getContextPath() %>';

                                            console.log('Loading featured doctors from: ' + contextPath + '/featuredDoctors');

                                            const container = document.getElementById('featured-doctors-list');
                                            if (!container) {
                                                console.error('Container #featured-doctors-list not found!');
                                                return;
                                            }

                                            fetch(contextPath + '/featuredDoctors')
                                                    .then(response => {
                                                        console.log('Response status:', response.status);
                                                        if (!response.ok) {
                                                            throw new Error('HTTP error! status: ' + response.status);
                                                        }
                                                        return response.json();
                                                    })
                                                    .then(doctors => {
                                                        console.log('Received doctors:', doctors);
                                                        console.log('Container element:', container);

                                                        if (doctors.length === 0) {
                                                            container.innerHTML = '<div class="col-12 text-center"><p class="text-muted">Chưa có bác sĩ nào</p></div>';
                                                            return;
                                                        }

                                                        let html = '';
                                                        doctors.forEach(function (doctor) {
                                                            html += '<div class="col-lg-4 col-md-6">';
                                                            html += '<a href="' + contextPath + '/doctorDetail?doctorId=' + doctor.doctorId + '" style="text-decoration: none; color: inherit;">';
                                                            html += '<div class="doctor-card">';
                                                            html += '<img src="' + contextPath + '/' + doctor.avatar + '" alt="' + doctor.username + '" class="doctor-avatar">';
                                                            html += '<h3 class="doctor-name">' + doctor.username + '</h3>';
                                                            html += '<p class="doctor-experience">' + doctor.experienceYears + ' năm kinh nghiệm</p>';
                                                            html += '</div></a></div>';
                                                        });

                                                        container.innerHTML = html;
                                                        console.log('HTML inserted successfully');
                                                    })
                                                    .catch(error => {
                                                        console.error('Error loading doctors:', error);
                                                        container.innerHTML = '<div class="col-12 text-center"><p class="text-muted">Không thể tải danh sách bác sĩ: ' + error.message + '</p></div>';
                                                    });
                                        });
                                    </script>

                                    </body>
                                    </html>
