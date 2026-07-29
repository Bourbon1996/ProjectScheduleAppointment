<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ include file="/site/shared/page.jsp" %>

<div class="container my-5">
	<h1 class="title mb-4 text-center">ĐẶT LỊCH KHÁM</h1>
    <!-- 1. THANH STEPPER -->
    <div class="booking-stepper-container mb-4">
        <div class="stepper-wrapper">
            <div class="step-item active" id="stepper-1">
                <div class="step-icon"><i class="bi bi-person"></i></div>
                <div class="step-label">Hồ sơ</div>
            </div>
            <div class="step-item" id="stepper-2">
                <div class="step-icon"><i class="bi bi-file-earmark-medical"></i></div>
                <div class="step-label">Chọn thông tin khám</div>
            </div>
            <div class="step-item" id="stepper-3">
                <div class="step-icon"><i class="bi bi-calendar-check"></i></div>
                <div class="step-label">Xác nhận</div>
            </div>
            <div class="step-item" id="stepper-4">
                <div class="step-icon"><i class="bi bi-check-lg"></i></div>
                <div class="step-label">Hoàn tất</div>
            </div>
        </div>
    </div>

    <!-- 2. KHUNG NỘI DUNG FORM -->
    <div class="step-content-box">
        
        <!-- BƯỚC 1: CHỌN HỒ SƠ -->
		<!-- BƯỚC 1: QUẢN LÝ & CHỌN HỒ SƠ -->
		<div class="step-pane active" id="step-pane-1">
		    <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
		        <h5 class="step-title mb-0 border-0 pb-0">Chọn hồ sơ đặt khám</h5>
		        <!-- Nút mở Modal Tạo hồ sơ -->
		        <button type="button" class="btn btn-outline-primary btn-sm fw-bold" data-bs-toggle="modal" data-bs-target="#createProfileModal">
		            <i class="bi bi-plus-circle me-1"></i> Tạo mới hồ sơ
		        </button>
		    </div>
		
		    <!-- KHUVỰC HIỆN THỊ DANH SÁCH HỒ SƠ -->
		    <!-- Vùng hiển thị danh sách hồ sơ ở Bước 1 -->
			<div class="row g-3">
			    <!-- Trường hợp rỗng: Chưa có hồ sơ nào trong DB -->
			    <c:if test="${empty patientList}">
			        <div class="col-12 text-center py-5 my-3 bg-light rounded-3 border border-dashed">
			            <i class="bi bi-folder-x text-secondary" style="font-size: 3.5rem;"></i>
			            <h6 class="fw-bold mt-3 text-secondary">Chưa có hồ sơ đặt khám nào</h6>
			            <button type="button" class="btn btn-primary btn-sm px-3 mt-2" data-bs-toggle="modal" data-bs-target="#createProfileModal">
			                <i class="bi bi-plus-circle me-1"></i> Tạo hồ sơ ngay
			            </button>
			        </div>
			    </c:if>
			
			    <!-- Trường hợp có hồ sơ: Lặp danh sách từ DB ra -->
			    <c:forEach var="p" items="${patientList}">
			        <div class="col-md-6">
			            <div class="profile-card d-flex align-items-center justify-content-between p-3" 
			                 onclick="selectProfileFromDB(this, '${p.id}', '${p.fullName}', '${p.phone}', '${p.dateOfBirth}', '${p.gender}', '${p.healthInsuranceCode}')">
			                <div class="d-flex align-items-center">
			                    <div class="profile-icon me-3"><i class="bi bi-person-fill"></i></div>
			                    <div>
			                        <h6 class="mb-1 fw-bold text-primary">${p.fullName}</h6>
			                        <p class="mb-0 text-muted small"><i class="bi bi-calendar3 me-1"></i> ${p.dateOfBirth} (${p.gender})</p>
			                        <p class="mb-0 text-muted small"><i class="bi bi-telephone me-1"></i> ${p.phone}</p>
			                    </div>
			                </div>
			                <i class="bi bi-check-circle-fill text-primary fs-4 d-none check-icon"></i>
			            </div>
			        </div>
			    </c:forEach>
			</div>
		
		    <div class="d-flex justify-content-end mt-4">
		        <!-- Nút Tiếp tục mặc định bị khóa (disabled) nếu chưa chọn hồ sơ nào -->
		        <button type="button" class="btn btn-primary px-4 py-2" id="btn-next-step1" onclick="goToStep(2)" disabled>
		            Tiếp tục <i class="bi bi-arrow-right ms-1"></i>
		        </button>
		    </div>
		</div>
		
		<!-- ========================================================== -->
		<!-- MODAL TẠO MỚI HỒ SƠ (Ánh xạ theo Entity Patient & Appointment) -->
		<!-- ========================================================== -->
		<%@ include file="/site/layouts/appointment-form.jsp" %>



	<!-- BƯỚC 2: CHỌN THÔNG TIN KHÁM (GIAO DIỆN CHUẨN UMC) -->
        <jsp:include page="/site/modal/modal-date.jsp" />
		<jsp:include page="/site/modal/modal-department.jsp" />
		<jsp:include page="/site/modal/modal-doctor.jsp" />

		<div class="step-pane" id="step-pane-2">
		    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
		        
		        <!-- Header & Nút kích hoạt luồng chọn Popup -->
		        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
		            <div>
		                <h5 class="fw-bold text-primary mb-1"><i class="bi bi-file-earmark-medical me-2"></i>THÔNG TIN KHÁM BỆNH</h5>
		                <p class="text-muted small mb-0">Vui lòng bấm chọn tuần tự Ngày khám, Chuyên khoa và Khung giờ</p>
		            </div>
		            <button type="button" class="btn btn-primary px-4 py-2 fw-bold shadow-sm" onclick="openBookingFlow()">
		                <i class="bi bi-hand-index-thumb me-1"></i> Bấm chọn lịch khám ngay
		            </button>
		        </div>
		
		        <!-- 4 Ô HIỂN THỊ KẾT QUẢ ĐÃ CHỌN (Bấm vào là mở Modal) -->
		        <div class="row g-4 mb-4">
		            
		            <!-- Ô 1: Ngày khám -->
		            <div class="col-md-6">
		                <label class="form-label small fw-bold text-muted">NGÀY KHÁM <span class="text-danger">*</span></label>
		                <div class="input-group" onclick="openBookingFlow()" style="cursor: pointer;">
		                    <span class="input-group-text bg-white text-primary"><i class="bi bi-calendar-check fs-5"></i></span>
		                    <input type="text" class="form-control bg-light fw-bold text-dark" id="input-display-date" 
		                           placeholder="Chưa chọn ngày khám..." readonly style="cursor: pointer;">
		                    <!-- Icon tích xanh sẽ bật lên khi chọn xong -->
		                    <span class="input-group-text bg-white border-start-0"><i class="bi bi-check-circle-fill check-status-icon d-none"></i></span>
		                </div>
		            </div>
		
		            <!-- Ô 2: Chuyên khoa -->
		            <div class="col-md-6">
		                <label class="form-label small fw-bold text-muted">CHUYÊN KHOA <span class="text-danger">*</span></label>
		                <div class="input-group" onclick="openBookingFlow()" style="cursor: pointer;">
		                    <span class="input-group-text bg-white text-primary"><i class="bi bi-heart-pulse fs-5"></i></span>
		                    <input type="text" class="form-control bg-light fw-bold text-dark" id="input-display-dept" 
		                           placeholder="Chưa chọn chuyên khoa..." readonly style="cursor: pointer;">
		                    <span class="input-group-text bg-white border-start-0"><i class="bi bi-check-circle-fill check-status-icon d-none"></i></span>
		                </div>
		            </div>
		
		            <!-- Ô 3: Giờ khám -->
		            <div class="col-md-6">
		                <label class="form-label small fw-bold text-muted">GIỜ KHÁM <span class="text-danger">*</span></label>
		                <div class="input-group" onclick="openBookingFlow()" style="cursor: pointer;">
		                    <span class="input-group-text bg-white text-primary"><i class="bi bi-clock fs-5"></i></span>
		                    <input type="text" class="form-control bg-light fw-bold text-dark" id="input-display-time" 
		                           placeholder="Chưa chọn giờ khám..." readonly style="cursor: pointer;">
		                    <span class="input-group-text bg-white border-start-0"><i class="bi bi-check-circle-fill check-status-icon d-none"></i></span>
		                </div>
		            </div>
		
		            <!-- Ô 4: Bác sĩ -->
		            <div class="col-md-6">
		                <label class="form-label small fw-bold text-muted">BÁC SĨ KHÁM <span class="text-muted fw-normal">(Tùy chọn)</span></label>
		                <div class="input-group" onclick="openBookingFlow()" style="cursor: pointer;">
		                    <span class="input-group-text bg-white text-primary"><i class="bi bi-person-badge fs-5"></i></span>
		                    <input type="text" class="form-control bg-light fw-bold text-dark" id="input-display-doctor" 
		                           placeholder="Chưa chọn bác sĩ..." readonly style="cursor: pointer;">
		                    <span class="input-group-text bg-white border-start-0"><i class="bi bi-check-circle-fill check-status-icon d-none"></i></span>
		                </div>
		            </div>
		
		        </div>
		
		        <!-- KHỐI CHECKBOX BẢO HIỂM Y TẾ & BẢO HIỂM TƯ NHÂN -->
		        <div class="bg-light p-3 rounded-3 mb-4 border">
		            <div class="row g-3">
		                <!-- Bảo hiểm y tế -->
		                <div class="col-md-6">
		                    <label class="fw-bold text-dark small d-block mb-2">Bảo hiểm y tế <span class="text-danger">*</span></label>
		                    <div class="d-flex gap-4">
		                        <div class="form-check">
		                            <input class="form-check-input" type="radio" name="radioBHYT" id="bhytYes" value="YES" onclick="checkBHYT(true)">
		                            <label class="form-check-label text-dark" for="bhytYes" style="cursor: pointer;">Có BHYT</label>
		                        </div>
		                        <div class="form-check">
		                            <input class="form-check-input" type="radio" name="radioBHYT" id="bhytNo" value="NO" checked onclick="checkBHYT(false)">
		                            <label class="form-check-label text-dark" for="bhytNo" style="cursor: pointer;">Không</label>
		                        </div>
		                    </div>
		                    <!-- Chỗ hiển thị thông báo áp dụng mã BHYT -->
		                    <div id="bhyt-status-msg" class="small mt-1 text-success fw-bold"></div>
		                </div>
		
		                <!-- Bảo hiểm tư nhân -->
		                <div class="col-md-6 border-start-md">
		                    <label class="fw-bold text-dark small d-block mb-2">Bảo hiểm tư nhân <span class="text-danger">*</span> <span class="text-muted fw-normal" style="font-size: 0.75rem;">(Bảo lãnh viện phí)</span></label>
		                    <div class="d-flex gap-4">
		                        <div class="form-check">
		                            <input class="form-check-input" type="radio" name="radioBHTN" id="bhtnYes" value="YES">
		                            <label class="form-check-label text-dark" for="bhtnYes" style="cursor: pointer;">Có</label>
		                        </div>
		                        <div class="form-check">
		                            <input class="form-check-input" type="radio" name="radioBHTN" id="bhtnNo" value="NO" checked>
		                            <label class="form-check-label text-dark" for="bhtnNo" style="cursor: pointer;">Không</label>
		                        </div>
		                    </div>
		                </div>
		            </div>
		        </div>
		
		        <!-- THANH TỔNG TIỀN KHÁM -->
		        <div class="umc-total-bar d-flex justify-content-between align-items-center mb-5">
		            <span class="fs-6 text-uppercase fw-bold"><i class="bi bi-wallet2 me-2"></i>TỔNG TIỀN KHÁM:</span>
		            <span class="fs-4 fw-bold" id="display-total-price"></span>
		        </div>
		
		        <!-- NÚT ĐIỀU HƯỚNG BƯỚC -->
		        <div class="d-flex justify-content-between pt-2">
		            <button type="button" class="btn btn-outline-secondary px-4 py-2" onclick="goToStep(1)">
		                <i class="bi bi-arrow-left me-1"></i> Quay lại Bước 1
		            </button>
		            <!-- Nút này bị mờ (disabled) cho đến khi chọn xong Popup thứ 3 -->
		            <button type="button" class="btn btn-primary px-5 py-2 fw-bold" id="btn-next-step2" disabled onclick="validateAndGoToStep3()">
		                Tiếp tục <i class="bi bi-arrow-right ms-1"></i>
		            </button>
		        </div>
		
		    </div>
		</div>
        
		<!-- BƯỚC 3: XÁC NHẬN THÔNG TIN -->
		<div class="step-pane" id="step-pane-3">
		    
		    <!-- 🔥 BỔ SUNG: KHỐI THÔNG TIN BỆNH NHÂN (Để JS không bị lỗi null textContent) 🔥 -->
		    <h5 class="step-title mb-3"><i class="bi bi-person-lines-fill text-primary me-2"></i>Thông tin bệnh nhân</h5>
		    <div class="row g-3 mb-4 bg-light p-3 rounded-3 border">
		        <div class="col-md-6">
		            <p class="mb-2"><strong>Họ và tên:</strong> <span id="conf-patient-name" class="text-primary fw-bold">--</span></p>
		            <p class="mb-2"><strong>Ngày sinh:</strong> <span id="conf-patient-dob">--</span></p>
		        </div>
		        <div class="col-md-6">
		            <p class="mb-2"><strong>Số điện thoại:</strong> <span id="conf-patient-phone" class="fw-bold">--</span></p>
		            <p class="mb-2"><strong>Mã BHYT:</strong> <span id="conf-patient-bhyt" class="text-success fw-bold">--</span></p>
		        </div>
		    </div>
		
		    <!-- KHỐI THÔNG TIN CHUYÊN KHOA ĐÃ ĐẶT -->
		    <h5 class="step-title mb-3"><i class="bi bi-calendar-check text-primary me-2"></i>Chuyên khoa đã đặt</h5>
		    <div class="row g-3 mb-4 bg-light p-3 rounded-3 border">
		        <div class="col-md-6">
		            <p class="mb-2"><strong>Chuyên khoa:</strong> <span id="conf-department" class="text-primary fw-bold">--</span></p>
		            <p class="mb-2"><strong>Giờ khám:</strong> <span id="conf-time" class="fw-bold text-danger">--</span></p>
		            <p class="mb-2"><strong>Bác sĩ:</strong> <span id="conf-doctor">--</span></p>
		            <p class="mb-2"><strong>Bảo hiểm y tế:</strong> Áp dụng theo mã BHYT</p>
		        </div>
		        <div class="col-md-6">
		            <p class="mb-2"><strong>Ngày khám:</strong> <span id="conf-date" class="fw-bold">--</span></p>
		            <p class="mb-2"><strong>Tiền khám:</strong> 150.000 đồng</p>
		            <p class="mb-2"><strong>Bảo hiểm tư nhân:</strong> Không</p>
		        </div>
		    </div>
		
		    <div class="total-price-bar d-flex justify-content-between align-items-center mb-5 p-3 bg-primary bg-opacity-10 rounded-3">
		        <span class="fw-bold">Tổng tiền khám:</span>
		        <span class="fs-5 fw-bold text-primary">150.000 đồng</span>
		    </div>
		
		    <!-- Form chính thức để Submit về Servlet -->
		    <form action="${ctx}/submit-booking" method="POST" id="realSubmitForm">
		        <!-- 🔥 SỬA LẠI ID THẺ HIDDEN CHO KHỚP 100% VỚI JAVASCRIPT 🔥 -->
		        <input type="hidden" name="patientId" id="hidden-patient-id">
		        <input type="hidden" name="examDate" id="hidden-date">
		        <input type="hidden" name="departmentId" id="hidden-dept">
		        <input type="hidden" name="timeSlot" id="hidden-time">
		        <input type="hidden" name="doctorId" id="hidden-doc">
		
		        <div class="d-flex justify-content-between">
		            <button type="button" class="btn btn-outline-secondary px-4" onclick="goToStep(2)">
		                <i class="bi bi-arrow-left me-1"></i> Quay lại
		            </button>
		            
		            <!-- Khi làm thật bấm nút này nên đổi thành type="submit" hoặc gọi form.submit() để gửi về Servlet nhé -->
		            <button type="button" class="btn btn-primary px-5 fw-bold" onclick="goToStep(4)">
		                Xác nhận đặt lịch <i class="bi bi-check-circle ms-1"></i>
		            </button>
		        </div>
		    </form>
		</div>

        <!-- BƯỚC 4: HOÀN TẤT (THAY THẾ BƯỚC THANH TOÁN) -->
        <div class="step-pane text-center py-5" id="step-pane-4">
            <div class="mb-4">
                <i class="bi bi-check-circle-fill text-success" style="font-size: 5rem;"></i>
            </div>
            <h3 class="fw-bold text-success mb-3">ĐẶT LỊCH KHÁM THÀNH CÔNG!</h3>
            <p class="text-muted mb-4">
                Cảm ơn bạn <strong id="success-patient-name" class="text-dark">TRẦN HOÀNG ANH KA</strong> đã đăng ký khám bệnh.<br>
                Mã phiếu khám của bạn là <strong class="text-primary">#UMC-2026-9823</strong>. Vui lòng đến trước giờ hẹn 15 phút để làm thủ tục.
            </p>
            <div class="d-flex justify-content-center gap-3">
                <a href="${ctx}/" class="btn btn-outline-primary px-4">
                    <i class="bi bi-house me-1"></i> Về trang chủ
                </a>
                <a href="${ctx}/lich-su-kham" class="btn btn-primary px-4">
                    Xem lịch sử khám <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>

    </div>
    </div>
<script src="${ctx}/assets/js/client/appointment-flow.js"></script>