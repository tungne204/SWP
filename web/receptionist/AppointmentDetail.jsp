<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết lịch hẹn - Medilab</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <jsp:include page="../includes/head-includes.jsp" />

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
            }

            .main-wrapper {
                display: flex;
                min-height: 100vh;
                padding-top: 70px;
            }

            .sidebar-fixed {
                width: 280px;
                background: white;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
                position: fixed;
                top: 70px;
                left: 0;
                height: calc(100vh - 70px);
                overflow-y: auto;
                z-index: 1000;
            }

            .content-area {
                flex: 1;
                margin-left: 280px;
                padding: 2rem;
            }

            .info-card {
                background: white;
                border-radius: 16px;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
                padding: 2.5rem 3rem;
                transition: all 0.3s ease;
            }

            .info-card:hover {
                box-shadow: 0 12px 36px rgba(0, 0, 0, 0.12);
                transform: translateY(-2px);
            }

            .section-title {
                font-weight: 700;
                color: #2c4964;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 1.2rem;
                font-size: 1.4rem;
                border-left: 5px solid #3fbbc0;
                padding-left: 10px;
            }

            .label {
                font-weight: 500;
                color: #64748b;
                font-size: 1.05rem;
            }

            .value {
                color: #1e293b;
                font-size: 1.1rem;
                font-weight: 500;
            }

            .value-wrap {
                display: inline-block;
                max-width: 100%;
                word-break: break-word;      /* hoặc break-all nếu vẫn tràn */
                overflow-wrap: break-word;
            }

            .badge {
                padding: 10px 24px;
                border-radius: 30px;
                font-weight: 600;
                font-size: 1rem;
                letter-spacing: 0.5px;
            }

            .btn {
                padding: 12px 26px;
                border-radius: 10px;
                font-size: 1rem;
                font-weight: 600;
                transition: all 0.2s ease-in-out;
            }

            .btn:hover {
                transform: translateY(-2px);
            }
        </style>
    </head>

    <body>
        <jsp:include page="../includes/header.jsp" />

        <div class="main-wrapper">
            <!-- Sidebar -->
            <c:if test="${sessionScope.acc != null and sessionScope.acc.roleId == 5}">
                <%@ include file="../includes/sidebar-receptionist.jsp" %>
            </c:if>

            <!-- Main Content -->
            <div class="content-area">
                <main class="max-w-5xl mx-auto">
                    <div class="info-card">

                        <!-- Header -->
                        <div class="flex justify-between items-center mb-8">
                            <h1 class="text-3xl font-bold text-gray-800 flex items-center gap-3">
                                <i class="fa-solid fa-calendar-days text-[#3fbbc0] text-3xl"></i>
                                Chi tiết lịch hẹn
                            </h1>

                            <!-- Status -->
                            <c:choose>
                                <c:when test="${appointment.status eq 'Confirmed'}">
                                    <span class="badge bg-green-500 text-white shadow-md">ĐÃ DUYỆT</span>
                                </c:when>
                                <c:when test="${appointment.status eq 'Pending'}">
                                    <span class="badge bg-yellow-500 text-white shadow-md">ĐANG CHỜ</span>
                                </c:when>
                                <c:when test="${appointment.status eq 'Cancelled'}">
                                    <span class="badge bg-red-500 text-white shadow-md">ĐÃ HỦY</span>
                                </c:when>
                                <c:when test="${appointment.status eq 'Completed'}">
                                    <span class="badge bg-blue-500 text-white shadow-md">ĐÃ KHÁM</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-gray-400 text-white shadow-md">${appointment.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Appointment + Patient Info -->
                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-14 mb-8">
                            <!-- Appointment Details -->
                            <div>
                                <h2 class="section-title">
                                    <i class="fa-solid fa-calendar-check text-[#3fbbc0]"></i> Lịch hẹn
                                </h2>
                                <div class="space-y-4">
                                    <p><span class="label">📅 Ngày & Giờ: </span>
                                        <span class="value">
                                            <fmt:formatDate value="${appointment.dateTime}" pattern="EEEE, dd/MM/yyyy 'lúc' HH:mm"/>
                                        </span>
                                    </p>
                                    <p><span class="label">👨‍⚕️ Bác sĩ: </span>
                                        <span class="value">${appointment.doctorName} - 
                                            <strong>Số năm kinh nghiệm:</strong> ${appointment.doctorExperienceYears} năm
                                        </span>
                                    </p>
                                </div>

                                <div class="mt-8">
                                    <h2 class="section-title">
                                        <i class="fa-solid fa-user-group text-[#3fbbc0]"></i> Phụ huynh
                                    </h2>
                                    <p><span class="label">👩 Họ tên: </span> <span class="value">${appointment.parentName}</span></p>
                                    <p><span class="label">📞 Số điện thoại: </span> <span class="value">${appointment.parentPhone}</span></p>
                                </div>
                            </div>

                            <!-- Patient Information -->
                            <div>
                                <h2 class="section-title">
                                    <i class="fa-solid fa-user text-[#3fbbc0]"></i> Bệnh nhân
                                </h2>
                                <div class="space-y-4">
                                    <p><span class="label">🧍 Họ tên: </span> <span class="value">${appointment.patientName}</span></p>
                                    <p><span class="label">📧 Email: </span> <span class="value">${appointment.patientEmail}</span></p>
                                    <p><span class="label">🏠 Địa chỉ: </span> <span class="value">${appointment.patientAddress}</span></p>
                                    <p>
                                        <span class="label">💳 Bảo hiểm: </span>
                                        <span class="value value-wrap">${appointment.patientInsurance}</span>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <c:if test="${appointment.status ne 'Completed'}">
                            <div class="flex justify-end mt-12">
                                <a href="Appointment-Update?id=${appointment.appointmentId}"
                                   class="btn bg-[#3fbbc0] text-white hover:bg-[#35a4a8] shadow-md flex items-center gap-2">
                                    <i class="fa-solid fa-pen-to-square text-lg"></i>
                                    <span>Chỉnh sửa</span>
                                </a>
                            </div>
                        </c:if>

                    </div>
                </main>
            </div>
        </div>

        <jsp:include page="../includes/footer.jsp"/>
    </body>
</html>
