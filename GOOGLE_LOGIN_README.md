# Google Login - Hướng dẫn sử dụng

## ✅ Đã hoàn thành

Chức năng đăng nhập Google đã được tích hợp hoàn chỉnh vào hệ thống Medilab với các tính năng:

### 🔧 Các file đã tạo/cập nhật:

1. **`web/Login.jsp`** - Giao diện đăng nhập với nút Google
2. **`src/java/control/GoogleOAuthCallback.java`** - Servlet xử lý callback từ Google
3. **`src/java/control/GoogleConfigServlet.java`** - Servlet cung cấp cấu hình Google
4. **`src/java/config/GoogleConfig.java`** - File cấu hình Google OAuth
5. **`src/java/dao/UserDAO.java`** - Thêm methods xử lý Google login/register

### 🚀 Tính năng:

- ✅ Đăng nhập bằng Google OAuth 2.0
- ✅ Tự động tạo tài khoản mới nếu chưa tồn tại
- ✅ Tích hợp với hệ thống role hiện có
- ✅ Redirect theo role (Admin, Doctor, Patient, etc.)
- ✅ Xử lý lỗi và thông báo người dùng
- ✅ Bảo mật Client ID

## 🔧 Cách cấu hình:

### Bước 1: Tạo Google OAuth Client ID
1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo project và kích hoạt Google Identity API
3. Tạo OAuth 2.0 Client ID
4. Thêm authorized origins: `http://localhost:8080`

### Bước 2: Cập nhật cấu hình
Mở file `src/java/config/GoogleConfig.java` và thay thế:
```java
public static final String GOOGLE_CLIENT_ID = "YOUR_ACTUAL_CLIENT_ID_HERE.apps.googleusercontent.com";
```

### Bước 3: Test
1. Deploy ứng dụng
2. Truy cập trang Login
3. Click nút "Google" để đăng nhập

## 📋 Luồng hoạt động:

1. **User click nút Google** → Google OAuth popup
2. **User chọn tài khoản** → Google trả về JWT token
3. **Frontend gửi token** → `GoogleOAuthCallback` servlet
4. **Server verify token** → Tìm/tạo user trong database
5. **Tạo session** → Redirect theo role

## 🔒 Bảo mật:

- Client ID được lưu trên server, không expose ra frontend
- JWT token được verify (có thể thêm Google API client library)
- Tự động tạo password ngẫu nhiên cho user Google
- Kiểm tra status user trước khi đăng nhập

## 🐛 Troubleshooting:

- **"Google Login chưa được cấu hình"** → Cập nhật Client ID trong GoogleConfig
- **"Invalid client"** → Kiểm tra Client ID và authorized origins
- **"Redirect URI mismatch"** → Thêm đúng URI trong Google Console

Xem file `GOOGLE_OAUTH_SETUP.md` để biết chi tiết cấu hình.
