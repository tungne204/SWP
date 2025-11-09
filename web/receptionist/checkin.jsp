<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
        <fmt:setLocale value="vi_VN" />
        <fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Check-in Patient - Medilab</title>

            <!-- Include all CSS files -->
            <jsp:include page="../includes/head-includes.jsp" />

            <style>
                :root {
                    --primary-color: #3fbbc0;
                    --primary-dark: #2a9fa4;
                    --secondary-color: #2c4964;
                    --accent-blue: #3b82f6;
                    --accent-blue-dark: #1d4ed8;
                    --neutral-50: #f8fafc;
                    --neutral-100: #f1f5f9;
                    --neutral-200: #e5e7eb;
                    --text-700: #374151;
                    --text-800: #1f2937;
                }

                body {
                    font-family: 'Roboto', sans-serif;
                    margin: 0;
                    padding: 0;
                    background: linear-gradient(180deg, var(--neutral-50), #ffffff);
                    color: var(--text-700);
                }

                .main-wrapper {
                    display: flex;
                    min-height: 100vh;
                    padding-top: 80px;
                }

                .sidebar-fixed {
                    width: 280px;
                    background: #ffffff;
                    box-shadow: 2px 0 12px rgba(0, 0, 0, 0.06);
                    position: fixed;
                    top: 80px;
                    left: 0;
                    height: calc(100vh - 80px);
                    overflow-y: auto;
                    z-index: 1000;
                }

                .content-area {
                    flex: 1;
                    margin-left: 280px;
                    padding: 2rem;
                    min-height: calc(100vh - 80px);
                    padding-bottom: 100px;
                    /* Space for footer */
                }

                .form-container {
                    margin: 0 auto;
                }

                .card {
                    background: #ffffff;
                    border-radius: 12px;
                    box-shadow: 0 8px 20px rgba(2, 8, 23, 0.06);
                    margin-bottom: 24px;
                    border: 1px solid var(--neutral-200);
                }

                .card-header {
                    background: linear-gradient(135deg, var(--accent-blue) 0%, var(--accent-blue-dark) 100%);
                    color: #ffffff;
                    padding: 20px 24px;
                    border-radius: 12px 12px 0 0;
                }

                .form-group {
                    margin-bottom: 18px;
                }

                .form-label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 600;
                    color: var(--text-700);
                }

                .form-control {
                    width: 100%;
                    padding: 12px 14px;
                    border: 1px solid #d1d5db;
                    border-radius: 8px;
                    font-size: 16px;
                    transition: border-color 0.2s, box-shadow 0.2s;
                    background-color: #ffffff;
                }

                .form-control:hover {
                    border-color: #bfc6d1;
                }

                .form-control:focus {
                    outline: none;
                    border-color: var(--accent-blue);
                    box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.18);
                }

                .btn {
                    padding: 12px 20px;
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: transform 0.1s ease, box-shadow 0.2s ease, background 0.2s ease;
                    text-align: center;
                    display: inline-block;
                    border: none;
                }

                .btn:active {
                    transform: translateY(1px);
                }

                .btn-primary {
                    background: linear-gradient(180deg, var(--accent-blue), #2563eb);
                    color: #ffffff;
                    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
                }

                .btn-primary:hover {
                    background: linear-gradient(180deg, #4f8df8, #1e54da);
                    box-shadow: 0 6px 16px rgba(37, 99, 235, 0.35);
                }

                .btn-secondary {
                    background: #6b7280;
                    color: #ffffff;
                    box-shadow: 0 4px 10px rgba(107, 114, 128, 0.2);
                }

                .btn-secondary:hover {
                    background: #565d6b;
                    box-shadow: 0 6px 14px rgba(86, 93, 107, 0.28);
                }

                .radio-group {
                    display: flex;
                    gap: 20px;
                    margin-bottom: 12px;
                    flex-wrap: wrap;
                }

                .radio-item {
                    display: flex;
                    align-items: center;
                    padding: 8px 12px;
                    border: 1px solid var(--neutral-200);
                    border-radius: 20px;
                    background: #ffffff;
                }

                .radio-item input {
                    margin-right: 8px;
                }

                .search-section {
                    background-color: #eef7ff;
                    border: 1px solid #cfe8ff;
                    border-radius: 10px;
                    padding: 16px;
                    margin-bottom: 20px;
                }

                .search-controls {
                    display: flex;
                    gap: 10px;
                    margin-bottom: 14px;
                }

                .search-input {
                    flex: 1;
                    padding: 10px 12px;
                    border: 1px solid #d1d5db;
                    border-radius: 8px;
                    font-size: 16px;
                    background: #ffffff;
                }

                .search-btn {
                    background-color: #0ea5e9;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    padding: 10px 16px;
                    cursor: pointer;
                    box-shadow: 0 4px 10px rgba(14, 165, 233, 0.25);
                }

                .search-btn:hover {
                    background-color: #0284c7;
                    box-shadow: 0 6px 14px rgba(2, 132, 199, 0.3);
                }

                .patient-info {
                    background-color: #eef7ff;
                    border: 1px solid #cfe8ff;
                    border-radius: 10px;
                    padding: 16px;
                    margin-top: 12px;
                    display: none;
                }

                .patient-info.visible {
                    display: block;
                }

                .alert {
                    border-radius: 8px;
                    border-width: 1px;
                }

                .appointment-list {
                    max-height: 400px;
                    overflow-y: auto;
                }

                .appointment-item {
                    background: #ffffff;
                    border: 1px solid #cfe8ff;
                    border-radius: 8px;
                    padding: 12px;
                    margin-bottom: 10px;
                    cursor: pointer;
                    transition: all 0.2s ease;
                }

                .appointment-item:hover {
                    background: #eef7ff;
                    border-color: var(--accent-blue);
                    box-shadow: 0 2px 8px rgba(59, 130, 246, 0.15);
                }

                .appointment-item.selected {
                    background: #dbeafe;
                    border-color: var(--accent-blue);
                    border-width: 2px;
                }

                .appointment-item-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 8px;
                }

                .appointment-id {
                    font-weight: 600;
                    color: var(--accent-blue);
                    font-size: 14px;
                }

                .appointment-date {
                    font-size: 12px;
                    color: #6b7280;
                }

                .appointment-details {
                    font-size: 13px;
                    color: #374151;
                }

                .appointment-details div {
                    margin: 4px 0;
                }

                .loading-indicator {
                    text-align: center;
                    padding: 20px;
                    color: #6b7280;
                }

                @media (max-width: 1024px) {
                    .content-area {
                        margin-left: 0;
                        padding: 1.25rem;
                    }

                    .sidebar-fixed {
                        position: static;
                        width: 100%;
                        height: auto;
                        box-shadow: none;
                    }

                    .form-container {
                        padding: 16px;
                    }
                }
            </style>
        </head>

        <body>
            <!-- Header -->
            <jsp:include page="../includes/header.jsp" />

            <div class="main-wrapper">
                <!-- Sidebar -->
                <div class="sidebar-fixed">
                    <%@ include file="../includes/sidebar-receptionist.jsp" %>
                </div>

                <!-- Main Content -->
                <div class="content-area">
                    <div class="form-container">
                        <!-- Header -->
                        <div class="card">
                            <div class="card-header">
                                <h5 class="text-xl font-semibold">Đăng Ký Bệnh Nhân Mới</h5>
                            </div>
                            <div class="card-body">
                                <!-- Error message display -->
                                <c:if test="${not empty sessionScope.errorMessage}">
                                    <div class="alert alert-danger mb-4"
                                        style="background-color: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 12px; border-radius: 4px; margin-bottom: 16px;">
                                        <i class="fas fa-exclamation-triangle"></i> ${sessionScope.errorMessage}
                                    </div>
                                    <c:remove var="errorMessage" scope="session" />
                                </c:if>

                                <!-- Success message display -->
                                <c:if test="${not empty sessionScope.successMessage}">
                                    <div class="alert alert-success mb-4"
                                        style="background-color: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 12px; border-radius: 4px; margin-bottom: 16px;">
                                        <i class="fas fa-check-circle"></i> ${sessionScope.successMessage}
                                    </div>
                                    <c:remove var="successMessage" scope="session" />
                                </c:if>

                                <form action="<c:url value="/receptionist/checkin-form"/>" method="post">
                                <input type="hidden" name="action" value="checkin">
                                <input type="hidden" name="patientType" value="walkin">

                                <!-- Section for walk-in patients -->
                                <div id="walkinSection">
                                    <div class="form-group">
                                        <label for="patientName" class="form-label">Họ Tên Bệnh Nhân <span
                                                class="text-red-500">*</span></label>
                                        <input type="text" class="form-control" id="patientName" name="patientName"
                                            placeholder="Nhập họ tên bệnh nhân" required>
                                    </div>

                                    <!-- Parent Information -->
                                    <div class="grid md:grid-cols-2 gap-4">
                                        <div class="form-group">
                                            <label for="parentName" class="form-label">Tên Phụ Huynh/Người Giám Hộ <span
                                                    class="text-red-500">*</span></label>
                                            <input type="text" class="form-control" id="parentName" name="parentName"
                                                placeholder="Nhập tên phụ huynh" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="parentCccd" class="form-label">Số CCCD Phụ Huynh <span
                                                    class="text-red-500">*</span></label>
                                            <input type="text" class="form-control" id="parentCccd" name="parentCccd"
                                                placeholder="Nhập số CCCD (9-12 số)" pattern="[0-9]{9,12}"
                                                maxlength="12" minlength="9" title="Số CCCD phải có từ 9 đến 12 chữ số"
                                                required>
                                            <small class="text-gray-500 text-sm">Số CCCD phải có từ 9 đến 12 chữ
                                                số</small>
                                        </div>
                                    </div>

                                    <!-- Các trường bổ sung -->
                                    <div class="grid md:grid-cols-2 gap-4">
                                        <div class="form-group">
                                            <label for="dob" class="form-label">Ngày Sinh</label>
                                            <input type="date" class="form-control" id="dob" name="dob">
                                        </div>
                                        <div class="form-group">
                                            <label for="address" class="form-label">Địa Chỉ</label>
                                            <input type="text" class="form-control" id="address" name="address"
                                                placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành">
                                        </div>
                                        <div class="form-group md:col-span-2">
                                            <label for="insuranceInfo" class="form-label">Thông Tin Bảo Hiểm</label>
                                            <input type="text" class="form-control" id="insuranceInfo"
                                                name="insuranceInfo" placeholder="Số thẻ/nhà cung cấp (tùy chọn)">
                                        </div>
                                    </div>
                                </div>

                                <div class="flex gap-3">
                                    <button type="submit" class="btn btn-primary flex-1">
                                        <i class="fas fa-user-plus"></i> Đăng Ký Bệnh Nhân
                                    </button>
                                    <a href="<c:url value="/receptionist"/>" class="btn btn-secondary flex-1 text-center">
                                        <i class="fas fa-arrow-left"></i> Quay Lại
                                    </a>
                                </div>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <script>
                // Set focus to patient name field on page load
                document.addEventListener('DOMContentLoaded', function () {
                    const patientNameField = document.getElementById('patientName');
                    if (patientNameField) {
                        patientNameField.focus();
                    }
                });


                // CCCD validation
                document.getElementById('parentCccd').addEventListener('input', function (e) {
                    const value = e.target.value;
                    const cccdPattern = /^[0-9]{9,12}$/;

                    // Remove any non-numeric characters
                    e.target.value = value.replace(/[^0-9]/g, '');

                    // Validate length and format
                    if (e.target.value.length > 0 && (e.target.value.length < 9 || e.target.value.length > 12)) {
                        e.target.setCustomValidity('Số CCCD phải có từ 9 đến 12 chữ số');
                    } else if (e.target.value.length >= 9 && e.target.value.length <= 12 && !cccdPattern.test(e.target.value)) {
                        e.target.setCustomValidity('Số CCCD chỉ được chứa chữ số');
                    } else {
                        e.target.setCustomValidity('');
                    }
                });

                // Form submission validation
                document.querySelector('form').addEventListener('submit', function (e) {
                    // Validate walk-in patient
                    const cccdInput = document.getElementById('parentCccd');
                    const cccdValue = cccdInput.value;
                    const cccdPattern = /^[0-9]{9,12}$/;

                    if (cccdValue && !cccdPattern.test(cccdValue)) {
                        e.preventDefault();
                        alert('Số CCCD phải có từ 9 đến 12 chữ số và chỉ chứa số');
                        cccdInput.focus();
                        return false;
                    }
                });
            </script>

            </div> <!-- End form-container -->
            </div> <!-- End content-area -->
            </div> <!-- End main-wrapper -->

            <!-- Footer -->
            <jsp:include page="../includes/footer.jsp" />

            <!-- Include all JS files -->
            <jsp:include page="../includes/footer-includes.jsp" />

        </body>

        </html>