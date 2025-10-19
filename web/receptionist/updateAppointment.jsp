<%-- 
    Document   : updateAppointment
    Created on : Oct 19, 2025, 7:47:48 AM
    Author     : KiênPC
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🩺 Update Appointment</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="bg-green-50 min-h-screen text-gray-800 flex justify-center items-center">

        <div class="bg-white shadow-lg rounded-xl p-8 w-full max-w-2xl border border-green-100">
            <h2 class="text-2xl font-bold text-green-700 mb-6 flex items-center gap-2">
                <span>🩺</span> Update Appointment Information
            </h2>

            <form action="${pageContext.request.contextPath}/Appointment-Update" method="post" class="space-y-4">
                <input type="hidden" name="action" value="update">
                <!-- Appointment ID -->
                <div>
                    <label class="block text-sm font-medium text-gray-600">Appointment ID</label>
                    <input type="number" name="appointmentId" value="${appointment.appointmentId}" 
                           class="w-full mt-1 border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-green-400" readonly>
                </div>

                <!-- Patient ID -->
                <div>
                    <label class="block text-sm font-medium text-gray-600">Patient ID</label>
                    <input type="number" name="patientId" value="${appointment.patientId}" 
                           class="w-full mt-1 border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-green-400" required>
                </div>

                <!-- Doctor ID -->
                <div>
                    <label class="block text-sm font-medium text-gray-600">Doctor ID</label>
                    <input type="number" name="doctorId" value="${appointment.doctorId}" 
                           class="w-full mt-1 border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-green-400" required>
                </div>

                <!-- Date & Time -->
                <div>
                    <label class="block text-sm font-medium text-gray-600">Date & Time</label>
                    <fmt:formatDate value="${appointment.dateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="formattedDate" />
                    <input type="datetime-local" name="dateTime" 
                           value="${formattedDate}" 
                           class="w-full mt-1 border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-green-400" required>

                </div>

                <!-- Status -->
                <div>
                    <label class="block text-sm font-medium text-gray-600">Status</label>
                    <select name="status" 
                            class="w-full mt-1 border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-green-400">
                        <option value="true" ${appointment.status ? "selected" : ""}>✅ Confirmed</option>
                        <option value="false" ${!appointment.status ? "selected" : ""}>🕓 Pending</option>
                    </select>
                </div>

                <!-- Buttons -->
                <div class="flex justify-between items-center mt-6">
                    <a href="Appointment-List"
                       class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">
                        ⬅️ Back to List
                    </a>
                    <button type="submit"
                            class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition">
                        💾 Save Changes
                    </button>
                </div>
            </form>
        </div>

    </body>
</html>
