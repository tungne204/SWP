<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setLocale value="vi_VN" />
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật cuộc hẹn - Medilab</title>
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
                padding: 2.5rem;
            }

            .form-card {
                background: white;
                border-radius: 20px;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
                padding: 2.5rem 3rem;
                transition: all 0.3s ease;
                border: 1px solid #e5e7eb;
            }

            .form-card:hover {
                box-shadow: 0 12px 36px rgba(0, 0, 0, 0.12);
                transform: translateY(-2px);
            }

            .form-section-title {
                font-weight: 700;
                color: #2c4964;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 1rem;
                font-size: 1.25rem;
                border-left: 5px solid #3fbbc0;
                padding-left: 10px;
            }

            label {
                font-weight: 500;
                color: #475569;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="../includes/header.jsp" />

        <div class="main-wrapper">
            <!-- Sidebar --><c:if test="${sessionScope.role eq 'Receptionist'}">
                <%@ include file="../includes/sidebar-receptionist.jsp" %>
            </c:if>

            <!-- Main Content -->
            <div class="content-area">
                <main class="max-w-5xl mx-auto">
                    <div class="form-card">

                        <!-- Title -->
                        <h2 class="text-3xl font-bold text-[#3fbbc0] mb-8 flex items-center gap-3">
                            <i class="fa-solid fa-pen-to-square text-[#3fbbc0]"></i>
                            Cập nhật cuộc hẹn
                        </h2>

                        <!-- Lỗi chung (DB, cập nhật fail) -->
                        <c:if test="${not empty errorMsg}">
                            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                                ${errorMsg}
                            </div>
                        </c:if>

                        <!-- Lỗi validate từng field -->
                        <c:if test="${not empty errors}">
                            <div class="bg-yellow-100 border border-yellow-400 text-yellow-800 px-4 py-3 rounded mb-5">
                                <ul class="list-disc list-inside">
                                    <c:forEach var="e" items="${errors}">
                                        <li>${e.value}</li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>

                        <!-- Form -->
                        <form action="${pageContext.request.contextPath}/Appointment-Update" method="post">
                            <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                            <!-- GIỮ TRẠNG THÁI HIỆN TẠI (nếu chưa cho sửa trên form) -->
                            <input type="hidden" name="status" value="${appointment.status}">

                            <div class="grid grid-cols-1 lg:grid-cols-2 gap-10">
                                <!-- LEFT COLUMN -->
                                <div class="space-y-6">
                                    <h3 class="form-section-title">
                                        🩺 Chi tiết cuộc hẹn
                                    </h3>

                                    <!-- Ngày và giờ -->
                                    <div>
                                        <label>Ngày</label>
                                        <input type="text" name="appointmentDate"
                                               placeholder="dd/MM/yyyy"
                                               value="<fmt:formatDate value='${appointment.dateTime}' pattern='dd/MM/yyyy'/>"
                                               class="w-full border rounded-lg p-2 focus:ring-2 focus:ring-[#3fbbc0]" required>
                                    </div>

                                    <div>
                                        <label>Giờ</label>
                                        <input type="time" name="appointmentTime"
                                               value="<fmt:formatDate value='${appointment.dateTime}' pattern='HH:mm'/>"
                                               class="w-full border rounded-lg p-2 focus:ring-2 focus:ring-[#3fbbc0]" required>
                                    </div>

                                    <!-- Bác sĩ -->
                                    <div>
                                        <label>Bác sĩ phụ trách</label>
                                        <select name="doctorId" required class="w-full border rounded-lg p-2 focus:ring-2 focus:ring-[#3fbbc0]">
                                            <option value="">-- Chọn bác sĩ --</option>
                                            <c:forEach var="d" items="${doctors}">
                                                <option value="${d.doctorId}" 
                                                        <c:if test="${appointment.doctorId == d.doctorId}">selected</c:if>>
                                                    ${d.username} - ${d.experienceYears}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <!-- RIGHT COLUMN -->
                                <div class="space-y-6">
                                    <h3 class="form-section-title">
                                        👶 Thông tin bệnh nhân & phụ huynh
                                    </h3>

                                    <div>
                                        <label>Tên bệnh nhân</label>
                                        <input type="text" name="patientName" value="${appointment.patientName}"
                                               class="w-full border rounded-lg p-2 focus:ring-2 focus:ring-[#3fbbc0]" required>
                                    </div>

                                    <div>
                                        <label>Phụ huynh</label>
                                        <input type="text" name="parentName" value="${appointment.parentName}"
                                               class="w-full border rounded-lg p-2 focus:ring-2 focus:ring-[#3fbbc0]" required>
                                    </div>

                                    <div>
                                        <label>Địa chỉ</label>
                                        <input type="text" name="patientAddress" value="${appointment.patientAddress}"
                                               class="w-full border rounded-lg p-2 focus:ring-2 focus:ring-[#3fbbc0]" required>
                                    </div>

                                    <div>
                                        <label>Email</label>
                                        <input type="email" name="patientEmail" value="${appointment.patientEmail}"
                                               class="w-full border rounded-lg p-2 focus:ring-2 focus:ring-[#3fbbc0]" required>
                                    </div>

                                    <div>
                                        <label>Số điện thoại</label>
                                        <input type="text" name="parentPhone" value="${appointment.parentPhone}"
                                               class="w-full border rounded-lg p-2 focus:ring-2 focus:ring-[#3fbbc0]" required>
                                    </div>
                                </div>
                            </div>

                            <!-- BUTTONS -->
                            <div class="flex justify-end gap-4 mt-10">
                                <a href="${pageContext.request.contextPath}/Appointment-Detail?id=${appointment.appointmentId}"
                                   class="px-6 py-3 bg-gray-400 text-white rounded-lg hover:bg-gray-500 transition">
                                    Hủy
                                </a>

                                <button type="submit"
                                        class="px-8 py-3 bg-[#3fbbc0] text-white rounded-lg font-semibold hover:bg-[#35a4a8] transition shadow-md">
                                    💾 Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <!-- Footer -->
        <%@ include file="../includes/footer.jsp" %>
    </body>
</html>
