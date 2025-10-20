<%-- 
    Document   : patientUpdateProfile
    Created on : Oct 19, 2025, 11:11:44 PM
    Author     : Kiên
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Patient | Medilab Clinic</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 text-gray-800 font-sans text-[18px] leading-relaxed font-medium">

    <!-- Header -->
    <header class="bg-blue-600 text-white shadow-md fixed w-full z-10">
        <div class="max-w-7xl mx-auto flex justify-between items-center px-8 py-3">
            <span class="text-2xl font-bold tracking-wide">Medilab Clinic</span>
            <div class="flex items-center gap-3">
                <a href="Receptionist-Dashboard"
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
    <main class="max-w-3xl mx-auto pt-28 pb-16 px-6">
        <section class="bg-white p-8 rounded-2xl shadow-md">
            <h2 class="text-2xl font-semibold text-blue-700 mb-6">🩺 Update Patient Information</h2>

            <form action="Update-Patient" method="post" class="space-y-6">
                <input type="hidden" name="patientId" value="${patient.patientId}">

                <!-- Full Name -->
                <div>
                    <label class="block text-gray-600 font-semibold mb-1">Full Name:</label>
                    <input type="text" name="fullName" value="${patient.fullName}"
                           class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>

                <!-- Date of Birth -->
                <div>
                    <label class="block text-gray-600 font-semibold mb-1">Date of Birth:</label>
                    <input type="date" name="dob" value="${patient.dob}"
                           class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>

                <!-- Address -->
                <div>
                    <label class="block text-gray-600 font-semibold mb-1">Address:</label>
                    <input type="text" name="address" value="${patient.address}"
                           class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>

                <!-- Insurance -->
                <div>
                    <label class="block text-gray-600 font-semibold mb-1">Insurance Info:</label>
                    <input type="text" name="insuranceInfo" value="${patient.insuranceInfo}"
                           class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>

                <!-- Parent -->
                <div>
                    <label class="block text-gray-600 font-semibold mb-1">Parent Name:</label>
                    <input type="text" name="parentName" value="${patient.parentName}"
                           class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>

                <!-- Doctor -->
                <div>
                    <label class="block text-gray-600 font-semibold mb-1">Doctor in Charge:</label>
                    <input type="text" name="doctorName" value="${patient.doctorName}"
                           class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>

                <!-- Buttons -->
                <div class="flex justify-end gap-4 mt-8">
                    <a href="Patient-Profile?pid=${patient.patientId}"
                       class="bg-gray-300 text-gray-800 px-6 py-2 rounded-lg hover:bg-gray-400 transition">
                        Cancel
                    </a>
                    <button type="submit"
                            class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition">
                        Update
                    </button>
                </div>
            </form>
        </section>
    </main>

    <!-- Footer -->
    <footer class="bg-blue-700 text-blue-100 py-6 mt-10 text-[16px]">
        <div class="text-center">
            © 2025 Medilab Pediatric Clinic | Designed by 
            <span class="font-semibold text-white">Kiên</span>
        </div>
    </footer>

</body>
</html>
