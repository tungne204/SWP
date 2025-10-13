<%-- 
    Document   : Search Patient
    Created on : Oct 8, 2025, 5:37:36 PM
    Author     : KiênPC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Search Patient</title>
  <!-- Tailwind Play CDN (tiện để demo; production nên build riêng) -->
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-50 min-h-screen text-slate-800">
  <div class="max-w-6xl mx-auto px-4 py-8">
    <!-- header -->
    <div class="flex items-end justify-between gap-4">
      <div>
        <h1 class="text-2xl font-semibold tracking-tight">Patient Search</h1>
        <p class="text-sm text-slate-500">Search is sent via <span class="font-medium">POST</span> to protect sensitive data.</p>
      </div>
      <c:if test="${not empty keyword}">
        <span class="text-sm px-2 py-1 rounded-md bg-emerald-100 text-emerald-700">
          Keyword: <span class="font-medium">${keyword}</span>
        </span>
      </c:if>
    </div>

    <!-- search form -->
    <form action="Patient-Search" method="post" class="mt-6">
      <div class="flex flex-col sm:flex-row gap-3">
        <input
          type="text" name="keyword" value="${keyword}"
          placeholder="Nhập tên, ID, hoặc địa chỉ bệnh nhân…"
          class="w-full sm:flex-1 rounded-xl border border-slate-300 bg-white px-4 py-2.5 outline-none focus:border-sky-500 focus:ring-2 focus:ring-sky-200"
        />
        <div class="flex gap-2">
          <button
            type="submit"
            class="inline-flex items-center justify-center rounded-xl bg-sky-600 px-5 py-2.5 text-white font-medium hover:bg-sky-700 active:bg-sky-800 transition">
            Tìm kiếm
          </button>
          <a
            href="Patient-Search"
            class="inline-flex items-center justify-center rounded-xl border border-slate-300 bg-white px-4 py-2.5 text-slate-700 hover:bg-slate-100">
            Reset
          </a>
        </div>
      </div>
    </form>

    <!-- result table / empty state -->
    <div class="mt-8">
      <c:if test="${empty patients}">
        <div class="rounded-2xl border border-dashed border-slate-300 bg-white p-10 text-center">
          <p class="text-slate-500">Không có dữ liệu bệnh nhân để hiển thị.</p>
          <p class="text-slate-400 text-sm mt-1">Hãy nhập từ khóa và nhấn <span class="font-medium text-slate-600">Tìm kiếm</span>.</p>
        </div>
      </c:if>

      <c:if test="${not empty patients}">
        <div class="overflow-hidden rounded-2xl border border-slate-200 shadow-sm bg-white">
          <div class="max-h-[65vh] overflow-auto">
            <table class="w-full text-left">
              <thead class="sticky top-0 bg-slate-100/90 backdrop-blur z-10">
                <tr class="text-slate-600 text-sm">
                  <th class="px-4 py-3 font-semibold">ID</th>
                  <th class="px-4 py-3 font-semibold">Full Name</th>
                  <th class="px-4 py-3 font-semibold">Address</th>
                  <th class="px-4 py-3 font-semibold">Phone</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-slate-100">
                <c:forEach var="p" items="${patients}">
                  <tr class="hover:bg-slate-50">
                    <td class="px-4 py-3 text-slate-700 font-medium">${p.patientId}</td>
                    <td class="px-4 py-3">${p.fullName}</td>
                    <td class="px-4 py-3 text-slate-600">${p.address}</td>
                    <td class="px-4 py-3 text-slate-600">
                      ${p.phone != null ? p.phone : '-'}
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </c:if>
    </div>
  </div>
</body>
</html>
