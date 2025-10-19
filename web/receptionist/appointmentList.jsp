<%-- 
    Document   : View Appointment List and Chang Status
    Created on : Oct 18, 2025, 9:16 PM
    Author     : KiênPC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setLocale value="vi_VN" />
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Manage Appointments</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="bg-gray-50 min-h-screen text-gray-800">
        <div class="max-w-6xl mx-auto p-6">
            <h2 class="text-2xl font-bold mb-4 text-green-700">📋 Appointment Management</h2>

            <c:if test="${empty appointments}">
                <div class="text-center text-gray-500 mt-6">
                    ❌ Không có cuộc hẹn nào trong hệ thống.
                </div>
            </c:if>

            <c:if test="${not empty appointments}">
                <table class="min-w-full bg-white border border-gray-200 rounded-xl shadow-sm">
                    <thead class="bg-green-100 text-green-800">
                        <tr>
                            <th class="px-4 py-2 text-left">Appointment ID</th>
                            <th class="px-4 py-2 text-left">Patient ID</th>
                            <th class="px-4 py-2 text-left">Doctor ID</th>
                            <th class="px-4 py-2 text-left">Date</th>
                            <th class="px-4 py-2 text-left">Status</th>
                            <th class="px-4 py-2 text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${appointments}">
                            <tr class="border-t hover:bg-green-50">
                                <td class="px-4 py-2">${a.appointmentId}</td>
                                <td class="px-4 py-2">${a.patientId}</td>
                                <td class="px-4 py-2">${a.doctorId}</td>
                                <td class="px-4 py-2">
                                    <fmt:formatDate value="${a.dateTime}" pattern="EEEE, dd/MM/yyyy hh:mm a" />
                                </td>
                                <td class="px-4 py-2">
                                    <c:choose>
                                        <c:when test="${a.status}">✅ Confirmed</c:when>
                                        <c:otherwise>🕓 Pending</c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Cột Actions -->
                                <td class="px-4 py-2 text-center flex justify-center gap-2">
                                    <!-- Change status -->
                                    <form action="Appointment-Status" method="post">
                                        <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                        <input type="hidden" name="status" value="${!a.status}">
                                        <button type="submit"
                                                class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700 transition">
                                            🔄 Change
                                        </button>
                                    </form>

                                    <!-- Edit appointment -->
                                    <form action="Appointment-Update" method="post">
                                        <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                        <input type="hidden" name="action" value="load">
                                        <button type="submit"
                                                class="bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700 transition">
                                            ✏️ Edit
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
