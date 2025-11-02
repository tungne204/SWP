<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách lịch hẹn - Medilab</title>
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
            .table-cell-truncate {
                max-width: 200px;           /* Giới hạn chiều rộng mỗi ô */
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
                cursor: pointer;
            }

            .table-cell-expanded {
                white-space: normal;
                word-break: break-word;
            }


        </style>
    </head>

    <body class="bg-gray-50">
        <!-- Header -->
        <jsp:include page="../includes/header.jsp" />

        <div class="p-6 max-w-6xl mx-auto">
            <!-- Sidebar -->
            <%@ include file="../includes/sidebar-receptionist.jsp" %>

            <h1 class="text-2xl font-bold text-teal-600 mb-4">Danh sách lịch hẹn</h1>

            <!--  Nếu là Patient thì có nút tạo mới -->
            <c:if test="${sessionScope.role eq 'Patient'}">
                <div class="mb-4">
                    <a href="Appointment-Create"
                       class="bg-orange-500 text-white px-4 py-2 rounded-md hover:bg-orange-600 transition">
                        ➕ Tạo lịch hẹn mới
                    </a>
                </div>
            </c:if>

            <!-- Search & Filter -->
            <form method="get" action="Appointment-List" class="flex gap-3 mb-4">
                <input type="text" name="keyword" placeholder="Tìm theo tên bệnh nhân, bác sĩ, địa chỉ,..."
                       value="${keyword}" class="border p-2 flex-1 rounded-md">
                <select name="status" class="border p-2 rounded-md">
                    <option value="all">Tất cả</option>
                    <option value="confirmed" ${status == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                    <option value="pending" ${status == 'pending' ? 'selected' : ''}>Chờ</option>
                    <option value="cancelled" ${status == 'cancelled' ? 'selected' : ''}>Huỷ</option>

                </select>
                <select name="sort" class="border p-2 rounded-md">
                    <option value="date_desc" ${sort == 'date_desc' ? 'selected' : ''}>Mới nhất</option>
                    <option value="date_asc" ${sort == 'date_asc' ? 'selected' : ''}>Cũ nhất</option>
                    <option value="today" ${sort == 'today' ? 'selected' : ''}>Hôm nay</option>
                </select>

                <button type="submit" class="bg-teal-600 text-white px-4 py-2 rounded-md">Lọc</button>

                <button type="button"
                        onclick="window.location.href = 'Appointment-List'"
                        class="bg-gray-500 text-white px-4 py-2 rounded-md hover:bg-gray-600">
                    🔄 Reload
                </button>

            </form>

            <!-- Table -->
            <div class="overflow-x-auto bg-white border rounded-lg shadow">
                <table class="min-w-full w-full text-sm">
                    <thead class="bg-gray-100 text-gray-600">
                        <tr>
                            <th class="p-3 text-left">ID</th>
                            <th class="p-3 text-left">Bệnh nhân</th>
                            <th class="p-3 text-left">Địa chỉ</th>
                            <th class="p-3 text-left">Bệnh nền</th>
                            <th class="p-3 text-left">Bác sĩ</th>
                            <th class="p-3 text-left">Chuyên khoa</th>
                            <th class="p-3 text-left">Ngày khám</th>
                            <th class="p-3 text-left">Trạng thái</th>
                            <th class="p-3 text-center">Thao tác</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="a" items="${list}">
                            <tr class="border-t hover:bg-gray-50">
                                <td class="p-3">${a.appointmentId}</td>
                                <td class="p-3">${a.patientName}</td>
                                <td class="p-3 table-cell-truncate" title="${a.patientAddress}">${a.patientAddress}</td> <!--chống tràn chữ-->
                                <td class="p-3 table-cell-truncate" title="${a.patientInsurance}">${a.patientInsurance}</td>
                                <td class="p-3">${a.doctorName}</td>
                                <td class="p-3">${a.doctorSpecialty}</td>
                                <td class="p-3"><fmt:formatDate value="${a.dateTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td class="p-3">
                                    <span class="px-2 py-1 rounded-full text-white
                                          ${a.status == 'Confirmed' ? 'bg-green-500' :
                                            (a.status == 'Pending' ? 'bg-yellow-500' :
                                            (a.status == 'Cancelled' ? 'bg-red-500' : 'bg-gray-400'))}">
                                              ${a.status}
                                          </span>
                                    </td>
                                    <td class="p-3 text-center">
                                        <!--Receptionist-->
                                        <c:if test="${sessionScope.role eq 'Receptionist'}">
                                            <a href="Appointment-Update?id=${a.appointmentId}"
                                               class="text-blue-500 hover:underline mr-2">Cập nhật</a>
                                            <form method="post" action="Appointment-Status" class="inline">
                                                <input type="hidden" name="id" value="${a.appointmentId}">

                                                <select name="status" class="border rounded-md p-1 text-sm focus:ring-2 focus:ring-teal-500 focus:outline-none">
                                                    <option value="Pending" ${a.status == 'Pending' ? 'selected' : ''}>Chờ xác nhận</option>
                                                    <option value="Confirmed" ${a.status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                                    <option value="Cancelled" ${a.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                                                    <option value="Completed" ${a.status == 'Completed' ? 'selected' : ''}>Đã khám</option>
                                                </select>

                                                <button type="submit" class="ml-2 bg-teal-600 text-white px-3 py-1 rounded-md hover:bg-teal-700 transition">
                                                    Lưu
                                                </button>
                                            </form>
                                        </c:if>
                                        <!-- Doctor chỉ được đổi trạng thái thành "Đã khám" -->
                                        <c:if test="${sessionScope.role eq 'Doctor'}">
                                            <form method="post" action="Appointment-Status" class="inline">
                                                <input type="hidden" name="id" value="${a.appointmentId}">
                                                <input type="hidden" name="status" value="Completed">

                                                <button type="submit" 
                                                        class="bg-orange-500 text-white px-3 py-1 rounded-md hover:bg-orange-600 transition">
                                                    ✅ Đánh dấu đã khám
                                                </button>
                                            </form>
                                        </c:if>
                                        <!--Patient -->
                                        <c:if test="${sessionScope.role eq 'Patient'}">
                                            <a href="Appointment-Detail?id=${a.appointmentId}"
                                               class="text-blue-600 hover:underline mr-2">👁 Xem</a>

                                            <c:if test="${a.status eq 'Pending'}">
                                                <a href="Appointment-Update?id=${a.appointmentId}"
                                                   class="text-green-600 hover:underline mr-2">📝 Sửa</a>
                                                <form method="post" action="Appointment-Status" class="inline">
                                                    <input type="hidden" name="id" value="${a.appointmentId}">
                                                    <input type="hidden" name="status" value="Cancelled">
                                                    <button type="submit"
                                                            class="bg-red-500 text-white px-3 py-1 rounded-md hover:bg-red-600 transition">
                                                        ❌ Hủy
                                                    </button>
                                                </form>
                                            </c:if>
                                        </c:if>

                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>

                    </table>
                </div>
                <!-- Paging -->
                <div class="flex justify-center mt-4 gap-2">
                    <c:forEach var="i" begin="1" end="5">
                        <a href="Appointment-List?page=${i}"
                           class="px-3 py-1 border rounded ${i==page ? 'bg-teal-600 text-white' : 'bg-white'}">${i}</a>
                    </c:forEach>
                </div>
            </div>
            <!-- Footer -->
            <%@ include file="../includes/footer.jsp" %>
            <script>
                document.addEventListener('DOMContentLoaded', () => {
                    document.querySelectorAll('.table-cell-truncate').forEach(cell => {
                        const fullText = cell.textContent.trim();
                        const limit = 30; // giới hạn số ký tự hiển thị ban đầu
                        if (fullText.length > limit) {
                            const shortText = fullText.substring(0, limit) + '...';
                            cell.textContent = shortText;
                            cell.dataset.full = fullText;
                            cell.dataset.short = shortText;
                            cell.dataset.expanded = "false";
                        }

                        cell.addEventListener('click', () => {
                            const expanded = cell.dataset.expanded === "true";
                            cell.textContent = expanded ? cell.dataset.short : cell.dataset.full;
                            cell.dataset.expanded = expanded ? "false" : "true";
                            cell.classList.toggle('table-cell-expanded', !expanded);
                        });
                    });
                });
            </script>

        </body>
    </html>
