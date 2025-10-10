<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Appointments</title>
</head>
<body>
    <h2>Appointment List</h2>

    <table border="1" cellpadding="6" cellspacing="0">
        <tr style="background-color: #f2f2f2;">
            <th>ID</th>
            <th>Patient ID</th>
            <th>Doctor ID</th>
            <th>Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        <c:forEach var="a" items="${appointments}">
            <tr>
                <td>${a.appointmentId}</td>
                <td>${a.patientId}</td>
                <td>${a.doctorId}</td>
                <td>${a.dateTime}</td>
                <td>
                    <c:choose>
                        <c:when test="${a.status}">✅ Confirmed</c:when>
                        <c:otherwise>⏳ Pending</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <form action="ChangeAppointmentStatusServlet" method="post">
                        <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                        <select name="status">
                            <option value="true" ${a.status ? "selected" : ""}>Confirmed</option>
                            <option value="false" ${!a.status ? "selected" : ""}>Pending</option>
                        </select>
                        <button type="submit">Update</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
