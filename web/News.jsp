<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.News, java.util.List" %>
<%
    User acc = (User) session.getAttribute("acc");
    News news = (News) request.getAttribute("news");
    List<News> relatedNews = (List<News>) request.getAttribute("relatedNews");
    List<News> latestNews = (List<News>) request.getAttribute("latestNews");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title><%= news != null ? news.getTitle() : "News Detail" %> - Medilab</title>

    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon">
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@300;400;500;600&family=Raleway:wght@400;600;700&display=swap" rel="stylesheet">

    <!-- Vendor CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="assets/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

    <!-- Main CSS -->
    <link href="assets/css/main.css" rel="stylesheet">

    <style>
        main {
            margin-top: 140px;
        }
        .news-header {
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .news-thumbnail {
            width: 100%;
            border-radius: 10px;
            margin: 20px 0;
        }
        .news-content {
            line-height: 1.8;
            text-align: justify;
        }
        .sidebar-title {
            border-left: 4px solid #007bff;
            padding-left: 10px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .related-item, .latest-item {
            margin-bottom: 15px;
        }
        .related-item a, .latest-item a {
            text-decoration: none;
            color: #333;
        }
        .related-item a:hover, .latest-item a:hover {
            color: #007bff;
        }
        .meta {
            font-size: 0.9em;
            color: gray;
        }
    </style>
</head>

<body class="index-page">

<!-- ======= HEADER (copy nguyên từ Home.jsp) ======= -->
<header id="header" class="header sticky-top">

    <!-- Topbar -->
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
    </div>

    <!-- Branding + Nav -->
    <div class="branding d-flex align-items-center">
        <div class="container position-relative d-flex align-items-center justify-content-between">
            <a href="${pageContext.request.contextPath}/" class="logo d-flex align-items-center me-auto">
                <h1 class="sitename">Medilab</h1>
            </a>

            <nav id="navmenu" class="navmenu">
                <ul>
                    <li><a href="Home.jsp">Home</a></li>
                    <li><a href="Home.jsp">About</a></li>
                    <li><a href="Home.jsp">Services</a></li>
                    <li><a href="Home.jsp">Departments</a></li>
                    <li><a href="Home.jsp">Doctors</a></li>
                    <li><a href="News.jsp" class="active">News</a></li>
                    <li><a href="Home.jsp">Contact</a></li>
                </ul>
                <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
            </nav>

            <a class="cta-btn d-none d-sm-block" href="#appointment">Make an Appointment</a>

            <% if (acc == null) { %>
                <a class="cta-btn d-none d-sm-block" href="Login">Login</a>
            <% } else { %>
                <div class="dropdown ms-4">
                    <button class="btn btn-outline-primary dropdown-toggle" type="button" id="userMenu"
                            data-bs-toggle="dropdown" aria-expanded="false">
                        Hello, <%= acc.getUsername() %>
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="userMenu">
                        <li><a class="dropdown-item" href="viewProfile.jsp">View Profile</a></li>
                        <li><a class="dropdown-item" href="Change_password">Change Password</a></li>
                        <li><a class="dropdown-item" href="patient-appointment">View My Appointments</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="logout">Logout</a></li>
                    </ul>
                </div>
            <% } %>
        </div>
    </div>
</header>
<!-- ======= END HEADER ======= -->


<!-- ======= MAIN CONTENT ======= -->
<main class="container mb-5">

    <% if (news == null) { %>
        <div class="alert alert-danger mt-5">
            <i class="bi bi-exclamation-triangle"></i> News not found or has been removed.
        </div>
    <% } else { %>
        <div class="row mt-4">
            <!-- Main article -->
            <div class="col-lg-8">
                <div class="news-header">
                    <h2><%= news.getTitle() %></h2>
                    <% if (news.getSubtitle() != null && !news.getSubtitle().isEmpty()) { %>
                        <h5 class="text-muted"><%= news.getSubtitle() %></h5>
                    <% } %>
                    <div class="meta mt-2">
                        <i class="bi bi-person"></i> Author ID: <%= news.getAuthorId() %> |
                        <i class="bi bi-calendar"></i> <%= news.getCreatedDate() %>
                    </div>
                </div>

                <img src="<%= news.getThumbnail() != null ? news.getThumbnail() : "assets/img/default-news.jpg" %>" 
                     alt="Thumbnail" class="news-thumbnail">

                <div class="news-content">
                    <%= news.getContent() %>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <div class="mb-4">
                    <h5 class="sidebar-title">Related News</h5>
                    <% if (relatedNews != null && !relatedNews.isEmpty()) {
                        for (News r : relatedNews) { %>
                        <div class="related-item">
                            <a href="news?newsId=<%= r.getNewsId() %>">
                                <strong><%= r.getTitle() %></strong>
                            </a>
                            <div class="meta"><%= r.getCreatedDate() %></div>
                        </div>
                    <% } } else { %>
                        <p class="text-muted">No related news available.</p>
                    <% } %>
                </div>

                <div>
                    <h5 class="sidebar-title">Latest News</h5>
                    <% if (latestNews != null && !latestNews.isEmpty()) {
                        for (News l : latestNews) { %>
                        <div class="latest-item">
                            <a href="news?newsId=<%= l.getNewsId() %>">
                                <%= l.getTitle() %>
                            </a>
                            <div class="meta"><%= l.getCreatedDate() %></div>
                        </div>
                    <% } } else { %>
                        <p class="text-muted">No recent news found.</p>
                    <% } %>
                </div>
            </div>
        </div>
    <% } %>

</main>
<!-- ======= END MAIN ======= -->


<!-- ======= FOOTER (copy từ Home.jsp) ======= -->
<footer id="footer" class="footer light-background">

    <div class="container footer-top">
        <div class="row gy-4">
            <div class="col-lg-4 col-md-6 footer-about">
                <a href="Home.jsp" class="logo d-flex align-items-center">
                    <span class="sitename">Medilab</span>
                </a>
                <div class="footer-contact pt-3">
                    <p>A108 Adam Street</p>
                    <p>New York, NY 535022</p>
                    <p class="mt-3"><strong>Phone:</strong> <span>+1 5589 55488 55</span></p>
                    <p><strong>Email:</strong> <span>info@example.com</span></p>
                </div>
                <div class="social-links d-flex mt-4">
                    <a href="#"><i class="bi bi-twitter-x"></i></a>
                    <a href="#"><i class="bi bi-facebook"></i></a>
                    <a href="#"><i class="bi bi-instagram"></i></a>
                    <a href="#"><i class="bi bi-linkedin"></i></a>
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
                <h4>Resources</h4>
                <ul>
                    <li><a href="#">Blog</a></li>
                    <li><a href="#">FAQs</a></li>
                    <li><a href="#">Support</a></li>
                </ul>
            </div>
        </div>
    </div>

    <div class="container copyright text-center mt-4">
        <p>© <span>Copyright</span> <strong class="px-1 sitename">Medilab</strong> <span>All Rights Reserved</span></p>
        <div class="credits">
            Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a>
        </div>
    </div>
</footer>

<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
<div id="preloader"></div>

<!-- Vendor JS -->
<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/aos/aos.js"></script>
<script src="assets/vendor/glightbox/js/glightbox.min.js"></script>
<script src="assets/vendor/purecounter/purecounter_vanilla.js"></script>
<script src="assets/vendor/swiper/swiper-bundle.min.js"></script>
<script src="assets/js/main.js"></script>

</body>
</html>
