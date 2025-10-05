<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Bệnh Nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1 class="mb-4">Đăng Ký Bệnh Nhân</h1>
        
        <!-- Form đăng ký -->
        <div class="card">
            <div class="card-header">
                <h5>Thông Tin Đăng Ký</h5>
            </div>
            <div class="card-body">
                <form action="patient-queue" method="post">
                    <input type="hidden" name="action" value="checkin">
                    
                    <div class="mb-3">
                        <label class="form-label">Loại Bệnh Nhân</label>
                        <div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="patientType" id="walkin" value="walkin" checked>
                                <label class="form-check-label" for="walkin">Bệnh Nhân Trực Tiếp</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="patientType" id="booked" value="booked">
                                <label class="form-check-label" for="booked">Bệnh Nhân Đặt Lịch</label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="patientId" class="form-label">Mã Bệnh Nhân</label>
                        <input type="number" class="form-control" id="patientId" name="patientId" required>
                    </div>
                    
                    <div class="mb-3" id="appointmentField" style="display: none;">
                        <label for="appointmentId" class="form-label">Mã Lịch Hẹn</label>
                        <input type="number" class="form-control" id="appointmentId" name="appointmentId">
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">Đăng Ký</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Danh sách bệnh nhân hiện có (mẫu) -->
        <div class="card mt-4">
            <div class="card-header">
                <h5>Danh Sách Bệnh Nhân</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Mã BN</th>
                                <th>Họ Tên</th>
                                <th>Ngày Sinh</th>
                                <th>Địa Chỉ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Trong thực tế, dữ liệu này sẽ được lấy từ cơ sở dữ liệu -->
                            <tr>
                                <td>1001</td>
                                <td>Nguyễn Văn A</td>
                                <td>01/01/1990</td>
                                <td>123 Đường ABC, Quận XYZ</td>
                            </tr>
                            <tr>
                                <td>1002</td>
                                <td>Trần Thị B</td>
                                <td>15/05/1985</td>
                                <td>456 Đường DEF, Quận UVW</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Nút quay lại -->
        <div class="mt-3">
            <a href="patient-queue?action=view" class="btn btn-secondary">Quay Lại Danh Sách</a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hiển thị/ẩn trường mã lịch hẹn dựa trên loại bệnh nhân
        document.querySelectorAll('input[name="patientType"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const appointmentField = document.getElementById('appointmentField');
                if (this.value === 'booked') {
                    appointmentField.style.display = 'block';
                } else {
                    appointmentField.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>