<%-- 
    Document   : PatientSearch
    Created on : Oct 8, 2025, 5:37:36 PM
    Author     : KienPC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Patient Information </title>
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Sort icons + hover style -->
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

    <body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">

        <!-- Header -->
        <header class="bg-blue-600 text-white shadow-md fixed w-full z-10">
            <div class="max-w-7xl mx-auto flex justify-between items-center px-8 py-3">
                <div class="flex items-center gap-3">
                    <a href="Receptionist-Dashboard" class="text-2xl font-bold tracking-wide hover:text-gray-200 transition">
                        Medilab
                    </a>
                </div>

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
        <main class="w-[95%] mx-auto px-8 pt-28 pb-10 flex-grow">
            <h2 class="text-3xl font-bold mb-6 text-blue-700 text-center">
                Patient Information
            </h2>

            <!-- ️ Error -->
            <c:if test="${not empty error}">
                <div class="mb-4 p-3 bg-red-100 text-red-700 rounded-lg border border-red-300 text-center">
                    ️ ${error}
                </div>
            </c:if>

            <!--️ Warning -->
            <c:if test="${not empty warning}">
                <div id="warningBox" class="mb-4 p-3 bg-yellow-100 text-yellow-700 rounded-lg border border-yellow-300 text-center">
                    ${warning}
                </div>
            </c:if>

            <!--Search Form -->
            <form id="searchForm" action="Patient-Search" method="post"
                  class="flex flex-col sm:flex-row gap-3 mb-10 justify-center max-w-3xl mx-auto w-full">
                <input
                    type="text"
                    name="keyword"
                    placeholder="Enter patient name or ID..."
                    value="${keyword}"
                    class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 text-lg"
                    >
                <button type="submit"
                        class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition font-semibold text-lg">
                    Search
                </button>
            </form>
            <!-- Advanced Filter -->
            <div class="flex flex-wrap gap-3 mb-6 bg-blue-100 border border-blue-200 p-4 rounded-lg shadow-sm">
                <input type="text" id="filterName" placeholder="Filter by Name"
                       class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                <input type="text" id="filterAddress" placeholder="Filter by Address"
                       class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                <input type="text" id="filterInsurance" placeholder="Filter by Insurance"
                       class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                <input type="text" id="filterPhone" placeholder="Filter by Phone"
                       class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
            </div>

            <!--  Table Result -->
            <c:if test="${not empty patients}">
                <div class="overflow-x-auto shadow border border-gray-200 rounded-xl bg-white w-full mx-auto">
                    <table id="patientTable" class="min-w-full w-full text-base text-left table-fixed">
                        <thead class="bg-gray-100 text-gray-700 text-sm uppercase">
                            <tr>
                                <th class="px-4 py-4 w-[6%]">Patient ID</th>
                                <th class="px-4 py-4 w-[14%] sortable" onclick="sortTable(1)">Full Name <span class="sort-icon">⇅</span></th>
                                <th class="px-4 py-4 w-[12%]">Date of Birth</th>
                                <th class="px-4 py-4 w-[18%] sortable" onclick="sortTable(3)">Address <span class="sort-icon">⇅</span></th>
                                <th class="px-4 py-4 w-[10%] sortable" onclick="sortTable(4)">Insurance <span class="sort-icon">⇅</span></th>
                                <th class="px-4 py-4 w-[20%]">Email</th>
                                <th class="px-4 py-4 w-[10%] sortable" onclick="sortTable(6)">Phone <span class="sort-icon">⇅</span></th>
                                <th class="px-4 py-4 w-[10%] text-center">Details</th>
                            </tr>

                            <!-- Filter Row -->
                            <tr class="bg-gray-50 text-gray-600 text-sm">
                                <td></td>
                                <td><input type="text" onkeyup="filterTable(1, this.value)" placeholder="Filter Name..." class="w-full px-2 py-1 border rounded"/></td>
                                <td></td>
                                <td><input type="text" onkeyup="filterTable(3, this.value)" placeholder="Filter Address..." class="w-full px-2 py-1 border rounded"/></td>
                                <td><input type="text" onkeyup="filterTable(4, this.value)" placeholder="Filter Insurance..." class="w-full px-2 py-1 border rounded"/></td>
                                <td></td>
                                <td><input type="text" onkeyup="filterTable(6, this.value)" placeholder="Filter Phone..." class="w-full px-2 py-1 border rounded"/></td>
                                <td></td>
                            </tr>
                        </thead>

                        <tbody class="divide-y divide-gray-200">
                            <c:forEach var="p" items="${patients}">
                                <tr class="hover:bg-blue-50">
                                    <td class="px-4 py-3 font-semibold">${p.patientId}</td>
                                    <td class="px-4 py-3">${p.fullName}</td>
                                    <td class="px-4 py-3">${p.dob}</td> 
                                    <td class="px-4 py-3">${p.address}</td>
                                    <td class="px-4 py-3">${p.insuranceInfo}</td>
                                    <td class="px-4 py-3 truncate">${p.email}</td>  
                                    <td class="px-4 py-3">${p.phone}</td>  
                                    <td class="px-4 py-3 text-center">
                                        <a href="Patient-Profile?id=${p.patientId}"
                                           class="bg-blue-500 text-white px-4 py-1.5 rounded-md hover:bg-blue-600 transition inline-flex items-center gap-1">
                                            👁 View
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <p class="mt-6 text-gray-600 text-center">
                    Found <strong>${fn:length(patients)}</strong> result(s)
                    <c:if test="${not empty keyword}"> for keyword "<em>${keyword}</em>"</c:if>.
                    </p>
            </c:if>

            <!-- ️ No input yet -->
            <c:if test="${empty keyword}">
                <div class="mt-10 text-gray-500 text-center text-lg">
                    Please search for a patient.
                </div>
            </c:if>

            <!-- No result -->
            <c:if test="${not empty keyword and empty patients}">
                <div class="mt-10 text-gray-500 text-center text-lg">
                    ❌ No patient found for keyword "<strong>${keyword}</strong>".
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
                <p class="text-sm text-gray-500 mt-4">
                    © <span class="fw-semibold text-gray-800">Medilab</span> — All Rights Reserved<br>
                    Designed by BootstrapMade | Customized by Medilab Team
                </p>
            </div>
        </footer>

        <!-- Scripts -->
        <script>
            // ===== SORT FUNCTION =====
            function sortTable(columnIndex) {
                const table = document.getElementById("patientTable");
                const tbody = table.querySelector("tbody");
                const rows = Array.from(tbody.querySelectorAll("tr"));
                const asc = table.dataset.sortOrder !== "asc";
                table.dataset.sortOrder = asc ? "asc" : "desc";

                rows.sort((a, b) => {
                    const aText = a.children[columnIndex].innerText.trim().toLowerCase();
                    const bText = b.children[columnIndex].innerText.trim().toLowerCase();

                    if (!isNaN(aText) && !isNaN(bText)) {
                        return asc ? aText - bText : bText - aText;
                    }
                    return asc ? aText.localeCompare(bText) : bText.localeCompare(aText);
                });

                tbody.innerHTML = "";
                rows.forEach(row => tbody.appendChild(row));
            }

            // ===== FILTER FUNCTION =====
            function filterTable(columnIndex, keyword) {
                const table = document.getElementById("patientTable");
                const rows = table.querySelectorAll("tbody tr");
                keyword = keyword.toLowerCase();

                rows.forEach(row => {
                    const cellText = row.children[columnIndex].innerText.toLowerCase();
                    row.style.display = cellText.includes(keyword) ? "" : "none";
                });
            }
            // ===== Advanced filter bar =====
            ["filterName", "filterAddress", "filterInsurance", "filterPhone"].forEach(id => {
                document.getElementById(id)?.addEventListener("input", advancedFilter);
            });

            function advancedFilter() {
                const name = document.getElementById("filterName").value.toLowerCase();
                const address = document.getElementById("filterAddress").value.toLowerCase();
                const insurance = document.getElementById("filterInsurance").value.toLowerCase();
                const phone = document.getElementById("filterPhone").value.toLowerCase();

                document.querySelectorAll("#patientTable tbody tr").forEach(row => {
                    const rowData = {
                        name: row.children[1]?.innerText.toLowerCase(),
                        address: row.children[3]?.innerText.toLowerCase(),
                        insurance: row.children[4]?.innerText.toLowerCase(),
                        phone: row.children[6]?.innerText.toLowerCase()
                    };
                    const visible =
                            (!name || rowData.name.includes(name)) &&
                            (!address || rowData.address.includes(address)) &&
                            (!insurance || rowData.insurance.includes(insurance)) &&
                            (!phone || rowData.phone.includes(phone));
                    row.style.display = visible ? "" : "none";
                });
            }
        </script>
    </body>
</html>
