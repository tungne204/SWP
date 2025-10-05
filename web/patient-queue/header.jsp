<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="sticky top-0 z-50 bg-white shadow">
    <div class="bg-gray-100 py-2 px-4">
        <div class="container mx-auto flex flex-col md:flex-row justify-between items-center">
            <div class="flex items-center space-x-4 mb-2 md:mb-0">
                <div class="flex items-center">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                    </svg>
                    <a href="mailto:contact@example.com" class="text-sm">contact@example.com</a>
                </div>
                <div class="flex items-center ml-4">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path>
                    </svg>
                    <span class="text-sm">+1 5589 55488 55</span>
                </div>
            </div>
            <div class="hidden md:flex items-center space-x-3">
                <a href="#" class="text-gray-600 hover:text-blue-500">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"></path>
                    </svg>
                </a>
                <a href="#" class="text-gray-600 hover:text-blue-500">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.879V14.89h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.989C18.343 21.129 22 16.99 22 12z"></path>
                    </svg>
                </a>
                <a href="#" class="text-gray-600 hover:text-pink-500">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.336 0 8.744 0 12c0 3.258.014 3.668.072 4.948.2 4.36 2.618 6.78 6.98 6.98C8.336 23.986 8.744 24 12 24c3.258 0 3.668-.014 4.948-.072 4.362-.2 6.782-2.618 6.98-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.948-.196-4.361-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.849 1.44 1.44 0 000-2.849z"></path>
                    </svg>
                </a>
                <a href="#" class="text-gray-600 hover:text-blue-700">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 01-2.063-2.065 2.064 2.064 0 112.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"></path>
                    </svg>
                </a>
            </div>
        </div>
    </div>

    <div class="bg-white py-4 px-4">
        <div class="container mx-auto flex flex-col md:flex-row items-center justify-between">
            <a href="<c:url value="/Home.jsp"/>" class="flex items-center mb-4 md:mb-0">
                <h1 class="text-2xl font-bold text-blue-600">Medilab</h1>
            </a>

            <nav class="w-full md:w-auto">
                <ul class="flex flex-col md:flex-row space-y-2 md:space-y-0 md:space-x-8 items-center">
                    <li><a href="<c:url value="/Home.jsp"/>" class="text-gray-600 hover:text-blue-600">Trang Chủ</a></li>
                    <li><a href="<c:url value="/patient-queue?action=view"/>" class="text-blue-600 font-medium">Hàng Đợi</a></li>
                    <li><a href="#statistics" class="text-gray-600 hover:text-blue-600">Thống Kê</a></li>
                </ul>
            </nav>

            <% if (acc == null) { %>
            <a class="hidden md:block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition" href="<c:url value="/Login.jsp"/>">Login</a>
            <% } else { %>
            <div class="flex items-center mt-4 md:mt-0">
                <span class="text-gray-700 mr-4">
                    Hello, <%= acc.getUsername() %>
                </span>
                <a class="bg-gray-200 text-gray-800 px-4 py-2 rounded hover:bg-gray-300 transition" href="<c:url value="/logout"/>">Logout</a>
            </div>
            <% } %>
        </div>
    </div>
</header>