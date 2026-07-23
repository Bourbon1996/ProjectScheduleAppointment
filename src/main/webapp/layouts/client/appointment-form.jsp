<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<div class="modal fade umc-modal" id="createProfileModal" tabindex="-1" aria-labelledby="modalTitle" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            
            <!-- HEADER -->
            <div class="modal-header text-white">
                <h5 class="modal-title fw-bold" id="modalTitle">
                    <i class="bi bi-person-vcard me-2"></i>TẠO HỒ SƠ BỆNH NHÂN MỚI
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <!-- BODY -->
            <div class="modal-body p-4">
                <!-- Thêm action trỏ về Servlet và method="POST" -->
				<form id="newProfileForm" action="${pageContext.request.contextPath}/patient/create" method="POST">
				    
				    <div class="row g-3 mb-4">
				        <!-- BẮT BUỘC THÊM THUỘC TÍNH name="..." CHO TẤT CẢ INPUT / SELECT -->
				        <div class="col-md-6">
				            <label class="umc-form-label">Họ và tên bệnh nhân <span class="text-danger">*</span></label>
				            <input type="text" class="form-control umc-input umc-input-name" name="fullName" required style="text-transform: uppercase;">
				        </div>
				
				        <div class="col-md-6">
				            <label class="umc-form-label">Mối quan hệ với bạn <span class="text-danger">*</span></label>
				            <select class="form-select umc-input" name="relationship" required>
				                <option value="BAN_THAN">Bản thân (Tài khoản chính)</option>
				                <option value="CHA_ME">Cha / Mẹ</option>
				                <option value="CON_CAI">Con cái</option>
				                <option value="VO_CHONG">Vợ / Chồng</option>
				                <option value="KHAC">Người thân khác</option>
				            </select>
				        </div>
				
				        <div class="col-md-6">
				            <label class="umc-form-label">Ngày sinh <span class="text-danger">*</span></label>
				            <input type="date" class="form-control umc-input" name="dob" required>
				        </div>
				
				        <div class="col-md-6">
				            <label class="umc-form-label">Giới tính <span class="text-danger">*</span></label>
				            <select class="form-select umc-input" name="gender" required>
				                <option value="Nam">Nam</option>
				                <option value="Nữ">Nữ</option>
				                <option value="Khác">Khác</option>
				            </select>
				        </div>
				        
				        <div class="col-md-6">
				            <label class="umc-form-label">Số điện thoại liên hệ <span class="text-danger">*</span></label>
				            <input type="tel" class="form-control umc-input" name="phone" required>
				        </div>
				
				        <div class="col-md-6">
				            <label class="umc-form-label">SĐT người thân khẩn cấp</label>
				            <input type="tel" class="form-control umc-input" name="emergency">
				        </div>
				
				        <div class="col-12">
				            <label class="umc-form-label">Mã Bảo hiểm y tế (BHYT)</label>
				            <input type="text" class="form-control umc-input" name="bhyt">
				        </div>
				
				        <div class="col-12">
				            <label class="umc-form-label">Địa chỉ hiện tại <span class="text-danger">*</span></label>
				            <input type="text" class="form-control umc-input" name="address" required>
				        </div>
				    </div>
				
				    <!-- Đổi nút bấm thành type="submit" và đặt bên trong form (Hoặc dùng thuộc tính form="newProfileForm") -->
				    <div class="modal-footer d-flex justify-content-between">
				        <span class="text-muted small">(*) Là các thông tin bắt buộc</span>
				        <div class="d-flex gap-2">
				            <button type="button" class="btn btn-umc-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
				            <!-- Nút Submit chính thức của Form -->
				            <button type="submit" class="btn btn-umc-primary">
				                <i class="bi bi-check2-circle me-1"></i> Lưu hồ sơ
				            </button>
				        </div>
				    </div>
				</form>
            </div>

            <!-- FOOTER -->
            <div class="modal-footer d-flex justify-content-between">
                <span class="text-muted small"><i class="bi bi-info-circle me-1"></i>(*) Là các thông tin bắt buộc</span>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-umc-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x-lg me-1"></i> Hủy bỏ
                    </button>
                    <button type="button" class="btn btn-umc-primary" onclick="saveNewProfile()">
                        <i class="bi bi-check2-circle me-1"></i> Lưu hồ sơ
                    </button>
                </div>
            </div>

        </div>
    </div>
</div>