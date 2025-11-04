<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Liên Hệ - Medilab</title>
    <meta name="description" content="">
    <meta name="keywords" content="">

    <!-- Include all CSS files -->
    <jsp:include page="includes/head-includes.jsp"/>

    <style>
        .contact-section {
            padding: 80px 0;
            background: linear-gradient(135deg, #e8f5f6 0%, #d4eef0 100%);
            min-height: calc(100vh - 200px);
        }

        .contact-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .contact-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 40px;
            margin-top: 30px;
        }

        .contact-title {
            color: #2c4964;
            font-weight: 700;
            margin-bottom: 10px;
            text-align: center;
        }

        .contact-subtitle {
            color: #6c757d;
            text-align: center;
            margin-bottom: 30px;
        }

        .form-label {
            font-weight: 600;
            color: #2c4964;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 12px 15px;
            transition: all 0.3s;
        }

        .form-control:focus, .form-select:focus {
            border-color: #3fbbc0;
            box-shadow: 0 0 0 0.2rem rgba(63, 187, 192, 0.25);
        }

        .btn-submit {
            background: linear-gradient(135deg, #3fbbc0 0%, #2a9fa4 100%);
            color: white;
            border: none;
            padding: 12px 40px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
            width: 100%;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #2a9fa4 0%, #1f7a7e 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(63, 187, 192, 0.4);
        }

        .alert {
            border-radius: 8px;
            margin-bottom: 25px;
        }

        textarea.form-control {
            min-height: 150px;
            resize: vertical;
        }
    </style>
</head>

<body>
    <!-- Header -->
    <jsp:include page="includes/header.jsp"/>

    <!-- Contact Section -->
    <section class="contact-section">
        <div class="contact-container">
            <div class="contact-card">
                <h2 class="contact-title">Liên Hệ Với Chúng Tôi</h2>
                <p class="contact-subtitle">Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn</p>

                <!-- Success Message -->
                <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= request.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>

                <!-- Error Message -->
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>

                <form action="contact-submit" method="POST">
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Họ và Tên <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="fullName" name="fullName" 
                               value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>"
                               required>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="email" name="email" 
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                               required>
                    </div>

                    <div class="mb-3">
                        <label for="subject" class="form-label">Tiêu Đề</label>
                        <input type="text" class="form-control" id="subject" name="subject" 
                               value="<%= request.getAttribute("subject") != null ? request.getAttribute("subject") : "" %>"
                               placeholder="Nhập tiêu đề (tùy chọn)">
                    </div>

                    <div class="mb-3">
                        <label for="message" class="form-label">Nội Dung <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="message" name="message" rows="5" 
                                  required><%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %></textarea>
                    </div>

                    <button type="submit" class="btn btn-submit">
                        <i class="bi bi-send me-2"></i>Gửi Liên Hệ
                    </button>
                </form>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="includes/footer.jsp"/>

    <!-- Include all JS files -->
    <jsp:include page="includes/footer-includes.jsp"/>

</body>

</html>




