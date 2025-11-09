<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Appointment</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            min-height: 100vh;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 32px;
            margin-bottom: 10px;
        }
        
        .header p {
            opacity: 0.9;
            font-size: 16px;
        }
        
        .content {
            padding: 40px;
        }
        
        .alert {
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
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border-left: 4px solid #ffc107;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 15px;
        }
        
        label .required {
            color: #e74c3c;
            margin-left: 3px;
        }
        
        input[type="date"],
        input[type="time"],
        select,
        textarea {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s;
            font-family: inherit;
        }
        
        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .doctor-card {
            display: flex;
            align-items: center;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .doctor-card:hover {
            border-color: #667eea;
            background: #f8f9fa;
            transform: translateX(5px);
        }
        
        .doctor-card input[type="radio"] {
            margin-right: 15px;
            width: 20px;
            height: 20px;
            cursor: pointer;
        }
        
        .doctor-info {
            flex: 1;
        }
        
        .doctor-name {
            font-weight: 600;
            color: #2c3e50;
            font-size: 16px;
            margin-bottom: 5px;
        }
        
        .doctor-details {
            font-size: 13px;
            color: #6c757d;
        }
        
        .doctor-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
            border: 3px solid #e0e0e0;
        }
        
        .time-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
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
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
        }
        
        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
        }
        
        .info-box p {
            margin: 5px 0;
            color: #1565c0;
            font-size: 14px;
        }
    </style>
    <script>
        function validateForm() {
            const doctorId = document.querySelector('input[name="doctorId"]:checked');
            const date = document.getElementById('appointmentDate').value;
            const time = document.getElementById('appointmentTime').value;
            
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
<body>
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
            
            <form method="post" action="${pageContext.request.contextPath}/patient" 
                  onsubmit="return validateForm()">
                <input type="hidden" name="action" value="create">
                
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
                    <a href="${pageContext.request.contextPath}/patient" 
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
</body>
</html>