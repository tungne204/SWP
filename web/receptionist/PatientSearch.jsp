<%-- 
    Document   : Search Patient
    Created on : Oct 8, 2025, 5:37:36 PM
    Author     : KiênPC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Search Patient</title>
        <!-- Tailwind CSS CDN -->
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="bg-gray-50 min-h-screen text-gray-800">
        <div class="max-w-5xl mx-auto px-4 py-8">

            <h2 class="text-2xl font-bold mb-4 text-indigo-700">
                🔍 Patient Search
            </h2>

            <!-- Thông báo lỗi hệ thống -->
            <c:if test="${not empty error}">
                <div class="mb-4 p-3 bg-red-100 text-red-700 rounded-lg border border-red-300">
                    ⚠️ ${error}
                </div>
            </c:if>

            <!-- ✅ Thông báo khi chưa nhập gì -->
            <c:if test="${not empty warning}">
                <div class="mb-4 p-3 bg-yellow-100 text-yellow-700 rounded-lg border border-yellow-300">
                    ${warning}
                </div>
            </c:if>

            <!-- Form tìm kiếm -->
            <form id="searchForm" action="Patient-Search" method="post" class="flex flex-col sm:flex-row gap-3 mb-6">
                <input
                    type="text"
                    name="keyword"
                    placeholder="Enter patient name or ID..."
                    value="${keyword}"
                    class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500"
                    >
                <button
                    type="submit"
                    class="bg-indigo-600 text-white px-6 py-2 rounded-lg hover:bg-indigo-700 transition"
                    >
                    Search
                </button>
                <!-- ✅ Nút View All --> <a href="Patient-Search" class="bg-green-600 text-white px-6 py-2 rounded-lg hover:bg-green-700 transition text-center">
                    View All </a>
            </form>

            <!-- Bảng kết quả -->
            <c:if test="${not empty patients}">
                <div class="overflow-x-auto shadow-sm border border-gray-200 rounded-xl bg-white">
                    <table class="min-w-full text-sm text-left">
                        <thead class="bg-gray-100 text-gray-700">
                            <tr>
                                <th class="px-5 py-3">ID</th>
                                <th class="px-5 py-3">Họ và Tên</th>
                                <th class="px-5 py-3">Địa chỉ</th>
                                <th class="px-5 py-3">Bảo hiểm</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${patients}">
                                <tr class="border-t hover:bg-gray-50">
                                    <td class="px-5 py-3 font-semibold">${p.patientId}</td>
                                    <td class="px-5 py-3">${p.fullName}</td>
                                    <td class="px-5 py-3">${p.address}</td>
                                    <td class="px-5 py-3">${p.insuranceInfo}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <p class="mt-4 text-sm text-gray-500">
                    Tìm thấy <strong>${fn:length(patients)}</strong> kết quả
                    <c:if test="${not empty keyword}"> cho từ khóa "<em>${keyword}</em>"</c:if>.
                    </p>
            </c:if>

            <!-- Khi chưa nhập từ khóa -->
            <c:if test="${empty keyword}">
                <div class="mt-6 text-gray-500 text-center">
                    🩺 Enter patient information to start searching.
                </div>
            </c:if>

            <!-- Khi đã nhập mà không tìm thấy -->
            <c:if test="${not empty keyword and empty patients}">
                <div class="mt-6 text-gray-500 text-center">
                    ❌ No patient found for keyword "<strong>${keyword}</strong>".
                </div>
            </c:if>
            <br>
            <!-- Nút quay lại Receptionist Dashboard -->
            <a href="Receptionist-Dashboard"
               class="bg-gray-200 text-gray-800 px-4 py-2 rounded-lg hover:bg-gray-300 transition font-medium shadow-sm">
                ⬅ Back to Dashboard
            </a>
        </div>

        <!-- ✅ Kiểm tra không nhập gì (Frontend) -->
        <script>
            const form = document.getElementById("searchForm");
            const input = form.querySelector("input[name='keyword']");

            form.addEventListener("submit", (e) => {
                if (input.value.trim() === "") {
                    e.preventDefault();
                    alert("⚠️ Please enter patient name or ID before searching!");
                    input.focus();
                }
            });
        </script>
    </body>
</html>
