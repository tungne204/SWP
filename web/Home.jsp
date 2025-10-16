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
        <title>Index - Medilab Bootstrap Template</title>
        <meta name="description" content="">
        <meta name="keywords" content="">

        <!-- Favicons -->
        <link href="assets/img/favicon.png" rel="icon">
        <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

        <!-- Fonts -->
        <link href="https://fonts.googleapis.com" rel="preconnect">
        <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&family=Poppins:wght@100;200;300;400;500;600;700;800;900&family=Raleway:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

        <!-- Vendor CSS Files -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" 
              rel="stylesheet" 
              integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" 
              crossorigin="anonymous">
        <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
        <link href="assets/vendor/aos/aos.css" rel="stylesheet">
        <link href="assets/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
        <link href="assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
        <link href="assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

        <!-- Main CSS File -->
        <link href="assets/css/main.css" rel="stylesheet">
    </head>

    <body class="index-page">

        <header id="header" class="header sticky-top">

            <div class="topbar d-flex align-items-center">
                <div class="container d-flex justify-content-center justify-content-md-between">
                    <div class="contact-info d-flex align-items-center">
                        <i class="bi bi-envelope d-flex align-items-center"><a href="mailto:contact@example.com">contact@example.com</a></i>
                        <i class="bi bi-phone d-flex align-items-center ms-4"><span>+1 5589 55488 55</span></i>
                    </div>
                    <div class="social-links d-none d-md-flex align-items-center">
                        <a href="#" class="twitter"><i class="bi bi-twitter-x"></i></a>
                        <a href="#" class="facebook"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="instagram"><i class="bi bi-instagram"></i></a>
                        <a href="#" class="linkedin"><i class="bi bi-linkedin"></i></a>
                    </div>
                </div>
            </div><!-- End Top Bar -->

            <div class="branding d-flex align-items-center">
                <div class="container position-relative d-flex align-items-center justify-content-between">
                    <a href="index.jsp" class="logo d-flex align-items-center me-auto">
                        <h1 class="sitename">Medilab</h1>
                    </a>

                    <nav id="navmenu" class="navmenu">
                        <ul>
                            <li><a href="#hero" class="active">Home<br></a></li>
                            <li><a href="#about">About</a></li>
                            <li><a href="#services">Services</a></li>
                            <li><a href="#departments">Departments</a></li>
                            <li><a href="#doctors">Doctors</a></li>
                            <li><a href="#contact">Contact</a></li>
                        </ul>
                        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
                    </nav>

                    <a class="cta-btn d-none d-sm-block" href="#appointment">Make an Appointment</a>

                    <% if (acc == null) { %>
                    <a class="cta-btn d-none d-sm-block" href="Login.jsp">Login</a>
                    <% } else { %>
                    <div class="dropdown ms-4">
                        <button class="btn btn-outline-primary dropdown-toggle" type="button" id="userMenu" 
                                data-bs-toggle="dropdown" aria-expanded="false">
                            Hello, <%= acc.getUsername() %>
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="userMenu">
                            <li><a class="dropdown-item" href="viewProfile.jsp">View Profile</a></li>
                            <li><a class="dropdown-item" href="Change_password.jsp">Change Password</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout">Logout</a></li>
                        </ul>
                    </div>

                    <% } %>


                </div>
            </div>
        </header>

        <main class="main">

            <!-- Hero Section -->
            <section id="hero" class="hero section light-background">

                <img src="assets/img/hero-bg.jpg" alt="Children Clinic Background" data-aos="fade-in">

                <div class="container position-relative">

                    <div class="welcome position-relative" data-aos="fade-down" data-aos-delay="100">
                        <h2>WELCOME TO MEDILAB PEDIATRIC CLINIC</h2>
                        <p>We are a dedicated team providing high-quality healthcare services for children.</p>
                    </div><!-- End Welcome -->

                    <div class="content row gy-4">
                        <div class="col-lg-4 d-flex align-items-stretch">
                            <div class="why-box" data-aos="zoom-out" data-aos-delay="200">
                                <h3>Why Choose Our Pediatric Clinic?</h3>
                                <p>
                                    At Medilab Pediatric Clinic, we focus on compassionate and specialized care for children of all ages. 
                                    From routine check-ups to advanced treatments, our team ensures your child’s health and well-being 
                                    in a safe and friendly environment.
                                </p>
                                <div class="text-center">
                                    <a href="#about" class="more-btn"><span>Learn More</span> <i class="bi bi-chevron-right"></i></a>
                                </div>
                            </div>
                        </div><!-- End Why Box -->

                        <div class="col-lg-8 d-flex align-items-stretch">
                            <div class="d-flex flex-column justify-content-center">
                                <div class="row gy-4">

                                    <div class="col-xl-4 d-flex align-items-stretch">
                                        <div class="icon-box" data-aos="zoom-out" data-aos-delay="300">
                                            <i class="bi bi-clipboard-data"></i>
                                            <h4>Comprehensive Child Care</h4>
                                            <p>We provide preventive care, growth monitoring, and health education for children and families.</p>
                                        </div>
                                    </div><!-- End Icon Box -->

                                    <div class="col-xl-4 d-flex align-items-stretch">
                                        <div class="icon-box" data-aos="zoom-out" data-aos-delay="400">
                                            <i class="bi bi-gem"></i>
                                            <h4>Experienced Pediatricians</h4>
                                            <p>Our doctors are highly trained and dedicated to ensuring your child’s healthy development.</p>
                                        </div>
                                    </div><!-- End Icon Box -->

                                    <div class="col-xl-4 d-flex align-items-stretch">
                                        <div class="icon-box" data-aos="zoom-out" data-aos-delay="500">
                                            <i class="bi bi-inboxes"></i>
                                            <h4>Safe & Friendly Environment</h4>
                                            <p>We create a welcoming space where children feel comfortable during medical visits.</p>
                                        </div>
                                    </div><!-- End Icon Box -->

                                </div>
                            </div>
                        </div>
                    </div><!-- End  Content-->

                </div>

            </section><!-- /Hero Section -->


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
                            <p>
                                At Medilab Pediatric Clinic, we are committed to providing comprehensive healthcare 
                                services tailored to the needs of children from infancy to adolescence. 
                                Our mission is to create a safe, caring, and child-friendly environment where families 
                                can feel confident about their children’s health and well-being.
                            </p>
                            <ul>
                                <li>
                                    <i class="fa-solid fa-vial-circle-check"></i>
                                    <div>
                                        <h5>Comprehensive Child Health Services</h5>
                                        <p>From regular check-ups and vaccinations to specialized treatments, 
                                            we provide complete care for every stage of childhood.</p>
                                    </div>
                                </li>
                                <li>
                                    <i class="fa-solid fa-pump-medical"></i>
                                    <div>
                                        <h5>Modern Equipment & Facilities</h5>
                                        <p>Our clinic is equipped with advanced medical technology to ensure 
                                            accurate diagnoses and effective treatments.</p>
                                    </div>
                                </li>
                                <li>
                                    <i class="fa-solid fa-heart-circle-xmark"></i>
                                    <div>
                                        <h5>Compassionate Pediatricians</h5>
                                        <p>Our experienced doctors provide not only medical expertise 
                                            but also warm, caring support to children and families.</p>
                                    </div>
                                </li>
                            </ul>
                        </div>

                    </div>

                </div>

            </section><!-- /About Section -->


            <!-- Stats Section -->
            <section id="stats" class="stats section light-background">

                <div class="container" data-aos="fade-up" data-aos-delay="100">

                    <div class="row gy-4">

                        <div class="col-lg-3 col-md-6 d-flex flex-column align-items-center">
                            <i class="fa-solid fa-user-doctor"></i>
                            <div class="stats-item">
                                <span data-purecounter-start="0" data-purecounter-end="85" data-purecounter-duration="1" class="purecounter"></span>
                                <p>Doctors</p>
                            </div>
                        </div><!-- End Stats Item -->

                        <div class="col-lg-3 col-md-6 d-flex flex-column align-items-center">
                            <i class="fa-regular fa-hospital"></i>
                            <div class="stats-item">
                                <span data-purecounter-start="0" data-purecounter-end="2" data-purecounter-duration="1" class="purecounter"></span>
                                <p>Departments</p>
                            </div>
                        </div><!-- End Stats Item -->

                        <div class="col-lg-3 col-md-6 d-flex flex-column align-items-center">
                            <i class="fas fa-flask"></i>
                            <div class="stats-item">
                                <span data-purecounter-start="0" data-purecounter-end="5" data-purecounter-duration="1" class="purecounter"></span>
                                <p>Research Labs</p>
                            </div>
                        </div><!-- End Stats Item -->

                        <div class="col-lg-3 col-md-6 d-flex flex-column align-items-center">
                            <i class="fas fa-award"></i>
                            <div class="stats-item">
                                <span data-purecounter-start="0" data-purecounter-end="80" data-purecounter-duration="1" class="purecounter"></span>
                                <p>Awards</p>
                            </div>
                        </div><!-- End Stats Item -->

                    </div>

                </div>

            </section><!-- /Stats Section -->

            <!-- Services Section -->
            <section id="services" class="services section">

                <!-- Section Title -->
                <div class="container section-title" data-aos="fade-up">
                    <h2>Our Services</h2>
                    <p>Comprehensive pediatric healthcare services designed for your child’s health and well-being.</p>
                </div><!-- End Section Title -->

                <div class="container">

                    <div class="row gy-4">

                        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="100">
                            <div class="service-item  position-relative">
                                <div class="icon">
                                    <i class="fas fa-heartbeat"></i>
                                </div>
                                <a href="#" class="stretched-link">
                                    <h3>General Pediatric Check-ups</h3>
                                </a>
                                <p>Regular health check-ups to monitor growth, development, and prevent common illnesses in children.</p>
                            </div>
                        </div><!-- End Service Item -->

                        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="200">
                            <div class="service-item position-relative">
                                <div class="icon">
                                    <i class="fas fa-syringe"></i>
                                </div>
                                <a href="#" class="stretched-link">
                                    <h3>Vaccination Programs</h3>
                                </a>
                                <p>Complete immunization services to protect your child from preventable diseases and infections.</p>
                            </div>
                        </div><!-- End Service Item -->

                        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="300">
                            <div class="service-item position-relative">
                                <div class="icon">
                                    <i class="fas fa-hospital-user"></i>
                                </div>
                                <a href="#" class="stretched-link">
                                    <h3>Newborn & Infant Care</h3>
                                </a>
                                <p>Specialized care and guidance for newborns and infants to ensure a healthy start in life.</p>
                            </div>
                        </div><!-- End Service Item -->

                        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="400">
                            <div class="service-item position-relative">
                                <div class="icon">
                                    <i class="fas fa-dna"></i>
                                </div>
                                <a href="#" class="stretched-link">
                                    <h3>Allergy & Asthma Management</h3>
                                </a>
                                <p>Diagnosis and treatment for allergies, asthma, and other chronic conditions in children.</p>
                            </div>
                        </div><!-- End Service Item -->

                        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="500">
                            <div class="service-item position-relative">
                                <div class="icon">
                                    <i class="fas fa-wheelchair"></i>
                                </div>
                                <a href="#" class="stretched-link">
                                    <h3>Emergency Pediatric Care</h3>
                                </a>
                                <p>Immediate medical attention for urgent health issues, injuries, and sudden illnesses in children.</p>
                            </div>
                        </div><!-- End Service Item -->

                        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="600">
                            <div class="service-item position-relative">
                                <div class="icon">
                                    <i class="fas fa-notes-medical"></i>
                                </div>
                                <a href="#" class="stretched-link">
                                    <h3>Health Counseling for Families</h3>
                                </a>
                                <p>Guidance for parents on nutrition, mental health, and preventive care for a healthy childhood.</p>
                            </div>
                        </div><!-- End Service Item -->

                    </div>

                </div>

            </section><!-- /Services Section -->


            <!-- Appointment Section -->
            <section id="appointment" class="appointment section">

                <!-- Section Title -->
                <div class="container section-title" data-aos="fade-up">
                    <h2>Appointment</h2>
                    <p>Necessitatibus eius consequatur ex aliquid fuga eum quidem sint consectetur velit</p>
                </div><!-- End Section Title -->

                <div class="container" data-aos="fade-up" data-aos-delay="100">

                    <% 
                        String success = (String) request.getAttribute("success");
                        String error = (String) request.getAttribute("error");
                    %>

                    <% if (success != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <% if (acc != null && acc.getRoleId() == 3) { %>
                    <form action="appointment" method="post" role="form" >
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <input type="text" name="parentName" class="form-control" id="parentName" placeholder="Tên Bố/Mẹ" required="">
                            </div>
                            <div class="col-md-6 form-group mt-3 mt-md-0">
                                <input type="text" class="form-control" name="parentId" id="parentId" placeholder="CMND của bố mẹ" required="">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group mt-3">
                                <input type="text" name="childName" class="form-control" id="childName" placeholder="Tên con" required="">
                            </div>
                            <div class="col-md-6 form-group mt-3">
                                <input type="date" name="childDob" class="form-control" id="childDob" placeholder="Ngày sinh của con" required="">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group mt-3">
                                <input type="text" name="address" class="form-control" id="address" placeholder="Địa chỉ" required="">
                            </div>
                            <div class="col-md-6 form-group mt-3">
                                <input type="text" name="insuranceInfo" class="form-control" id="insuranceInfo" placeholder="Thông tin bảo hiểm" required="">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group mt-3">
                                <select name="doctorId" id="doctorId" class="form-select" required="">
                                    <option value="">Chọn bác sĩ</option>
                                    <!-- Doctors will be loaded via JavaScript -->
                                </select>
                            </div>
                            <div class="col-md-6 form-group mt-3">
                                <input type="date" name="appointmentDate" class="form-control" id="appointmentDate" placeholder="Ngày khám" required="">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 form-group mt-3">
                                <select name="appointmentTime" id="appointmentTime" class="form-select" required="">
                                    <option value="">Chọn giờ khám</option>
                                    <option value="08:00">8:00 AM</option>
                                    <option value="09:00">9:00 AM</option>
                                    <option value="10:00">10:00 AM</option>
                                    <option value="11:00">11:00 AM</option>
                                    <option value="13:00">1:00 PM</option>
                                    <option value="14:00">2:00 PM</option>
                                    <option value="15:00">3:00 PM</option>
                                    <option value="16:00">4:00 PM</option>
                                </select>
                            </div>
                        </div>

                        <div class="mt-3">
                            <div class="loading">Loading</div>
                            <div class="error-message"></div>
                            <div class="sent-message">Your appointment request has been sent successfully. Thank you!</div>
                            <div class="text-center"><button type="submit">Đặt lịch</button></div>
                        </div>
                    </form>
                    <% } else { %>
                    <div class="text-center">
                        <h4>Để đặt lịch hẹn, vui lòng đăng nhập với tài khoản bệnh nhân</h4>
                        <a href="Login.jsp" class="btn btn-primary">Đăng nhập</a>
                    </div>
                    <% } %>

                </div>

            </section><!-- /Appointment Section -->

            <!-- Departments Section -->
            <section id="departments" class="departments section">

                <!-- Section Title -->
                <div class="container section-title" data-aos="fade-up">
                    <h2>Departments</h2>
                    <p>Specialized pediatric departments dedicated to children’s health and well-being.</p>
                </div><!-- End Section Title -->

                <div class="container" data-aos="fade-up" data-aos-delay="100">

                    <div class="row">
                        <div class="col-lg-3">
                            <ul class="nav nav-tabs flex-column">
                                <li class="nav-item">
                                    <a class="nav-link active show" data-bs-toggle="tab" href="#departments-tab-1">General Pediatrics</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" data-bs-toggle="tab" href="#departments-tab-2">Neonatology</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" data-bs-toggle="tab" href="#departments-tab-3">Pediatric Nutrition</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" data-bs-toggle="tab" href="#departments-tab-4">Pediatric Neurology</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" data-bs-toggle="tab" href="#departments-tab-5">Pediatric Eye Care</a>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-9 mt-4 mt-lg-0">
                            <div class="tab-content">

                                <!-- General Pediatrics -->
                                <div class="tab-pane active show" id="departments-tab-1">
                                    <div class="row">
                                        <div class="col-lg-8 details order-2 order-lg-1">
                                            <h3>General Pediatrics</h3>
                                            <p class="fst-italic">Comprehensive healthcare for children of all ages, from routine check-ups to preventive care.</p>
                                            <p>Our pediatricians focus on overall growth, development, and early detection of common childhood illnesses. We provide vaccinations, health screenings, and treatment for acute and chronic conditions.</p>
                                        </div>
                                        <div class="col-lg-4 text-center order-1 order-lg-2">
                                            <img src="assets/img/departments-1.jpg" alt="General Pediatrics" class="img-fluid">
                                        </div>
                                    </div>
                                </div>

                                <!-- Neonatology -->
                                <div class="tab-pane" id="departments-tab-2">
                                    <div class="row">
                                        <div class="col-lg-8 details order-2 order-lg-1">
                                            <h3>Neonatology</h3>
                                            <p class="fst-italic">Specialized care for newborns, including premature babies and infants with medical needs.</p>
                                            <p>Our neonatal team ensures the best start for your baby with advanced monitoring, early screenings, and parental guidance for infant care at home.</p>
                                        </div>
                                        <div class="col-lg-4 text-center order-1 order-lg-2">
                                            <img src="assets/img/departments-2.jpg" alt="Neonatology" class="img-fluid">
                                        </div>
                                    </div>
                                </div>

                                <!-- Pediatric Nutrition -->
                                <div class="tab-pane" id="departments-tab-3">
                                    <div class="row">
                                        <div class="col-lg-8 details order-2 order-lg-1">
                                            <h3>Pediatric Nutrition</h3>
                                            <p class="fst-italic">Guidance and treatment for nutrition-related issues in children.</p>
                                            <p>We provide dietary counseling, weight management, and personalized meal plans to support healthy growth, address malnutrition, and prevent obesity in children.</p>
                                        </div>
                                        <div class="col-lg-4 text-center order-1 order-lg-2">
                                            <img src="assets/img/departments-3.jpg" alt="Pediatric Nutrition" class="img-fluid">
                                        </div>
                                    </div>
                                </div>

                                <!-- Pediatric Neurology -->
                                <div class="tab-pane" id="departments-tab-4">
                                    <div class="row">
                                        <div class="col-lg-8 details order-2 order-lg-1">
                                            <h3>Pediatric Neurology</h3>
                                            <p class="fst-italic">Diagnosis and treatment of neurological conditions in children.</p>
                                            <p>Our specialists care for children with epilepsy, developmental delays, headaches, and other neurological disorders, combining expertise with compassionate support for families.</p>
                                        </div>
                                        <div class="col-lg-4 text-center order-1 order-lg-2">
                                            <img src="assets/img/departments-4.jpg" alt="Pediatric Neurology" class="img-fluid">
                                        </div>
                                    </div>
                                </div>

                                <!-- Pediatric Eye Care -->
                                <div class="tab-pane" id="departments-tab-5">
                                    <div class="row">
                                        <div class="col-lg-8 details order-2 order-lg-1">
                                            <h3>Pediatric Eye Care</h3>
                                            <p class="fst-italic">Comprehensive eye examinations and treatments for children.</p>
                                            <p>From vision screenings to treatment for conditions such as lazy eye or myopia, our specialists ensure children’s visual health supports their learning and development.</p>
                                        </div>
                                        <div class="col-lg-4 text-center order-1 order-lg-2">
                                            <img src="assets/img/departments-5.jpg" alt="Pediatric Eye Care" class="img-fluid">
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                </div>

            </section><!-- /Departments Section -->

            <!-- Doctors Section -->
            <section id="doctors" class="doctors section">

                <!-- Section Title -->
                <div class="container section-title" data-aos="fade-up">
                    <h2>Doctors</h2>
                    <p>Necessitatibus eius consequatur ex aliquid fuga eum quidem sint consectetur velit</p>
                </div><!-- End Section Title -->

                <div class="container">

                    <div class="row gy-4">

                        <div class="col-lg-6" data-aos="fade-up" data-aos-delay="100">
                            <div class="team-member d-flex align-items-start">
                                <div class="pic"><img src="assets/img/doctors/doctors-1.jpg" class="img-fluid" alt=""></div>
                                <div class="member-info">
                                    <h4>Walter White</h4>
                                    <span>Chief Medical Officer</span>
                                    <p>Explicabo voluptatem mollitia et repellat qui dolorum quasi</p>
                                    <div class="social">
                                        <a href=""><i class="bi bi-twitter-x"></i></a>
                                        <a href=""><i class="bi bi-facebook"></i></a>
                                        <a href=""><i class="bi bi-instagram"></i></a>
                                        <a href=""> <i class="bi bi-linkedin"></i> </a>
                                    </div>
                                </div>
                            </div>
                        </div><!-- End Team Member -->

                        <div class="col-lg-6" data-aos="fade-up" data-aos-delay="200">
                            <div class="team-member d-flex align-items-start">
                                <div class="pic"><img src="assets/img/doctors/doctors-2.jpg" class="img-fluid" alt=""></div>
                                <div class="member-info">
                                    <h4>Sarah Jhonson</h4>
                                    <span>Anesthesiologist</span>
                                    <p>Aut maiores voluptates amet et quis praesentium qui senda para</p>
                                    <div class="social">
                                        <a href=""><i class="bi bi-twitter-x"></i></a>
                                        <a href=""><i class="bi bi-facebook"></i></a>
                                        <a href=""><i class="bi bi-instagram"></i></a>
                                        <a href=""> <i class="bi bi-linkedin"></i> </a>
                                    </div>
                                </div>
                            </div>
                        </div><!-- End Team Member -->

                        <div class="col-lg-6" data-aos="fade-up" data-aos-delay="300">
                            <div class="team-member d-flex align-items-start">
                                <div class="pic"><img src="assets/img/doctors/doctors-3.jpg" class="img-fluid" alt=""></div>
                                <div class="member-info">
                                    <h4>William Anderson</h4>
                                    <span>Cardiology</span>
                                    <p>Quisquam facilis cum velit laborum corrupti fuga rerum quia</p>
                                    <div class="social">
                                        <a href=""><i class="bi bi-twitter-x"></i></a>
                                        <a href=""><i class="bi bi-facebook"></i></a>
                                        <a href=""><i class="bi bi-instagram"></i></a>
                                        <a href=""> <i class="bi bi-linkedin"></i> </a>
                                    </div>
                                </div>
                            </div>
                        </div><!-- End Team Member -->

                        <div class="col-lg-6" data-aos="fade-up" data-aos-delay="400">
                            <div class="team-member d-flex align-items-start">
                                <div class="pic"><img src="assets/img/doctors/doctors-4.jpg" class="img-fluid" alt=""></div>
                                <div class="member-info">
                                    <h4>Amanda Jepson</h4>
                                    <span>Neurosurgeon</span>
                                    <p>Dolorum tempora officiis odit laborum officiis et et accusamus</p>
                                    <div class="social">
                                        <a href=""><i class="bi bi-twitter-x"></i></a>
                                        <a href=""><i class="bi bi-facebook"></i></a>
                                        <a href=""><i class="bi bi-instagram"></i></a>
                                        <a href=""> <i class="bi bi-linkedin"></i> </a>
                                    </div>
                                </div>
                            </div>
                        </div><!-- End Team Member -->

                    </div>

                </div>

            </section><!-- /Doctors Section -->

            <!-- Faq Section -->
            <section id="faq" class="faq section light-background">

                <!-- Section Title -->
                <div class="container section-title" data-aos="fade-up">
                    <h2>Frequently Asked Questions</h2>
                    <p>Find answers to common questions from parents about our pediatric clinic.</p>
                </div><!-- End Section Title -->

                <div class="container">

                    <div class="row justify-content-center">

                        <div class="col-lg-10" data-aos="fade-up" data-aos-delay="100">

                            <div class="faq-container">

                                <div class="faq-item faq-active">
                                    <h3>What ages of children do you provide care for?</h3>
                                    <div class="faq-content">
                                        <p>We provide healthcare services for children from newborns to adolescents (0–18 years old), covering every stage of growth and development.</p>
                                    </div>
                                    <i class="faq-toggle bi bi-chevron-right"></i>
                                </div><!-- End Faq item-->

                                <div class="faq-item">
                                    <h3>Do you offer vaccination services?</h3>
                                    <div class="faq-content">
                                        <p>Yes, we provide a full range of vaccinations recommended for children according to national and international guidelines. Our doctors will guide parents on the vaccination schedule appropriate for each age.</p>
                                    </div>
                                    <i class="faq-toggle bi bi-chevron-right"></i>
                                </div><!-- End Faq item-->

                                <div class="faq-item">
                                    <h3>How can I book an appointment for my child?</h3>
                                    <div class="faq-content">
                                        <p>You can book an appointment online through our website, by phone, or directly at our clinic’s reception desk. We recommend booking in advance to minimize waiting time.</p>
                                    </div>
                                    <i class="faq-toggle bi bi-chevron-right"></i>
                                </div><!-- End Faq item-->

                                <div class="faq-item">
                                    <h3>What should I bring when visiting the clinic?</h3>
                                    <div class="faq-content">
                                        <p>Please bring your child’s health records, vaccination history, and any medical prescriptions or test results if available. This helps our pediatricians provide the best care.</p>
                                    </div>
                                    <i class="faq-toggle bi bi-chevron-right"></i>
                                </div><!-- End Faq item-->

                                <div class="faq-item">
                                    <h3>Do you handle emergency cases?</h3>
                                    <div class="faq-content">
                                        <p>Yes, we provide emergency pediatric care during working hours. For severe or life-threatening emergencies, we recommend calling your local emergency number immediately.</p>
                                    </div>
                                    <i class="faq-toggle bi bi-chevron-right"></i>
                                </div><!-- End Faq item-->

                                <div class="faq-item">
                                    <h3>How much does a pediatric consultation cost?</h3>
                                    <div class="faq-content">
                                        <p>Consultation fees vary depending on the type of service and specialist. Please contact our reception desk or check the pricing section on our website for more details.</p>
                                    </div>
                                    <i class="faq-toggle bi bi-chevron-right"></i>
                                </div><!-- End Faq item-->

                            </div>

                        </div><!-- End Faq Column-->

                    </div>

                </div>

            </section><!-- /Faq Section -->


            <!-- Testimonials Section -->
            <section id="testimonials" class="testimonials section">

                <div class="container">

                    <div class="row align-items-center">

                        <div class="col-lg-5 info" data-aos="fade-up" data-aos-delay="100">
                            <h3>What Parents Say</h3>
                            <p>
                                Families trust us to care for their children’s health. Here are some words from parents 
                                about their experience at our pediatric clinic.
                            </p>
                        </div>

                        <div class="col-lg-7" data-aos="fade-up" data-aos-delay="200">

                            <div class="swiper init-swiper">
                                <script type="application/json" class="swiper-config">
                                    {
                                    "loop": true,
                                    "speed": 600,
                                    "autoplay": {
                                    "delay": 5000
                                    },
                                    "slidesPerView": "auto",
                                    "pagination": {
                                    "el": ".swiper-pagination",
                                    "type": "bullets",
                                    "clickable": true
                                    }
                                    }
                                </script>
                                <div class="swiper-wrapper">

                                    <!-- Testimonial 1 -->
                                    <div class="swiper-slide">
                                        <div class="testimonial-item">
                                            <div class="d-flex">
                                                <img src="assets/img/testimonials/testimonials-1.jpg" class="testimonial-img flex-shrink-0" alt="">
                                                <div>
                                                    <h3>Emily Johnson</h3>
                                                    <h4>Mother of 2-year-old</h4>
                                                    <div class="stars">
                                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <p>
                                                <i class="bi bi-quote quote-icon-left"></i>
                                                <span>The doctors here are amazing with kids! My daughter felt safe and comfortable during her check-up. The staff is warm and professional.</span>
                                                <i class="bi bi-quote quote-icon-right"></i>
                                            </p>
                                        </div>
                                    </div><!-- End testimonial item -->

                                    <!-- Testimonial 2 -->
                                    <div class="swiper-slide">
                                        <div class="testimonial-item">
                                            <div class="d-flex">
                                                <img src="assets/img/testimonials/testimonials-2.jpg" class="testimonial-img flex-shrink-0" alt="">
                                                <div>
                                                    <h3>Michael Carter</h3>
                                                    <h4>Father of 5-year-old</h4>
                                                    <div class="stars">
                                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <p>
                                                <i class="bi bi-quote quote-icon-left"></i>
                                                <span>The vaccination service is excellent and well-organized. The doctors explained everything clearly, which gave us peace of mind.</span>
                                                <i class="bi bi-quote quote-icon-right"></i>
                                            </p>
                                        </div>
                                    </div><!-- End testimonial item -->

                                    <!-- Testimonial 3 -->
                                    <div class="swiper-slide">
                                        <div class="testimonial-item">
                                            <div class="d-flex">
                                                <img src="assets/img/testimonials/testimonials-3.jpg" class="testimonial-img flex-shrink-0" alt="">
                                                <div>
                                                    <h3>Sophia Lee</h3>
                                                    <h4>Mother of twins</h4>
                                                    <div class="stars">
                                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <p>
                                                <i class="bi bi-quote quote-icon-left"></i>
                                                <span>The clinic is very child-friendly. My twins loved the play area and felt calm during their visit. Thank you for your thoughtful care!</span>
                                                <i class="bi bi-quote quote-icon-right"></i>
                                            </p>
                                        </div>
                                    </div><!-- End testimonial item -->

                                    <!-- Testimonial 4 -->
                                    <div class="swiper-slide">
                                        <div class="testimonial-item">
                                            <div class="d-flex">
                                                <img src="assets/img/testimonials/testimonials-4.jpg" class="testimonial-img flex-shrink-0" alt="">
                                                <div>
                                                    <h3>David Smith</h3>
                                                    <h4>Father of 8-year-old</h4>
                                                    <div class="stars">
                                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <p>
                                                <i class="bi bi-quote quote-icon-left"></i>
                                                <span>We visited in an emergency situation and the doctors acted quickly and professionally. Our son received excellent care.</span>
                                                <i class="bi bi-quote quote-icon-right"></i>
                                            </p>
                                        </div>
                                    </div><!-- End testimonial item -->

                                    <!-- Testimonial 5 -->
                                    <div class="swiper-slide">
                                        <div class="testimonial-item">
                                            <div class="d-flex">
                                                <img src="assets/img/testimonials/testimonials-5.jpg" class="testimonial-img flex-shrink-0" alt="">
                                                <div>
                                                    <h3>Anna Brown</h3>
                                                    <h4>Mother of 10-year-old</h4>
                                                    <div class="stars">
                                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <p>
                                                <i class="bi bi-quote quote-icon-left"></i>
                                                <span>The nutrition advice we received here helped improve my son’s health. I truly appreciate the care and support from the doctors.</span>
                                                <i class="bi bi-quote quote-icon-right"></i>
                                            </p>
                                        </div>
                                    </div><!-- End testimonial item -->

                                </div>
                                <div class="swiper-pagination"></div>
                            </div>

                        </div>

                    </div>

                </div>

            </section><!-- /Testimonials Section -->


            <!-- Gallery Section -->
            <section id="gallery" class="gallery section">

                <!-- Section Title -->
                <div class="container section-title" data-aos="fade-up">
                    <h2>Gallery</h2>
                    <p>Caring for your child’s health with expert pediatric care and a family-friendly environment.</p>

                </div><!-- End Section Title -->

                <div class="container-fluid" data-aos="fade-up" data-aos-delay="100">

                    <div class="row g-0">

                        <div class="col-lg-3 col-md-4">
                            <div class="gallery-item">
                                <a href="assets/img/gallery/gallery-1.jpg" class="glightbox" data-gallery="images-gallery">
                                    <img src="assets/img/gallery/gallery-1.jpg" alt="" class="img-fluid">
                                </a>
                            </div>
                        </div><!-- End Gallery Item -->

                        <div class="col-lg-3 col-md-4">
                            <div class="gallery-item">
                                <a href="assets/img/gallery/gallery-2.jpg" class="glightbox" data-gallery="images-gallery">
                                    <img src="assets/img/gallery/gallery-2.jpg" alt="" class="img-fluid">
                                </a>
                            </div>
                        </div><!-- End Gallery Item -->

                        <div class="col-lg-3 col-md-4">
                            <div class="gallery-item">
                                <a href="assets/img/gallery/gallery-3.jpg" class="glightbox" data-gallery="images-gallery">
                                    <img src="assets/img/gallery/gallery-3.jpg" alt="" class="img-fluid">
                                </a>
                            </div>
                        </div><!-- End Gallery Item -->

                        <div class="col-lg-3 col-md-4">
                            <div class="gallery-item">
                                <a href="assets/img/gallery/gallery-4.jpg" class="glightbox" data-gallery="images-gallery">
                                    <img src="assets/img/gallery/gallery-4.jpg" alt="" class="img-fluid">
                                </a>
                            </div>
                        </div><!-- End Gallery Item -->

                        <div class="col-lg-3 col-md-4">
                            <div class="gallery-item">
                                <a href="assets/img/gallery/gallery-5.jpg" class="glightbox" data-gallery="images-gallery">
                                    <img src="assets/img/gallery/gallery-5.jpg" alt="" class="img-fluid">
                                </a>
                            </div>
                        </div><!-- End Gallery Item -->

                        <div class="col-lg-3 col-md-4">
                            <div class="gallery-item">
                                <a href="assets/img/gallery/gallery-6.jpg" class="glightbox" data-gallery="images-gallery">
                                    <img src="assets/img/gallery/gallery-6.jpg" alt="" class="img-fluid">
                                </a>
                            </div>
                        </div><!-- End Gallery Item -->

                        <div class="col-lg-3 col-md-4">
                            <div class="gallery-item">
                                <a href="assets/img/gallery/gallery-7.jpg" class="glightbox" data-gallery="images-gallery">
                                    <img src="assets/img/gallery/gallery-7.jpg" alt="" class="img-fluid">
                                </a>
                            </div>
                        </div><!-- End Gallery Item -->

                        <div class="col-lg-3 col-md-4">
                            <div class="gallery-item">
                                <a href="assets/img/gallery/gallery-8.jpg" class="glightbox" data-gallery="images-gallery">
                                    <img src="assets/img/gallery/gallery-8.jpg" alt="" class="img-fluid">
                                </a>
                            </div>
                        </div><!-- End Gallery Item -->

                    </div>

                </div>

            </section><!-- /Gallery Section -->

            <!-- Contact Section -->
            <section id="contact" class="contact section">

                <!-- Section Title -->
                <div class="container section-title" data-aos="fade-up">
                    <h2>Contact</h2>
                    <p>Necessitatibus eius consequatur ex aliquid fuga eum quidem sint consectetur velit</p>
                </div><!-- End Section Title -->

                <div class="mb-5" data-aos="fade-up" data-aos-delay="200">
                    <iframe style="border:0; width: 100%; height: 270px;" src="https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d48389.78314118045!2d-74.006138!3d40.710059!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c25a22a3bda30d%3A0xb89d1fe6bc499443!2sDowntown%20Conference%20Center!5e0!3m2!1sen!2sus!4v1676961268712!5m2!1sen!2sus" frameborder="0" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div><!-- End Google Maps -->

                <div class="container" data-aos="fade-up" data-aos-delay="100">

                    <div class="row gy-4">

                        <div class="col-lg-4">
                            <div class="info-item d-flex" data-aos="fade-up" data-aos-delay="300">
                                <i class="bi bi-geo-alt flex-shrink-0"></i>
                                <div>
                                    <h3>Location</h3>
                                    <p>A108 Adam Street, New York, NY 535022</p>
                                </div>
                            </div><!-- End Info Item -->

                            <div class="info-item d-flex" data-aos="fade-up" data-aos-delay="400">
                                <i class="bi bi-telephone flex-shrink-0"></i>
                                <div>
                                    <h3>Call Us</h3>
                                    <p>+1 5589 55488 55</p>
                                </div>
                            </div><!-- End Info Item -->

                            <div class="info-item d-flex" data-aos="fade-up" data-aos-delay="500">
                                <i class="bi bi-envelope flex-shrink-0"></i>
                                <div>
                                    <h3>Email Us</h3>
                                    <p>info@example.com</p>
                                </div>
                            </div><!-- End Info Item -->

                        </div>

                        <div class="col-lg-8">
                            <form action="forms/contact.php" method="post" class="php-email-form" data-aos="fade-up" data-aos-delay="200">
                                <div class="row gy-4">

                                    <div class="col-md-6">
                                        <input type="text" name="name" class="form-control" placeholder="Your Name" required="">
                                    </div>

                                    <div class="col-md-6 ">
                                        <input type="email" class="form-control" name="email" placeholder="Your Email" required="">
                                    </div>

                                    <div class="col-md-12">
                                        <input type="text" class="form-control" name="subject" placeholder="Subject" required="">
                                    </div>

                                    <div class="col-md-12">
                                        <textarea class="form-control" name="message" rows="6" placeholder="Message" required=""></textarea>
                                    </div>

                                    <div class="col-md-12 text-center">
                                        <div class="loading">Loading</div>
                                        <div class="error-message"></div>
                                        <div class="sent-message">Your message has been sent. Thank you!</div>

                                        <button type="submit">Send Message</button>
                                    </div>

                                </div>
                            </form>
                        </div><!-- End Contact Form -->

                    </div>

                </div>

            </section><!-- /Contact Section -->

        </main>

        <footer id="footer" class="footer light-background">

            <div class="container footer-top">
                <div class="row gy-4">
                    <div class="col-lg-4 col-md-6 footer-about">
                        <a href="index.html" class="logo d-flex align-items-center">
                            <span class="sitename">Medilab</span>
                        </a>
                        <div class="footer-contact pt-3">
                            <p>A108 Adam Street</p>
                            <p>New York, NY 535022</p>
                            <p class="mt-3"><strong>Phone:</strong> <span>+1 5589 55488 55</span></p>
                            <p><strong>Email:</strong> <span>info@example.com</span></p>
                        </div>
                        <div class="social-links d-flex mt-4">
                            <a href=""><i class="bi bi-twitter-x"></i></a>
                            <a href=""><i class="bi bi-facebook"></i></a>
                            <a href=""><i class="bi bi-instagram"></i></a>
                            <a href=""><i class="bi bi-linkedin"></i></a>
                        </div>
                    </div>

                    <div class="col-lg-2 col-md-3 footer-links">
                        <h4>Useful Links</h4>
                        <ul>
                            <li><a href="#">Home</a></li>
                            <li><a href="#">About us</a></li>
                            <li><a href="#">Services</a></li>
                            <li><a href="#">Terms of service</a></li>
                            <li><a href="#">Privacy policy</a></li>
                        </ul>
                    </div>

                    <div class="col-lg-2 col-md-3 footer-links">
                        <h4>Our Services</h4>
                        <ul>
                            <li><a href="#">Web Design</a></li>
                            <li><a href="#">Web Development</a></li>
                            <li><a href="#">Product Management</a></li>
                            <li><a href="#">Marketing</a></li>
                            <li><a href="#">Graphic Design</a></li>
                        </ul>
                    </div>

                    <div class="col-lg-2 col-md-3 footer-links">
                        <h4>Hic solutasetp</h4>
                        <ul>
                            <li><a href="#">Molestiae accusamus iure</a></li>
                            <li><a href="#">Excepturi dignissimos</a></li>
                            <li><a href="#">Suscipit distinctio</a></li>
                            <li><a href="#">Dilecta</a></li>
                            <li><a href="#">Sit quas consectetur</a></li>
                        </ul>
                    </div>

                    <div class="col-lg-2 col-md-3 footer-links">
                        <h4>Nobis illum</h4>
                        <ul>
                            <li><a href="#">Ipsam</a></li>
                            <li><a href="#">Laudantium dolorum</a></li>
                            <li><a href="#">Dinera</a></li>
                            <li><a href="#">Trodelas</a></li>
                            <li><a href="#">Flexo</a></li>
                        </ul>
                    </div>

                </div>
            </div>

            <div class="container copyright text-center mt-4">
                <p>© <span>Copyright</span> <strong class="px-1 sitename">Medilab</strong> <span>All Rights Reserved</span></p>
                <div class="credits">
                    <!-- All the links in the footer should remain intact. -->
                    <!-- You can delete the links only if you've purchased the pro version. -->
                    <!-- Licensing information: https://bootstrapmade.com/license/ -->
                    <!-- Purchase the pro version with working PHP/AJAX contact form: [buy-url] -->
                    Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a> Distributed by <a href=?https://themewagon.com>ThemeWagon
                </div>
            </div>

        </footer>

        <!-- Scroll Top -->
        <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

        <!-- Preloader -->
        <div id="preloader"></div>

        <!-- Vendor JS Files -->
        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="assets/vendor/php-email-form/validate.js"></script>
        <script src="assets/vendor/aos/aos.js"></script>
        <script src="assets/vendor/glightbox/js/glightbox.min.js"></script>
        <script src="assets/vendor/purecounter/purecounter_vanilla.js"></script>
        <script src="assets/vendor/swiper/swiper-bundle.min.js"></script>

        <!-- Main JS File -->
        <script src="assets/js/main.js"></script>

        <!-- Appointment JS -->
        <script>
// Load doctors when page loads
document.addEventListener('DOMContentLoaded', function () {
    loadDoctors();
    setupDateValidation();
});

function loadDoctors() {
    fetch('doctors')
            .then(response => response.json())
            .then(doctors => {
                const doctorSelect = document.getElementById('doctorId');
                doctorSelect.innerHTML = '<option value="">Chọn bác sĩ</option>';

                doctors.forEach(doctor => {
    const option = document.createElement('option');
    option.value = doctor.doctorId;
    option.textContent = doctor.username + " - " + doctor.specialty; // 👈 hiển thị username + specialty
    doctorSelect.appendChild(option);
});

            })
            .catch(error => {
                console.error('Error loading doctors:', error);
                document.getElementById('doctorId').innerHTML = '<option value="">Lỗi tải danh sách bác sĩ</option>';
            });
}

function setupDateValidation() {
    const appointmentDateInput = document.getElementById('appointmentDate');
    const childDobInput = document.getElementById('childDob');

    if (appointmentDateInput) {
        const today = new Date();
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);

        const year = tomorrow.getFullYear();
        const month = String(tomorrow.getMonth() + 1).padStart(2, '0');
        const day = String(tomorrow.getDate()).padStart(2, '0');

        appointmentDateInput.min = `${year}-${month}-${day}`;
                }

                if (childDobInput) {
                    const today = new Date();
                    const year = today.getFullYear();
                    const month = String(today.getMonth() + 1).padStart(2, '0');
                    const day = String(today.getDate()).padStart(2, '0');

                    childDobInput.max = `${year}-${month}-${day}`;
                            }
                        }
        </script>

    </body>

</html>