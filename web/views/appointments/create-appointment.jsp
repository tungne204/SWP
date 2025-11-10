<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Appointment - Medilab</title>

        <!-- Include all CSS files -->
        <jsp:include page="../../includes/head-includes.jsp"/>

        <style>
            /* Scope CSS chỉ cho content của trang này, không ảnh hưởng header/sidebar */
            .main * {
                box-sizing: border-box;
            }

            .main {
                font-family: 'Roboto', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #ffffff;
                min-height: calc(100vh - 80px);
            }

            .main .container {
                max-width: 800px;
                margin: 20px auto;
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                overflow: hidden;
            }

            .main .container .header {
                background: linear-gradient(135deg, #1977cc 0%, #2c4964 100%);
                color: white;
                padding: 40px;
                text-align: center;
            }

            .main .container .header h1 {
                font-size: 32px;
                margin-bottom: 10px;
            }

            .main .container .header p {
                opacity: 0.9;
                font-size: 16px;
            }

            .main .container .content {
                padding: 40px;
            }

            .main .container .alert {
                padding: 15px 20px;
                margin-bottom: 25px;
                border-radius: 10px;
                animation: slideDown 0.3s ease-out;
            }

            @keyframes slideDown {
                from {
                    transform: translateY(-20px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            .main .container .alert-success {
                background: #d4edda;
                color: #155724;
                border-left: 4px solid #28a745;
            }

            .main .container .alert-error {
                background: #f8d7da;
                color: #721c24;
                border-left: 4px solid #dc3545;
            }

            .main .container .alert-warning {
                background: #fff3cd;
                color: #856404;
                border-left: 4px solid #ffc107;
            }

            .main .container .form-group {
                margin-bottom: 25px;
            }

            .main .container label {
                display: block;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 10px;
                font-size: 15px;
            }

            .main .container label .required {
                color: #e74c3c;
                margin-left: 3px;
            }

            .main .container input[type="date"],
            .main .container input[type="time"],
            .main .container select,
            .main .container textarea {
                width: 100%;
                padding: 14px 16px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 15px;
                transition: all 0.3s;
                font-family: inherit;
            }

            .main .container input:focus,
            .main .container select:focus,
            .main .container textarea:focus {
                outline: none;
                border-color: #1977cc;
                box-shadow: 0 0 0 4px rgba(25, 119, 204, 0.1);
            }

            .main .container textarea {
                resize: vertical;
                min-height: 100px;
            }

            .main .container .doctor-card {
                display: flex;
                align-items: center;
                padding: 15px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                margin-bottom: 12px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .main .container .doctor-card:hover {
                border-color: #1977cc;
                background: #f1f7fc;
                transform: translateX(5px);
            }

            .main .container .doctor-card input[type="radio"] {
                margin-right: 15px;
                width: 20px;
                height: 20px;
                cursor: pointer;
            }

            .main .container .doctor-info {
                flex: 1;
            }

            .main .container .doctor-name {
                font-weight: 600;
                color: #2c3e50;
                font-size: 16px;
                margin-bottom: 5px;
            }

            .main .container .doctor-details {
                font-size: 13px;
                color: #6c757d;
            }

            .main .container .doctor-avatar {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                margin-right: 15px;
                object-fit: cover;
                border: 3px solid #e0e0e0;
            }

            .main .container .time-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }

            .main .container .btn-group {
                display: flex;
                gap: 15px;
                margin-top: 30px;
            }

            .main .container .btn {
                flex: 1;
                padding: 16px 30px;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
                text-align: center;
                display: inline-block;
            }

            .main .container .btn-primary {
                background: linear-gradient(135deg, #1977cc 0%, #2c4964 100%);
                color: white;
            }

            .main .container .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(25, 119, 204, 0.4);
            }

            .main .container .btn-secondary {
                background: #95a5a6;
                color: white;
            }

            .main .container .btn-secondary:hover {
                background: #7f8c8d;
            }

            .main .container .info-box {
                background: #e3f2fd;
                border-left: 4px solid #1977cc;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 25px;
            }

            .main .container .info-box p {
                margin: 5px 0;
                color: #2c4964;
                font-size: 14px;
            }

            .main .container .form-section {
                margin-bottom: 32px;
                padding: 24px;
                border: 2px solid #e0e0e0;
                border-radius: 12px;
                background: #f9fbfd;
            }

            .main .container .form-section h2 {
                font-size: 20px;
                margin-bottom: 12px;
                color: #2c4964;
            }

            .main .container .form-section p {
                margin-bottom: 20px;
                color: #607d8b;
                font-size: 14px;
            }

            .main .container .form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 18px;
            }

            .main .container input[type="text"],
            .main .container input[type="tel"],
            .main .container textarea {
                width: 100%;
                padding: 14px 16px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 15px;
                transition: all 0.3s;
                font-family: inherit;
            }
            
            .main .container textarea {
                resize: vertical;
                min-height: 100px;
            }

        </style>
        <script>
            const SYMPTOMS_MAX_LENGTH = 400;
            
            function updateSymptomsCharCount() {
                const textarea = document.getElementById("symptoms");
                const counter = document.getElementById("symptomsCharCount");
                if (!textarea || !counter) return;
                
                const currentLength = textarea.value.length;
                const remaining = SYMPTOMS_MAX_LENGTH - currentLength;
                
                counter.textContent = currentLength + " / " + SYMPTOMS_MAX_LENGTH + " ký tự";
                
                if (remaining < 0) {
                    counter.style.color = "#dc3545";
                } else if (remaining < 100) {
                    counter.style.color = "#ffc107";
                } else {
                    counter.style.color = "#6c757d";
                }
            }
            
            function validateForm() {
                const doctorId = document.querySelector('input[name="doctorId"]:checked');
                const date = document.getElementById('appointmentDate').value;
                const time = document.getElementById('appointmentTime').value;
                const patientName = document.getElementById('patientName').value.trim();
                const patientDob = document.getElementById('patientDob').value;
                const patientAddress = document.getElementById('patientAddress').value.trim();
                const patientPhone = document.getElementById('patientPhone').value.trim();
                const symptoms = document.getElementById('symptoms') ? document.getElementById('symptoms').value.trim() : '';

                if (!patientName) {
                    alert('Vui lòng nhập họ và tên bệnh nhân!');
                    return false;
                }

                if (!patientDob) {
                    alert('Vui lòng chọn ngày sinh của bệnh nhân!');
                    return false;
                }

                if (!patientAddress) {
                    alert('Vui lòng nhập địa chỉ bệnh nhân!');
                    return false;
                }

                if (!patientPhone) {
                    alert('Vui lòng nhập số điện thoại bệnh nhân!');
                    return false;
                }

                // Validate format số điện thoại
                const phoneRegex = /^(0[0-9]{9}|\+84[0-9]{9})$/;
                if (!phoneRegex.test(patientPhone)) {
                    alert('Định dạng số điện thoại không hợp lệ! Số điện thoại phải có 10 chữ số bắt đầu bằng 0 (ví dụ: 0123456789) hoặc định dạng +84 (ví dụ: +84123456789)!');
                    return false;
                }

                if (!doctorId) {
                    alert('Vui lòng chọn bác sĩ!');
                    return false;
                }

                if (!date) {
                    alert('Vui lòng chọn ngày khám!');
                    return false;
                }

                if (!time) {
                    alert('Vui lòng chọn giờ khám!');
                    return false;
                }
                
                // Validate symptoms length
                if (symptoms && symptoms.length > SYMPTOMS_MAX_LENGTH) {
                    alert('Triệu chứng quá dài! Tối đa ' + SYMPTOMS_MAX_LENGTH + ' ký tự. Hiện tại: ' + symptoms.length + ' ký tự.');
                    return false;
                }

                // Kiểm tra ngày phải trong tương lai
                const selectedDateTime = new Date(date + ' ' + time);
                const now = new Date();

                if (selectedDateTime <= now) {
                    alert('Ngày và giờ khám phải trong tương lai!');
                    return false;
                }

                return confirm('Bạn có chắc chắn muốn tạo lịch hẹn này?');
            }
            
            // Initialize character counter on page load
            document.addEventListener("DOMContentLoaded", function() {
                const symptomsTextarea = document.getElementById("symptoms");
                if (symptomsTextarea) {
                    symptomsTextarea.addEventListener("input", updateSymptomsCharCount);
                    updateSymptomsCharCount();
                }
                
                // Set min date là ngày mai
                const tomorrow = new Date();
                tomorrow.setDate(tomorrow.getDate() + 1);
                const minDate = tomorrow.toISOString().split('T')[0];
                const dateInput = document.getElementById('appointmentDate');
                if (dateInput) {
                    dateInput.setAttribute('min', minDate);
                }
            });
        </script>
    </head>
    <body class="index-page">
        <!-- Header -->
        <jsp:include page="../../includes/header.jsp"/>

        <main class="main" style="padding-top: 80px;">
            <div class="container">
                <div class="header">
                    <h1>📅 Đặt lịch hẹn mới</h1>
                    <p>Đặt lịch hẹn với bác sĩ của chúng tôi</p>
                </div>

                <div class="content">
                    <c:if test="${not empty sessionScope.message}">
                        <div class="alert alert-${sessionScope.messageType}">
                            ${sessionScope.message}
                        </div>
                        <c:remove var="message" scope="session"/>
                        <c:remove var="messageType" scope="session"/>
                    </c:if>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">
                            ${errorMessage}
                        </div>
                    </c:if>

                    <div class="info-box">
                        <p><strong>📌 Thông tin quan trọng:</strong></p>
                        <p>• Vui lòng chọn bác sĩ và thời gian khám mong muốn</p>
                        <p>• Lịch hẹn phải được đặt trước ít nhất 24 giờ</p>
                        <p>• Bạn sẽ nhận được xác nhận từ lễ tân</p>
                        <p>• Bạn có thể đặt lịch cho chính mình hoặc cho bệnh nhân khác</p>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/appointments" 
                          onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="create">

                        <div class="form-section">
                            <h2>Thông tin bệnh nhân</h2>
                            <p>Vui lòng cung cấp thông tin bệnh nhân để chúng tôi có thể lưu trữ hồ sơ y tế chính xác. Bạn có thể đặt lịch cho chính mình hoặc cho bệnh nhân khác.</p>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="patientName">Họ và tên bệnh nhân <span class="required">*</span></label>
                                    <input type="text" id="patientName" name="patientName" 
                                           value="${param.patientName}" 
                                           placeholder="Nhập họ và tên đầy đủ" required>
                                </div>
                                <div class="form-group">
                                    <label for="patientDob">Ngày sinh <span class="required">*</span></label>
                                    <input type="date" id="patientDob" name="patientDob" 
                                           value="${param.patientDob}" required>
                                </div>
                                <div class="form-group">
                                    <label for="patientPhone">Số điện thoại <span class="required">*</span></label>
                                    <input type="tel" id="patientPhone" name="patientPhone" 
                                           value="${param.patientPhone}" 
                                           placeholder="Nhập số điện thoại" required>
                                </div>
                                <div class="form-group">
                                    <label for="parentName">Phụ huynh / Người giám hộ</label>
                                    <input type="text" id="parentName" name="parentName" 
                                           value="${param.parentName}" 
                                           placeholder="Nhập tên phụ huynh hoặc người giám hộ">
                                </div>
                            </div>
                            <div class="form-group" style="margin-top: 18px;">
                                <label for="patientAddress">Địa chỉ <span class="required">*</span></label>
                                <textarea id="patientAddress" name="patientAddress" required
                                          placeholder="Nhập địa chỉ hiện tại">${param.patientAddress}</textarea>
                            </div>
                            <div class="form-group">
                                <label for="insuranceInfo">Thông tin bảo hiểm</label>
                                <input type="text" id="insuranceInfo" name="insuranceInfo" 
                                       value="${param.insuranceInfo}" 
                                       placeholder="Nhập thông tin bảo hiểm (nếu có)">
                            </div>
                        </div>

                        <div class="form-section">
                            <h2>Triệu chứng / Lý do khám</h2>
                            <p>Vui lòng mô tả các triệu chứng hoặc lý do khám của bệnh nhân. Thông tin này sẽ giúp bác sĩ chuẩn bị cho việc khám bệnh.</p>
                            <div class="form-group">
                                <label for="symptoms">Symptoms (Triệu chứng)</label>
                                <textarea id="symptoms" name="symptoms" 
                                          placeholder="Vui lòng mô tả các triệu chứng hoặc lý do khám bệnh... (Please describe symptoms or reason for visit...)"
                                          maxlength="400">${param.symptoms}</textarea>
                                <small id="symptomsCharCount" style="display: block; margin-top: 5px; color: #6c757d; font-size: 12px;">
                                    0 / 400 ký tự
                                </small>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Chọn bác sĩ <span class="required">*</span></label>
                            <c:choose>
                                <c:when test="${not empty doctors}">
                                    <c:forEach var="doctor" items="${doctors}">
                                        <label class="doctor-card">
                                            <input type="radio" name="doctorId" value="${doctor.doctorId}"
                                                   <c:if test="${param.doctorId == doctor.doctorId}">checked</c:if>>
                                            <c:if test="${not empty doctor.avatar}">
                                                <img src="${pageContext.request.contextPath}/${doctor.avatar}" 
                                                     alt="${doctor.username}" class="doctor-avatar">
                                            </c:if>
                                            <div class="doctor-info">
                                                <div class="doctor-name">
                                                    👨‍⚕️ Dr. ${doctor.username}
                                                </div>
                                                <div class="doctor-details">
                                                    <c:if test="${not empty doctor.experienceYears}">
                                                        ${doctor.experienceYears} years experience
                                                    </c:if>
                                                    <c:if test="${not empty doctor.email}">
                                                        • ${doctor.email}
                                                    </c:if>
                                                    <c:if test="${not empty doctor.phone}">
                                                        • ${doctor.phone}
                                                    </c:if>
                                                </div>
                                                <c:if test="${not empty doctor.introduce}">
                                                    <div style="margin-top: 5px; font-size: 13px; color: #555;">
                                                        ${doctor.introduce}
                                                    </div>
                                                </c:if>
                                            </div>
                                        </label>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p style="color: #e74c3c; padding: 15px;">
                                        Hiện tại không có bác sĩ nào khả dụng.
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="time-grid">
                            <div class="form-group">
                                <label for="appointmentDate">
                                    Ngày khám <span class="required">*</span>
                                </label>
                                <input type="date" id="appointmentDate" name="appointmentDate" 
                                       value="${param.appointmentDate}" required>
                            </div>

                            <div class="form-group">
                                <label for="appointmentTime">
                                    Giờ khám <span class="required">*</span>
                                </label>
                                <input type="time" id="appointmentTime" name="appointmentTime" 
                                       value="${param.appointmentTime}" 
                                       min="08:00" max="17:00" step="1800" required>
                            </div>
                        </div>

                        <div class="btn-group">
                            <a href="${pageContext.request.contextPath}/appointments" 
                               class="btn btn-secondary">
                                ← Quay lại
                            </a>
                            <button type="submit" class="btn btn-primary">
                                📅 Đặt lịch hẹn
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="../../includes/footer.jsp"/>

        <!-- Include all JS files -->
        <jsp:include page="../../includes/footer-includes.jsp"/>
    </body>
</html>