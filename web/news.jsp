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
        <title>Tin tức - Medilab</title>
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

        <!-- ======= HEADER (giữ nguyên từ Home.jsp) ======= -->
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
                            <li><a href="Home.jsp">Home</a></li>
                            <li><a href="#about">About</a></li>
                            <li><a href="#services">Services</a></li>
                            <li><a href="#departments">Departments</a></li>
                            <li><a href="#doctors">Doctors</a></li>
                            <li><a href="news.jsp" class="active">News</a></li>
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
        <!-- ======= END HEADER ======= -->

        <!-- ======= MAIN CONTENT (Phần Tin Tức) ======= -->
        <main class="main">
            <section class="section py-5" style="background-color: #f7fbff;">
                <div class="container">
                    <div class="text-center mb-5">
                        <h2 class="fw-bold text-primary">Tin Tức</h2>
                        <p class="text-muted">Cập nhật các bài viết, sự kiện và chương trình mới nhất tại Medilab</p>
                    </div>

                    <div class="row gy-4">
                        <!-- Bài 1 -->
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm h-100">
                                <img src="assets/img/news-1.jpg" class="card-img-top" alt="Phòng bệnh mùa lạnh cho trẻ">
                                <div class="card-body">
                                    <h5 class="card-title fw-semibold">Phòng bệnh mùa lạnh cho trẻ</h5>
                                    <p class="card-text text-muted">Một số lời khuyên của bác sĩ về chăm sóc sức khỏe trẻ khi thời tiết chuyển mùa.</p>
                                    <a href="#" class="text-primary fw-semibold">Xem chi tiết →</a>
                                </div>
                            </div>
                        </div>

                        <!-- Bài 2 -->
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm h-100">
                                <img src="assets/img/news-2.jpg" class="card-img-top" alt="Chương trình tiêm phòng mở rộng">
                                <div class="card-body">
                                    <h5 class="card-title fw-semibold">Chương trình tiêm phòng mở rộng</h5>
                                    <p class="card-text text-muted">Medilab triển khai gói tiêm phòng ưu đãi cho trẻ dưới 5 tuổi trong tháng này.</p>
                                    <a href="#" class="text-primary fw-semibold">Xem chi tiết →</a>
                                </div>
                            </div>
                        </div>

                        <!-- Bài 3 -->
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm h-100">
                                <img src="assets/img/news-3.jpg" class="card-img-top" alt="Dinh dưỡng và phát triển chiều cao">
                                <div class="card-body">
                                    <h5 class="card-title fw-semibold">Dinh dưỡng và phát triển chiều cao</h5>
                                    <p class="card-text text-muted">Bác sĩ dinh dưỡng chia sẻ bí quyết giúp trẻ phát triển toàn diện.</p>
                                    <a href="#" class="text-primary fw-semibold">Xem chi tiết →</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <!-- ======= END MAIN ======= -->

        <!-- ======= FOOTER (giữ nguyên từ Home.jsp) ======= -->
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
                    Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a> Distributed by <a href="?https://themewagon.com">ThemeWagon</a>
                </div>
            </div>
        </footer>
        <!-- ======= END FOOTER ======= -->

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
    </body>
</html>
