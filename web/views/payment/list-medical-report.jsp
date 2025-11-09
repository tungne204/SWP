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
                          class="payment-form"
                          data-record-id="${mr.recordId}"
                          onsubmit="return validatePaymentForm(this)"
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

                          <div class="flex flex-col gap-2 min-w-[280px]">
                            <!-- Amount Input -->
                            <div class="flex gap-2 items-center flex-wrap">
                              <input
                                type="number"
                                id="original-amount-${mr.recordId}"
                                class="original-amount-input border rounded px-2 py-1 text-sm w-32"
                                data-record-id="${mr.recordId}"
                                min="1000"
                                step="1000"
                                placeholder="Số tiền gốc"
                                required
                              />
                              
                              <!-- Discount Code Selection -->
                              <div class="flex items-center gap-1 flex-1 min-w-[150px]">
                                <select
                                  id="discount-select-${mr.recordId}"
                                  class="discount-select border rounded px-2 py-1 text-sm w-full"
                                  data-record-id="${mr.recordId}"
                                >
                                  <option value="" data-percentage="0" data-discount-id="">Không giảm giá</option>
                                  <c:forEach var="discount" items="${activeDiscounts}">
                                    <option 
                                      value="${discount.code}" 
                                      data-percentage="${discount.percentage.doubleValue()}" 
                                      data-discount-id="${discount.discountId}"
                                    >
                                      ${discount.code} (${discount.percentage}%)
                                    </option>
                                  </c:forEach>
                                </select>
                              </div>
                            </div>
                            
                            <!-- Display Final Amount -->
                            <div class="text-xs text-gray-600 bg-gray-50 p-2 rounded border final-amount-display-${mr.recordId}" style="display: none;">
                              <div class="flex justify-between items-center gap-2 mb-1">
                                <span>Tiền gốc:</span>
                                <span id="display-original-${mr.recordId}" class="font-medium"></span>
                              </div>
                              <div class="flex justify-between items-center gap-2 mb-1">
                                <span>Giảm giá:</span>
                                <span id="display-discount-${mr.recordId}" class="font-medium text-red-600"></span>
                              </div>
                              <div class="flex justify-between items-center gap-2 border-t border-gray-300 pt-1 mt-1">
                                <span class="font-semibold">Thành tiền:</span>
                                <span id="display-final-${mr.recordId}" class="font-bold text-green-600 text-base"></span>
                              </div>
                            </div>
                            
                            <!-- Hidden inputs for form submission -->
                            <input
                              type="hidden"
                              id="amount-${mr.recordId}"
                              name="amount"
                            />
                            <input
                              type="hidden"
                              id="discount-id-${mr.recordId}"
                              name="discountId"
                              value=""
                            />

                            <button
                              type="submit"
                              class="bg-green-500 hover:bg-green-600 text-white text-sm font-semibold px-3 py-1 rounded w-full mt-1"
                            >
                              Thu tiền (VNPay)
                            </button>
                          </div>
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

    <script>
      // Format số tiền VNĐ
      function formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {
          style: 'currency',
          currency: 'VND'
        }).format(amount);
      }

      // Tính toán số tiền cuối cùng sau khi áp dụng discount
      function calculateFinalAmount(recordId) {
        const originalAmountInput = document.getElementById('original-amount-' + recordId);
        const discountSelect = document.getElementById('discount-select-' + recordId);
        const amountInput = document.getElementById('amount-' + recordId); // Hidden input for form submission
        const discountIdInput = document.getElementById('discount-id-' + recordId); // Hidden input for discount ID
        const displayDiv = document.querySelector('.final-amount-display-' + recordId);
        const displayOriginalSpan = document.getElementById('display-original-' + recordId);
        const displayDiscountSpan = document.getElementById('display-discount-' + recordId);
        const displayFinalSpan = document.getElementById('display-final-' + recordId);

        if (!originalAmountInput || !discountSelect || !amountInput) {
          return;
        }

        const originalAmount = parseFloat(originalAmountInput.value) || 0;
        const selectedOption = discountSelect.options[discountSelect.selectedIndex];
        const discountPercent = parseFloat(selectedOption.getAttribute('data-percentage')) || 0;
        const discountId = selectedOption.getAttribute('data-discount-id') || '';
        const discountCode = selectedOption.value || '';

        if (originalAmount > 0) {
          // Tính toán
          const discountAmount = (originalAmount * discountPercent) / 100;
          const finalAmount = Math.max(0, originalAmount - discountAmount);

          // Hiển thị kết quả
          if (displayOriginalSpan) {
            displayOriginalSpan.textContent = formatCurrency(originalAmount);
          }
          if (displayDiscountSpan) {
            if (discountPercent > 0 && discountCode) {
              displayDiscountSpan.textContent = '-' + formatCurrency(discountAmount) + ' (' + discountCode + ': ' + discountPercent.toFixed(1) + '%)';
            } else {
              displayDiscountSpan.textContent = formatCurrency(0);
            }
          }
          if (displayFinalSpan) {
            displayFinalSpan.textContent = formatCurrency(finalAmount);
          }
          if (displayDiv) {
            displayDiv.style.display = 'block';
          }

          // Cập nhật giá trị trong hidden inputs
          amountInput.value = Math.floor(finalAmount);
          discountIdInput.value = discountId;
        } else {
          if (displayDiv) {
            displayDiv.style.display = 'none';
          }
          amountInput.value = '';
          discountIdInput.value = '';
        }
      }

      // Validate form trước khi submit
      function validatePaymentForm(form) {
        const recordId = form.getAttribute('data-record-id');
        const originalAmountInput = document.getElementById('original-amount-' + recordId);
        const discountSelect = document.getElementById('discount-select-' + recordId);
        const amountInput = document.getElementById('amount-' + recordId);
        const discountIdInput = document.getElementById('discount-id-' + recordId);

        if (!originalAmountInput || !discountSelect || !amountInput) {
          alert('Có lỗi xảy ra khi xử lý form');
          return false;
        }

        const originalAmount = parseFloat(originalAmountInput.value) || 0;
        const selectedOption = discountSelect.options[discountSelect.selectedIndex];
        const discountPercent = parseFloat(selectedOption.getAttribute('data-percentage')) || 0;
        const discountId = selectedOption.getAttribute('data-discount-id') || '';

        // Validate số tiền gốc
        if (originalAmount < 1000) {
          alert('Số tiền gốc phải lớn hơn hoặc bằng 1,000 VND');
          originalAmountInput.focus();
          return false;
        }

        // Tính toán số tiền cuối cùng
        const discountAmount = (originalAmount * discountPercent) / 100;
        const finalAmount = Math.max(0, originalAmount - discountAmount);

        // Validate số tiền sau giảm giá
        if (finalAmount < 1000) {
          alert('Số tiền sau giảm giá (' + formatCurrency(finalAmount) + ') phải lớn hơn hoặc bằng 1,000 VND. Vui lòng chọn mã giảm giá khác hoặc bỏ chọn giảm giá.');
          discountSelect.focus();
          return false;
        }

        // Cập nhật giá trị cuối cùng vào hidden inputs
        amountInput.value = Math.floor(finalAmount);
        discountIdInput.value = discountId;

        return true;
      }

      // Gắn event listeners khi trang load
      document.addEventListener('DOMContentLoaded', function() {
        // Gắn event listener cho tất cả các input số tiền gốc
        document.querySelectorAll('.original-amount-input').forEach(function(input) {
          const recordId = input.getAttribute('data-record-id');
          input.addEventListener('input', function() {
            calculateFinalAmount(recordId);
          });
        });

        // Gắn event listener cho tất cả các select discount
        document.querySelectorAll('.discount-select').forEach(function(select) {
          const recordId = select.getAttribute('data-record-id');
          select.addEventListener('change', function() {
            calculateFinalAmount(recordId);
          });
        });
      });
    </script>

    <!-- Footer -->
    <%@ include file="/includes/footer.jsp" %>
  </body>
</html>
