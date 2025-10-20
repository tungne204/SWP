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
  <title>Edit Appointment | Medilab Clinic</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 min-h-screen text-gray-800">
  <div class="max-w-6xl mx-auto bg-white shadow-xl rounded-xl mt-10 p-8 border border-gray-200">
    <h2 class="text-2xl font-bold text-blue-700 mb-6 flex items-center gap-2">✏️ Edit Appointment</h2>

    <form action="${pageContext.request.contextPath}/Appointment-Update" method="post">
      <input type="hidden" name="action" value="update">
      <!-- ✅ BẮT BUỘC: appointmentId để servlet update -->
      <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

      <div class="grid grid-cols-2 gap-8">
        <!-- LEFT: Appointment + Patient -->
        <div class="space-y-6">
          <!-- Appointment Details -->
          <div>
            <h3 class="text-lg font-semibold text-gray-700 mb-3 border-b pb-1">📅 Appointment Details</h3>

            <label class="block text-sm font-medium text-gray-600">Appointment Date</label>
            <input type="date" name="appointmentDate"
                   value="<fmt:formatDate value='${appointment.dateTime}' pattern='yyyy-MM-dd'/>"
                   class="w-full border rounded-lg p-2 mb-3" required>

            <label class="block text-sm font-medium text-gray-600">Appointment Time</label>
            <input type="time" name="appointmentTime"
                   value="<fmt:formatDate value='${appointment.dateTime}' pattern='HH:mm'/>"
                   class="w-full border rounded-lg p-2 mb-3" required>

            <label class="block text-sm font-medium text-gray-600">Doctor</label>
            <select name="doctorId" required class="w-full border rounded-lg p-2">
              <option value="">-- Select Doctor - Specialty --</option>
              <c:forEach var="d" items="${doctors}">
                <option value="${d.doctorId}"
                        <c:if test="${appointment.doctorId == d.doctorId}">selected</c:if>>
                  ${d.username} - ${d.specialty}
                </option>
              </c:forEach>
            </select>
          </div>

          <!-- Patient Information -->
          <div>
            <h3 class="text-lg font-semibold text-gray-700 mb-3 border-b pb-1">👤 Patient Information</h3>

            <label class="block text-sm font-medium text-gray-600">Full Name</label>
            <input type="text" name="fullName" value="${patient.fullName}"
                   class="w-full border rounded-lg p-2 mb-3" required>

            <label class="block text-sm font-medium text-gray-600">Date of Birth</label>
            <input type="date" name="dob"
                   value="<fmt:formatDate value='${patient.dob}' pattern='yyyy-MM-dd'/>"
                   class="w-full border rounded-lg p-2 mb-3">

            <label class="block text-sm font-medium text-gray-600">Address</label>
            <input type="text" name="address" value="${patient.address}"
                   class="w-full border rounded-lg p-2 mb-3">

            <label class="block text-sm font-medium text-gray-600">Insurance Info</label>
            <input type="text" name="insuranceInfo" value="${patient.insuranceInfo}"
                   class="w-full border rounded-lg p-2 mb-3">
          </div>
        </div>

        <!-- RIGHT: Parent -->
        <div class="space-y-6">
          <div>
            <h3 class="text-lg font-semibold text-gray-700 mb-3 border-b pb-1">👪 Parent Information</h3>

            <label class="block text-sm font-medium text-gray-600">Parent Name</label>
            <input type="text" name="parentName" value="${parent.parentName}"
                   class="w-full border rounded-lg p-2 mb-3" required>

            <label class="block text-sm font-medium text-gray-600">Parent ID</label>
            <input type="text" name="parentId" value="${parent.idInfo}"
                   class="w-full border rounded-lg p-2 mb-3" required>

            <!-- ✅ NEW: Parent Email (đọc từ User) -->
            <label class="block text-sm font-medium text-gray-600">Parent Email</label>
            <input type="email" name="parentEmail" value="${user.email}"
                   placeholder="Enter parent email"
                   class="w-full border rounded-lg p-2 mb-3">
          </div>
        </div>
      </div>

      <!-- BUTTONS -->
      <div class="flex justify-end gap-4 mt-8">
        <a href="${pageContext.request.contextPath}/Appointment-List"
           class="px-6 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 transition">✖ Cancel</a>

        <button type="submit"
                class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition">
          ✔ Confirm Update
        </button>
      </div>
    </form>
  </div>
</body>
</html>
