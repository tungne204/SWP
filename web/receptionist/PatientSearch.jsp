<%-- 
    Document   : PatientSearch
    Created on : Oct 8, 2025, 5:37:36 PM
    Author     : KienPC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Patient Information | Medilab Clinic</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <!--  Body flex để giữ footer dưới cùng -->
    <body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">

        <!-- Header -->
        <header class="bg-blue-600 text-white shadow-md fixed w-full z-10">
            <div class="max-w-7xl mx-auto flex justify-between items-center px-8 py-3">
                <div class="flex items-center gap-3">
                    <span class="text-xl font-bold tracking-wide">Medilab Clinic</span>
                </div>

                <div class="flex items-center gap-3">
                    <a href="Receptionist-Dashboard"
                       class="bg-white/20 text-white px-4 py-1.5 rounded-full font-semibold hover:bg-white hover:text-blue-700 transition">
                        Home
                    </a>
                    <a href="logout"
                       class="bg-white text-blue-600 px-4 py-1.5 rounded-full font-semibold hover:bg-blue-100 transition">
                        Logout
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="max-w-7xl mx-auto px-8 pt-28 pb-10 flex-grow">
            <h2 class="text-3xl font-bold mb-6 text-blue-700 text-center">
                Patient Information
            </h2>

            <!-- ️ Error -->
            <c:if test="${not empty error}">
                <div class="mb-4 p-3 bg-red-100 text-red-700 rounded-lg border border-red-300 text-center">
                    ️ ${error}
                </div>
            </c:if>

            <!--️ Warning -->
            <c:if test="${not empty warning}">
                <div id="warningBox" class="mb-4 p-3 bg-yellow-100 text-yellow-700 rounded-lg border border-yellow-300 text-center">
                    ${warning}
                </div>
            </c:if>

            <!--Search Form -->
            <form id="searchForm" action="Patient-Search" method="post"
                  class="flex flex-col sm:flex-row gap-3 mb-10 justify-center max-w-3xl mx-auto w-full">
                <input
                    type="text"
                    name="keyword"
                    placeholder="Enter patient name or ID..."
                    value="${keyword}"
                    class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 text-lg"
                >
                <button type="submit"
                        class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition font-semibold text-lg">
                    Search
                </button>
            </form>

            <!--  Table Result -->
            <c:if test="${not empty patients}">
                <div class="overflow-x-auto shadow border border-gray-200 rounded-xl bg-white max-w-6xl mx-auto">
                    <table class="min-w-full w-full text-base text-left">
                        <thead class="bg-gray-100 text-gray-700 text-sm uppercase">
                            <tr>
                                <th class="px-6 py-4">Patient ID</th>
                                <th class="px-6 py-4">Full Name</th>
                                <th class="px-6 py-4">Date of Birth</th> <!-- NEW COLUMN -->
                                <th class="px-6 py-4">Address</th>
                                <th class="px-6 py-4">Insurance</th>
                                <th class="px-6 py-4 text-center">Details</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <c:forEach var="p" items="${patients}">
                                <tr class="hover:bg-blue-50">
                                    <td class="px-6 py-4 font-semibold">${p.patientId}</td>
                                    <td class="px-6 py-4">${p.fullName}</td>
                                    <td class="px-6 py-4">${p.dob}</td> <!-- DISPLAY DOB -->
                                    <td class="px-6 py-4">${p.address}</td>
                                    <td class="px-6 py-4">${p.insuranceInfo}</td>
                                    <td class="px-6 py-4 text-center">
                                        <a href="Patient-Profile?id=${p.patientId}"
                                           class="bg-blue-500 text-white px-4 py-1.5 rounded-md hover:bg-blue-600 transition inline-flex items-center gap-1">
                                            👁 View
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <p class="mt-6 text-gray-600 text-center">
                    Found <strong>${fn:length(patients)}</strong> result(s)
                    <c:if test="${not empty keyword}"> for keyword "<em>${keyword}</em>"</c:if>.
                </p>
            </c:if>

            <!-- ️ No input yet -->
            <c:if test="${empty keyword}">
                <div class="mt-10 text-gray-500 text-center text-lg">
                    Please search for a patient.
                </div>
            </c:if>

            <!-- No result -->
            <c:if test="${not empty keyword and empty patients}">
                <div class="mt-10 text-gray-500 text-center text-lg">
                    ❌ No patient found for keyword "<strong>${keyword}</strong>".
                </div>
            </c:if>
        </main>

        <!--  Footer -->
        <footer class="bg-blue-700 text-blue-100 py-6 mt-auto">
            <div class="text-center text-sm">
                © 2025 Medilab Pediatric Clinic | Designed by 
                <span class="font-semibold text-white">Kien</span>
            </div>
        </footer>

        <!--  Patient Detail Modal -->
        <div id="detailModal" class="hidden fixed inset-0 bg-black/50 flex items-center justify-center z-50">
            <div class="bg-white rounded-xl shadow-lg w-96 p-6">
                <h3 class="text-xl font-bold text-blue-700 mb-4">🩺 Patient Details</h3>
                <div id="modalContent" class="text-sm text-gray-700 space-y-2">
                    <!-- Content injected by JS -->
                </div>
                <div class="mt-6 text-center">
                    <button onclick="closeModal()"
                            class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!--  Script -->
        <script>
            const form = document.getElementById("searchForm");
            const input = form.querySelector("input[name='keyword']");
            const warningBox = document.getElementById("warningBox");
            const modal = document.getElementById("detailModal");
            const modalContent = document.getElementById("modalContent");

            // Prevent empty search
            form.addEventListener("submit", (e) => {
                const value = input.value.trim();
                if (value === "") {
                    e.preventDefault();
                    alert("Please enter a patient name or ID to search!");
                    input.focus();
                }
            });

            // Open detail modal
            function openModal(id, name, dob, address, insurance, parent, doctor, status, appointment) {
                modal.classList.remove("hidden");
                modalContent.innerHTML = `
                    <p><strong>ID:</strong> ${id}</p>
                    <p><strong>Full Name:</strong> ${name}</p>
                    <p><strong>Date of Birth:</strong> ${dob || '—'}</p> <!-- Show DOB -->
                    <p><strong>Address:</strong> ${address}</p>
                    <p><strong>Insurance:</strong> ${insurance}</p>
                    <p><strong>Parent:</strong> ${parent || '—'}</p>
                    <p><strong>Assigned Doctor:</strong> ${doctor || '—'}</p>
                    <p><strong>Status:</strong> ${status || '—'}</p>
                    <p><strong>Appointment:</strong> ${appointment || '—'}</p>
                `;
            }

            // Close modal
            function closeModal() {
                modal.classList.add("hidden");
            }

            // Hide warning after 3s
            if (warningBox) {
                setTimeout(() => {
                    warningBox.style.opacity = "0";
                    warningBox.style.transition = "opacity 0.5s ease";
                    setTimeout(() => warningBox.remove(), 500);
                }, 3000);
            }
        </script>

    </body>
</html>
