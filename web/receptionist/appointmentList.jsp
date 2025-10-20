<%-- 
    Document   : updateAppointment
    Created on : Oct 19, 2025, 7:47:48 AM
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
        <title>Manage Appointments | Medilab Clinic</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="bg-blue-50 min-h-screen text-gray-800 font-sans flex flex-col">

        <!-- Header -->
        <header class="bg-blue-700 text-white shadow-md fixed w-full z-10">
            <div class="max-w-7xl mx-auto flex justify-between items-center px-8 py-3">
                <span class="text-xl font-bold tracking-wide">Medilab Clinic</span>
                <div class="flex items-center gap-3">
                    <a href="${pageContext.request.contextPath}/Receptionist-Dashboard"
                       class="bg-white/20 text-white px-4 py-1.5 rounded-full font-semibold hover:bg-white hover:text-blue-700 transition">
                        Home
                    </a>
                    <a href="${pageContext.request.contextPath}/logout"
                       class="bg-white text-blue-600 px-4 py-1.5 rounded-full font-semibold hover:bg-blue-100 transition">
                        Logout
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="max-w-7xl mx-auto w-full px-6 pt-28 pb-10 flex-grow">
            <h2 class="text-3xl font-bold mb-6 text-blue-700 text-center">
                Appointment Management
            </h2>

            <!-- Thông báo lỗi từ servlet -->
            <c:if test="${not empty errorMessage}">
                <div class="bg-red-100 text-red-700 font-semibold p-3 mb-5 rounded-lg text-center">
                    ⚠ ${errorMessage}
                </div>
            </c:if>

            <!-- No appointments -->
            <c:if test="${empty appointments}">
                <div class="text-center text-gray-600 mt-8 text-lg">
                    No appointments found in the system.
                </div>
            </c:if>

            <!-- Appointment Table -->
            <c:if test="${not empty appointments}">
                <div class="overflow-x-auto bg-white border border-blue-200 rounded-xl shadow-md">
                    <table class="min-w-[1800px] w-full text-base text-left border-collapse pr-8">
                        <thead class="bg-blue-100 text-blue-800">
                            <tr>
                                <th class="px-5 py-3">Appointment ID</th>
                                <th class="px-5 py-3">Patient Name</th>
                                <th class="px-5 py-3">Parent Name</th>
                                <th class="px-5 py-3">Patient Email</th>
                                <th class="px-5 py-3">Parent Phone</th>
                                <th class="px-5 py-3">Doctor Name</th>
                                <th class="px-5 py-3">Doctor Specialty</th>
                                <th class="px-5 py-3">Date</th>
                                <th class="px-5 py-3">Status</th>
                                <th class="px-5 py-3 text-center sticky right-0 bg-blue-50 z-10 shadow-inner">
                                    Actions
                                </th>
                            </tr>
                        </thead>

                        <tbody class="divide-y divide-blue-100">
                            <c:forEach var="a" items="${appointments}">
                                <tr class="hover:bg-blue-50 transition">
                                    <td class="px-5 py-3 font-medium">${a.appointmentId}</td>
                                    <td class="px-5 py-3 whitespace-nowrap">${a.patientName}</td>
                                    <td class="px-5 py-3 whitespace-nowrap">
                                        <c:out value="${a.parentName != null ? a.parentName : '-'}"/>
                                    </td>
                                    <td class="px-5 py-3 whitespace-nowrap">
                                        <c:out value="${a.patientEmail != null ? a.patientEmail : '-'}"/>
                                    </td>
                                    <td class="px-5 py-3 whitespace-nowrap">
                                        <c:out value="${a.parentPhone != null ? a.parentPhone : '-'}"/>
                                    </td>
                                    <td class="px-5 py-3 whitespace-nowrap">${a.doctorName}</td>
                                    <td class="px-5 py-3 whitespace-nowrap">${a.doctorSpecialty}</td>
                                    <td class="px-5 py-3">
                                        <fmt:formatDate value="${a.dateTime}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td class="px-5 py-3">
                                        <c:choose>
                                            <c:when test="${a.status}">Confirmed</c:when>
                                            <c:otherwise>Pending</c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Actions -->
                                    <td class="px-5 py-3 text-center sticky right-0 bg-white shadow-md">
                                        <div class="flex justify-center gap-2">
                                            <!-- Change Status -->
                                            <form action="${pageContext.request.contextPath}/Appointment-Status" method="post">
                                                <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                                <input type="hidden" name="status" value="${!a.status}">
                                                <button type="submit"
                                                        class="bg-blue-600 text-white px-3 py-1.5 rounded hover:bg-blue-700 transition text-sm">
                                                    Change
                                                </button>
                                            </form>

                                            <!-- Edit -->
                                            <form action="${pageContext.request.contextPath}/Appointment-Update" method="post">
                                                <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                                <input type="hidden" name="action" value="load">
                                                <button type="submit"
                                                        class="bg-green-600 text-white px-3 py-1.5 rounded hover:bg-green-700 transition text-sm">
                                                    Edit
                                                </button>
                                            </form>

                                            <!-- Delete -->
                                            <form action="${pageContext.request.contextPath}/Appointment-Delete" method="post"
                                                  onsubmit="return confirm('Are you sure you want to delete this appointment?');">
                                                <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                                <button type="submit"
                                                        class="bg-red-600 text-white px-3 py-1.5 rounded hover:bg-red-700 transition text-sm">
                                                    Delete
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </main>

        <!-- Footer -->
        <footer class="bg-[#f7f9fc] text-gray-700 py-8 border-top border-gray-200 mt-5">
            <div class="max-w-5xl mx-auto text-center space-y-3">
                <h2 class="text-2xl fw-bold text-gray-800">Medilab</h2>
                <p>FPT University, Hoa Lac Hi-Tech Park, Thach That, Hanoi</p>
                <p>
                    <strong>Phone:</strong> +84 987 654 321<br>
                    <strong>Email:</strong> medilab.contact@gmail.com
                </p>
                <div class="d-flex justify-content-center gap-4 mt-4">
                    <a href="#" class="text-blue-600 hover:text-blue-800 transition"><i class="fab fa-facebook fa-lg"></i></a>
                    <a href="#" class="text-pink-500 hover:text-pink-700 transition"><i class="fab fa-instagram fa-lg"></i></a>
                    <a href="#" class="text-blue-500 hover:text-blue-700 transition"><i class="fab fa-youtube fa-lg"></i></a>
                    <a href="#" class="text-blue-700 hover:text-blue-900 transition"><i class="fab fa-linkedin fa-lg"></i></a>
                </div>
                <p class="text-sm text-gray-500 mt-4">
                    © <span class="fw-semibold text-gray-800">Medilab</span> — All Rights Reserved<br>
                    Designed by BootstrapMade | Customized by Medilab Team
                </p>
            </div>
        </footer>
    </body>
</html>
