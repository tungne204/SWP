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
        <style>
            .sortable:hover {
                cursor: pointer;
                background-color: #e2e8f0;
                transition: background-color 0.2s ease;
            }
            .sort-icon {
                font-size: 0.8rem;
                margin-left: 4px;
                opacity: 0.6;
            }
        </style>
    </head>

    <body class="bg-blue-50 min-h-screen text-gray-800 font-sans flex flex-col">

        <!-- Header -->
        <header class="bg-blue-700 text-white shadow-md fixed w-full z-10">
            <div class="max-w-7xl mx-auto flex justify-between items-center px-8 py-3">
                <a href="Receptionist-Dashboard" class="text-2xl font-bold tracking-wide hover:text-gray-200 transition">
                    Medilab
                </a>
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
        <main class="w-[100%] mx-auto px-8 pt-28 pb-10 flex-grow">
            <h2 class="text-3xl font-bold mb-6 text-blue-700 text-center">
                Appointment Management
            </h2>

            <!-- Thông báo lỗi -->
            <c:if test="${not empty errorMessage}">
                <div class="bg-red-100 text-red-700 font-semibold p-3 mb-5 rounded-lg text-center">
                    ⚠ ${errorMessage}
                </div>
            </c:if>

            <!-- Không có dữ liệu -->
            <c:if test="${empty appointments}">
                <div class="text-center text-gray-600 mt-8 text-lg">
                    No appointments found in the system.
                </div>
            </c:if>

            <!-- Bảng hiển thị -->
            <c:if test="${not empty appointments}">
                <!-- 🔍 Advanced Filter Bar -->
                <div class="flex flex-wrap gap-3 mb-6 bg-blue-100 border border-blue-200 p-4 rounded-lg shadow-sm">
                    <input type="text" id="filterPatient" placeholder="Filter by Patient Name"
                           class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                    <input type="text" id="filterDoctor" placeholder="Filter by Doctor Name"
                           class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                    <input type="text" id="filterAddress" placeholder="Filter by Address"
                           class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                    <input type="text" id="filterParent" placeholder="Filter by Parent Name"
                           class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                    <select id="filterStatus" class="px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500">
                        <option value="">All Status</option>
                        <option value="Confirmed">Confirmed</option>
                        <option value="Pending">Pending</option>
                    </select>

                    <!-- Date Range -->
                    <div class="flex items-center gap-2">
                        <label class="text-sm font-semibold text-gray-700">From:</label>
                        <input type="date" id="dateFrom" class="border rounded-md px-2 py-1">
                        <label class="text-sm font-semibold text-gray-700">To:</label>
                        <input type="date" id="dateTo" class="border rounded-md px-2 py-1">
                    </div>

                    <!-- Export Buttons -->
                    <div class="flex gap-2 ml-auto">
                        <button onclick="exportTableToExcel('appointmentTable')" 
                                class="bg-green-600 text-white px-3 py-2 rounded-md hover:bg-green-700 transition">
                            📗 Export Excel
                        </button>
                        <button onclick="window.print()" 
                                class="bg-red-600 text-white px-3 py-2 rounded-md hover:bg-red-700 transition">
                            🧾 Print / PDF
                        </button>
                    </div>
                </div>
                <div class="overflow-x-auto bg-white border border-blue-200 rounded-xl shadow-md">
                    <table id="appointmentTable" class="min-w-full w-full text-base text-left border-collapse">
                        <thead class="bg-blue-100 text-blue-800 text-sm uppercase">
                            <tr>
                                <th class="px-5 py-3">Appointment ID</th>
                                <th class="px-5 py-3 sortable" onclick="sortTable(1)">Patient Name <span class="sort-icon">⇅</span></th>
                                <th class="px-5 py-3 sortable" onclick="sortTable(2)">Parent Name <span class="sort-icon">⇅</span></th>
                                <th class="px-5 py-3 sortable" onclick="sortTable(7)">Address <span class="sort-icon">⇅</span></th>
                                <th class="px-5 py-3">Patient Email</th>
                                <th class="px-5 py-3 sortable" onclick="sortTable(4)">Parent Phone <span class="sort-icon">⇅</span></th>
                                <th class="px-5 py-3 sortable" onclick="sortTable(5)">Doctor Name <span class="sort-icon">⇅</span></th>
                                <th class="px-5 py-3 sortable" onclick="sortTable(6)">Doctor Specialty <span class="sort-icon">⇅</span></th>
                                <th class="px-5 py-3">Date</th>
                                <th class="px-5 py-3 sortable" onclick="sortTable(9)">Status <span class="sort-icon">⇅</span></th>
                                <th class="px-5 py-3 text-center sticky right-0 bg-blue-50 z-[20] shadow-inner">Actions</th>
                            </tr>

                            <!-- Hàng filter -->
                            <tr class="bg-blue-50 text-blue-700 text-sm">
                                <td></td>
                                <td><input type="text" onkeyup="filterTable(1, this.value)" placeholder="Filter Patient..." class="w-full px-2 py-1 border rounded"/></td>
                                <td><input type="text" onkeyup="filterTable(2, this.value)" placeholder="Filter Parent..." class="w-full px-2 py-1 border rounded"/></td>
                                <td><input type="text" onkeyup="filterTable(7, this.value)" placeholder="Filter Address..." class="w-full px-2 py-1 border rounded"/></td>
                                <td></td>
                                <td><input type="text" onkeyup="filterTable(4, this.value)" placeholder="Filter Phone..." class="w-full px-2 py-1 border rounded"/></td>
                                <td><input type="text" onkeyup="filterTable(5, this.value)" placeholder="Filter Doctor..." class="w-full px-2 py-1 border rounded"/></td>
                                <td><input type="text" onkeyup="filterTable(6, this.value)" placeholder="Filter Specialty..." class="w-full px-2 py-1 border rounded"/></td>
                                <td></td>
                                <td class="relative z-[10] bg-blue-50">
                                    <input type="text" onkeyup="filterTable(9, this.value)"
                                           placeholder="Filter Status..."
                                           class="w-full px-2 py-1 border rounded bg-white" />
                                </td>
                                <td class="sticky right-0 bg-blue-50 z-[20]"></td>

                            </tr>
                        </thead>

                        <tbody class="divide-y divide-blue-100">
                            <c:forEach var="a" items="${appointments}">
                                <tr class="hover:bg-blue-50 transition">
                                    <td class="px-5 py-3 font-medium">${a.appointmentId}</td>
                                    <td class="px-5 py-3">${a.patientName}</td>
                                    <td class="px-5 py-3">${a.parentName}</td>
                                    <td class="px-5 py-3">${a.patientAddress}</td>
                                    <td class="px-5 py-3">${a.patientEmail}</td>
                                    <td class="px-5 py-3">${a.parentPhone}</td>
                                    <td class="px-5 py-3">${a.doctorName}</td>
                                    <td class="px-5 py-3">${a.doctorSpecialty}</td>
                                    <td class="px-5 py-3"><fmt:formatDate value="${a.dateTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td class="px-5 py-3">
                                        <c:choose>
                                            <c:when test="${a.status}">Confirmed</c:when>
                                            <c:otherwise>Pending</c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Actions -->
                                    <td class="px-5 py-3 text-center sticky right-0 bg-white shadow-md">
                                        <div class="flex justify-center gap-2">
                                            <form action="${pageContext.request.contextPath}/Appointment-Status" method="post">
                                                <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                                <input type="hidden" name="status" value="${!a.status}">
                                                <button type="submit"
                                                        class="bg-blue-600 text-white px-3 py-1.5 rounded hover:bg-blue-700 transition text-sm">
                                                    Change
                                                </button>
                                            </form>

                                            <form action="${pageContext.request.contextPath}/Appointment-Update" method="post">
                                                <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                                <input type="hidden" name="action" value="load">
                                                <button type="submit"
                                                        class="bg-green-600 text-white px-3 py-1.5 rounded hover:bg-green-700 transition text-sm">
                                                    Edit
                                                </button>
                                            </form>

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
                <p><strong>Phone:</strong> +84 987 654 321<br>
                    <strong>Email:</strong> medilab.contact@gmail.com</p>
                <p class="text-sm text-gray-500 mt-4">
                    © <span class="fw-semibold text-gray-800">Medilab</span> — All Rights Reserved<br>
                    Designed by BootstrapMade | Customized by Medilab Team
                </p>
            </div>
        </footer>

        <!-- Script Sort + Filter -->
        <script>
            function sortTable(colIndex) {
                const table = document.getElementById("appointmentTable");
                const tbody = table.querySelector("tbody");
                const rows = Array.from(tbody.querySelectorAll("tr"));
                const asc = table.dataset.sortOrder !== "asc";
                table.dataset.sortOrder = asc ? "asc" : "desc";
                rows.sort((a, b) => {
                    const aText = a.children[colIndex].innerText.trim().toLowerCase();
                    const bText = b.children[colIndex].innerText.trim().toLowerCase();
                    return asc ? aText.localeCompare(bText) : bText.localeCompare(aText);
                });
                tbody.innerHTML = "";
                rows.forEach(r => tbody.appendChild(r));
            }

            function filterTable(colIndex, keyword) {
                keyword = keyword.toLowerCase();
                const rows = document.querySelectorAll("#appointmentTable tbody tr");
                rows.forEach(row => {
                    const text = row.children[colIndex].innerText.toLowerCase();
                    row.style.display = text.includes(keyword) ? "" : "none";
                });
            }
            // === Filter nâng cao & xuất Excel ===
            const filterInputs = ["filterPatient", "filterDoctor", "filterAddress", "filterParent", "filterStatus", "dateFrom", "dateTo"];
            filterInputs.forEach(id => {
                document.getElementById(id)?.addEventListener("input", advancedFilter);
            });

            function advancedFilter() {
                const patient = document.getElementById("filterPatient").value.toLowerCase();
                const doctor = document.getElementById("filterDoctor").value.toLowerCase();
                const address = document.getElementById("filterAddress").value.toLowerCase();
                const parent = document.getElementById("filterParent").value.toLowerCase();
                const status = document.getElementById("filterStatus").value.toLowerCase();
                const from = document.getElementById("dateFrom").value ? new Date(document.getElementById("dateFrom").value) : null;
                const to = document.getElementById("dateTo").value ? new Date(document.getElementById("dateTo").value) : null;
                document.querySelectorAll("#appointmentTable tbody tr").forEach(row => {
                    const rowData = {
                        patient: row.children[1]?.innerText.toLowerCase(),
                        parent: row.children[2]?.innerText.toLowerCase(),
                        address: row.children[3]?.innerText.toLowerCase(),
                        doctor: row.children[6]?.innerText.toLowerCase(),
                        specialty: row.children[7]?.innerText.toLowerCase(),
                        date: new Date(row.children[8]?.innerText.split("/").reverse().join("-")),
                        status: row.children[9]?.innerText.toLowerCase()
                    };
                    let visible =
                            (!patient || rowData.patient.includes(patient)) &&
                            (!doctor || rowData.doctor.includes(doctor)) &&
                            (!address || rowData.address.includes(address)) &&
                            (!parent || rowData.parent.includes(parent)) &&
                            (!status || rowData.status.includes(status)) &&
                            (!from || rowData.date >= from) &&
                            (!to || rowData.date <= to);
                    row.style.display = visible ? "" : "none";
                });
            }

            // === Xuất Excel ===
            function exportTableToExcel(tableID, filename = '') {
                const table = document.getElementById(tableID);
                const tableHTML = table.outerHTML.replace(/ /g, '%20');
                const name = filename ? filename + '.xls' : 'appointments.xls';
                const link = document.createElement("a");
                document.body.appendChild(link);
                link.href = 'data:application/vnd.ms-excel,' + tableHTML;
                link.download = name;
                link.click();
            }

        </script>

    </body>
</html>
