<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setLocale value="vi_VN" />
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Check-in Patient - Medilab</title>
        
        <!-- Include all CSS files -->
        <jsp:include page="../includes/head-includes.jsp"/>
        
        <style>
            
            :root {
                --primary-color: #3fbbc0;
                --primary-dark: #2a9fa4;
                --secondary-color: #2c4964;
            }
            
            body {
                background: linear-gradient(135deg, #e8f5f6 0%, #d4eef0 100%);
                min-height: 100vh;
                font-family: 'Roboto', sans-serif;
                margin: 0;
                padding: 0;
            }
            
            .main-wrapper {
                display: flex;
                min-height: 100vh;
                padding-top: 80px;
            }
            
            .sidebar-fixed {
                width: 280px;
                background: white;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
                position: fixed;
                top: 80px;
                left: 0;
                height: calc(100vh - 80px);
                overflow-y: auto;
                z-index: 1000;
            }
            
            .content-area {
                flex: 1;
                margin-left: 280px;
                padding: 2rem;
                min-height: calc(100vh - 80px);
                padding-bottom: 100px; /* Space for footer */
            }
        
        .form-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }
        
        .card-header {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            padding: 20px;
            border-radius: 10px 10px 0 0;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #374151;
        }
        
        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.2s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }
        
        .btn {
            padding: 12px 20px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
            display: inline-block;
        }
        
        .btn-primary {
            background-color: #3b82f6;
            color: white;
            border: none;
        }
        
        .btn-primary:hover {
            background-color: #2563eb;
        }
        
        .btn-secondary {
            background-color: #6b7280;
            color: white;
            border: none;
        }
        
        .btn-secondary:hover {
            background-color: #4b5563;
        }
        
        .radio-group {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
        }
        
        .radio-item {
            display: flex;
            align-items: center;
        }
        
        .radio-item input {
            margin-right: 8px;
        }
        
        .search-section {
            background-color: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .search-controls {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .search-input {
            flex: 1;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 16px;
        }
        
        .search-btn {
            background-color: #0ea5e9;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 15px;
            cursor: pointer;
        }
        
        .search-btn:hover {
            background-color: #0284c7;
        }
        
        .patient-info {
            background-color: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 6px;
            padding: 15px;
            margin-top: 15px;
            display: none;
        }
        
        .patient-info.visible {
            display: block;
        }
    </style>
</head>

    <body>
        <!-- Header -->
        <jsp:include page="../includes/header.jsp"/>

        <div class="main-wrapper">
            <!-- Sidebar -->
            <div class="sidebar-fixed">
                <%@ include file="../includes/sidebar-receptionist.jsp" %>
            </div>

            <!-- Main Content -->
            <div class="content-area">
                <div class="form-container">
        <!-- Header -->
        <div class="bg-white rounded-lg shadow-sm p-6 mb-6">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-bold text-gray-800">Đăng Ký Bệnh Nhân</h1>
                    <p class="text-gray-600 mt-2">Dành cho Lễ Tân - Quản lý hàng đợi bệnh nhân</p>
                </div>
                <div class="text-right">
                    <p class="text-sm text-gray-500">Xin chào, <strong>${sessionScope.acc.username}</strong></p>
                    <p class="text-sm text-gray-500">Vai trò: Lễ Tân</p>
                </div>
            </div>
        </div>
        
        <!-- Form đăng ký -->
        <div class="card">
            <div class="card-header">
                <h5 class="text-xl font-semibold">Thông Tin Đăng Ký</h5>
            </div>
            <div class="p-6">
                <!-- Error message display -->
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger mb-4" style="background-color: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 12px; border-radius: 4px; margin-bottom: 16px;">
                        <i class="fas fa-exclamation-triangle"></i> ${sessionScope.errorMessage}
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>
                
                <!-- Success message display -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success mb-4" style="background-color: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 12px; border-radius: 4px; margin-bottom: 16px;">
                        <i class="fas fa-check-circle"></i> ${sessionScope.successMessage}
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>
                
                <form action="<c:url value="/receptionist/checkin-form"/>" method="post">
                    <input type="hidden" name="action" value="checkin">
                    
                    <div class="form-group">
                        <label class="form-label">Loại Bệnh Nhân</label>
                        <div class="radio-group">
                            <div class="radio-item">
                                <input class="form-check-input" type="radio" name="patientType" id="walkin" value="walkin" checked>
                                <label class="form-check-label" for="walkin">Bệnh Nhân Trực Tiếp</label>
                            </div>
                            <div class="radio-item">
                                <input class="form-check-input" type="radio" name="patientType" id="booked" value="booked">
                                <label class="form-check-label" for="booked">Bệnh Nhân Đặt Lịch</label>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Section for walk-in patients -->
                    <div id="walkinSection">
                        <div class="form-group">
                            <label for="patientName" class="form-label">Họ Tên Bệnh Nhân <span class="text-red-500">*</span></label>
                            <input type="text" class="form-control" id="patientName" name="patientName" placeholder="Nhập họ tên bệnh nhân" required>
                        </div>
                        
                        <!-- Parent Information -->
                        <div class="grid md:grid-cols-2 gap-4">
                            <div class="form-group">
                                <label for="parentName" class="form-label">Tên Phụ Huynh/Người Giám Hộ <span class="text-red-500">*</span></label>
                                <input type="text" class="form-control" id="parentName" name="parentName" placeholder="Nhập tên phụ huynh" required>
                            </div>
                            <div class="form-group">
                                <label for="parentCccd" class="form-label">Số CCCD Phụ Huynh <span class="text-red-500">*</span></label>
                                <input type="text" class="form-control" id="parentCccd" name="parentCccd" 
                                       placeholder="Nhập số CCCD (9-12 số)" 
                                       pattern="[0-9]{9,12}" 
                                       maxlength="12"
                                       minlength="9"
                                       title="Số CCCD phải có từ 9 đến 12 chữ số"
                                       required>
                                <small class="text-gray-500 text-sm">Số CCCD phải có từ 9 đến 12 chữ số</small>
                            </div>
                        </div>

                        <!-- Các trường bổ sung -->
                        <div class="grid md:grid-cols-2 gap-4">
                            <div class="form-group">
                                <label for="dob" class="form-label">Ngày Sinh</label>
                                <input type="date" class="form-control" id="dob" name="dob">
                            </div>
                            <div class="form-group">
                                <label for="address" class="form-label">Địa Chỉ</label>
                                <input type="text" class="form-control" id="address" name="address" placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành">
                            </div>
                            <div class="form-group md:col-span-2">
                                <label for="insuranceInfo" class="form-label">Thông Tin Bảo Hiểm</label>
                                <input type="text" class="form-control" id="insuranceInfo" name="insuranceInfo" placeholder="Số thẻ/nhà cung cấp (tùy chọn)">
                            </div>
                        </div>
                    </div>
                    
                    <!-- Section for booked patients -->
                    <div id="bookedSection" style="display: none;">
                        <div class="search-section">
                            <h6 class="font-semibold text-gray-800 mb-3">Tìm Kiếm Bệnh Nhân Đặt Lịch</h6>
                            <div class="search-controls">
                                <input type="text" class="search-input" id="searchInput" placeholder="Nhập mã đặt lịch, số điện thoại hoặc tên bệnh nhân">
                                <button type="button" class="search-btn" id="searchBtn">
                                    <i class="fas fa-search"></i> Tìm Kiếm
                                </button>
                            </div>
                            
                            <div class="patient-info" id="patientInfo">
                                <h6 class="font-semibold text-gray-800 mb-2">Thông Tin Bệnh Nhân</h6>
                                <div class="grid grid-cols-2 gap-2">
                                    <div><strong>Mã BN:</strong> <span id="displayPatientId">-</span></div>
                                    <div><strong>Họ Tên:</strong> <span id="displayPatientName">-</span></div>
                                    <div><strong>SĐT Phụ Huynh:</strong> <span id="displayPatientPhone">-</span></div>
                                    <div><strong>Mã Lịch Hẹn:</strong> <span id="displayAppointmentId">-</span></div>
                                </div>
                                <input type="hidden" id="hiddenPatientId" name="patientId">
                                <input type="hidden" id="hiddenAppointmentId" name="appointmentId">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="appointmentId" class="form-label">Mã Lịch Hẹn</label>
                            <input type="number" class="form-control" id="appointmentId" name="appointmentId" readonly>
                            <p class="text-sm text-gray-500 mt-2">Bệnh nhân đã đặt lịch sẽ có ưu tiên cao hơn trong hàng đợi</p>
                        </div>
                    </div>
                    


                    <div class="flex gap-3">
                        <button type="submit" class="btn btn-primary flex-1">
                            <i class="fas fa-user-plus"></i> Đăng Ký Bệnh Nhân
                        </button>
                        <a href="<c:url value="/receptionist/waiting-screen.jsp"/>" class="btn btn-secondary flex-1 text-center">
                            <i class="fas fa-arrow-left"></i> Quay Lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Hướng dẫn sử dụng -->
        <div class="card mt-6">
            <div class="card-header">
                <h5 class="text-xl font-semibold">Hướng Dẫn Sử Dụng</h5>
            </div>
            <div class="p-6">
                <div class="grid md:grid-cols-2 gap-6">
                    <div>
                        <h6 class="font-semibold text-lg text-gray-800 mb-3">Bệnh Nhân Trực Tiếp</h6>
                        <ul class="list-disc pl-5 space-y-2 text-gray-600">
                            <li>Nhập thông tin bệnh nhân (họ tên) và SĐT phụ huynh</li>
                            <li>Nhập mã bệnh nhân nếu đã có trong hệ thống</li>
                            <li>Ấn "Đăng Ký" để vào hàng đợi</li>
                            <li>Bệnh nhân sẽ được sắp xếp theo thứ tự đến</li>
                        </ul>
                    </div>
                    <div>
                        <h6 class="font-semibold text-lg text-gray-800 mb-3">Bệnh Nhân Đặt Lịch</h6>
                        <ul class="list-disc pl-5 space-y-2 text-gray-600">
                            <li>Tìm kiếm bệnh nhân bằng mã đặt lịch, số điện thoại hoặc tên</li>
                            <li>Hệ thống sẽ tự động điền thông tin bệnh nhân</li>
                            <li>Ấn "Đăng Ký" để vào hàng đợi với ưu tiên cao</li>
                            <li>Bệnh nhân đặt lịch có quyền ưu tiên cao hơn</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
                </div>
            </div>
        </div>
    
    <script>
        // Hiển thị/ẩn các section dựa trên loại bệnh nhân
        document.querySelectorAll('input[name="patientType"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const walkinSection = document.getElementById('walkinSection');
                const bookedSection = document.getElementById('bookedSection');
                
                if (this.value === 'booked') {
                    walkinSection.style.display = 'none';
                    bookedSection.style.display = 'block';
                } else {
                    walkinSection.style.display = 'block';
                    bookedSection.style.display = 'none';
                }
            });
        });
        
        // Set focus to patient name field on page load
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('patientName').focus();
        });
        
        // Mock data for patient search (in a real application, this would come from the server)
        const mockPatients = [
            { id: 1001, name: "Nguyễn Văn A", phone: "0987654321", appointmentId: 5001 },
            { id: 1002, name: "Trần Thị B", phone: "0912345678", appointmentId: 5002 },
            { id: 1003, name: "Phạm Văn C", phone: "0909876543", appointmentId: 5003 }
        ];
        
        // Search functionality for booked patients
        document.getElementById('searchBtn').addEventListener('click', function() {
            const searchInput = document.getElementById('searchInput').value.toLowerCase();
            const patientInfo = document.getElementById('patientInfo');
            
            // Hide patient info initially
            patientInfo.classList.remove('visible');
            
            // Search through mock data
            const patient = mockPatients.find(p => 
                p.id.toString().includes(searchInput) || 
                p.name.toLowerCase().includes(searchInput) || 
                p.phone.includes(searchInput) ||
                p.appointmentId.toString().includes(searchInput)
            );
            
            if (patient) {
                // Display patient information
                document.getElementById('displayPatientId').textContent = patient.id;
                document.getElementById('displayPatientName').textContent = patient.name;
                document.getElementById('displayPatientPhone').textContent = patient.phone;
                document.getElementById('displayAppointmentId').textContent = patient.appointmentId;
                
                // Set hidden fields for form submission
                document.getElementById('hiddenPatientId').value = patient.id;
                document.getElementById('hiddenAppointmentId').value = patient.appointmentId;
                document.getElementById('appointmentId').value = patient.appointmentId;
                
                // Show patient info section
                patientInfo.classList.add('visible');
            } else {
                alert('Không tìm thấy bệnh nhân với thông tin đã nhập');
            }
        });
        
        // Allow search on Enter key
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                document.getElementById('searchBtn').click();
            }
        });
        
        // CCCD validation
        document.getElementById('parentCccd').addEventListener('input', function(e) {
            const value = e.target.value;
            const cccdPattern = /^[0-9]{9,12}$/;
            
            // Remove any non-numeric characters
            e.target.value = value.replace(/[^0-9]/g, '');
            
            // Validate length and format
            if (e.target.value.length > 0 && (e.target.value.length < 9 || e.target.value.length > 12)) {
                e.target.setCustomValidity('Số CCCD phải có từ 9 đến 12 chữ số');
            } else if (e.target.value.length >= 9 && e.target.value.length <= 12 && !cccdPattern.test(e.target.value)) {
                e.target.setCustomValidity('Số CCCD chỉ được chứa chữ số');
            } else {
                e.target.setCustomValidity('');
            }
        });
        
        // Form submission validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const cccdInput = document.getElementById('parentCccd');
            const cccdValue = cccdInput.value;
            const cccdPattern = /^[0-9]{9,12}$/;
            
            if (cccdValue && !cccdPattern.test(cccdValue)) {
                e.preventDefault();
                alert('Số CCCD phải có từ 9 đến 12 chữ số và chỉ chứa số');
                cccdInput.focus();
                return false;
            }
        });
    </script>

            </div> <!-- End form-container -->
        </div> <!-- End content-area -->
    </div> <!-- End main-wrapper -->

    <!-- Footer -->
    <jsp:include page="../includes/footer.jsp"/>
    
    <!-- Include all JS files -->
    <jsp:include page="../includes/footer-includes.jsp"/>

</body>
</html>