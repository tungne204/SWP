<%-- 
    Document   : appointmentList
    Created on : Oct 8, 2025
    Author     : Kiên
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
                <a href="Receptionist-Dashboard"
                   class="bg-white/20 text-white px-4 py-1.5 rounded-full font-semibold hover:bg-white hover:text-blue-700 transition">
                    Home
                </a>
                <a href="logout"
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

        <!-- No appointments -->
        <c:if test="${empty appointments}">
            <div class="text-center text-gray-600 mt-8 text-lg">
                No appointments found in the system.
            </div>
        </c:if>

        <!-- Appointment Table -->
        <c:if test="${not empty appointments}">
            <div class="overflow-x-auto bg-white border border-blue-200 rounded-xl shadow-md">
                <table class="min-w-full text-base text-left border-collapse">
                    <thead class="bg-blue-100 text-blue-800">
                        <tr>
                            <th class="px-5 py-3">Appointment ID</th>
                            <th class="px-5 py-3">Patient Name</th>
                            <th class="px-5 py-3">Doctor Name</th>
                            <th class="px-5 py-3">Doctor Specialty</th>
                            <th class="px-5 py-3">Date</th>
                            <th class="px-5 py-3">Status</th>
                            <th class="px-5 py-3 text-center">Actions</th>
                        </tr>
                    </thead>

                    <tbody class="divide-y divide-blue-100">
                        <c:forEach var="a" items="${appointments}">
                            <tr class="hover:bg-blue-50 transition">
                                <td class="px-5 py-3 font-medium">${a.appointmentId}</td>
                                <td class="px-5 py-3 whitespace-nowrap max-w-[220px] overflow-hidden text-ellipsis">
                                    <c:out value="${a.patientName != null ? a.patientName : '-'}"/>
                                </td>
                                <td class="px-5 py-3 whitespace-nowrap max-w-[220px] overflow-hidden text-ellipsis">
                                    <c:out value="${a.doctorName != null ? a.doctorName : '-'}"/>
                                </td>
                                <td class="px-5 py-3 whitespace-nowrap max-w-[200px] overflow-hidden text-ellipsis">
                                    <c:out value="${a.doctorSpecialty != null ? a.doctorSpecialty : '-'}"/>
                                </td>
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
                                <td class="px-5 py-3 text-center">
                                    <div class="flex justify-center gap-3">
                                        <!-- Change -->
                                        <form action="Appointment-Status" method="post">
                                            <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                            <input type="hidden" name="status" value="${!a.status}">
                                            <button type="submit"
                                                    class="bg-blue-600 text-white px-4 py-1.5 rounded hover:bg-blue-700 transition">
                                                Change
                                            </button>
                                        </form>

                                        <!-- Edit -->
                                        <form action="Appointment-Update" method="post">
                                            <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                            <input type="hidden" name="action" value="load">
                                            <button type="submit"
                                                    class="bg-green-600 text-white px-4 py-1.5 rounded hover:bg-green-700 transition">
                                                Edit
                                            </button>
                                        </form>

                                        <!-- Delete -->
                                        <form action="Appointment-Delete" method="post"
                                              onsubmit="return confirm('Are you sure you want to delete this appointment?');">
                                            <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                            <button type="submit"
                                                    class="bg-red-600 text-white px-4 py-1.5 rounded hover:bg-red-700 transition">
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
    <footer class="bg-blue-700 text-blue-100 py-6 mt-auto">
        <div class="text-center text-sm">
            © 2025 Medilab Pediatric Clinic | Designed by 
            <span class="font-semibold text-white">Kiên</span>
        </div>
    </footer>
</body>
</html>
