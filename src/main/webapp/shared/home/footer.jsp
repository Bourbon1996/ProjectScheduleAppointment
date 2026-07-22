<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="umc-footer pt-5 pb-3 mt-5">
    <div class="container">
        <div class="row gy-4">
            
            <!-- Cột 1: Thông tin thương hiệu (Đã được bọc trong khung Box để chống lệch) -->
            <div class="col-lg-4 col-md-12 mb-4">
                <div class="brand-box h-100">
                    
                    <div class="text-center mb-4 pb-3 brand-border-bottom">
                        <img src="${pageContext.request.contextPath}/img/logo.png" 
                             alt="Logo DHAK" 
                             style="height: 75px; max-width: 100%; object-fit: cover;">
                    </div>
                    
                    <!-- Thông tin liên hệ -->
                    <ul class="list-unstyled contact-info m-0">
                        <li class="d-flex mb-3">
                            <i class="bi bi-geo-alt-fill me-3 mt-1"></i> 
                            <span class="text-muted small">Tòa nhà Innovation, Lô 24 Công viên phần mềm Quang Trung, P. Tân Chánh Hiệp, Quận 12, TP.HCM</span>
                        </li>
                        <li class="d-flex mb-3 align-items-center">
                            <i class="bi bi-envelope-fill me-3"></i> 
                            <span class="text-muted small">contact@caodang.fpt.edu.vn</span>
                        </li>
                        <li class="d-flex align-items-center">
                            <i class="bi bi-telephone-fill me-3"></i> 
                            <span class="fw-bold" style="color: var(--text-color);">1900 1234 (CSKH)</span>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Cột 2: Giờ làm việc (Style gốc) -->
            <div class="col-lg-3 col-md-6">
                <h5 class="footer-title mb-4">Giờ làm việc</h5>
                <ul class="list-unstyled work-hours">
                    <li class="d-flex justify-content-between mb-3 border-bottom pb-2">
                        <span>Thứ 2 - Thứ 6:</span> <strong>06:30 - 16:30</strong>
                    </li>
                    <li class="d-flex justify-content-between mb-3 border-bottom pb-2">
                        <span>Thứ 7:</span> <strong>06:30 - 11:30</strong>
                    </li>
                    <li class="d-flex justify-content-between mb-3 border-bottom pb-2">
                        <span>Chủ nhật:</span> <strong class="text-danger">Nghỉ khám</strong>
                    </li>
                    <!-- Điểm nhấn khẩn cấp -->
                    <li class="d-flex justify-content-between mt-3 pt-2 bg-light rounded p-2 border-start border-danger border-4">
                        <span class="text-danger fw-bold">CẤP CỨU:</span> <strong class="text-danger">24/7</strong>
                    </li>
                </ul>
            </div>

            <!-- Cột 3: Liên kết nhanh (Style gốc) -->
            <div class="col-lg-2 col-md-6">
                <h5 class="footer-title mb-4">Liên kết nhanh</h5>
                <ul class="list-unstyled footer-links">
                    <li class="mb-3"><a href="#">Về bệnh viện</a></li>
                    <li class="mb-3"><a href="#">Danh sách Chuyên khoa</a></li>
                    <li class="mb-3"><a href="#">Đội ngũ Bác sĩ</a></li>
                    <li class="mb-3"><a href="#">Tra cứu kết quả</a></li>
                    <li class="mb-3"><a href="#">Hướng dẫn khách hàng</a></li>
                </ul>
            </div>

            <!-- Cột 4: Mạng xã hội & Tải ứng dụng (Style gốc) -->
            <div class="col-lg-3 col-md-6">
                <h5 class="footer-title mb-4">Kết nối với chúng tôi</h5>
                <div class="social-links mb-4">
                    <a href="#" class="me-2"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="me-2"><i class="bi bi-youtube"></i></a>
                    <a href="#" class="me-2"><i class="bi bi-tiktok"></i></a>
                </div>
                
                <h5 class="footer-title mb-3 mt-4">Tải ứng dụng đặt lịch</h5>
                <div class="d-flex gap-2">
                    <div class="app-badge bg-white border p-2 rounded text-center w-50">
                        <i class="bi bi-apple fs-4"></i><br>
                        <small class="fw-bold">App Store</small>
                    </div>
                    <div class="app-badge bg-white border p-2 rounded text-center w-50">
                        <i class="bi bi-google-play fs-4 text-success"></i><br>
                        <small class="fw-bold">Google Play</small>
                    </div>
                </div>
            </div>
        </div>
        
        
        <hr class="mt-5 mb-4" style="border-color: #d1d5db;">
        
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                <p class="mb-0 text-muted small">&copy; 2026 Đồ án Đặt Lịch Khám. All rights reserved.</p>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="#" class="text-muted small me-3 text-decoration-none">Chính sách bảo mật</a>
                <a href="#" class="text-muted small text-decoration-none">Điều khoản sử dụng</a>
            </div>
        </div>
    </div>
</div>