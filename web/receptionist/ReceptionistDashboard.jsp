<%@ page contentType="text/html;charset=UTF-8" %>
<%-- 
    Document   : Receptionist Dashboard
    Created on : Oct 18, 2025, 10:37:08 PM
    Author     : KiênPC
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Receptionist Home</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <!--Dùng flex layout toàn trang -->
    <body class="bg-gradient-to-b from-blue-50 to-white text-gray-800 font-sans min-h-screen flex flex-col">

        <!--  Header -->
        <header class="bg-blue-600 text-white shadow-md fixed w-full z-10">
            <div class="max-w-7xl mx-auto flex justify-between items-center px-8 py-3">
                <!-- Logo -->
                <div class="flex items-center gap-3">
                    <a href="Receptionist-Dashboard" class="text-2xl font-bold tracking-wide hover:text-gray-200 transition">
                        Medilab
                    </a>
                </div>

                <!-- Button group -->
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

        <!--  Hero Section -->
        <section class="pt-24 pb-10 text-center bg-gradient-to-r from-blue-100 to-blue-50 relative flex-shrink-0">
            <div class="max-w-4xl mx-auto relative z-10 px-6">
                <h1 class="text-4xl md:text-5xl font-extrabold text-blue-700 mb-3">
                    Welcome, Receptionist!
                </h1>
                <p class="text-gray-600 text-lg max-w-2xl mx-auto">
                    Manage patient profiles and appointments efficiently with our Medilab system.
                </p>
            </div>
            <img src="https://i.ibb.co/4MZ7hCm/doctor-bg.png"
                 alt="Doctor Background"
                 class="absolute right-0 top-0 h-full opacity-20 object-contain pointer-events-none" />
        </section>

        <!--  Quick Access Buttons -->
        <main class="max-w-5xl mx-auto px-6 py-16 flex-grow">
            <div class="grid md:grid-cols-2 gap-10">

                <!-- View Patient Profile -->
                <a href="Patient-Search"
                   class="flex flex-col items-center justify-center bg-white hover:bg-blue-50 p-10 rounded-2xl border border-blue-100 shadow-md hover:shadow-lg transition text-center">
                    <h3 class="font-bold text-2xl text-gray-800 mb-2">View Patient</h3>
                    <p class="text-gray-600 max-w-sm">
                        Easily search and view detailed information about your patients.
                    </p>
                </a>

                <!-- Manage Appointments -->
                <a href="Appointment-List"
                   class="flex flex-col items-center justify-center bg-white hover:bg-blue-50 p-10 rounded-2xl border border-blue-100 shadow-md hover:shadow-lg transition text-center">
                    <h3 class="font-bold text-2xl text-gray-800 mb-2">Manage Appointments</h3>
                    <p class="text-gray-600 max-w-sm">
                        View, update, or delete appointments for patients in just a few clicks.
                    </p>
                </a>

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

    </body>
</html>
