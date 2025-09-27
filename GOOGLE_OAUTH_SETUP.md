# Hướng dẫn cấu hình Google OAuth

## Bước 1: Tạo Google OAuth Client ID

1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo project mới hoặc chọn project hiện có
3. Kích hoạt Google+ API hoặc Google Identity API
4. Vào **Credentials** > **Create Credentials** > **OAuth 2.0 Client IDs**
5. Chọn **Web application**
6. Thêm **Authorized JavaScript origins**:
   - `http://localhost:8080` (cho development)
   - `https://yourdomain.com` (cho production)
7. Thêm **Authorized redirect URIs**:
   - `http://localhost:8080/SWP01/Login.jsp`
   - `https://yourdomain.com/SWP01/Login.jsp`
8. Lưu Client ID

## Bước 2: Cập nhật Client ID trong code

### Trong file `web/Login.jsp`:
Thay thế `YOUR_GOOGLE_CLIENT_ID` bằng Client ID thực tế:

```javascript
google.accounts.id.initialize({
    client_id: 'YOUR_ACTUAL_CLIENT_ID_HERE.apps.googleusercontent.com',
    callback: handleCredentialResponse
});
```

### Trong file `src/java/control/GoogleOAuthCallback.java`:
Thay thế `YOUR_GOOGLE_CLIENT_ID` bằng Client ID thực tế:

```java
private static final String GOOGLE_CLIENT_ID = "YOUR_ACTUAL_CLIENT_ID_HERE.apps.googleusercontent.com";
```

## Bước 3: Thêm dependencies (nếu cần)

Nếu muốn verify Google token trên server, thêm vào `pom.xml`:

```xml
<dependency>
    <groupId>com.google.api-client</groupId>
    <artifactId>google-api-client</artifactId>
    <version>2.0.0</version>
</dependency>
<dependency>
    <groupId>com.google.oauth-client</groupId>
    <artifactId>google-oauth-client-jetty</artifactId>
    <version>1.34.1</version>
</dependency>
```

## Bước 4: Test chức năng

1. Deploy ứng dụng
2. Truy cập trang Login
3. Click nút "Google" để đăng nhập
4. Chọn tài khoản Google
5. Kiểm tra xem có đăng nhập thành công không

## Lưu ý bảo mật

- Không commit Client ID vào repository public
- Sử dụng environment variables cho production
- Luôn verify token trên server trong production
- Cấu hình HTTPS cho production

## Troubleshooting

### Lỗi "Invalid client"
- Kiểm tra Client ID có đúng không
- Kiểm tra domain có được authorize không

### Lỗi "Redirect URI mismatch"
- Kiểm tra redirect URI trong Google Console
- Đảm bảo URI khớp chính xác với URL hiện tại

### Lỗi CORS
- Đảm bảo domain được thêm vào Authorized JavaScript origins
- Kiểm tra protocol (http/https) có khớp không
