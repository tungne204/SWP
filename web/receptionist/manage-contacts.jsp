<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="entity.Contact" %>
<%@ page import="java.util.List" %>
<fmt:setLocale value="vi_VN"/>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh"/>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý liên hệ - Medilab</title>
        
        <!-- Include all CSS files -->
        <jsp:include page="../includes/head-includes.jsp"/>
        
        <style>
            :root {
                --primary-color: #3fbbc0;
                --primary-dark: #2a9fa4;
                --secondary-color: #2c4964;
            }
            
            body {
                background: linear-gradient(135deg, #e8f5f6 0%, #d4eef0 100%);
                min-height: 100vh;
                font-family: 'Roboto', sans-serif;
            }
            
            .main-wrapper {
                display: flex;
                min-height: 100vh;
                padding-top: 70px;
            }
            
            .sidebar-fixed {
                width: 280px;
                background: white;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
                position: fixed;
                top: 70px;
                left: 0;
                height: calc(100vh - 70px);
                overflow-y: auto;
                z-index: 1000;
            }
            
            .content-area {
                flex: 1;
                margin-left: 280px;
                padding: 2rem;
            }
            
            .page-header {
                background: linear-gradient(135deg, #3fbbc0 0%, #2a9fa4 100%);
                color: white;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }
            
            .page-header h2 {
                margin: 0;
                font-size: 2rem;
                font-weight: 700;
            }
            
            .contact-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
                transition: all 0.3s;
                border-left: 4px solid #3fbbc0;
            }
            
            .contact-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
            }
            
            .contact-card.pending {
                border-left-color: #ffc107;
            }
            
            .contact-card.reviewed {
                border-left-color: #28a745;
                opacity: 0.9;
            }
            
            .status-badge {
                display: inline-block;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
            }
            
            .status-pending {
                background: #fff3cd;
                color: #856404;
            }
            
            .status-reviewed {
                background: #d4edda;
                color: #155724;
            }
            
            .btn-mark-reviewed {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
                border: none;
                padding: 8px 20px;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s;
            }
            
            .btn-mark-reviewed:hover {
                background: linear-gradient(135deg, #20c997 0%, #28a745 100%);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
            }
            
            .contact-info {
                margin-bottom: 15px;
            }
            
            .contact-info strong {
                color: #2c4964;
                margin-right: 8px;
            }
            
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }
            
            .empty-state i {
                font-size: 4rem;
                margin-bottom: 20px;
                color: #dee2e6;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <%@ include file="../includes/header.jsp" %>

        <div class="main-wrapper">
            <!-- Sidebar -->
            <%@ include file="../includes/sidebar-receptionist.jsp" %>

            <!-- Main Content -->
            <div class="content-area">
                <div class="page-header">
                    <h2><i class="bi bi-envelope-check me-2"></i>Quản lý liên hệ</h2>
                    <p class="mb-0 mt-2">Xem và quản lý các tin nhắn từ người dùng</p>
                </div>

                <!-- Success/Error Messages -->
                <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= request.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>

                <!-- Contact List -->
                <%
                    List<Contact> contacts = (List<Contact>) request.getAttribute("contacts");
                    if (contacts == null || contacts.isEmpty()) {
                %>
                <div class="empty-state">
                    <i class="bi bi-inbox"></i>
                    <h3>Chưa trả lời</h3>
                    <p>Hệ thống chưa nhận được tin nhắn liên hệ nào từ người dùng.</p>
                </div>
                <% } else { %>
                
                <div class="row">
                    <c:forEach var="contact" items="${contacts}">
                        <div class="col-12">
                            <div class="contact-card ${contact.status == 'pending' ? 'pending' : 'reviewed'}">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h5 class="mb-2">
                                            <i class="bi bi-person me-2"></i>${contact.fullName}
                                        </h5>
                                        <span class="status-badge ${contact.status == 'pending' ? 'status-pending' : 'status-reviewed'}">
                                            ${contact.status == 'pending' ? 'Chưa đọc' : 'Đã đọc'}
                                        </span>
                                    </div>
                                    <div class="text-end">
                                        <small class="text-muted d-block">
                                            <i class="bi bi-clock me-1"></i>
                                            <fmt:formatDate value="${contact.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </div>
                                </div>
                                
                                <div class="contact-info">
                                    <div class="mb-2">
                                        <strong>Email:</strong> 
                                        <a href="mailto:${contact.email}">${contact.email}</a>
                                    </div>
                                    <c:if test="${not empty contact.subject}">
                                        <div class="mb-2">
                                            <strong>Tiêu Đề:</strong> ${contact.subject}
                                        </div>
                                    </c:if>
                                    <div class="mb-3">
                                        <strong>Nội Dung:</strong>
                                        <p class="mb-0 mt-1" style="white-space: pre-wrap;">${contact.message}</p>
                                    </div>
                                </div>
                                
                                <c:if test="${contact.status == 'pending'}">
                                    <form method="POST" action="manage-contacts" class="d-inline">
                                        <input type="hidden" name="action" value="markReviewed">
                                        <input type="hidden" name="contactId" value="${contact.contactId}">
                                        <button type="submit" class="btn btn-mark-reviewed">
                                            <i class="bi bi-check-circle me-2"></i>Đánh dấu đã đọc
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <% } %>
            </div>
        </div>

        

    </body>
</html>

