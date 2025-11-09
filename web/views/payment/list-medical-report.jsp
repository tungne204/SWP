<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
language="java" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Thanh toán hồ sơ</title>

    <!-- Tailwind -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- CSS chung của project -->
    <jsp:include page="/includes/head-includes.jsp" />

    <style>
      :root {
        --primary-color: #3fbbc0;
        --primary-dark: #2a9fa4;
        --secondary-color: #2c4964;
      }

      body {
        background-color: #f1f7fc;
        min-height: 100vh;
        font-family: var(--default-font, "Roboto", sans-serif);
      }

      /* Đảm bảo header được fixed ở trên cùng */
      #header {
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        right: 0 !important;
        width: 100% !important;
        z-index: 1050 !important;
      }

      .main-wrapper {
        display: flex;
        min-height: 100vh;
        padding-top: 80px; /* height header */
      }

      .sidebar-fixed {
        width: 280px;
        background: #ffffff;
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        position: fixed;
        top: 80px;
        left: 0;
        height: calc(100vh - 80px);
        overflow-y: auto;
        z-index: 1000;
      }

      .content-area {
        flex: 1;
        margin-left: 280px; /* = width sidebar */
        padding: 2rem;
      }
    </style>
  </head>
  <body>
    <!-- Header -->
    <jsp:include page="/includes/header.jsp" />

    <div class="main-wrapper">
      <!-- Sidebar Receptionist -->
      <%@ include file="/includes/sidebar-receptionist.jsp" %>

      <!-- MAIN CONTENT -->
      <div class="content-area">
        <h1 class="text-3xl font-bold mb-2 text-blue-700">
          Thanh toán hồ sơ khám bệnh
        </h1>

        <p class="mb-6 text-gray-600">
          Danh sách Medical Report và trạng thái thanh toán.
        </p>

        <!-- Search and Filter Section -->
        <div class="bg-white shadow border border-gray-200 rounded-lg p-4 mb-4">
          <form method="get" action="${pageContext.request.contextPath}/reception/medical-reports" class="flex flex-wrap gap-4 items-end">
            <!-- Search Input -->
            <div class="flex-1 min-w-[200px]">
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Tìm kiếm
              </label>
              <input
                type="text"
                name="search"
                value="${searchKeyword}"
                placeholder="Tên bệnh nhân, Record ID, Chẩn đoán..."
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            <!-- Status Filter -->
            <div class="min-w-[150px]">
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Trạng thái thanh toán
              </label>
              <select
                name="status"
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="all" ${paymentStatus == 'all' ? 'selected' : ''}>Tất cả</option>
                <option value="paid" ${paymentStatus == 'paid' ? 'selected' : ''}>Đã thanh toán</option>
                <option value="unpaid" ${paymentStatus == 'unpaid' ? 'selected' : ''}>Chưa thanh toán</option>
              </select>
            </div>

            <!-- Page Size -->
            <div class="min-w-[120px]">
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Số bản ghi/trang
              </label>
              <select
                name="pageSize"
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
              </select>
            </div>

            <!-- Buttons -->
            <div class="flex gap-2">
              <button
                type="submit"
                class="bg-blue-500 hover:bg-blue-600 text-white font-semibold px-4 py-2 rounded-md transition"
              >
                <i class="fas fa-search me-2"></i>Tìm kiếm
              </button>
              <a
                href="${pageContext.request.contextPath}/reception/medical-reports"
                class="bg-gray-500 hover:bg-gray-600 text-white font-semibold px-4 py-2 rounded-md transition inline-block"
              >
                <i class="fas fa-redo me-2"></i>Reset
              </a>
            </div>
          </form>
        </div>

        <!-- Results Info -->
        <div class="mb-4 text-sm text-gray-600">
          Hiển thị <strong>${totalCount}</strong> kết quả
          <c:if test="${not empty searchKeyword}">
            cho từ khóa "<strong>${searchKeyword}</strong>"
          </c:if>
        </div>

        <div
          class="overflow-x-auto bg-white shadow border border-gray-200 rounded-lg"
        >
          <table class="min-w-full text-sm text-left">
            <thead class="bg-gray-100 text-gray-700">
              <tr>
                <th class="px-4 py-3">Record ID</th>
                <th class="px-4 py-3">Tên bệnh nhân</th>
                <th class="px-4 py-3">Đơn thuốc</th>
                <th class="px-4 py-3">Chẩn đoán</th>
                <th class="px-4 py-3">Thanh toán</th>
                <th class="px-4 py-3">Trạng thái</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <c:forEach var="mr" items="${medicalReports}">
                <tr class="hover:bg-blue-50">
                  <td class="px-4 py-3">${mr.recordId}</td>
                  <td class="px-4 py-3 font-semibold text-gray-800">
                    ${mr.patientName}
                  </td>
                  <td class="px-4 py-3">
                    <c:choose>
                      <c:when test="${not empty mr.prescription}">
                        <div class="max-w-md">
                          <p class="text-sm text-gray-700 line-clamp-2">
                            ${mr.prescription}
                          </p>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <span class="text-gray-400 italic text-sm"
                          >Chưa có đơn thuốc</span
                        >
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td class="px-4 py-3">${mr.diagnosis}</td>

                  <td class="px-4 py-3">
                    <c:choose>
                      <c:when test="${!mr.paid}">
                        <form
                          action="${pageContext.request.contextPath}/reception/payment/create"
                          method="post"
                          class="flex gap-2 items-center"
                        >
                          <input
                            type="hidden"
                            name="recordId"
                            value="${mr.recordId}"
                          />
                          <input
                            type="hidden"
                            name="appointmentId"
                            value="${mr.appointmentId}"
                          />

                          <input
                            type="number"
                            name="amount"
                            min="1000"
                            step="1000"
                            required
                            placeholder="Nhập số tiền (VND)"
                            class="border rounded px-2 py-1 text-sm w-40"
                          />

                          <button
                            type="submit"
                            class="bg-green-500 hover:bg-green-600 text-white text-sm font-semibold px-3 py-1 rounded"
                          >
                            Thu tiền (VNPay)
                          </button>
                        </form>
                      </c:when>
                      <c:otherwise>
                        <span class="text-gray-400 text-sm italic">
                          Đã thanh toán
                        </span>
                      </c:otherwise>
                    </c:choose>
                  </td>

                  <td class="px-4 py-3 font-semibold">
                    <c:choose>
                      <c:when test="${mr.paid}">
                        <span class="text-green-600">ĐÃ THANH TOÁN</span>
                      </c:when>
                      <c:otherwise>
                        <span class="text-red-600">CHƯA THANH TOÁN</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
          <div class="mt-4 flex justify-center items-center gap-2">
            <!-- Previous Button -->
            <c:if test="${currentPage > 1}">
              <c:url var="prevUrl" value="/reception/medical-reports">
                <c:param name="page" value="${currentPage - 1}"/>
                <c:param name="pageSize" value="${pageSize}"/>
                <c:if test="${not empty searchKeyword}">
                  <c:param name="search" value="${searchKeyword}"/>
                </c:if>
                <c:if test="${paymentStatus != 'all'}">
                  <c:param name="status" value="${paymentStatus}"/>
                </c:if>
              </c:url>
              <a
                href="${prevUrl}"
                class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition"
              >
                <i class="fas fa-chevron-left"></i> Trước
              </a>
            </c:if>
            <c:if test="${currentPage == 1}">
              <span class="px-4 py-2 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed">
                <i class="fas fa-chevron-left"></i> Trước
              </span>
            </c:if>

            <!-- Page Numbers -->
            <c:forEach var="i" begin="1" end="${totalPages}">
              <c:choose>
                <c:when test="${i == currentPage}">
                  <span class="px-4 py-2 bg-blue-600 text-white rounded-md font-semibold">
                    ${i}
                  </span>
                </c:when>
                <c:when test="${i <= 3 || i > totalPages - 3 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                  <c:url var="pageUrl" value="/reception/medical-reports">
                    <c:param name="page" value="${i}"/>
                    <c:param name="pageSize" value="${pageSize}"/>
                    <c:if test="${not empty searchKeyword}">
                      <c:param name="search" value="${searchKeyword}"/>
                    </c:if>
                    <c:if test="${paymentStatus != 'all'}">
                      <c:param name="status" value="${paymentStatus}"/>
                    </c:if>
                  </c:url>
                  <a
                    href="${pageUrl}"
                    class="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-md hover:bg-gray-100 transition"
                  >
                    ${i}
                  </a>
                </c:when>
                <c:when test="${i == 4 && currentPage > 5}">
                  <span class="px-2 text-gray-500">...</span>
                </c:when>
                <c:when test="${i == totalPages - 3 && currentPage < totalPages - 4}">
                  <span class="px-2 text-gray-500">...</span>
                </c:when>
              </c:choose>
            </c:forEach>

            <!-- Next Button -->
            <c:if test="${currentPage < totalPages}">
              <c:url var="nextUrl" value="/reception/medical-reports">
                <c:param name="page" value="${currentPage + 1}"/>
                <c:param name="pageSize" value="${pageSize}"/>
                <c:if test="${not empty searchKeyword}">
                  <c:param name="search" value="${searchKeyword}"/>
                </c:if>
                <c:if test="${paymentStatus != 'all'}">
                  <c:param name="status" value="${paymentStatus}"/>
                </c:if>
              </c:url>
              <a
                href="${nextUrl}"
                class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition"
              >
                Sau <i class="fas fa-chevron-right"></i>
              </a>
            </c:if>
            <c:if test="${currentPage >= totalPages}">
              <span class="px-4 py-2 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed">
                Sau <i class="fas fa-chevron-right"></i>
              </span>
            </c:if>
          </div>

          <!-- Page Info -->
          <div class="mt-2 text-center text-sm text-gray-600">
            Trang ${currentPage} / ${totalPages}
          </div>
        </c:if>

        <!-- Empty State -->
        <c:if test="${empty medicalReports}">
          <div class="bg-white shadow border border-gray-200 rounded-lg p-8 text-center">
            <i class="fas fa-inbox text-4xl text-gray-400 mb-4"></i>
            <p class="text-gray-600 text-lg">Không tìm thấy kết quả nào</p>
            <c:if test="${not empty searchKeyword}">
              <p class="text-gray-500 text-sm mt-2">
                Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc
              </p>
            </c:if>
          </div>
        </c:if>
      </div>
    </div>
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
      crossorigin="anonymous"
    ></script>

    <!-- Footer -->
    <%@ include file="/includes/footer.jsp" %>
  </body>
</html>
