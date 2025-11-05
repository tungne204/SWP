<%-- 
    Document   : patientUpdateProfile
    Created on : Oct 19, 2025, 11:11:44 PM
    Author     : Kiên
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setLocale value="vi_VN" />
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật thông tin Bệnh Nhân</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- Include all CSS files -->
        <jsp:include page="../includes/head-includes.jsp"/>

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
        <jsp:include page="../includes/header.jsp" />

        <div class="main-wrapper">
            <!-- Sidebar -->
            <%@ include file="../includes/sidebar-receptionist.jsp" %>

            <!-- Main Content -->
            <div class="content-area">
                <div class="form-container">
                    <h1 class="text-3xl font-bold text-center mb-10 text-gray-800">
                        Cập nhật thông tin Bệnh Nhân
                        <div class="h-1 w-56 mx-auto bg-blue-500 mt-2 rounded-full"></div>
                    </h1>

                    <!-- Update Form -->
                    <form action="Patient-Update" method="post" class="bg-white shadow-lg rounded-4 border border-blue-100 p-5">

                        <!-- PATIENT INFO -->
                        <h4 class="text-blue-700 fw-bold mb-4">
                            <i class="fa-regular fa-user text-blue-600"></i> Thông tin bệnh nhân
                        </h4>
                        <div class="row gx-5">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Họ Tên</label>
                                <input type="text" name="fullName" value="${patient.fullName}" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Ngày Sinh</label>
                                <input type="date" name="dob"
                                       value="<c:out value='${fn:substring(patient.dob, 0, 10)}'/>"
                                       class="form-control">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Địa chỉ</label>
                                <input type="text" name="address" value="${patient.address}" class="form-control">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Bệnh nền</label>
                                <input type="text" name="insuranceInfo" value="${patient.insuranceInfo}" class="form-control">
                            </div>
                        </div>

                        <!-- PARENT INFO -->
                        <h4 class="text-blue-700 fw-bold mt-5 mb-3">
                            <i class="fa-regular fa-address-book text-blue-600"></i>Thông tin Phụ Huynh
                        </h4>
                        <div class="row gx-5">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Họ Tên</label>
                                <input type="text" name="parentName" value="${patient.parentName}" class="form-control">
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Email</label>
                                <input type="email" name="email" value="${patient.email}" class="form-control">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">SDT</label>
                                <input type="text" name="phone" value="${patient.phone}" class="form-control">
                            </div>
                        </div>

                        <!-- Hidden patient ID -->
                        <input type="hidden" name="patientId" value="${patient.patientId}">

                        <!-- BUTTONS -->
                        <div class="d-flex justify-content-end gap-3 mt-5">
                            <!-- Save -->
                            <button type="submit" class="btn btn-success d-flex align-items-center gap-2 px-4">
                                <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                            </button>
                            <!-- Cancel -->
                            <a href="Patient-Profile?pid=${patient.patientId}" class="btn btn-secondary d-flex align-items-center gap-2 px-4">
                                <i class="fa-solid fa-xmark"></i> Huỷ
                            </a>
                        </div>
                    </form>
                    </main>
                    </body>
                    <c:if test="${param.success == 'true'}">
                        <div class="alert alert-success text-center fw-semibold my-3" role="alert">
                            ✅ Cập nhật Thành Công!
                        </div>
                    </c:if>

                    <c:if test="${param.error == 'true'}">
                        <div class="alert alert-danger text-center fw-semibold my-3" role="alert">
                            ❌ Cập nhật thất bại. Vui lòng thử lại.
                        </div>
                    </c:if>

                    <c:if test="${param.error == 'notfound'}">
                        <div class="alert alert-warning text-center fw-semibold my-3" role="alert">
                            ⚠️ Không tìm thấy bệnh nhân!
                        </div>
                    </c:if>

                </div> <!-- End form-container -->
            </div> <!-- End content-area -->
        </div> <!-- End main-wrapper -->

        <!-- Footer -->
        <%@ include file="../includes/footer.jsp" %>

    </body>
</html>
