<%-- 
    Document   : Receptionist Dashboard
    Created on : Oct 18, 2025, 10:37:08 PM
    Author     : KiênPC
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Receptionist Dashboard | Clinic Manager</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="flex bg-gray-50 text-gray-800 font-sans">

    <!-- Sidebar -->
    <aside class="w-64 bg-emerald-700 text-white flex flex-col justify-between fixed h-screen shadow-lg">
        <div>
            <!-- Logo + Title -->
            <div class="flex items-center gap-3 p-6 border-b border-emerald-600">
                <span class="text-3xl">🩺</span>
                <div>
                    <h2 class="text-lg font-bold leading-tight">Receptionist</h2>
                    <p class="text-xs text-emerald-200">Clinic Manager</p>
                </div>
            </div>

            <!-- Navigation -->
            <nav class="mt-6">
                <a href="Patient-Search"
                   class="flex items-center gap-2 py-3 px-6 hover:bg-emerald-600 transition-all duration-200">
                    👶 <span>View/Search Patient</span>
                </a>
                <a href="Appointment-List"
                   class="flex items-center gap-2 py-3 px-6 hover:bg-emerald-600 transition-all duration-200">
                    📋 <span>Manage Appointments</span>
                </a>
            </nav>
        </div>

        <!-- Logout -->
        <div class="p-6 border-t border-emerald-600">
            <a href="logout.jsp"
               class="flex justify-center items-center gap-2 bg-red-600 hover:bg-red-700 py-2 rounded-lg font-semibold transition">
                🔒 Logout
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 ml-64 p-8">
        <!-- Header -->
        <header class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-emerald-700 flex items-center gap-2">
                <span>🏥</span> Receptionist Management System
            </h1>
            <span class="text-sm text-gray-500">v1.0 | Pediatric Clinic Manager</span>
        </header>

        <!-- Welcome Card -->
        <section class="bg-white p-8 rounded-2xl shadow-md border border-emerald-100">
            <h2 class="text-xl font-semibold mb-2 text-emerald-700">👋 Welcome, Receptionist!</h2>
            <p class="text-gray-600 leading-relaxed">
                Use the sidebar to manage <b>patient records</b> and <b>appointments</b>.  
                You can <b>view</b>, <b>update</b>, or <b>delete</b> appointments as required.
            </p>
        </section>

        <!-- Footer -->
        <footer class="mt-10 text-center text-gray-500 text-sm">
            © 2025 Pediatric Clinic Manager | Designed by <span class="font-semibold text-emerald-700">Kiên</span>
        </footer>
    </main>

</body>
</html>
