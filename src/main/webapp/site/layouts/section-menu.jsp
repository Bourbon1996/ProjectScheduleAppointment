<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<section class="section-menu-wrapper">
    <h2 class="menu-title">Bạn cần khám chữa bệnh</h2>

    <div class="menu-container">
        
        <!-- Về Chuyên khoa -->
        <a href="#dept" class="menu-item">
            <div class="icon-box">
                <img src="${pageContext.request.contextPath}/assets/img/departments/icon-ve-chuyen-khoa.webp" alt="Chuyên khoa">
            </div>
            <span>Về Chuyên khoa</span>
        </a>

        <!-- Tìm Bác sĩ -->
        <a href="${ctx}/home/doctor" class="menu-item">
            <div class="icon-box">
                <img src="${pageContext.request.contextPath}/assets/img/departments/icon-tim-bac-si.webp" alt="Tìm Bác sĩ">
            </div>
            <span>Tìm Bác sĩ</span>
        </a>

        <!-- Lịch khám bệnh -->
        <a href="${ctx}/appointment/history" class="menu-item">
            <div class="icon-box">
                <img src="${pageContext.request.contextPath}/assets/img/departments/icon-lich-kham-benh.webp" alt="Lịch khám">
            </div>
            <span>Lịch sử khám bệnh</span>
        </a>

        <!-- Đặt lịch khám -->
        <a href="${ctx}/appointment" class="menu-item">
            <div class="icon-box">
                <img src="${pageContext.request.contextPath}/assets/img/departments/icon-dat-lich-kham.webp" alt="Đặt lịch">
            </div>
            <span>Đặt lịch khám</span>
        </a>

        <!-- Dịch vụ -->
        <a href="#" class="menu-item">
            <div class="icon-box">
                <img src="${pageContext.request.contextPath}/assets/img/departments/icon-dich-vu.webp" alt="Dịch vụ">
            </div>
            <span>Dịch vụ</span>
        </a>

        <!-- Hỗ trợ người bệnh -->
        <a href="#" class="menu-item">
            <div class="icon-box">
                <img src="${pageContext.request.contextPath}/assets/img/departments/icon-ho-tro-nguoi-benh.webp" alt="Hỗ trợ">
            </div>
            <span>Hỗ trợ người bệnh</span>
        </a>

    </div>
</section>