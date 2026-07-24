<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ include file="/shared/home/page.jsp" %>

<div class="container my-5">
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
			                 onclick="selectProfileFromDB('${p.id}', '${p.fullName}', '${p.phone}', '${p.dateOfBirth}', '${p.gender}', '${p.healthInsuranceCode}')">
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
		<%@ include file="/layouts/client/appointment-form.jsp" %>

        <!-- BƯỚC 2: CHỌN THÔNG TIN KHÁM -->
        <div class="step-pane" id="step-pane-2">
            <h5 class="step-title">Thông tin khám</h5>
            <form id="bookingForm">
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">CHỌN NGÀY KHÁM</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-calendar-event text-primary"></i></span>
                            <input type="date" class="form-control" id="examDate" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">CHỌN CHUYÊN KHOA</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-heart-pulse text-primary"></i></span>
                            <select class="form-select" id="departmentSelect" required>
                                <option value="">-- Vui lòng chọn chuyên khoa --</option>
                                <option value="BỆNH LÝ CỘT SỐNG">Bệnh lý cột sống</option>
                                <option value="KHOA TIM MẠCH">Khoa Tim mạch</option>
                                <option value="KHOA TIÊU HÓA">Khoa Tiêu hóa</option>
                                <option value="KHOA THẦN KINH">Khoa Thần kinh</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">CHỌN GIỜ KHÁM</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-clock text-primary"></i></span>
                            <select class="form-select" id="timeSlotSelect" required>
                                <option value="">-- Vui lòng chọn giờ khám --</option>
                                <option value="07:30 - 08:30">07:30 - 08:30</option>
                                <option value="08:30 - 09:30">08:30 - 09:30</option>
                                <option value="09:30 - 10:30">09:30 - 10:30</option>
                                <option value="13:30 - 14:30">13:30 - 14:30</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">CHỌN BÁC SĨ</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-person-workspace text-primary"></i></span>
                            <select class="form-select" id="doctorSelect">
                                <option value="Bác sĩ phân công tự động">-- Vui lòng chọn bác sĩ (Tùy chọn) --</option>
                                <option value="PGS. TS. BS Nguyễn Văn A">PGS. TS. BS Nguyễn Văn A</option>
                                <option value="TS. BS Trần Thị B">TS. BS Trần Thị B</option>
                                <option value="ThS. BS Lê Văn C">ThS. BS Lê Văn C</option>
                            </select>
                        </div>
                    </div>
                </div>
            </form>
            <div class="d-flex justify-content-between mt-5">
                <button type="button" class="btn btn-outline-secondary px-4" onclick="goToStep(1)">
                    <i class="bi bi-arrow-left me-1"></i> Quay lại
                </button>
                <button type="button" class="btn btn-primary px-4" onclick="validateAndGoToStep3()">
                    Tiếp tục <i class="bi bi-arrow-right ms-1"></i>
                </button>
            </div>
        </div>

        <!-- BƯỚC 3: XÁC NHẬN THÔNG TIN -->
        <div class="step-pane" id="step-pane-3">
            <h5 class="step-title">Chuyên khoa đã đặt</h5>
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <p class="mb-2"><strong>Chuyên khoa:</strong> <span id="conf-department" class="text-primary fw-bold">--</span></p>
                    <p class="mb-2"><strong>Giờ khám:</strong> <span id="conf-time">--</span></p>
                    <p class="mb-2"><strong>Bác sĩ:</strong> <span id="conf-doctor">--</span></p>
                    <p class="mb-2"><strong>Bảo hiểm y tế:</strong> Không</p>
                </div>
                <div class="col-md-6">
                    <p class="mb-2"><strong>Ngày khám:</strong> <span id="conf-date" class="fw-bold">--</span></p>
                    <p class="mb-2"><strong>Tiền khám:</strong> 150.000 đồng</p>
                    <p class="mb-2"><strong>Bảo hiểm tư nhân:</strong> Không</p>
                </div>
            </div>

            <div class="total-price-bar d-flex justify-content-between align-items-center mb-5">
                <span>Tổng tiền khám:</span>
                <span class="fs-5">150.000 đồng</span>
            </div>

            <!-- Form chính thức để Submit về Servlet (Nếu cần) -->
            <form action="${pageContext.request.contextPath}/submit-booking" method="POST" id="realSubmitForm">
                <!-- Các thẻ hidden này sẽ được JS điền dữ liệu vào trước khi submit -->
                <input type="hidden" name="patientName" id="hidden-patient" value="TRẦN HOÀNG ANH KA">
                <input type="hidden" name="examDate" id="hidden-date">
                <input type="hidden" name="department" id="hidden-dept">
                <input type="hidden" name="timeSlot" id="hidden-time">
                <input type="hidden" name="doctor" id="hidden-doc">

                <div class="d-flex justify-content-between">
                    <button type="button" class="btn btn-outline-secondary px-4" onclick="goToStep(2)">
                        <i class="bi bi-arrow-left me-1"></i> Quay lại
                    </button>
                    <!-- Bấm nút này sẽ chuyển thẳng sang Bước 4 (Hoàn tất) -->
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
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary px-4">
                    <i class="bi bi-house me-1"></i> Về trang chủ
                </a>
                <a href="${pageContext.request.contextPath}/lich-su-kham" class="btn btn-primary px-4">
                    Xem lịch sử khám <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>

    </div>
</div>