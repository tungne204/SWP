<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Change Appointment Status</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 min-h-screen text-gray-800">
<div class="max-w-5xl mx-auto p-6">
    <h2 class="text-2xl font-bold mb-4 text-indigo-700">⚙️ Change Appointment Status</h2>

    <c:if test="${empty appointments}">
        <div class="text-center text-gray-500 mt-6">
            ❌ Không có cuộc hẹn nào trong hệ thống.
        </div>
    </c:if>

    <c:if test="${not empty appointments}">
        <table class="min-w-full bg-white border border-gray-200 rounded-xl shadow-sm">
            <thead class="bg-gray-100 text-gray-700">
                <tr>
                    <th class="px-4 py-2 text-left">Appointment ID</th>
                    <th class="px-4 py-2 text-left">Patient ID</th>
                    <th class="px-4 py-2 text-left">Doctor ID</th>
                    <th class="px-4 py-2 text-left">Date</th>
                    <th class="px-4 py-2 text-left">Status</th>
                    <th class="px-4 py-2 text-center">Change</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="a" items="${appointments}">
                    <tr class="border-t hover:bg-gray-50">
                        <td class="px-4 py-2">${a.appointmentId}</td>
                        <td class="px-4 py-2">${a.patientId}</td>
                        <td class="px-4 py-2">${a.doctorId}</td>
                        <td class="px-4 py-2">
                            <fmt:formatDate value="${a.dateTime}" pattern="dd/MM/yyyy" />
                        </td>
                        <td class="px-4 py-2">
                            <c:choose>
                                <c:when test="${a.status}">✅ Confirmed</c:when>
                                <c:otherwise>🕓 Pending</c:otherwise>
                            </c:choose>
                        </td>

                        <!-- Nút đổi trạng thái -->
                        <td class="px-4 py-2 text-center">
                            <form action="Appointment-Status" method="post">
                                <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                <input type="hidden" name="status" value="${!a.status}">
                                <button type="submit"
                                        class="bg-indigo-600 text-white px-3 py-1 rounded hover:bg-indigo-700 transition">
                                    Change
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>
</body>
</html>
