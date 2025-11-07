<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán hồ sơ</title>

    <!-- Tailwind -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- CSS chung của project -->
    <jsp:include page="/includes/head-includes.jsp" />

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
            padding-top: 70px; /* height header */
        }

        .sidebar-fixed {
            width: 280px;
            background: #ffffff;
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
            margin-left: 280px; /* = width sidebar */
            padding: 2rem;
        }
    </style>
</head>
<body>

    <!-- Header -->
    <jsp:include page="/includes/header.jsp" />

    <div class="main-wrapper">
        <!-- Sidebar Receptionist -->
        <%@ include file="/includes/sidebar-receptionist.jsp" %>

        <!-- MAIN CONTENT -->
        <div class="content-area">
            <h1 class="text-3xl font-bold mb-2 text-blue-700">
                Thanh toán hồ sơ khám bệnh
            </h1>

            <p class="mb-6 text-gray-600">
                Danh sách Medical Report và trạng thái thanh toán.
            </p>

            <div class="overflow-x-auto bg-white shadow border border-gray-200 rounded-lg">
                <table class="min-w-full text-sm text-left">
                    <thead class="bg-gray-100 text-gray-700">
                        <tr>
                            <th class="px-4 py-3">Record ID</th>
                            <th class="px-4 py-3">Appointment</th>
                            <th class="px-4 py-3">Chẩn đoán</th>
                            <th class="px-4 py-3">Thanh toán</th>
                            <th class="px-4 py-3">Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                        <c:forEach var="mr" items="${medicalReports}">
                            <tr class="hover:bg-blue-50">
                                <td class="px-4 py-3">${mr.recordId}</td>
                                <td class="px-4 py-3">#${mr.appointmentId}</td>
                                <td class="px-4 py-3">${mr.diagnosis}</td>

                                <td class="px-4 py-3">
                                    <c:choose>
                                        <c:when test="${!mr.paid}">
                                            <form action="${pageContext.request.contextPath}/reception/payment/create"
                                                  method="post"
                                                  class="flex gap-2 items-center">
                                                <input type="hidden" name="recordId" value="${mr.recordId}"/>
                                                <input type="hidden" name="appointmentId" value="${mr.appointmentId}"/>

                                                <input type="number" name="amount"
                                                       min="1000" step="1000" required
                                                       placeholder="Nhập số tiền (VND)"
                                                       class="border rounded px-2 py-1 text-sm w-40"/>

                                                <button type="submit"
                                                        class="bg-green-500 hover:bg-green-600 text-white text-sm font-semibold px-3 py-1 rounded">
                                                    Thu tiền (VNPay)
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-400 text-sm italic">
                                                Đã thanh toán
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="px-4 py-3 font-semibold">
                                    <c:choose>
                                        <c:when test="${mr.paid}">
                                            <span class="text-green-600">ĐÃ THANH TOÁN</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-red-600">CHƯA THANH TOÁN</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
                crossorigin="anonymous"></script>

    <!-- Footer -->
    <%@ include file="/includes/footer.jsp" %>
</body>
</html>
