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
    <title>Your Page Title - Medilab</title>
    
    <!-- ✅ BƯỚC 1: Include tất cả CSS files (Bootstrap, Icons, AOS, etc) -->
    <jsp:include page="includes/head-includes.jsp"/>
    
    <!-- Custom CSS cho trang này nếu cần -->
    <style>
        /* Your custom styles here */
    </style>
</head>

<body>

    <!-- ✅ BƯỚC 2: Include Header -->
    <jsp:include page="includes/header.jsp"/>

    <main class="main">
        <!-- Nội dung của bạn ở đây -->
        <div class="container">
            <h1>Your Content</h1>
        </div>
    </main>

    <!-- ✅ BƯỚC 3: Include Footer -->
    <jsp:include page="includes/footer.jsp"/>
    
    <!-- ✅ BƯỚC 4: Include tất cả JS files (Bootstrap, AOS, Glightbox, etc) -->
    <jsp:include page="includes/footer-includes.jsp"/>
    
    <!-- Custom JS cho trang này nếu cần -->
    <script>
        // Your custom JavaScript here
    </script>

</body>
</html>


