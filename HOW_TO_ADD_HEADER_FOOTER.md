# Cách thêm Header và Footer vào các trang JSP

## 🎉 CÁCH MỚI - CHỈ CẦN 3 DÒNG!

### Files đã tạo sẵn:
- `includes/head-includes.jsp` - Tất cả CSS files
- `includes/header.jsp` - Header với user menu
- `includes/footer.jsp` - Footer
- `includes/footer-includes.jsp` - Tất cả JS files

### Cách sử dụng:
```jsp
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Page</title>
    
    <!-- ✅ 1. Include CSS -->
    <jsp:include page="includes/head-includes.jsp"/>
</head>

<body>
    <!-- ✅ 2. Include Header -->
    <jsp:include page="includes/header.jsp"/>
    
    <!-- Your content here -->
    
    <!-- ✅ 3. Include Footer + JS -->
    <jsp:include page="includes/footer.jsp"/>
    <jsp:include page="includes/footer-includes.jsp"/>
</body>
</html>
```

**XONG! Chỉ cần 3 dòng là có đầy đủ CSS, Header, Footer và JS!** 🎉

## Có 2 cách include trong JSP:

### 1. `<jsp:include>` (Được khuyến nghị - Dynamic Include)
Include khi trang được request, cho phép truyền tham số.

**Syntax:**
```jsp
<jsp:include page="path/to/file.jsp"/>
```

### 2. `<%@ include %>` (Static Include)
Include tại compile time, copy toàn bộ code vào.

**Syntax:**
```jsp
<%@ include file="path/to/file.jsp" %>
```

## Cấu trúc chuẩn của một trang JSP:

```jsp
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
    <title>Your Page Title</title>
    
    <!-- CSS Files -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Custom CSS nếu cần -->
    <style>
        /* Your custom styles */
    </style>
</head>

<body>

    <!-- ✅ Header -->
    <jsp:include page="includes/header.jsp"/>

    <!-- ✅ Main Content của bạn -->
    <main class="main">
        <div class="container">
            <!-- Nội dung trang -->
        </div>
    </main>

    <!-- ✅ Footer -->
    <jsp:include page="includes/footer.jsp"/>
    
    <!-- ✅ JavaScript Files -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS nếu cần -->
    <script>
        // Your custom JS
    </script>

</body>
</html>
```

## Ví dụ cho trang Dashboard:

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User acc = (User) session.getAttribute("acc");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Dashboard | Medilab</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
</head>

<body>
    <!-- ✅ HEADER -->
    <jsp:include page="../includes/header.jsp"/>
    
    <!-- Content Area -->
    <div class="container mt-4">
        <h1>Dashboard Content</h1>
        <!-- Nội dung của bạn -->
    </div>

    <!-- ✅ FOOTER -->
    <jsp:include page="../includes/footer.jsp"/>
    
    <!-- ✅ JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

## Đường dẫn include:

### Từ root web folder (web/):
```jsp
<jsp:include page="includes/header.jsp"/>
<jsp:include page="includes/footer.jsp"/>
```

### Từ thư mục con (web/receptionist/):
```jsp
<jsp:include page="../includes/header.jsp"/>
<jsp:include page="../includes/footer.jsp"/>
```

### Từ thư mục sâu hơn (web/doctor/...):
```jsp
<jsp:include page="../../includes/header.jsp"/>
<jsp:include page="../../includes/footer.jsp"/>
```

## Danh sách các trang đã được update:

### ✅ Đã có Header + Footer:
- `web/Home.jsp`
- `web/receptionist/ReceptionistDashboard.jsp`
- `web/includes/header.jsp` (chứa user menu)
- `web/includes/footer.jsp` (chứa footer info)

### 📝 Cần thêm Header + Footer:
- `web/doctor/doctorDashboard.jsp`
- `web/patient/viewProfile.jsp`
- Các trang khác theo nhu cầu

## Quy trình thêm Header/Footer:

1. **Mở file JSP cần thêm**
2. **Thêm vào sau thẻ `<body>`:**
   ```jsp
   <!-- Header -->
   <jsp:include page="../includes/header.jsp"/>
   ```
3. **Thêm vào trước thẻ `</body>`:**
   ```jsp
   <!-- Footer -->
   <jsp:include page="../includes/footer.jsp"/>
   ```
4. **Thêm Bootstrap JS (nếu chưa có):**
   ```jsp
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
   ```

## Lưu ý:

1. **Path tương đối**: `../` = lên 1 cấp thư mục
2. **Không duplicate**: Đảm bảo không include header/footer 2 lần
3. **Bootstrap JS**: Chỉ thêm 1 lần ở cuối trang
4. **Custom CSS**: Thêm vào `<style>` trong `<head>`
5. **Custom JS**: Thêm vào `<script>` trước `</body>`

## Debugging:

Nếu header/footer không hiển thị:
1. Kiểm tra path có đúng không
2. Kiểm tra file có tồn tại không
3. Kiểm tra console browser để xem lỗi
4. Đảm bảo server đã restart

