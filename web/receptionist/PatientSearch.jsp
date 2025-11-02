<%-- 
Document : PatientSearch 
Created on : Oct 8, 2025, 5:37:36 PM 
Author : KienPC 
--%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Bệnh Nhân</title>
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Include all CSS files -->
        <jsp:include page="../includes/head-includes.jsp" />

        <!-- Sort icons + hover style -->
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

            /* Prevent text from overflowing into other columns */
            #patientTable {
                table-layout: fixed;
                width: 100%;
            }

            #patientTable th,
            #patientTable td {
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="../includes/header.jsp" />


        <div class="main-wrapper">
            <!-- Sidebar -->
            <%@ include file="../includes/sidebar-receptionist.jsp" %>

            <!-- Main Content -->
            <div class="content-area">

                <!-- Main Content -->
                <main class="w-[95%] mx-auto px-8 pt-0 pb-10 flex-grow">
                    <h2 class="text-3xl font-bold mb-6 text-blue-700 text-center">
                        Danh Sách Bệnh Nhân
                    </h2>

                    <!-- ️ Error -->
                    <c:if test="${not empty error}">
                        <div
                            class="mb-4 p-3 bg-red-100 text-red-700 rounded-lg border border-red-300 text-center">
                            ️ ${error}
                        </div>
                    </c:if>

                    <!--️ Warning -->
                    <c:if test="${not empty warning}">
                        <div id="warningBox"
                             class="mb-4 p-3 bg-yellow-100 text-yellow-700 rounded-lg border border-yellow-300 text-center">
                            ${warning}
                        </div>
                    </c:if>

                    <!--Search Form -->
                    <form id="searchForm" action="Patient-Search" method="post"
                          class="flex flex-col sm:flex-row gap-3 mb-10 justify-center max-w-3xl mx-auto w-full">
                        <input type="text" name="keyword" placeholder="Nhập tên hoặc mã Bệnh Nhân..."
                               value="${keyword}"
                               class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 text-lg">
                        <button type="submit"
                                class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition font-semibold text-lg">
                            Tìm kiếm
                        </button>
                    </form>

                    <!-- Action buttons -->
                    <div class="flex justify-end mb-6 gap-3">
                        <button type="button" onclick="window.location.reload()"
                                class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-semibold px-4 py-2 rounded-md">
                            🔄 Làm mới
                        </button>
                        <button type="button"
                                onclick="exportTableToExcel('patientTable', 'DanhSachBenhNhan')"
                                class="bg-green-500 hover:bg-green-600 text-white font-semibold px-4 py-2 rounded-md">
                            📗 Excel
                        </button>
                        <button type="button" onclick="exportTableToPDF()"
                                class="bg-red-500 hover:bg-red-600 text-white font-semibold px-4 py-2 rounded-md">
                            📕 PDF
                        </button>
                    </div>
                    <!-- Advanced Filter -->
                    <div
                        class="flex flex-wrap gap-3 mb-6 bg-blue-100 border border-blue-200 p-4 rounded-lg shadow-sm">
                        <input type="text" id="filterName" placeholder="Lọc theo tên"
                               class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                        <input type="text" id="filterAddress" placeholder="Lọc theo địa chỉ"
                               class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                        <input type="text" id="filterInsurance" placeholder="Lọc theo bệnh nền"
                               class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                        <input type="text" id="filterPhone" placeholder="Lọc theo SĐT"
                               class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                    </div>

                    <!--  Table Result -->
                    <c:if test="${not empty patients}">
                        <div
                            class="overflow-x-auto shadow border border-gray-200 rounded-xl bg-white w-full mx-auto">
                            <table id="patientTable"
                                   class="min-w-full w-full text-base text-left table-fixed">
                                <thead class="bg-gray-100 text-gray-700 text-sm uppercase">
                                    <tr>
                                        <th class="px-4 py-4 w-[6%]">Mã Bệnh Nhân</th>
                                        <th class="px-4 py-4 w-[14%] sortable" onclick="sortTable(1)">
                                            Họ Tên<span class="sort-icon">⇅</span></th>
                                        <th class="px-4 py-4 w-[12%]">Ngày sinh</th>
                                        <th class="px-4 py-4 w-[18%] sortable" onclick="sortTable(3)">
                                            Địa chỉ <span class="sort-icon">⇅</span></th>
                                        <th class="px-4 py-4 w-[10%] sortable" onclick="sortTable(4)">
                                            Bệnh nền <span class="sort-icon">⇅</span></th>
                                        <th class="px-4 py-4 w-[20%]">Email</th>
                                        <th class="px-4 py-4 w-[10%] sortable" onclick="sortTable(6)">
                                            SĐt <span class="sort-icon">⇅</span></th>
                                        <th class="px-4 py-4 w-[10%] text-center">Chi tiết</th>
                                    </tr>

                                    <!-- Filter Row -->
                                    <tr class="bg-gray-50 text-gray-600 text-sm">
                                        <td></td>
                                        <td><input type="text" onkeyup="filterTable(1, this.value)"
                                                   placeholder="Lọc tên..."
                                                   class="w-full px-2 py-1 border rounded" /></td>
                                        <td></td>
                                        <td><input type="text" onkeyup="filterTable(3, this.value)"
                                                   placeholder="Lọc địa chỉ..."
                                                   class="w-full px-2 py-1 border rounded" /></td>
                                        <td><input type="text" onkeyup="filterTable(4, this.value)"
                                                   placeholder="Lọc bệnh nền..."
                                                   class="w-full px-2 py-1 border rounded" /></td>
                                        <td></td>
                                        <td><input type="text" onkeyup="filterTable(6, this.value)"
                                                   placeholder="Lọc SĐT..."
                                                   class="w-full px-2 py-1 border rounded" /></td>
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
                                                    👁 Xem
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <div class="flex justify-center mt-6 gap-2">
                                    <c:if test="${currentPage > 1}">
                                        <a href="Patient-Search?page=${currentPage - 1}&keyword=${keyword}"
                                           class="px-3 py-1 bg-gray-200 hover:bg-gray-300 rounded">Trước</a>
                                    </c:if>

                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <a href="Patient-Search?page=${i}&keyword=${keyword}"
                                           class="px-3 py-1 rounded
                                           ${i == currentPage ? 'bg-blue-600 text-white' : 'bg-gray-200 hover:bg-gray-300'}">
                                            ${i}
                                        </a>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="Patient-Search?page=${currentPage + 1}&keyword=${keyword}"
                                           class="px-3 py-1 bg-gray-200 hover:bg-gray-300 rounded">Tiếp</a>
                                    </c:if>
                                </div>
                            </c:if>

                        </div>

                        <p class="mt-6 text-gray-600 text-center">
                            Found <strong id="resultCount">${fn:length(patients)}</strong> result(s)
                            <c:if test="${not empty keyword}"> for keyword "<em>${keyword}</em>"</c:if>.
                            </p>
                    </c:if>

                    <!-- ️ No input yet -->
                    <c:if test="${empty keyword}">
                        <div class="mt-10 text-gray-500 text-center text-lg">
                            Vui lòng nhập bệnh nhân cần tìm
                        </div>
                    </c:if>

                    <!-- No result -->
                    <c:if test="${not empty keyword and empty patients}">
                        <div class="mt-10 text-gray-500 text-center text-lg">
                            ❌ Không có thông tin bệnh nhân "<strong>${keyword}</strong>".
                        </div>
                    </c:if>
                </main>



                <!-- Export libraries -->
                <script
                src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
                <script
                src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

                <!-- Scripts -->
                <script>
                                            // Keep visible-results counter in sync
                                            function updateResultCount() {
                                                const table = document.getElementById('patientTable');
                                                const counter = document.getElementById('resultCount');
                                                if (!table || !counter)
                                                    return;
                                                const rows = Array.from(table.querySelectorAll('tbody tr'));
                                                const visible = rows.filter(r => r.style.display !== 'none').length;
                                                counter.textContent = String(visible);
                                            }
                                            // ===== EXPORT HELPERS =====
                                            function getExportData(tableId) {
                                                const table = document.getElementById(tableId);
                                                if (!table)
                                                    return [];
                                                // Headers: strip sort icons and trim
                                                const headers = Array.from(table.querySelectorAll('thead th')).map(th => {
                                                    const clone = th.cloneNode(true);
                                                    clone.querySelectorAll('.sort-icon').forEach(el => el.remove());
                                                    return (clone.textContent || '').replace(/⇅/g, '').replace(/\s+/g, ' ').trim();
                                                });
                                                // Drop last column if it's Details or an action column
                                                if (headers.length)
                                                    headers.pop();
                                                const data = [headers];
                                                // Rows
                                                Array.from(table.querySelectorAll('tbody tr')).forEach(tr => {
                                                    const cells = Array.from(tr.children).map(td => (td.innerText || '').trim());
                                                    if (cells.length)
                                                        cells.pop();
                                                    data.push(cells);
                                                });
                                                return data;
                                            }

                                            function exportTableToExcel(tableId, filename = 'DanhSachBenhNhan') {
                                                const data = getExportData(tableId);
                                                if (!data.length)
                                                    return;
                                                const wb = XLSX.utils.book_new();
                                                const ws = XLSX.utils.aoa_to_sheet(data);
                                                const maxCols = Math.max(...data.map(r => r.length));
                                                ws['!cols'] = Array.from({length: maxCols}, () => ({wch: 22}));
                                                XLSX.utils.book_append_sheet(wb, ws, 'DanhSach');
                                                const wbout = XLSX.write(wb, {bookType: 'xlsx', type: 'array'});
                                                const blob = new Blob([wbout], {type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'});
                                                const url = URL.createObjectURL(blob);
                                                const a = document.createElement('a');
                                                a.href = url;
                                                a.download = `${filename}.xlsx`;
                                                document.body.appendChild(a);
                                                a.click();
                                                a.remove();
                                                URL.revokeObjectURL(url);
                                            }

                                            function exportTableToPDF() {
                                                const data = getExportData('patientTable');
                                                if (!data.length)
                                                    return;
                                                const container = document.createElement('div');
                                                container.style.padding = '12px';
                                                const title = document.createElement('h3');
                                                title.textContent = 'Danh sách bệnh nhân';
                                                title.style.fontFamily = 'Arial, sans-serif';
                                                title.style.margin = '0 0 12px 0';
                                                container.appendChild(title);
                                                const tbl = document.createElement('table');
                                                tbl.style.borderCollapse = 'collapse';
                                                tbl.style.width = '100%';
                                                tbl.style.fontFamily = 'Arial, sans-serif';
                                                const thead = document.createElement('thead');
                                                const hr = document.createElement('tr');
                                                data[0].forEach(h => {
                                                    const th = document.createElement('th');
                                                    th.textContent = h;
                                                    th.style.border = '1px solid #666';
                                                    th.style.padding = '6px 8px';
                                                    th.style.background = '#f1f5f9';
                                                    th.style.fontWeight = 'bold';
                                                    hr.appendChild(th);
                                                });
                                                thead.appendChild(hr);
                                                tbl.appendChild(thead);
                                                const tbody = document.createElement('tbody');
                                                for (let i = 1; i < data.length; i++) {
                                                    const tr = document.createElement('tr');
                                                    data[i].forEach(v => {
                                                        const td = document.createElement('td');
                                                        td.textContent = v;
                                                        td.style.border = '1px solid #888';
                                                        td.style.padding = '6px 8px';
                                                        tr.appendChild(td);
                                                    });
                                                    tbody.appendChild(tr);
                                                }
                                                tbl.appendChild(tbody);
                                                container.appendChild(tbl);
                                                const opt = {
                                                    margin: 0.5,
                                                    filename: 'DanhSachBenhNhan.pdf',
                                                    image: {type: 'jpeg', quality: 0.98},
                                                    html2canvas: {scale: 2},
                                                    jsPDF: {unit: 'in', format: 'a4', orientation: 'landscape'}
                                                };
                                                html2pdf().set(opt).from(container).save();
                                            }
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
                                                updateResultCount();
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
                                                updateResultCount();
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
                                                updateResultCount();
                                            }
                                            document.addEventListener('DOMContentLoaded', updateResultCount);
                </script>

            </div> <!-- End content-area -->
        </div> <!-- End main-wrapper -->

        <!-- Footer -->
        <%@ include file="../includes/footer.jsp" %>

    </body>

</html>
