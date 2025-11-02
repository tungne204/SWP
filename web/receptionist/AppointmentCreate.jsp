<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tạo lịch hẹn mới - Medilab</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <!-- Include all CSS files -->
    <jsp:include page="../includes/head-includes.jsp" />
    <body class="bg-gray-100 min-h-screen">
        <jsp:include page="../includes/header.jsp"/>

        <div class="max-w-5xl mx-auto bg-white shadow-xl rounded-xl p-10 mt-10">
            <h1 class="text-3xl font-bold text-[#3fbbc0] mb-6">➕ Tạo lịch hẹn mới</h1>

            <!-- Hiển thị lỗi -->
            <c:if test="${not empty errorMsg}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">${errorMsg}</div>
            </c:if>

            <c:if test="${not empty errors}">
                <div class="bg-yellow-100 border border-yellow-400 text-yellow-800 px-4 py-3 rounded mb-4">
                    <ul class="list-disc ml-6">
                        <c:forEach var="err" items="${errors}">
                            <li>${err.value}</li>
                            </c:forEach>
                    </ul>
                </div>
            </c:if>

            <!-- Form -->
            <form action="Appointment-Create" method="post" class="grid grid-cols-2 gap-8">
                <!-- LEFT -->
                <div class="space-y-5">
                    <label class="block text-gray-700 font-medium">Tên bệnh nhân</label>
                    <input type="text" name="patientName" class="w-full border rounded-lg p-2" required>

                    <label class="block text-gray-700 font-medium">Phụ huynh</label>
                    <input type="text" name="parentName" class="w-full border rounded-lg p-2" required>

                    <label class="block text-gray-700 font-medium">Địa chỉ</label>
                    <input type="text" name="patientAddress" class="w-full border rounded-lg p-2" required>

                    <label class="block text-gray-700 font-medium">Email</label>
                    <input type="email" name="patientEmail" class="w-full border rounded-lg p-2" required>

                    <label class="block text-gray-700 font-medium">Số điện thoại</label>
                    <input type="text" name="parentPhone" class="w-full border rounded-lg p-2" required>
                </div>

                <!-- RIGHT -->
                <div class="space-y-5">
                    <label class="block text-gray-700 font-medium">Ngày khám</label>
                    <input type="text" name="appointmentDate" placeholder="dd/MM/yyyy"
                           class="w-full border rounded-lg p-2" required>

                    <label class="block text-gray-700 font-medium">Giờ khám</label>
                    <input type="time" name="appointmentTime" class="w-full border rounded-lg p-2" required>

                    <label class="block text-gray-700 font-medium">Bác sĩ</label>
                    <select name="doctorId" class="w-full border rounded-lg p-2" required>
                        <option value="">-- Chọn bác sĩ --</option>
                        <c:forEach var="d" items="${doctors}">
                            <option value="${d.doctorId}">${d.username} - ${d.specialty}</option>
                        </c:forEach>
                    </select>

                    <label class="block text-gray-700 font-medium">Trạng thái</label>
                    <select name="status" class="w-full border rounded-lg p-2">
                        <option value="Pending">Chờ xác nhận</option>
                        <option value="Confirmed">Đã xác nhận</option>
                        <option value="Cancelled">Đã hủy</option>
                    </select>
                </div>

                <!-- Buttons -->
                <div class="col-span-2 flex justify-end gap-4 mt-6">
                    <a href="Appointment-List" class="px-6 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 transition">
                        Hủy
                    </a>
                    <button type="submit"
                            class="px-6 py-2 bg-[#3fbbc0] text-white rounded-lg hover:bg-[#2a9fa4] transition">
                        💾 Lưu lịch hẹn
                    </button>
                </div>
            </form>
        </div>

        <jsp:include page="../includes/footer.jsp"/>
    </body>
</html>
