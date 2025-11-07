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
        .main .container input[type="tel"] {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s;
            font-family: inherit;
        }
    </style>
    <script>
        function validateForm() {
            const doctorId = document.querySelector('input[name="doctorId"]:checked');
            const date = document.getElementById('appointmentDate').value;
            const time = document.getElementById('appointmentTime').value;
            const patientName = document.getElementById('patientName').value.trim();
            const patientDob = document.getElementById('patientDob').value;
            const patientAddress = document.getElementById('patientAddress').value.trim();
            const patientPhone = document.getElementById('patientPhone').value.trim();

            if (!patientName) {
                alert('Please enter patient full name!');
                return false;
            }

            if (!patientDob) {
                alert('Please select patient date of birth!');
                return false;
            }

            if (!patientAddress) {
                alert('Please enter patient address!');
                return false;
            }

            if (!patientPhone) {
                alert('Please enter patient phone number!');
                return false;
            }
            
            if (!doctorId) {
                alert('Please select a doctor!');
                return false;
            }
            
            if (!date) {
                alert('Please select appointment date!');
                return false;
            }
            
            if (!time) {
                alert('Please select appointment time!');
                return false;
            }
            
            // Kiểm tra ngày phải trong tương lai
            const selectedDateTime = new Date(date + ' ' + time);
            const now = new Date();
            
            if (selectedDateTime <= now) {
                alert('Appointment date and time must be in the future!');
                return false;
            }
            
            return confirm('Are you sure you want to create this appointment?');
        }
        
        // Set min date là ngày mai
        window.onload = function() {
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            const minDate = tomorrow.toISOString().split('T')[0];
            document.getElementById('appointmentDate').setAttribute('min', minDate);
        };
    </script>
</head>
<body class="index-page">
    <!-- Header -->
    <jsp:include page="../../includes/header.jsp"/>
    
    <main class="main" style="padding-top: 80px;">
        <div class="container">
        <div class="header">
            <h1>📅 Create New Appointment</h1>
            <p>Book your appointment with our doctors</p>
        </div>
        
        <div class="content">
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-${sessionScope.messageType}">
                    ${sessionScope.message}
                </div>
                <c:remove var="message" scope="session"/>
                <c:remove var="messageType" scope="session"/>
            </c:if>
            
            <div class="info-box">
                <p><strong>📌 Important Information:</strong></p>
                <p>• Please select your preferred doctor and appointment time</p>
                <p>• Appointments must be scheduled at least 24 hours in advance</p>
                <p>• You will receive a confirmation from our receptionist</p>
            </div>
            
            <c:set var="dobValue" value="" />
            <c:if test="${not empty patientProfile.dob}">
                <fmt:formatDate value="${patientProfile.dob}" pattern="yyyy-MM-dd" var="dobValue" />
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/appointments" 
                  onsubmit="return validateForm()">
                <input type="hidden" name="action" value="create">

                <div class="form-section">
                    <h2>Patient Information</h2>
                    <p>Provide the patient's details so we can store medical records correctly.</p>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="patientName">Patient Full Name <span class="required">*</span></label>
                            <input type="text" id="patientName" name="patientName" placeholder="Enter full name"
                                   value="${not empty patientProfile.fullName ? patientProfile.fullName : ''}" required>
                        </div>
                        <div class="form-group">
                            <label for="patientDob">Date of Birth <span class="required">*</span></label>
                            <input type="date" id="patientDob" name="patientDob" value="${dobValue}" required>
                        </div>
                        <div class="form-group">
                            <label for="patientPhone">Phone Number <span class="required">*</span></label>
                            <input type="tel" id="patientPhone" name="patientPhone" placeholder="Enter phone number"
                                   value="${not empty patientProfile.phone ? patientProfile.phone : ''}" required>
                        </div>
                        <div class="form-group">
                            <label for="parentName">Parent / Guardian</label>
                            <input type="text" id="parentName" name="parentName" placeholder="Enter parent or guardian name"
                                   value="${not empty patientProfile.parentName ? patientProfile.parentName : ''}">
                        </div>
                    </div>
                    <div class="form-group" style="margin-top: 18px;">
                        <label for="patientAddress">Address <span class="required">*</span></label>
                        <textarea id="patientAddress" name="patientAddress" required
                                  placeholder="Enter current address">${not empty patientProfile.address ? patientProfile.address : ''}</textarea>
                    </div>
                    <div class="form-group">
                        <label for="insuranceInfo">Insurance Information</label>
                        <input type="text" id="insuranceInfo" name="insuranceInfo" placeholder="Enter insurance details if any"
                               value="${not empty patientProfile.insuranceInfo ? patientProfile.insuranceInfo : ''}">
                    </div>
                </div>

                <div class="form-group">
                    <label>Select Doctor <span class="required">*</span></label>
                    <c:choose>
                        <c:when test="${not empty doctors}">
                            <c:forEach var="doctor" items="${doctors}">
                                <label class="doctor-card">
                                    <input type="radio" name="doctorId" value="${doctor.doctorId}">
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
                                No doctors available at the moment.
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="time-grid">
                    <div class="form-group">
                        <label for="appointmentDate">
                            Appointment Date <span class="required">*</span>
                        </label>
                        <input type="date" id="appointmentDate" name="appointmentDate" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="appointmentTime">
                            Appointment Time <span class="required">*</span>
                        </label>
                        <input type="time" id="appointmentTime" name="appointmentTime" 
                               min="08:00" max="17:00" step="1800" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="reason">Reason for Visit (Optional)</label>
                    <textarea id="reason" name="reason" 
                              placeholder="Please describe your symptoms or reason for visit..."></textarea>
                </div>
                
                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/appointments" 
                       class="btn btn-secondary">
                        ← Back
                    </a>
                    <button type="submit" class="btn btn-primary">
                        📅 Create Appointment
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