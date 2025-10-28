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
           



            <!-- Hero Section -->
            <section id="hero" class="hero section light-background">
                <img src="assets/img/hero-bg.jpg" alt="Children Clinic Background" data-aos="fade-in">
                <div class="container position-relative">
                    <div class="welcome position-relative" data-aos="fade-down" data-aos-delay="100">
                        <h2>WELCOME TO MEDILAB PEDIATRIC CLINIC</h2>
                        <p>We are a dedicated team providing high-quality healthcare services for children.</p>
                        </div>

                    <div class="content row gy-4">
                        <div class="col-lg-4 d-flex align-items-stretch">
                            <div class="why-box" data-aos="zoom-out" data-aos-delay="200">
                                <h3>Why Choose Our Pediatric Clinic?</h3>
                                    <p>At Medilab Pediatric Clinic, we focus on compassionate and specialized care for children of all ages. From routine check-ups to advanced treatments, our team ensures your child's health and well-being in a safe and friendly environment.</p>
                                <div class="text-center">
                                    <a href="#about" class="more-btn"><span>Learn More</span> <i class="bi bi-chevron-right"></i></a>
                                    </div>
                                </div>
                            </div>

                        <div class="col-lg-8 d-flex align-items-stretch">
                            <div class="d-flex flex-column justify-content-center">
                                <div class="row gy-4">
                                    <div class="col-xl-4 d-flex align-items-stretch">
                                        <div class="icon-box" data-aos="zoom-out" data-aos-delay="300">
                                            <i class="bi bi-clipboard-data"></i>
                                            <h4>Comprehensive Child Care</h4>
                                            <p>We provide preventive care, growth monitoring, and health education for children and families.</p>
                                        </div>
                                        </div>

                                    <div class="col-xl-4 d-flex align-items-stretch">
                                        <div class="icon-box" data-aos="zoom-out" data-aos-delay="400">
                                            <i class="bi bi-gem"></i>
                                            <h4>Experienced Pediatricians</h4>
                                                <p>Our doctors are highly trained and dedicated to ensuring your child's healthy development.</p>
                                            </div>
                                        </div>

                                    <div class="col-xl-4 d-flex align-items-stretch">
                                        <div class="icon-box" data-aos="zoom-out" data-aos-delay="500">
                                            <i class="bi bi-inboxes"></i>
                                            <h4>Safe & Friendly Environment</h4>
                                            <p>We create a welcoming space where children feel comfortable during medical visits.</p>
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
                            <img src="assets/img/about.jpg" class="img-fluid" alt="About Our Pediatric Clinic">
                            <a href="https://www.youtube.com/watch?v=Y7f98aduVJ8" class="glightbox pulsating-play-btn"></a>
                        </div>
                        <div class="col-lg-6 content" data-aos="fade-up" data-aos-delay="100">
                            <h3>About Our Pediatric Clinic</h3>
                                <p>At Medilab Pediatric Clinic, we are committed to providing comprehensive healthcare services tailored to the needs of children from infancy to adolescence.</p>
                            <ul>
                                <li>
                                    <i class="fa-solid fa-vial-circle-check"></i>
                                    <div>
                                        <h5>Comprehensive Child Health Services</h5>
                                            <p>From regular check-ups and vaccinations to specialized treatments.</p>
                                    </div>
                                </li>
                                <li>
                                    <i class="fa-solid fa-pump-medical"></i>
                                    <div>
                                        <h5>Modern Equipment & Facilities</h5>
                                            <p>State-of-the-art technology for accurate diagnosis and treatment.</p>
                                    </div>
                                </li>
                            </ul>
                            </div>
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

</body>
</html>
