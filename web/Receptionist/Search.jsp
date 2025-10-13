<%-- 
    Document   : Search Patient
    Created on : Oct 8, 2025, 5:37:36 PM
    Author     : Kiên
--%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>View / Search Patient</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
            }
            table {
                border-collapse: collapse;
                width: 90%;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 8px;
                text-align: center;
            }
            th {
                background-color: #f2f2f2;
            }
            input[type="text"] {
                padding: 6px;
                width: 250px;
            }
            button {
                padding: 6px 10px;
                background-color: #007bff;
                color: white;
                border: none;
                cursor: pointer;
            }
            button:hover {
                background-color: #0056b3;
            }
            .search-bar {
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <h2>🔍 View / Search Patient</h2>

        <!-- Form search -->
        <form action="PatientSearchServlet" method="get" class="search-bar">
            <input type="text" name="keyword" placeholder="Search by ID, name, or address"
                   value="${keyword != null ? keyword : ''}">
            <button type="submit">Search</button>
            <a href="PatientSearchServlet"><button type="button">Reset</button></a>
        </form>

        <!-- Nếu có lỗi -->
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>

        <!-- Bảng danh sách bệnh nhân -->
        <c:if test="${not empty patients}">
            <table>
                <tr>
                    <th>ID</th>
                    <th>User ID</th>
                    <th>Full Name</th>
                    <th>Date of Birth</th>
                    <th>Address</th>
                    <th>Insurance Info</th>
                    <th>Parent ID</th>
                </tr>

                <c:forEach var="p" items="${patients}">
                    <tr>
                        <td>${p.patientId}</td>
                        <td>${p.userId}</td>
                        <td>${p.fullName}</td>
                        <td><fmt:formatDate value="${p.dob}" pattern="yyyy-MM-dd" /></td>
                        <td>${p.address}</td>
                        <td>${p.insuranceInfo}</td>
                        <td>${p.parentId}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>

        <!-- Nếu không có dữ liệu -->
        <c:if test="${empty patients}">
            <p>Không tìm thấy bệnh nhân nào!</p>
        </c:if>
    </body>
</html>
