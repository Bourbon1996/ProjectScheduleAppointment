<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/site/shared/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Khoa ${department.name}</title>

    <link rel="icon" type="image/png" href="${ctx}/assets/img/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/client/index.css">
    <link rel="stylesheet" href="${ctx}/assets/css/client/auth.css">
    <link rel="stylesheet" href="${ctx}/assets/css/client/doctor.css">
</head>
<body class="bg-light-custom">
    <%@ include file="/site/shared/header.jsp" %>
    
    <main class="container my-5">
        <!-- Banner/Header for department -->
        <div class="row align-items-center mb-5 bg-white p-4 rounded-4 shadow-sm border border-light">
            <div class="col-md-3 text-center">
                <img src="${ctx}${department.imageUrl}" class="img-fluid rounded-3 mb-3 mb-md-0" alt="${department.name}" style="max-height: 150px; object-fit: contain; filter: drop-shadow(0 4px 6px rgba(0,0,0,0.1));">
            </div>
            <div class="col-md-9">
                <h1 class="fw-bold text-primary mb-3">${department.name}</h1>
                <p class="text-muted fs-6 lh-lg">${department.description}</p>
                <div class="d-inline-block bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-3 fw-bold border border-primary-subtle mt-2">
                    <i class="bi bi-wallet2 me-2"></i> Giá khám cơ bản: 
                    <span class="ms-1">
                        <fmt:setLocale value="vi_VN" />
                        <fmt:formatNumber value="${department.basePrice}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
                    </span>
                </div>
            </div>
        </div>

        <h3 class="page-title mb-4 border-bottom pb-2">Danh sách bác sĩ Khoa ${department.name}</h3>
        
        <!-- Vùng chứa danh sách bác sĩ -->
        <div class="doctor-grid" id="doctor-list-container"> 
            <c:if test="${empty listDoctor}">
                <div class="col-12 text-center py-5" style="grid-column: 1 / -1;">
                    <i class="bi bi-person-x text-muted" style="font-size: 4rem;"></i>
                    <h5 class="text-muted mt-3">Hiện chưa có bác sĩ nào thuộc chuyên khoa này.</h5>
                </div>
            </c:if>

            <c:forEach items="${listDoctor}" var="doctor">
                <article class="doctor-card">
                    <div class="doctor-icon-badge">
                        <img alt="Icon khoa" src="${ctx}${doctor.department.imageUrl}">
                    </div>

                    <div class="doctor-info">
                        <div class="doctor-avatar">
                            <img alt="Hình ảnh bác sĩ ${doctor.user.fullName}" src="${ctx}${doctor.avtUrl}">
                        </div>
                        
                        <div class="doctor-details">
                            <div class="doctor-title">${doctor.title}</div>
                            <h3 class="doctor-name">${doctor.user.fullName}</h3>
                            <div class="doctor-department">${doctor.department.name}</div>
                        </div>
                    </div>
                    
                    <div class="doctor-actions">
                        <a href="${ctx}/doctor/detail/${doctor.id}" class="btn-custom btn-outline-primary-custom">
                            Xem hồ sơ <i class="bi bi-chevron-right"></i>
                        </a>
                        <a href="${ctx}/appointment?doctorId=${doctor.id}" class="btn-custom btn-primary-custom">
                            Đặt lịch khám <i class="bi bi-calendar-event"></i>
                        </a>
                    </div>
                </article>
            </c:forEach>
        </div>
        
    </main>
    
    <%@ include file="/site/shared/footer.jsp" %>
    
</body>
</html>
