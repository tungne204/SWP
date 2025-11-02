<%-- 
    Document   : AppointmentUpdateSearch
    Created on : Nov 2, 2025, 1:10:26 PM
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm & Cập nhật cuộc hẹn</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 font-sans">

    <!-- Header -->
    <jsp:include page="../includes/header.jsp"/>

    <div class="flex">
        <!-- Sidebar -->
        <%@ include file="../includes/sidebar-receptionist.jsp" %>

        <!-- Main Content -->
        <main class="flex-1 p-8">
            <div class="max-w-lg mx-auto bg-white shadow-xl rounded-xl p-8 border border-gray-200 mt-10">
                <h2 class="text-2xl font-bold text-blue-700 mb-6 flex items-center gap-2">
                    🔍 Tìm & Cập nhật cuộc hẹn
                </h2>

                <!-- Form nhập ID -->
                <form method="get" action="${pageContext.request.contextPath}/Appointment-Update" class="space-y-4">
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Mã cuộc hẹn</label>
                        <input type="number" name="id" required
                               class="w-full border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-blue-400"
                               placeholder="Nhập mã cuộc hẹn cần cập nhật...">
                    </div>

                    <div class="flex justify-end gap-3">
                        <a href="${pageContext.request.contextPath}/Appointment-List"
                           class="px-5 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 transition">
                           ← Quay lại danh sách
                        </a>
                        <button type="submit"
                                class="px-5 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                            Tìm & Cập nhật
                        </button>
                    </div>
                </form>

                <!-- Hiển thị lỗi nếu có -->
                <c:if test="${param.error == 'notfound'}">
                    <div class="mt-6 text-red-600 bg-red-50 border border-red-300 rounded-md p-3">
                        ❌ Không tìm thấy cuộc hẹn với ID đã nhập.
                    </div>
                </c:if>

                <c:if test="${param.error == 'missingId'}">
                    <div class="mt-6 text-red-600 bg-red-50 border border-red-300 rounded-md p-3">
                        ⚠️ Vui lòng nhập mã cuộc hẹn trước khi tìm kiếm.
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>
</body>
</html>
