<%-- 
Document : PatientProfile
Created on : Oct 8, 2025, 5:37:36
PM Author : KienPC
--%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông tin Bệnh Nhân</title>

        <!-- Tailwind -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- FontAwesome -->
        <script src="https://kit.fontawesome.com/a2e0b7c6d6.js" crossorigin="anonymous"></script>
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

                <!-- Page Title -->
                <h1 class="text-3xl font-bold text-center mb-10 text-gray-800">
                    Hồ Sơ Bệnh Nhân
                    <div class="h-1 w-48 mx-auto bg-blue-500 mt-2 rounded-full"></div>
                </h1>

                <!-- ==================== PDF CONTENT ==================== -->
                <div id="pdfContent" class="bg-white shadow-sm rounded-4 border border-blue-100 p-5">

                    <!-- Logo + Title -->
                    <div class="text-center mb-4">
                        <h2 class="text-primary fw-bold">Thông tin</h2>
                        <hr class="my-3 border-blue-300">
                    </div>

                    <!-- Profile Details -->
                    <div class="row gx-5">
                        <!-- Left Column -->
                        <div class="col-md-6">
                            <h5 class="fw-bold text-primary mb-2">Chi tiết cuộc hẹn</h5>
                            <p class="mb-1"><strong>Trạng thái:</strong>
                                <c:choose>
                                    <c:when test="${patient.status == 'Confirmed'}">
                                        Đã Xác Nhận
                                    </c:when>
                                    <c:when test="${patient.status == 'Pending'}">
                                        Chờ
                                    </c:when>
                                    <c:otherwise>
                                        Huỷ bỏ
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <p class="mb-1"><strong>Ngày & giờ:</strong>
                                ${patient.appointmentDate} ${patient.appointmentTime}
                            </p>
                            <p class="mb-4"><strong>Bác Sĩ:</strong>
                                ${patient.doctorName} - <strong>Số năm kinh nghiệm: 
                                </strong>${patient.doctorExperienceYears} năm
                            </p>

                            <h5 class="fw-bold text-primary mb-2 mt-4">Thông Tin Phụ Huynh</h5>
                            <p class="mb-1"><strong>Họ tên:</strong> ${patient.parentName}</p>
                            <p class="mb-1"><strong>Email:</strong> ${patient.email}</p>
                            <p class="mb-1"><strong>SĐT:</strong> ${patient.phone}</p>
                        </div>

                        <!-- Right Column -->
                        <div class="col-md-6">
                            <h5 class="fw-bold text-primary mb-2">Thông tin Bệnh Nhân</h5>
                            <p class="mb-1"><strong>Họ tên:</strong> ${patient.fullName}</p>
                            <p class="mb-1"><strong>Ngày sinh:</strong> ${patient.dob}</p>
                            <p class="mb-1"><strong>Địa chỉ:</strong> ${patient.address}</p>
                            <p class="mb-1"><strong>Bệnh nền:</strong> ${patient.insuranceInfo}</p>
                        </div>
                    </div>
                </div>

                <!-- ==================== BUTTONS (Không in vào PDF) ==================== -->
                <div class="d-flex justify-content-end gap-3 mt-4">
                    <a href="Update-Patient?pid=${patient.patientId}"
                       class="btn btn-primary d-flex align-items-center gap-2 px-4">
                        <i class="fa-regular fa-pen-to-square"></i> Cập Nhật
                    </a>

                    <button id="exportExcelBtn"
                            class="btn btn-success d-flex align-items-center gap-2 px-4">
                        <i class="fa-regular fa-file-excel"></i> Xuất Excel
                    </button>

                    <button id="printPdfBtn" class="btn btn-danger d-flex align-items-center gap-2 px-4">
                        <i class="fa-regular fa-file-pdf"></i> In PDF
                    </button>
                </div>
                </main>

                <!-- Libraries -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
                <script
                src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

                <!-- === EXPORT EXCEL + PDF === -->
                <script>
                    document.addEventListener("DOMContentLoaded", () => {
                        // --- EXPORT EXCEL ---
                        document.getElementById("exportExcelBtn").addEventListener("click", () => {
                            const wb = XLSX.utils.book_new();
                            const ws_data = [
                                ["H\u1ecd t\u00ean", "${patient.fullName}"],
                                ["Ng\u00e0y sinh", "${patient.dob}"],
                                ["\u0110\u1ecba ch\u1ec9", "${patient.address}"],
                                ["B\u1ea3o hi\u1ec3m", "${patient.insuranceInfo}"],
                                [],
                                ["Ph\u1ee5 huynh", "${patient.parentName}"],
                                ["Email", "${patient.email}"],
                                ["S\u0110T", "${patient.phone}"],
                                [],
                                ["Tr\u1ea1ng th\u00e1i", "${patient.status}"],
                                ["Ng\u00e0y & Gi\u1edd", "${patient.appointmentDate} at ${patient.appointmentTime}"],
                                                ["B\u00e1c s\u0129", "${patient.doctorName} - ${patient.doctorExperienceYears} n\u0103m"]
                                            ];
                                            const ws = XLSX.utils.aoa_to_sheet(ws_data);
                                            // Định dạng độ rộng cột để đọc dễ hơn
                                            ws['!cols'] = [{wch: 22}, {wch: 50}];
                                            XLSX.utils.book_append_sheet(wb, ws, "Profile");
                                            const wbout = XLSX.write(wb, {bookType: "xlsx", type: "array"});
                                            const blob = new Blob([wbout], {type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"});
                                            const url = URL.createObjectURL(blob);
                                            const a = document.createElement("a");
                                            a.href = url;
                                            a.download = "PatientProfile.xlsx";
                                            document.body.appendChild(a);
                                            a.click();
                                            a.remove();
                                            URL.revokeObjectURL(url);
                                        });

                                        // --- EXPORT PDF (Không chứa các nút, có logo + tiêu đề) ---
                                        document.getElementById("printPdfBtn").addEventListener("click", () => {
                                            const element = document.getElementById("pdfContent"); // chỉ in phần nội dung hồ sơ
                                            const opt = {
                                                margin: 0.5,
                                                filename: 'PatientProfile.pdf',
                                                image: {type: 'jpeg', quality: 0.98},
                                                html2canvas: {scale: 2},
                                                jsPDF: {unit: 'in', format: 'a4', orientation: 'portrait'}
                                            };
                                            html2pdf().set(opt).from(element).save();
                                        });
                                    });
                </script>

            </div> <!-- End content-area -->
        </div> <!-- End main-wrapper -->

        <!-- Footer -->
        <%@ include file="../includes/footer.jsp" %>

    </body>

</html>
