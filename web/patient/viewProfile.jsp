<%-- 
    Document   : viewProfile
    Created on : Oct 20, 2025, 10:52:56 AM
    Author     : Kiên
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>View Profile | Medilab Clinic</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 text-gray-800 font-sans text-[18px] leading-relaxed">

    <!-- Header -->
    <header class="bg-blue-600 text-white shadow-md fixed w-full z-10">
        <div class="max-w-7xl mx-auto flex justify-between items-center px-8 py-3">
            <span class="text-2xl font-bold tracking-wide">Medilab Clinic</span>
            <div class="flex items-center gap-3">
                <a href="${pageContext.request.contextPath}/Receptionist-Dashboard"
                   class="bg-white/20 px-4 py-1.5 rounded-full font-semibold hover:bg-white hover:text-blue-700 transition">
                    Home
                </a>
                <a href="logout"
                   class="bg-white text-blue-600 px-4 py-1.5 rounded-full font-semibold hover:bg-blue-100 transition">
                    Logout
                </a>
            </div>
        </div>
    </header>

    <!-- Content -->
    <main class="max-w-4xl mx-auto pt-28 pb-16 px-6">
        <section class="bg-white p-8 rounded-2xl shadow-md">
            <h2 class="text-2xl font-semibold text-blue-700 mb-6 text-center">Patient Profile</h2>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-y-5">
                <div>
                    <p class="font-semibold text-gray-600">Patient ID:</p>
                    <p>${patient.patientId}</p>
                </div>
                <div>
                    <p class="font-semibold text-gray-600">Full Name:</p>
                    <p>${patient.fullName}</p>
                </div>
                <div>
                    <p class="font-semibold text-gray-600">Date of Birth:</p>
                    <p>${patient.dob}</p>
                </div>
                <div>
                    <p class="font-semibold text-gray-600">Address:</p>
                    <p>${patient.address}</p>
                </div>
                <div>
                    <p class="font-semibold text-gray-600">Insurance:</p>
                    <p>${patient.insuranceInfo}</p>
                </div>
                <div>
                    <p class="font-semibold text-gray-600">Parent:</p>
                    <p>${patient.parentName}</p>
                </div>
                <div>
                    <p class="font-semibold text-gray-600">Doctor:</p>
                    <p>${patient.doctorName}</p>
                </div>
                <div>
                    <p class="font-semibold text-gray-600">Next Appointment:</p>
                    <p>${patient.appointmentDate}</p>
                </div>
            </div>

            <div class="mt-10 flex justify-center">
                <a href="${pageContext.request.contextPath}/Patient-Search"
                   class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition">
                    ← Back to Search
                </a>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="bg-blue-700 text-blue-100 py-6 text-center text-[16px]">
        © 2025 Medilab Pediatric Clinic | Designed by 
        <span class="font-semibold text-white">Kiên</span>
    </footer>

</body>
</html>

