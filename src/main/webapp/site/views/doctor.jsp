<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/site/shared/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh sách bác sĩ</title>

    <!-- Cài đặt Favicon cho web -->
	<link rel="icon" type="image/png" href="${ctx}/assets/img/logo.png">

    <!-- Bootstrap CSS: vẫn giữ để dùng cho navbar -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons: dùng icon người dùng và icon con mắt -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

    <!-- CSS trang chủ -->
    <link rel="stylesheet"
          href="${ctx}/assets/css/client/index.css">
          
    <!-- CSS popup đăng nhập -->
    <link rel="stylesheet"
          href="${ctx}/assets/css/client/auth.css">
          
    <!-- CSS doctor -->
    <link rel="stylesheet"
          href="${ctx}/assets/css/client/doctor.css">
</head>
<body class="bg-light-custom">
    <%@ include file="/site/shared/header.jsp" %>
    
    <main class="container my-5">
        <h2 class="page-title mb-4">Danh sách bác sĩ</h2>
        
        <!-- Vùng chứa danh sách bác sĩ -->
<div class="doctor-grid" id="doctor-list-container"> 
    <c:forEach items="${listDoctor}" var="doctor">
        <article class="doctor-card">
            <!-- Icon y tế góc phải (sử dụng ảnh động từ khoa) -->
            <div class="doctor-icon-badge">
                <!-- Nếu không có ảnh động, có thể để lại thẻ <i class="bi bi-lungs"></i> -->
                <img alt="Icon khoa" src="${ctx}${doctor.department.imageUrl}">
            </div>

            <!-- Phần thông tin phía trên -->
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
        
        <!-- Vùng chứa nút phân trang -->
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center" id="pagination-controls">
                <!-- JavaScript sẽ render các nút phân trang vào đây -->
            </ul>
        </nav>
        
    </main>
    
    <%@ include file="/site/shared/footer.jsp" %>
    
    <!-- Script xử lý phân trang -->
    <script src="${ctx}/assets/js/client/doctor-pagination.js"></script>
</body>
</html>