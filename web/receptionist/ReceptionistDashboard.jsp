<%@ page contentType="text/html;charset=UTF-8" %>
<%-- 
    Document   : Receptionist Dashboard
    Created on : Oct 18, 2025, 10:37:08 PM
    Author     : KiênPC
--%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Receptionist Home | Medilab Clinic</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body>
        <!-- Include Header -->
        <%@ include file="../includes/header.jsp" %>
        
        <!-- Include Sidebar -->
        <%@ include file="../includes/sidebar-receptionist.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <!--  Hero Section -->
            <section class="text-center bg-gradient-to-r from-blue-100 to-blue-50 relative mb-6 rounded-lg p-8">
                <div class="max-w-4xl mx-auto relative z-10">
                    <h1 class="text-4xl md:text-5xl font-extrabold text-blue-700 mb-3">
                        Welcome, Receptionist!
                    </h1>
                    <p class="text-gray-600 text-lg max-w-2xl mx-auto">
                        Manage patient profiles and appointments efficiently with our Medilab system.
                    </p>
                </div>
            </section>

            <!--  Quick Access Buttons -->
            <section class="py-8">
                <div class="max-w-6xl mx-auto">
                    <h2 class="text-3xl font-bold text-center text-gray-800 mb-12">Quick Access</h2>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <!-- Patient Check-in -->
                        <a href="receptionist/checkin.jsp"
                           class="group bg-white rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 p-8 text-center border border-gray-100 hover:border-blue-200 transform hover:-translate-y-2">
                            <div class="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-6 group-hover:bg-blue-200 transition-colors">
                                <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path>
                                </svg>
                            </div>
                            <h3 class="text-xl font-semibold text-gray-800 mb-3">Patient Check-in</h3>
                            <p class="text-gray-600 leading-relaxed">Register new patients and manage check-in process efficiently.</p>
                        </a>

                        <!-- Patient Search -->
                        <a href="PatientSearch"
                           class="group bg-white rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 p-8 text-center border border-gray-100 hover:border-green-200 transform hover:-translate-y-2">
                            <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6 group-hover:bg-green-200 transition-colors">
                                <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                                </svg>
                            </div>
                            <h3 class="text-xl font-semibold text-gray-800 mb-3">Patient Search</h3>
                            <p class="text-gray-600 leading-relaxed">Search and view patient information quickly and easily.</p>
                        </a>

                        <!-- Waiting Screen -->
                        <a href="/patient-queue"
                           class="group bg-white rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 p-8 text-center border border-gray-100 hover:border-purple-200 transform hover:-translate-y-2">
                            <div class="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-6 group-hover:bg-purple-200 transition-colors">
                                <svg class="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path>
                                </svg>
                            </div>
                            <h3 class="text-xl font-semibold text-gray-800 mb-3">Waiting Screen</h3>
                            <p class="text-gray-600 leading-relaxed">Monitor and manage the patient queue and waiting times.</p>
                        </a>
                    </div>
                </div>
            </section>

            <!--  Footer -->
            <footer class="bg-gray-800 text-white py-8 mt-auto rounded-lg">
                <div class="max-w-7xl mx-auto text-center px-6">
                    <p class="text-gray-300">&copy; 2024 Medilab Clinic. All rights reserved.</p>
                </div>
            </footer>
        </div>

    </body>
</html>
