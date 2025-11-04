<%-- 
    Document   : AppointmentUpdateSearch
    Created on : Nov 2, 2025, 1:10:26 PM
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tìm & Cập nhật cuộc hẹn - Medilab</title>
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

            label {
                font-weight: 500;
                color: #475569;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="../includes/header.jsp"/>

        <div class="main-wrapper">
            <c:choose>
                <c:when test="${sessionScope.acc != null and sessionScope.acc.roleId == 5}">
                    <%@ include file="../includes/sidebar-receptionist.jsp" %>

                    <!-- Main Content -->
                    <div class="content-area">
                        <main class="max-w-xl mx-auto">
                            <div class="form-card">
                                <h2 class="text-3xl font-bold text-[#3fbbc0] mb-8 flex items-center gap-3">
                                    <i class="fa-solid fa-magnifying-glass text-[#3fbbc0]"></i>
                                    Tìm & Cập nhật cuộc hẹn
                                </h2>

                                <!-- Form nhập ID -->
                                <form method="get" action="${pageContext.request.contextPath}/Appointment-UpdateSearch" class="space-y-6">
                                    <div>
                                        <label class="block mb-2">Mã cuộc hẹn</label>
                                        <input type="number" name="id" required
                                               class="w-full border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-[#3fbbc0]"
                                               placeholder="Nhập mã cuộc hẹn cần cập nhật...">
                                    </div>

                                    <div class="flex justify-end gap-4">
                                        <a href="${pageContext.request.contextPath}/Appointment-List"
                                           class="px-6 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 transition">
                                            ← Quay lại danh sách
                                        </a>
                                        <button type="submit"
                                                class="px-6 py-2 bg-[#3fbbc0] text-white rounded-lg hover:bg-[#2a9fa4] transition">
                                            🔍 Tìm & Cập nhật
                                        </button>
                                    </div>

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

                                    <c:if test="${param.error == 'invalidId'}">
                                        <div class="mt-6 text-red-600 bg-red-50 border border-red-300 rounded-md p-3">
                                            ⚠️ Mã cuộc hẹn phải là số nguyên hợp lệ.
                                        </div>
                                    </c:if>
                                </form>
                            </div>
                        </main>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="content-area">
                        <main class="max-w-xl mx-auto">
                            <div class="form-card text-center">
                                <h2 class="text-2xl font-bold text-red-600 mb-4">
                                    ⚠️ Không được phép truy cập
                                </h2>
                                <p class="text-gray-600 mb-6">
                                    Chức năng này chỉ dành cho nhân viên lễ tân (Receptionist).
                                </p>
                                <a href="${pageContext.request.contextPath}/Home.jsp"
                                   class="px-6 py-2 bg-[#3fbbc0] text-white rounded-lg hover:bg-[#2a9fa4] transition">
                                    Về trang chủ
                                </a>
                            </div>
                        </main>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Footer -->
        <%@ include file="../includes/footer.jsp" %>
    </body>
</html>
