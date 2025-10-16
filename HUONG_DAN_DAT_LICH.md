# 🏥 HƯỚNG DẪN SỬ DỤNG HỆ THỐNG ĐẶT LỊCH HẸN

## 📋 Tổng quan

Hệ thống đặt lịch hẹn cho phép bệnh nhân (Patient) đặt lịch khám cho con của họ với các bác sĩ trong phòng khám. Hệ thống bao gồm:

- **Form đặt lịch** với đầy đủ thông tin
- **Validation thời gian** nghiêm ngặt
- **Tự động tạo Parent và Patient** trong database
- **Giao diện đẹp** và thân thiện

## 🎯 Các tính năng chính

### ✅ **Form đặt lịch hoàn chỉnh**
- **Tên Bố/Mẹ**: Tên đầy đủ của phụ huynh
- **CMND của bố mẹ**: Số CMND/CCCD của phụ huynh
- **Tên con**: Tên đầy đủ của trẻ em
- **Ngày sinh của con**: Ngày sinh của trẻ
- **Địa chỉ**: Địa chỉ liên hệ
- **Thông tin bảo hiểm**: Thông tin bảo hiểm y tế
- **Chọn bác sĩ**: Danh sách bác sĩ có sẵn
- **Ngày khám**: Ngày muốn đặt lịch
- **Giờ khám**: Giờ khám cụ thể

### ⏰ **Validation thời gian nghiêm ngặt**
- **Giờ khám**: Chỉ cho phép từ **8h-11h** và **13h-16h**
- **Giờ chẵn**: Chỉ cho phép giờ chẵn (8h, 9h, 10h, 11h, 13h, 14h, 15h, 16h)
- **Ngày tương lai**: Không cho phép đặt lịch trong quá khứ
- **Ngày sinh hợp lệ**: Ngày sinh không được trong tương lai

### 🔐 **Phân quyền**
- Chỉ **Patient (role_id = 3)** mới có thể đặt lịch
- Các role khác sẽ thấy thông báo yêu cầu đăng nhập

## 🚀 Cách sử dụng

### **1. Đăng nhập**
- Sử dụng tài khoản Patient để đăng nhập
- Ví dụ: `patient01` / `1`

### **2. Điền form đặt lịch**
1. Truy cập trang chủ (`Home.jsp`)
2. Cuộn xuống phần "Appointment"
3. Điền đầy đủ thông tin:
   - **Tên Bố/Mẹ**: Nguyễn Văn A
   - **CMND của bố mẹ**: 123456789
   - **Tên con**: Nguyễn Văn B
   - **Ngày sinh của con**: 2015-01-01
   - **Địa chỉ**: 123 Đường ABC, Quận 1, TP.HCM
   - **Thông tin bảo hiểm**: BHYT001
   - **Chọn bác sĩ**: Pediatrics - Dr. 19
   - **Ngày khám**: 2025-01-20
   - **Giờ khám**: 9:00 AM

### **3. Submit form**
- Nhấn nút "Đặt lịch"
- Hệ thống sẽ xử lý và hiển thị thông báo thành công/lỗi

## 🔧 Cách hoạt động kỹ thuật

### **1. Frontend (Home.jsp)**
```javascript
// Load danh sách bác sĩ từ API
fetch('doctors')
    .then(response => response.json())
    .then(doctors => {
        // Populate dropdown với danh sách bác sĩ
    });

// Validation ngày
appointmentDateInput.min = tomorrow; // Chỉ cho phép từ ngày mai
childDobInput.max = today; // Ngày sinh không được trong tương lai
```

### **2. Backend Processing (AppointmentServlet)**
```java
// 1. Validate user role (chỉ Patient)
if (user.getRoleId() != 3) {
    response.sendRedirect("403.jsp");
    return;
}

// 2. Validate input data
// 3. Validate time slot (8h-11h, 13h-16h, chỉ giờ chẵn)
// 4. Create/find Parent record
// 5. Create Patient record
// 6. Create Appointment record
```

