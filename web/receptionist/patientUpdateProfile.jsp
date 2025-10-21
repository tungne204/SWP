<%-- 
    Document   : patientUpdateProfile
    Created on : Oct 19, 2025, 11:11:44 PM
    Author     : Kiên
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Update Patient | Medilab Clinic</title>

        <!-- Tailwind + Bootstrap -->
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/a2e0b7c6d6.js" crossorigin="anonymous"></script>
    </head>

    <body class="bg-[#f7f9fc] text-gray-800 font-sans text-[17px]">
        <!-- ===== HEADER ===== -->
        <header class="bg-blue-600 text-white shadow-md fixed w-full z-10">
            <div class="max-w-7xl mx-auto flex justify-between items-center px-8 py-3">
                <span class="text-2xl fw-bold tracking-wide">Medilab Clinic</span>
                <div class="d-flex gap-3">
                    <!-- Nút Home quay về Dashboard -->
                    <a href="Receptionist-Dashboard" class="btn btn-light text-blue-700 fw-semibold px-4 py-1">
                        <i class="fa-solid fa-house"></i> Home
                    </a>
                    <!-- Logout -->
                    <a href="logout" class="btn btn-outline-light fw-semibold px-4 py-1">
                        <i class="fa-solid fa-right-from-bracket"></i> Logout
                    </a>
                </div>
            </div>
        </header>

        <!-- ===== MAIN CONTENT ===== -->
        <main class="max-w-6xl mx-auto pt-32 pb-10 px-8">
            <h1 class="text-3xl font-bold text-center mb-10 text-gray-800">
                Update Patient Information
                <div class="h-1 w-56 mx-auto bg-blue-500 mt-2 rounded-full"></div>
            </h1>

            <!-- Update Form -->
            <form action="Update-Patient" method="post" class="bg-white shadow-lg rounded-4 border border-blue-100 p-5">

                <!-- PATIENT INFO -->
                <h4 class="text-blue-700 fw-bold mb-4">
                    <i class="fa-regular fa-user text-blue-600"></i> Patient Information
                </h4>
                <div class="row gx-5">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Full Name</label>
                        <input type="text" name="fullName" value="${patient.fullName}" class="form-control" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Date of Birth</label>
                        <input type="date" name="dob"
                               value="<c:out value='${fn:substring(patient.dob, 0, 10)}'/>"
                               class="form-control">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Address</label>
                        <input type="text" name="address" value="${patient.address}" class="form-control">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Insurance Info</label>
                        <input type="text" name="insuranceInfo" value="${patient.insuranceInfo}" class="form-control">
                    </div>
                </div>

                <!-- PARENT INFO -->
                <h4 class="text-blue-700 fw-bold mt-5 mb-3">
                    <i class="fa-regular fa-address-book text-blue-600"></i> Parent Information
                </h4>
                <div class="row gx-5">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Parent Name</label>
                        <input type="text" name="parentName" value="${patient.parentName}" class="form-control">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Parent ID</label>
                        <input type="text" name="parentIdNumber" value="${patient.parentIdNumber}" class="form-control">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Email</label>
                        <input type="email" name="email" value="${patient.email}" class="form-control">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Phone</label>
                        <input type="text" name="phone" value="${patient.phone}" class="form-control">
                    </div>
                </div>

                <!-- Hidden patient ID -->
                <input type="hidden" name="patientId" value="${patient.patientId}">

                <!-- BUTTONS -->
                <div class="d-flex justify-content-end gap-3 mt-5">
                    <!-- Save -->
                    <button type="submit" class="btn btn-success d-flex align-items-center gap-2 px-4">
                        <i class="fa-solid fa-floppy-disk"></i> Save Changes
                    </button>
                    <!-- Cancel -->
                    <a href="Patient-Profile?pid=${patient.patientId}" class="btn btn-secondary d-flex align-items-center gap-2 px-4">
                        <i class="fa-solid fa-xmark"></i> Cancel
                    </a>
                </div>
            </form>
        </main>

        <!-- ===== FOOTER ===== -->
        <footer class="bg-[#f7f9fc] text-gray-700 py-8 border-top border-gray-200 mt-5">
            <div class="max-w-5xl mx-auto text-center space-y-3">
                <h2 class="text-2xl fw-bold text-gray-800">Medilab</h2>
                <p>FPT University, Hoa Lac Hi-Tech Park, Thach That, Hanoi</p>
                <p><strong>Phone:</strong> +84 987 654 321<br>
                    <strong>Email:</strong> medilab.contact@gmail.com</p>
                <div class="d-flex justify-content-center gap-4 mt-4">
                    <a href="#" class="text-blue-600 hover:text-blue-800"><i class="fab fa-facebook fa-lg"></i></a>
                    <a href="#" class="text-pink-500 hover:text-pink-700"><i class="fab fa-instagram fa-lg"></i></a>
                    <a href="#" class="text-blue-500 hover:text-blue-700"><i class="fab fa-youtube fa-lg"></i></a>
                    <a href="#" class="text-blue-700 hover:text-blue-900"><i class="fab fa-linkedin fa-lg"></i></a>
                </div>
                <p class="text-sm text-gray-500 mt-4">
                    © <span class="fw-semibold text-gray-800">Medilab</span> — All Rights Reserved<br>
                    Designed by BootstrapMade | Customized by Medilab Team
                </p>
            </div>
        </footer>

    </body>
    <c:if test="${param.success == 'true'}">
        <div class="alert alert-success text-center fw-semibold my-3" role="alert">
            ✅ Update successful!
        </div>
    </c:if>

    <c:if test="${param.error == 'true'}">
        <div class="alert alert-danger text-center fw-semibold my-3" role="alert">
            ❌ Update failed. Please try again.
        </div>
    </c:if>

    <c:if test="${param.error == 'notfound'}">
        <div class="alert alert-warning text-center fw-semibold my-3" role="alert">
            ⚠️ Patient not found!
        </div>
    </c:if>
    
</html>
