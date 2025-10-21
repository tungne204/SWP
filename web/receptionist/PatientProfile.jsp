<%-- 
    Document   : PatientSearch
    Created on : Oct 8, 2025, 5:37:36 PM
    Author     : KienPC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Patient Profile</title>

        <!-- Tailwind -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Bootstrap 5.3 -->
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet"
            crossorigin="anonymous"
            />
        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            crossorigin="anonymous"
        ></script>

        <!-- FontAwesome -->
        <script src="https://kit.fontawesome.com/a2e0b7c6d6.js" crossorigin="anonymous"></script>
    </head>

    <body class="bg-[#f7f9fc] text-gray-800 font-sans text-[17px]">

        <!-- Header -->
        <header class="bg-blue-600 text-white shadow-md fixed w-full z-10">
            <div class="max-w-7xl mx-auto flex justify-between items-center px-8 py-3">
                <a href="Receptionist-Dashboard" class="text-2xl font-bold tracking-wide hover:text-gray-200 transition">
                    Medilab
                </a>
                <div class="d-flex gap-3">
                    <a href="Receptionist-Dashboard" class="btn btn-light text-blue-700 fw-semibold px-4 py-1">Home</a>
                    <a href="logout" class="btn btn-outline-light fw-semibold px-4 py-1">Logout</a>
                </div>
            </div>
        </header>

        <!-- Main -->
        <main class="max-w-6xl mx-auto pt-32 pb-10 px-8">

            <!-- Page Title -->
            <h1 class="text-3xl font-bold text-center mb-10 text-gray-800">
                Patient Profile
                <div class="h-1 w-48 mx-auto bg-blue-500 mt-2 rounded-full"></div>
            </h1>

            <!-- ==================== PDF CONTENT ==================== -->
            <div id="pdfContent" class="bg-white shadow-sm rounded-4 border border-blue-100 p-5">

                <!-- Logo + Title -->
                <div class="text-center mb-4">
                    <h2 class="text-primary fw-bold">Medilab - Patient Profile</h2>
                    <hr class="my-3 border-blue-300">
                </div>

                <!-- Profile Details -->
                <div class="row gx-5">
                    <!-- Left Column -->
                    <div class="col-md-6">
                        <h5 class="fw-bold text-primary mb-2">Appointment Details</h5>
                        <p class="mb-1"><strong>Status:</strong> 
                            <c:choose>
                                <c:when test="${patient.status == 'Confirmed'}">
                                    CONFIRMED
                                </c:when>
                                <c:when test="${patient.status == 'Pending'}">
                                    PENDING
                                </c:when>
                                <c:otherwise>
                                    REJECTED
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <p class="mb-1"><strong>Date & Time:</strong> 
                            ${patient.appointmentDate} at ${patient.appointmentTime}
                        </p>
                        <p class="mb-4"><strong>Doctor:</strong> 
                            ${patient.doctorName} - ${patient.doctorSpecialty}
                        </p>

                        <h5 class="fw-bold text-primary mb-2 mt-4">Parent Information</h5>
                        <p class="mb-1"><strong>Parent Name:</strong> ${patient.parentName}</p>
                        <p class="mb-1"><strong>Parent ID:</strong> ${patient.parentIdNumber}</p>
                        <p class="mb-1"><strong>Email:</strong> ${patient.email}</p>
                        <p class="mb-1"><strong>Phone:</strong> ${patient.phone}</p>
                    </div>

                    <!-- Right Column -->
                    <div class="col-md-6">
                        <h5 class="fw-bold text-primary mb-2">Patient Information</h5>
                        <p class="mb-1"><strong>Full Name:</strong> ${patient.fullName}</p>
                        <p class="mb-1"><strong>Date of Birth:</strong> ${patient.dob}</p>
                        <p class="mb-1"><strong>Address:</strong> ${patient.address}</p>
                        <p class="mb-1"><strong>Insurance:</strong> ${patient.insuranceInfo}</p>
                    </div>
                </div>
            </div>

            <!-- ==================== BUTTONS (Không in vào PDF) ==================== -->
            <div class="d-flex justify-content-end gap-3 mt-4">
                <a href="Update-Patient?pid=${patient.patientId}" 
                   class="btn btn-primary d-flex align-items-center gap-2 px-4">
                    <i class="fa-regular fa-pen-to-square"></i> Update
                </a>

                <button id="exportExcelBtn" class="btn btn-success d-flex align-items-center gap-2 px-4">
                    <i class="fa-regular fa-file-excel"></i> Export Excel
                </button>

                <button id="printPdfBtn" class="btn btn-danger d-flex align-items-center gap-2 px-4">
                    <i class="fa-regular fa-file-pdf"></i> Print PDF
                </button>
            </div>
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
                <div class="d-flex justify-content-center gap-4 mt-4">
                    <a href="#" class="text-blue-600 hover:text-blue-800 transition"><i class="fab fa-facebook fa-lg"></i></a>
                    <a href="#" class="text-pink-500 hover:text-pink-700 transition"><i class="fab fa-instagram fa-lg"></i></a>
                    <a href="#" class="text-blue-500 hover:text-blue-700 transition"><i class="fab fa-youtube fa-lg"></i></a>
                    <a href="#" class="text-blue-700 hover:text-blue-900 transition"><i class="fab fa-linkedin fa-lg"></i></a>
                </div>
                <p class="text-sm text-gray-500 mt-4">
                    © <span class="fw-semibold text-gray-800">Medilab</span> — All Rights Reserved<br>
                    Designed by BootstrapMade | Customized by Medilab Team
                </p>
            </div>
        </footer>

        <!-- Libraries -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

        <!-- === EXPORT EXCEL + PDF === -->
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                // --- EXPORT EXCEL ---
                document.getElementById("exportExcelBtn").addEventListener("click", () => {
                    const wb = XLSX.utils.book_new();
                    const ws_data = [
                        ["Medilab Clinic - Patient Profile"], [],
                        ["Full Name", "${patient.fullName}"],
                        ["Date of Birth", "${patient.dob}"],
                        ["Address", "${patient.address}"],
                        ["Insurance", "${patient.insuranceInfo}"], [],
                        ["Parent Name", "${patient.parentName}"],
                        ["Parent ID", "${patient.parentIdNumber}"],
                        ["Email", "${patient.email}"],
                        ["Phone", "${patient.phone}"], [],
                        ["Status", "${patient.status}"],
                        ["Date & Time", "${patient.appointmentDate} at ${patient.appointmentTime}"],
                                        ["Doctor", "${patient.doctorName} - ${patient.doctorSpecialty}"]
                                                    ];
                                                    const ws = XLSX.utils.aoa_to_sheet(ws_data);
                                                    XLSX.utils.book_append_sheet(wb, ws, "Profile");
                                                    XLSX.writeFile(wb, "PatientProfile.xlsx");
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

    </body>
</html>
