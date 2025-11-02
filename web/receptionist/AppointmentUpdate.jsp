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
        <title>Cập nhật cuộc hẹn</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <jsp:include page="../includes/head-includes.jsp" />
    </head>

    <body class="bg-gray-100 min-h-screen">
        <!-- Header -->
        <jsp:include page="../includes/header.jsp" />

        <div class="flex">
            <%@ include file="../includes/sidebar-receptionist.jsp" %>

            <main class="flex-1 p-10">
                <div class="max-w-5xl mx-auto bg-white shadow-xl rounded-xl p-8 border border-gray-200">
                    <h2 class="text-2xl font-bold text-blue-700 mb-6 flex items-center gap-2">
                        ✏️ Cập nhật cuộc hẹn
                    </h2>

                    <!-- ⚠️ Hiển thị thông báo lỗi -->
                    <c:if test="${not empty errorMsg}">
                        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                            ${errorMsg}
                        </div>
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

                    <!--Form cập nhật -->
                    <form action="${pageContext.request.contextPath}/Appointment-Update" method="post">
                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

                        <div class="grid grid-cols-2 gap-8">
                            <!-- LEFT COLUMN -->
                            <div class="space-y-6">
                                <h3 class="text-lg font-semibold text-gray-700 mb-3 border-b pb-1">Chi tiết cuộc hẹn</h3>

                                <!-- Ngày và giờ -->
                                <label class="block text-sm font-medium text-gray-600">Ngày</label>
                                <input type="text" name="appointmentDate"
                                       placeholder="dd/MM/yyyy"
                                       value="<fmt:formatDate value='${appointment.dateTime}' pattern='dd/MM/yyyy'/>"
                                       class="w-full border rounded-lg p-2 mb-3" required>


                                <label class="block text-sm font-medium text-gray-600">Giờ</label>
                                <input type="time" name="appointmentTime"
                                       value="<fmt:formatDate value='${appointment.dateTime}' pattern='HH:mm'/>"
                                       class="w-full border rounded-lg p-2 mb-3" required>

                                <!-- Bác sĩ -->
                                <label class="block text-sm font-medium text-gray-600">Bác sĩ phụ trách</label>
                                <select name="doctorId" required class="w-full border rounded-lg p-2 mb-3">
                                    <option value="">-- Chọn bác sĩ --</option>
                                    <c:forEach var="d" items="${doctors}">
                                        <option value="${d.doctorId}" 
                                                <c:if test="${appointment.doctorId == d.doctorId}">selected</c:if>>
                                            ${d.username} - ${d.specialty}
                                        </option>
                                    </c:forEach>
                                </select>

                                <!-- Trạng thái -->
                                <label class="block text-sm font-medium text-gray-600">Trạng thái</label>
                                <select name="status" class="w-full border rounded-lg p-2 mb-3">
                                    <option value="Pending" ${appointment.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                    <option value="Confirmed" ${appointment.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                    <option value="Cancelled" ${appointment.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>

                            <!-- RIGHT COLUMN -->
                            <div class="space-y-6">
                                <h3 class="text-lg font-semibold text-gray-700 mb-3 border-b pb-1">Thông tin bệnh nhân</h3>

                                <label class="block text-sm font-medium text-gray-600">Tên bệnh nhân</label>
                                <input type="text" value="${appointment.patientName}" 
                                       class="w-full border rounded-lg p-2 bg-gray-100 cursor-not-allowed" readonly>

                                <label class="block text-sm font-medium text-gray-600">Phụ huynh</label>
                                <input type="text" value="${appointment.parentName}" 
                                       class="w-full border rounded-lg p-2 bg-gray-100 cursor-not-allowed" readonly>

                                <label class="block text-sm font-medium text-gray-600">Địa chỉ</label>
                                <input type="text" value="${appointment.patientAddress}" 
                                       class="w-full border rounded-lg p-2 bg-gray-100 cursor-not-allowed" readonly>

                                <label class="block text-sm font-medium text-gray-600">Email</label>
                                <input type="text" value="${appointment.patientEmail}" 
                                       class="w-full border rounded-lg p-2 bg-gray-100 cursor-not-allowed" readonly>

                                <label class="block text-sm font-medium text-gray-600">SĐT</label>
                                <input type="text" value="${appointment.parentPhone}" 
                                       class="w-full border rounded-lg p-2 bg-gray-100 cursor-not-allowed" readonly>
                            </div>
                        </div>

                        <!-- BUTTONS -->
                        <div class="flex justify-end gap-4 mt-8">
                            <a href="${pageContext.request.contextPath}/Appointment-List"
                               class="px-6 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 transition">
                                Hủy
                            </a>

                            <button type="submit"
                                    class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition">
                                Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <!-- Footer -->
        <%@ include file="../includes/footer.jsp" %>
    </body>
</html>