### **3. Database Operations**
```sql
-- Tạo Parent mới (nếu chưa tồn tại)
INSERT INTO Parent (parentname, id_info) VALUES (?, ?)

-- Tạo Patient mới
INSERT INTO Patient (user_id, full_name, dob, address, insurance_info, parent_id) 
VALUES (?, ?, ?, ?, ?, ?)

-- Tạo Appointment
INSERT INTO Appointment (patient_id, doctor_id, date_time, status) 
VALUES (?, ?, ?, ?)
```

## 📊 Cấu trúc Database

### **Bảng Parent**
- `parent_id`: ID tự động
- `parentname`: Tên phụ huynh
- `id_info`: CMND/CCCD

### **Bảng Patient**
- `patient_id`: ID tự động
- `user_id`: Liên kết với User đăng nhập
- `full_name`: Tên trẻ em
- `dob`: Ngày sinh
- `address`: Địa chỉ
- `insurance_info`: Thông tin bảo hiểm
- `parent_id`: Liên kết với Parent

### **Bảng Appointment**
- `appointment_id`: ID tự động
- `patient_id`: Liên kết với Patient
- `doctor_id`: Liên kết với Doctor
- `date_time`: Ngày giờ hẹn
- `status`: Trạng thái (true = active)

## 🎨 Giao diện

### **Form đặt lịch**
- **Responsive design**: Hoạt động trên mọi thiết bị
- **Bootstrap styling**: Giao diện đẹp và hiện đại
- **Real-time validation**: Kiểm tra dữ liệu ngay khi nhập
- **Success/Error messages**: Thông báo rõ ràng

### **Trang 403 (Access Denied)**
- **Thiết kế đẹp**: Gradient background, animation
- **Thông tin role**: Hiển thị role hiện tại
- **Danh sách quyền**: Liệt kê trang được phép truy cập
- **Nút điều hướng**: Smart navigation dựa trên role

## ⚠️ Lưu ý quan trọng

### **1. Role Mapping**
- `role_id = 1`: Admin
- `role_id = 2`: Doctor
- `role_id = 3`: Patient (có thể đặt lịch)
- `role_id = 4`: MedicalAssistant
- `role_id = 5`: Receptionist

### **2. Time Validation**
- Chỉ cho phép giờ: 8h, 9h, 10h, 11h, 13h, 14h, 15h, 16h
- Không cho phép: 8h30, 9h15, 12h, 17h, etc.

### **3. Date Validation**
- Ngày khám: Từ ngày mai trở đi
- Ngày sinh: Không được trong tương lai

## 🐛 Troubleshooting

### **Lỗi thường gặp:**

1. **"Vui lòng điền đầy đủ thông tin bắt buộc!"**
   - Kiểm tra tất cả các trường đã được điền
   - Đảm bảo không có trường nào để trống

2. **"Giờ khám chỉ được chọn từ 8h-11h và 13h-16h, chỉ giờ chẵn!"**
   - Chọn lại giờ khám từ dropdown
   - Chỉ chọn các giờ được phép

3. **"Ngày giờ hẹn phải trong tương lai!"**
   - Chọn ngày khám từ ngày mai trở đi
   - Kiểm tra giờ khám không phải giờ đã qua

4. **"Bác sĩ không tồn tại!"**
   - Refresh trang để load lại danh sách bác sĩ
   - Kiểm tra database có bác sĩ không

### **Debug:**
```java
// Thêm log để debug
System.out.println("Parent: " + parentName);
System.out.println("Child: " + childName);
System.out.println("Doctor ID: " + doctorId);
System.out.println("DateTime: " + appointmentDateTime);
```

## 📞 Hỗ trợ

Nếu gặp vấn đề, hãy kiểm tra:
1. **Database connection** - Đảm bảo kết nối database
2. **Role mapping** - Kiểm tra role_id trong database
3. **Time validation** - Đảm bảo chọn đúng giờ
4. **Form data** - Kiểm tra tất cả trường đã điền

---

**🎉 Chúc bạn sử dụng hệ thống đặt lịch thành công!**
