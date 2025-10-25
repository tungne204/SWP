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
        <title>Edit Appointment</title>
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Bootstrap 5.3 -->
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet"
            crossorigin="anonymous"
            />
        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            crossorigin="anonymous"
        ></script>

        <!-- FontAwesome -->
        <script src="https://kit.fontawesome.com/a2e0b7c6d6.js" crossorigin="anonymous"></script>
    </head>

    <body class="bg-gray-50 min-h-screen text-gray-800">

        <!-- ================= HEADER (copy từ PatientSearch.jsp) ================= -->
        <header class="bg-blue-600 text-white shadow-md fixed w-full z-10">
            <div class="max-w-7xl mx-auto flex justify-between items-center px-8 py-3">
                <a href="Receptionist-Dashboard" class="text-2xl font-bold tracking-wide hover:text-gray-200 transition">
                    Medilab
                </a>
                <div class="d-flex gap-3">
                    <a href="Receptionist-Dashboard" class="btn btn-light text-blue-700 fw-semibold px-4 py-1">Home</a>
                    <a href="logout" class="btn btn-outline-light fw-semibold px-4 py-1">Logout</a>
                </div>
            </div>
        </header>

        <!-- ================= MAIN CONTENT ================= -->
        <main class="pt-32 pb-10 px-8">
            <div class="max-w-6xl mx-auto bg-white shadow-xl rounded-xl mt-10 p-8 border border-gray-200">
                <h2 class="text-2xl font-bold text-blue-700 mb-6 flex items-center gap-2">✏️ Edit Appointment</h2>

                <!--EXPORT BUTTONS -->
                <div class="flex justify-end gap-3 mb-6">
                    <button onclick="exportFormToExcel()" 
                            class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition">
                        📗 Export Excel
                    </button>
                    <button onclick="window.print()" 
                            class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition">
                        🧾 Print / PDF
                    </button>
                </div>

                <form action="${pageContext.request.contextPath}/Appointment-Update" method="post" id="appointmentForm">
                    <input type="hidden" name="action" value="update">
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
        </main>

        <!-- ================= FOOTER (copy từ PatientSearch.jsp) ================= -->
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

        <!--SCRIPT EXPORT FUNCTION -->
        <script>
            function exportFormToExcel() {
                const form = document.getElementById("appointmentForm");
                const inputs = form.querySelectorAll("input, select, textarea");
                let html = "<meta charset='UTF-8'><table border='1'><tr><th>Trường</th><th>Giá trị</th></tr>";

                inputs.forEach(el => {
                    let label = "(Không xác định)";
                    let value = "";

                    const prevLabel = el.previousElementSibling;
                    if (prevLabel && prevLabel.tagName === "LABEL") {
                        label = prevLabel.innerText.trim();
                    } else if (el.name) {
                        label = el.name;
                    }

                    if (el.tagName === "SELECT") {
                        value = el.options[el.selectedIndex]?.text || "";
                    } else {
                        value = el.value || "";
                    }

                    if (
                            el.type !== "hidden" &&
                            el.type !== "submit" &&
                            el.type !== "button" &&
                            label &&
                            value &&
                            !["action", "appointmentId"].includes(el.name)
                            ) {
                        html += `<tr><td>${label}</td><td>${value}</td></tr>`;
                    }
                });

                html += "</table>";

                const blob = new Blob(["\ufeff" + html], {type: "application/vnd.ms-excel;charset=utf-8;"});
                const url = URL.createObjectURL(blob);
                const a = document.createElement("a");
                a.href = url;
                a.download = "Appointment_Update_Info.xls";
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
            }
        </script>

    </body>
</html>
