<%-- 
    Document   : PatientProfile
    Created on : Oct 19, 2025, 10:28:11 PM
    Author     : KiênPC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Patient Profile | Medilab Clinic</title>
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
        <main class="max-w-5xl mx-auto pt-28 pb-16 px-4">
            <!-- Profile Information -->
            <section class="bg-white p-8 rounded-2xl shadow-md mb-8 relative">
                <h2 class="text-2xl font-semibold text-blue-700 mb-6">Patient Information</h2>

                <!-- ✏️ Edit Profile Button -->
                <a href="Update-Patient?pid=${patient.patientId}"
                   class="absolute top-8 right-8 bg-blue-600 text-white px-5 py-2 rounded-lg hover:bg-blue-700 transition text-base font-semibold">
                    ✏️ Edit Profile
                </a>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-y-5 text-[18px]">
                    <div>
                        <p class="font-semibold text-gray-600">Patient ID:</p>
                        <p>${patient.patientId}</p>
                    </div>
                    <div>
                        <p class="font-semibold text-gray-600">Full name:</p>
                        <p>${patient.fullName}</p>
                    </div>
                    <div>
                        <p class="font-semibold text-gray-600">Date of Birth:</p> <!--New Field -->
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
                        <p class="font-semibold text-gray-600">Status:</p>
                        <p>${patient.status}</p>
                    </div>
                    <div>
                        <p class="font-semibold text-gray-600">Next medical appointment:</p>
                        <p>${patient.appointmentDate}</p>
                    </div>
                </div>
            </section>

            <!-- Medical History -->
            <section class="bg-white p-8 rounded-2xl shadow-md">
                <h2 class="text-2xl font-semibold text-blue-700 mb-6">Medical History</h2>

                <c:if test="${empty historyList}">
                    <p class="text-gray-500 italic">No medical history available.</p>
                </c:if>

                <c:if test="${not empty historyList}">
                    <div class="overflow-x-auto">
                        <table class="min-w-full text-[17px] text-left border border-gray-200 rounded-lg">
                            <thead class="bg-gray-100 text-gray-700">
                                <tr>
                                    <th class="px-5 py-3">📅 Examination Date</th>
                                    <th class="px-5 py-3">💊 Diagnosis</th>
                                    <th class="px-5 py-3">📝 Notes</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="h" items="${historyList}">
                                <tr class="border-t hover:bg-blue-50">
                                    <td class="px-5 py-3">${h.date}</td>
                                    <td class="px-5 py-3 font-semibold text-blue-700">${h.diagnosis}</td>
                                    <td class="px-5 py-3">${h.notes}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
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
