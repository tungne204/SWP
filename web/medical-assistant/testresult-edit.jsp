<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Test Result</title>
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

        .info-box {
            background: #e8f4f8;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #3498db;
        }

        .info-box p {
            margin: 5px 0;
            color: #2c3e50;
        }

        .info-box strong {
            color: #3498db;
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

        .btn-primary {
            background: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
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
            <i class="fas fa-edit"></i>
            Edit Test Result #${testResult.testId}
        </h1>

        <div class="info-box">
            <p><strong>Patient:</strong> ${testResult.patientName}</p>
            <p><strong>Doctor:</strong> ${testResult.doctorName}</p>
            <p><strong>Diagnosis:</strong> ${testResult.diagnosis}</p>
        </div>

        <form action="testresult" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="testId" value="${testResult.testId}">

            <div class="form-group">
                <label for="recordId">
                    Medical Record <span class="required">*</span>
                </label>
                <select id="recordId" name="recordId" required>
                    <c:forEach var="report" items="${medicalReports}">
                        <option value="${report.recordId}" 
                                ${report.recordId == testResult.recordId ? 'selected' : ''}>
                            Record #${report.recordId} - ${report.patientName} (${report.diagnosis})
                        </option>
                    </c:forEach>
                </select>
                <div class="help-text">
                    Medical record associated with this test
                </div>
            </div>

            <div class="form-group">
                <label for="testType">
                    Test Type <span class="required">*</span>
                </label>
                <select id="testType" name="testType" required>
                    <option value="Blood Test" ${testResult.testType == 'Blood Test' ? 'selected' : ''}>Blood Test</option>
                    <option value="Urine Test" ${testResult.testType == 'Urine Test' ? 'selected' : ''}>Urine Test</option>
                    <option value="X-Ray" ${testResult.testType == 'X-Ray' ? 'selected' : ''}>X-Ray</option>
                    <option value="CT Scan" ${testResult.testType == 'CT Scan' ? 'selected' : ''}>CT Scan</option>
                    <option value="MRI" ${testResult.testType == 'MRI' ? 'selected' : ''}>MRI</option>
                    <option value="Ultrasound" ${testResult.testType == 'Ultrasound' ? 'selected' : ''}>Ultrasound</option>
                    <option value="ECG" ${testResult.testType == 'ECG' ? 'selected' : ''}>ECG</option>
                    <option value="Allergy Test" ${testResult.testType == 'Allergy Test' ? 'selected' : ''}>Allergy Test</option>
                    <option value="Other" ${testResult.testType == 'Other' ? 'selected' : ''}>Other</option>
                </select>
                <div class="help-text">
                    Type of medical test performed
                </div>
            </div>

            <div class="form-group">
                <label for="result">
                    Test Result <span class="required">*</span>
                </label>
                <textarea id="result" name="result" required>${testResult.result}</textarea>
                <div class="help-text">
                    Complete test results and findings
                </div>
            </div>

            <div class="form-group">
                <label for="date">
                    Test Date <span class="required">*</span>
                </label>
                <input type="date" id="date" name="date" value="${testResult.date}" required>
                <div class="help-text">
                    Date when the test was conducted
                </div>
            </div>

            <div class="form-group">
                <label for="consultationId">
                    Consultation ID (Optional)
                </label>
                <input type="number" id="consultationId" name="consultationId" 
                       value="${testResult.consultationId != null ? testResult.consultationId : ''}" 
                       placeholder="Enter consultation ID if applicable">
                <div class="help-text">
                    Link this test result to a specific consultation
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Update Test Result
                </button>
                <a href="testresult?action=list" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </form>
    </div>
</body>
</html>