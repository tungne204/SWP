<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả xét nghiệm - Hồ sơ #${recordId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .header-section {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .card {
            border: none;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .test-card {
            border-left: 4px solid #11998e;
            transition: all 0.3s;
        }
        .test-card:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .result-box {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            border: 2px dashed #11998e;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header-section">
        <div class="container">
            <h1>
                <i class="fas fa-flask"></i> 
                Kết quả xét nghiệm - Hồ sơ #${recordId}
            </h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 text-white">
                    <li class="breadcrumb-item">
                        <a href="medical-report?action=list" class="text-white">Đơn thuốc</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="test-result?action=list" class="text-white">Xét nghiệm</a>
                    </li>
                    <li class="breadcrumb-item active text-white-50">Hồ sơ #${recordId}</li>
                </ol>
            </nav>
        </div>
    </div