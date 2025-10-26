<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setLocale value="vi_VN" />
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Appointment - Medilab</title>
        <script src="https://cdn.tailwindcss.com"></script>
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
                padding: 2rem;
            }
            
            .form-container {
                max-width: 800px;
                margin: 0 auto;
                padding: 20px;
            }
            .form-card {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                padding: 40px;
            }
            .form-title {
                color: #4a5568;
                font-size: 2.5rem;
                font-weight: bold;
                text-align: center;
                margin-bottom: 30px;
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-label {
                display: block;
                color: #4a5568;
                font-weight: 600;
                margin-bottom: 8px;
            }
            .form-input {
                width: 100%;
                padding: 12px 16px;
                border: 2px solid #e2e8f0;
                border-radius: 10px;
                font-size: 16px;
                transition: all 0.3s ease;
            }
            .form-input:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(63, 187, 192, 0.1);
            }
            .btn-primary {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
                color: white;
                padding: 12px 30px;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(63, 187, 192, 0.3);
            }
            .btn-secondary {
                background: #e2e8f0;
                color: #4a5568;
                padding: 12px 30px;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-left: 10px;
            }
            .btn-secondary:hover {
                background: #cbd5e0;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <%@ include file="../includes/header.jsp" %>

        <div class="main-wrapper">
            <!-- Sidebar -->
            <%@ include file="../includes/sidebar-receptionist.jsp" %>

            <!-- Main Content -->
            <div class="content-area">
                <div class="form-container">
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

                </div> <!-- End form-container -->
            </div> <!-- End content-area -->
        </div> <!-- End main-wrapper -->

        <!-- Footer -->
        <%@ include file="../includes/footer.jsp" %>

    </body>
</html>
