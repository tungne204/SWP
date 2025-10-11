<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Appointments</title>
</head>
<body>
    <h2>Manage Appointments</h2>
    <hr>

    <table border="1" cellpadding="6" cellspacing="0">
        <tr style="background-color:#e9e9e9;">
            <th>ID</th>
            <th>Patient ID</th>
            <th>Doctor ID</th>
            <th>Date/Time</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        <c:forEach var="a" items="${appointments}">
            <tr>
                <form action="UpdateAppointmentServlet" method="post">
                    <td>${a.appointmentId}
                        <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                    </td>
                    <td><input type="text" name="patientId" value="${a.patientId}" size="5"></td>
                    <td><input type="text" name="doctorId" value="${a.doctorId}" size="5"></td>
                    <td>
                        <input type="datetime-local" name="dateTime"
                               value="${a.dateTime.toInstant().toString().substring(0,16)}">
                    </td>
                    <td>
                        <select name="status">
                            <option value="true" ${a.status ? "selected" : ""}>Confirmed</option>
                            <option value="false" ${!a.status ? "selected" : ""}>Pending</option>
                        </select>
                    </td>
                    <td>
                        <button type="submit">Update</button>
                    </td>
                </form>
                <td>
                    <form action="DeleteAppointmentServlet" method="post">
                        <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                        <button type="submit" style="background-color:red;color:white;">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
