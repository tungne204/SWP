<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh Sách Bệnh Nhân</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Include all CSS files -->
        <jsp:include page="../includes/head-includes.jsp" />

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
                <main class="w-[95%] mx-auto px-8 pt-0 pb-10 flex-grow">
                    <h2 class="text-3xl font-bold mb-6 text-blue-700 text-center">
                        Danh Sách Bệnh Nhân
                    </h2>

                    <!-- Error -->
                    <c:if test="${not empty error}">
                        <div class="mb-4 p-3 bg-red-100 text-red-700 rounded-lg border border-red-300 text-center">
                            ${error}
                        </div>
                    </c:if>

                    <!-- Warning -->
                    <c:if test="${not empty warning}">
                        <div id="warningBox"
                             class="mb-4 p-3 bg-yellow-100 text-yellow-700 rounded-lg border border-yellow-300 text-center">
                            ${warning}
                        </div>
                    </c:if>

                    <!-- Search Form -->
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
                        <button type="button" onclick="window.location.href = 'Patient-Search'"
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
                    <div class="flex flex-wrap gap-3 mb-6 bg-blue-100 border border-blue-200 p-4 rounded-lg shadow-sm">
                        <input type="text" id="filterName" placeholder="Lọc theo tên"
                               class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                        <input type="text" id="filterAddress" placeholder="Lọc theo địa chỉ"
                               class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                        <input type="text" id="filterInsurance" placeholder="Lọc theo bệnh nền"
                               class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                        <input type="text" id="filterPhone" placeholder="Lọc theo SĐT"
                               class="flex-1 px-4 py-2 border rounded-md focus:ring-2 focus:ring-blue-500" />
                    </div>

                    <!-- Table Result -->
                    <c:if test="${not empty patients}">
                        <div class="overflow-x-auto shadow border border-gray-200 rounded-xl bg-white w-full mx-auto">
                            <table id="patientTable" class="min-w-full w-full text-base text-left table-fixed">
                                <thead class="bg-gray-100 text-gray-700 text-sm uppercase">
                                    <tr>
                                        <th class="px-4 py-4 w-[6%]">Mã</th>
                                        <th class="px-4 py-4 w-[14%] sortable" onclick="sortTable(1)">Họ Tên</th>
                                        <th class="px-4 py-4 w-[12%]">Ngày sinh</th>
                                        <th class="px-4 py-4 w-[18%] sortable" onclick="sortTable(3)">Địa chỉ</th>
                                        <th class="px-4 py-4 w-[10%] sortable" onclick="sortTable(4)">Bệnh nền</th>
                                        <th class="px-4 py-4 w-[20%]">Email</th>
                                        <th class="px-4 py-4 w-[10%] sortable" onclick="sortTable(6)">SĐT</th>
                                        <th class="px-4 py-4 w-[10%] text-center">Chi tiết</th>
                                    </tr>
                                    <!-- Filter Row -->
                                    <tr class="bg-gray-50 text-gray-600 text-sm">
                                        <td></td>
                                        <td><input type="text" onkeyup="filterTable(1, this.value)" class="w-full px-2 py-1 border rounded" placeholder="Lọc tên..." /></td>
                                        <td></td>
                                        <td><input type="text" onkeyup="filterTable(3, this.value)" class="w-full px-2 py-1 border rounded" placeholder="Lọc địa chỉ..." /></td>
                                        <td><input type="text" onkeyup="filterTable(4, this.value)" class="w-full px-2 py-1 border rounded" placeholder="Lọc bệnh nền..." /></td>
                                        <td></td>
                                        <td><input type="text" onkeyup="filterTable(6, this.value)" class="w-full px-2 py-1 border rounded" placeholder="Lọc SĐT..." /></td>
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
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <a href="Patient-Search?page=${i}&keyword=${keyword}"
                                                   class="px-3 py-1 rounded bg-blue-600 text-white">${i}</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="Patient-Search?page=${i}&keyword=${keyword}"
                                                   class="px-3 py-1 rounded bg-gray-200 hover:bg-gray-300">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
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

                    <!-- Không có dữ liệu -->
                    <c:if test="${empty patients}">
                        <div class="mt-10 text-gray-500 text-center text-lg">
                            Vui lòng nhập bệnh nhân cần tìm
                        </div>
                    </c:if>
                </main>

                <!-- Export libraries -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

                <!-- Scripts của em (sort, filter, export) để nguyên -->
                <!-- ... giữ nguyên đoạn script cũ của em ở đây ... -->
            </div>
        </div>

        <!-- Footer -->
        <%@ include file="../includes/footer.jsp" %>
    </body>
</html>
