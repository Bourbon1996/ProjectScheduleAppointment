<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/shared/home/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chi tiết bác sĩ | ${doctor.user.fullName}</title>

<%@ include file="/shared/home/link.jsp" %>
</head>
<body class="bg-light-custom">
    <%@ include file="/shared/home/header.jsp" %>
    
    <main class="container my-5">
        <!-- Nút quay lại -->
        <div class="mb-4">
            <a href="${ctx}/doctor" class="back-link">
                <i class="bi bi-arrow-left"></i> Quay lại danh sách
            </a>
        </div>

        <div class="row">
            <div class="col-lg-4 col-md-5 mb-4 mb-md-0">
                <div class="detail-card profile-sidebar text-center">
                    <div class="avatar-large mx-auto mb-3">
                        <img alt="Bác sĩ ${doctor.user.fullName}" src="${ctx}/${doctor.avtUrl}">
                    </div>
                    
                    <div class="doctor-title-detail">${doctor.title}</div>
                    <h1 class="doctor-name-detail">${doctor.user.fullName}</h1>
                    <div class="doctor-dept-badge mb-4">${doctor.department.name}</div>
                    
                    <hr class="divider">
                    
                    <div class="quick-info text-start">
                        <div class="info-item">
                            <div class="info-icon"><i class="bi bi-cash-stack"></i></div>
                            <div class="info-text">
                                <span class="info-label">Giá khám:</span>
                                <strong><fmt:formatNumber value="${doctor.examinationFee}" type="number" maxFractionDigits="0"/> VNĐ</strong>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-icon"><i class="bi bi-award"></i></div>
                            <div class="info-text">
                                <span class="info-label">Kinh nghiệm:</span>
                                <strong>${doctor.experienceYears} năm</strong>
                            </div>
                        </div>
                    </div>
                    
                    <a href="${ctx}/appointment/${doctor.id}" class="btn-custom btn-primary-custom w-100 mt-4">
                        Đặt lịch khám ngay <i class="bi bi-calendar-check ms-1"></i>
                    </a>
                </div>
            </div>
            
            <div class="col-lg-8 col-md-7">
                <div class="detail-card description-section">
                    <h3 class="section-title">Giới thiệu chuyên môn</h3>
                    <div class="description-content">
                        ${doctor.description}
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="/shared/home/footer.jsp" %>    
</body>
</html>