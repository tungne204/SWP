<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Test Result</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #34495e;
            font-weight: 600;
        }

        label .required {
            color: #e74c3c;
        }

        input[type="text"],
        input[type="date"],
        input[type="number"],
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #3498db;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            transition: all 0.3s;
            font-weight: 600;
        }

        .btn-success {
            background: #27ae60;
            color: white;
        }

        .btn-success:hover {
            background: #229954;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
        }

        .help-text {
            font-size: 13px;
            color: #7f8c8d;
            margin-top: 5px;
        }

        .select-info {
            background: #ecf0f1;
            padding: 10px;
            border-radius: 5px;
            font-size: 13px;
            color: #34495e;
            margin-top: 5px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>
            <i class="fas fa-plus-circle"></i>
            Add New Test Result
        </h1>

        <form action="testresult" method="post">
            <input type="hidden" name="action" value="insert">

            <div class="form-group">
                <label for="recordId">
                    Medical Record <span class="required">*</span>
                </label>
                <select id="recordId" name="recordId" required>
                    <option value="">-- Select Medical Record --</option>
                    <c:forEach var="report" items="${medicalReports}">
                        <option value="${report.recordId}">
                            Record #${report.recordId} - ${report.patientName} (${report.diagnosis})
                        </option>
                    </c:forEach>
                </select>
                <div class="help-text">
                    Select the medical record that requested this test
                </div>
            </div>

            <div class="form-group">
                <label for="testType">
                    Test Type <span class="required">*</span>
                </label>
                <select id="testType" name="testType" required>
                    <option value="">-- Select Test Type --</option>
                    <option value="Blood Test">Blood Test</option>
                    <option value="Urine Test">Urine Test</option>
                    <option value="X-Ray">X-Ray</option>
                    <option value="CT Scan">CT Scan</option>
                    <option value="MRI">MRI</option>
                    <option value="Ultrasound">Ultrasound</option>
                    <option value="ECG">ECG</option>
                    <option value="Allergy Test">Allergy Test</option>
                    <option value="Other">Other</option>
                </select>
                <div class="help-text">
                    Type of medical test performed
                </div>
            </div>

            <div class="form-group">
                <label for="result">
                    Test Result <span class="required">*</span>
                </label>
                <textarea id="result" name="result" required placeholder="Enter detailed test results..."></textarea>
                <div class="help-text">
                    Enter the complete test results and findings
                </div>
            </div>

            <div class="form-group">
                <label for="date">
                    Test Date <span class="required">*</span>
                </label>
                <input type="date" id="date" name="date" required max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                <div class="help-text">
                    Date when the test was conducted
                </div>
            </div>

            <div class="form-group">
                <label for="consultationId">
                    Consultation ID (Optional)
                </label>
                <input type="number" id="consultationId" name="consultationId" placeholder="Enter consultation ID if applicable">
                <div class="help-text">
                    Link this test result to a specific consultation (if applicable)
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> Save Test Result
                </button>
                <a href="testresult?action=list" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </form>
    </div>

    <script>
        // Set today's date as default
        document.getElementById('date').valueAsDate = new Date();
    </script>
</body>
</html>