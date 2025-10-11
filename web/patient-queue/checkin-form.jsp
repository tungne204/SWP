<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Bệnh Nhân</title>
    <!-- Tailwind CSS -->
    <script src="<c:url value="/assets/vendor/tailwindv4/tailwind.min.js"/>"></script>
    <link href="<c:url value="/assets/vendor/fontawesome-free/css/all.min.css"/>" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
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
        
        .table-container {
            overflow-x: auto;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th, .table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .table th {
            background-color: #f9fafb;
            font-weight: 600;
            color: #374151;
        }
        
        .table-striped tr:nth-child(even) {
            background-color: #f9fafb;
        }
        
        .priority-booked {
            background-color: #fffbeb;
            border-left: 4px solid #f59e0b;
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
    <%@ include file="header.jsp" %>
    
    <div class="form-container">
        <h1 class="text-3xl font-bold text-gray-800 mb-6">Đăng Ký Bệnh Nhân</h1>
        
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
                
                <form action="<c:url value="/patient-queue"/>" method="post">
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
                            <label for="patientName" class="form-label">Họ Tên Bệnh Nhân</label>
                            <input type="text" class="form-control" id="patientName" name="patientName" placeholder="Nhập họ tên bệnh nhân">
                        </div>
                        
                        <div class="form-group">
                            <label for="patientPhone" class="form-label">Số Điện Thoại</label>
                            <input type="text" class="form-control" id="patientPhone" name="patientPhone" placeholder="Nhập số điện thoại">
                        </div>
                        
                        <div class="form-group">
                            <label for="patientId" class="form-label">Mã Bệnh Nhân (nếu có)</label>
                            <input type="number" class="form-control" id="patientId" name="patientId" placeholder="Nhập mã bệnh nhân nếu đã có">
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
                                    <div><strong>SĐT:</strong> <span id="displayPatientPhone">-</span></div>
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
                        <button type="submit" class="btn btn-primary flex-1">Đăng Ký</button>
                        <a href="patient-queue?action=view" class="btn btn-secondary flex-1 text-center">Quay Lại Danh Sách</a>
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
                            <li>Nhập thông tin bệnh nhân (họ tên, số điện thoại)</li>
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
    </script>
</body>
</html>