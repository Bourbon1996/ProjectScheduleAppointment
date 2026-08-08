<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/doctor/shared/page.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctor Portal - Quản lý Giờ rảnh</title>
<%@ include file="/admin/shared/page-admin.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body class="bg-light">
	<%@ include file="/doctor/shared/header.jsp" %>
	
	<main class="py-5">
		<div class="container-fluid px-4">
			<div class="d-flex justify-content-between align-items-center mb-4">
				<div>
					<h2 class="fw-bold text-dark mb-1"><i class="bi bi-clock-history text-success me-2"></i>Quản lý Lịch rảnh</h2>
					<p class="text-muted mb-0">Thiết lập thời gian làm việc để bệnh nhân có thể đặt lịch</p>
				</div>
				<button class="btn btn-success rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addSlotModal">
					<i class="bi bi-plus-circle me-1"></i> Thêm Khung giờ
				</button>
			</div>

			<!-- Bộ lọc -->
			<div class="card border-0 shadow-sm rounded-4 mb-4">
			    <div class="card-body p-3">
			        <form method="GET" action="${ctx}/doctor-portal/schedule" class="row g-3 align-items-center">
			            <div class="col-md-3">
			                <label class="form-label fw-bold text-secondary small mb-1">Ngày làm việc</label>
			                <input type="text" name="filterDate" id="filterDate" class="form-control bg-white" placeholder="dd-MM-yyyy" value="${param.filterDate}">
			            </div>
			            <div class="col-md-3">
			                <label class="form-label fw-bold text-secondary small mb-1">Ca làm việc</label>
			                <select name="filterShift" class="form-select" onchange="this.form.submit()">
			                    <option value="">Tất cả các ca</option>
			                    <option value="MORNING" ${param.filterShift == 'MORNING' ? 'selected' : ''}>Ca Sáng (Trước 12h)</option>
			                    <option value="AFTERNOON" ${param.filterShift == 'AFTERNOON' ? 'selected' : ''}>Ca Chiều (Sau 12h)</option>
			                </select>
			            </div>
			            <div class="col-md-3">
			                <label class="form-label fw-bold text-secondary small mb-1">Trạng thái</label>
			                <select name="filterStatus" class="form-select" onchange="this.form.submit()">
			                    <option value="">Tất cả trạng thái</option>
			                    <option value="AVAILABLE" ${param.filterStatus == 'AVAILABLE' ? 'selected' : ''}>Còn trống</option>
			                    <option value="FULL" ${param.filterStatus == 'FULL' ? 'selected' : ''}>Đã kín chỗ</option>
			                    <option value="CLOSED" ${param.filterStatus == 'CLOSED' ? 'selected' : ''}>Đã nghỉ / Hủy</option>
			                </select>
			            </div>
			            <div class="col-md-3 d-flex align-items-end">
			                <a href="${ctx}/doctor-portal/schedule" class="btn btn-outline-secondary w-100">Xóa lọc</a>
			            </div>
			        </form>
			    </div>
			</div>
			
			<c:if test="${not empty sessionScope.error}">
				<div class="alert alert-danger alert-dismissible fade show" role="alert">
					${sessionScope.error}
					<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
				</div>
				<c:remove var="error" scope="session"/>
			</c:if>

			<c:choose>
				<c:when test="${not empty upcomingSlots or not empty pastSlots}">
					<ul class="nav nav-pills mb-4 gap-2" id="schedule-tabs" role="tablist">
						<li class="nav-item" role="presentation">
							<button class="nav-link active rounded-pill px-4" id="upcoming-tab" data-bs-toggle="pill" data-bs-target="#upcoming" type="button" role="tab" aria-controls="upcoming" aria-selected="true">
								<i class="bi bi-calendar-check me-2"></i>Lịch sắp tới
							</button>
						</li>
						<li class="nav-item" role="presentation">
							<button class="nav-link rounded-pill px-4" id="past-tab" data-bs-toggle="pill" data-bs-target="#past" type="button" role="tab" aria-controls="past" aria-selected="false">
								<i class="bi bi-calendar-x me-2"></i>Lịch đã qua
							</button>
						</li>
					</ul>

					<div class="tab-content" id="schedule-tabs-content">
						<!-- Tab Upcoming -->
						<div class="tab-pane fade show active" id="upcoming" role="tabpanel" aria-labelledby="upcoming-tab">
							<div class="row g-4">
								<c:set var="upcomingCount" value="0" />
								<c:forEach var="entry" items="${upcomingSlots}">
									<c:set var="workDate" value="${entry.key}" />
									<c:set var="upcomingCount" value="${upcomingCount + 1}" />
									<c:set var="daySlots" value="${entry.value}" />
									<c:set var="isToday" value="${workDate.isEqual(todayDate)}" />
										
										<div class="col-12">
											<div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100 ${isToday ? 'border-primary border-2 border' : ''}">
												<div class="card-header ${isToday ? 'bg-primary-subtle border-bottom-0' : 'bg-white border-bottom-0'} pt-4 pb-2 d-flex align-items-center">
													<h5 class="fw-bold text-primary mb-0">
														<i class="bi bi-calendar-event me-2"></i>Ngày: 
														<fmt:parseDate value="${workDate}" pattern="yyyy-MM-dd" var="parsedWorkDate" type="date" />
														<fmt:formatDate value="${parsedWorkDate}" pattern="dd-MM-yyyy" />
													</h5>
													<c:if test="${isToday}">
														<span class="badge bg-primary ms-3 rounded-pill px-3 py-2">HÔM NAY</span>
													</c:if>
												</div>
												<div class="card-body pt-2">
													<div class="d-flex flex-wrap gap-3">
														<c:forEach var="item" items="${daySlots}">
															<c:set var="isFull" value="${item.status == 'FULL'}" />
															<c:set var="isClosed" value="${item.status == 'CLOSED'}" />
															<c:set var="maxPatients" value="${item.maxPatients > 0 ? item.maxPatients : 1}" />
															<c:set var="percentage" value="${(item.bookedCount / maxPatients) * 100}" />
															
															<div class="position-relative" style="min-width: 170px;">
																<div class="border rounded-4 p-3 text-center ${isClosed ? 'bg-light text-muted border-light' : (isFull ? 'bg-danger-subtle border-danger-subtle text-danger' : 'bg-white shadow-sm border-primary-subtle')}">
																	<div class="fw-bold fs-6 mb-1">${item.startTime} - ${item.endTime}</div>
																	<div class="small fw-semibold ${isClosed ? 'text-muted' : (isFull ? 'text-danger' : 'text-success')}">
																		<c:choose>
																			<c:when test="${isClosed}">Đã nghỉ / Hủy ca</c:when>
																			<c:when test="${isFull}">Đã kín chỗ</c:when>
																			<c:otherwise>${item.bookedCount} / ${item.maxPatients} bệnh nhân</c:otherwise>
																		</c:choose>
																	</div>
																	
																	<c:if test="${!isClosed}">
																		<div class="progress mt-2" style="height: 6px; border-radius: 10px;">
																		  <div class="progress-bar ${isFull ? 'bg-danger' : (percentage > 70 ? 'bg-warning' : 'bg-success')}" role="progressbar" style="width: ${percentage}%" aria-valuenow="${percentage}" aria-valuemin="0" aria-valuemax="100"></div>
																		</div>
																	</c:if>
																	
																	<div class="mt-3 d-flex justify-content-center gap-2">
																		<c:if test="${!isClosed}">
																			<c:if test="${item.bookedCount == 0}">
																				<form action="${ctx}/doctor-portal/schedule/delete" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa khung giờ này?');">
																					<input type="hidden" name="id" value="${item.id}">
																					<button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3" title="Xóa">
																						<i class="bi bi-trash"></i> Xóa
																					</button>
																				</form>
																			</c:if>
																			<c:if test="${item.bookedCount > 0}">
																				<form action="${ctx}/doctor-portal/schedule/close" method="POST" class="d-inline" onsubmit="return confirm('CẢNH BÁO: Đã có bệnh nhân đặt lịch! Nếu XIN NGHỈ, hệ thống sẽ tự động HỦY toàn bộ lịch hẹn và gửi Email. Tiếp tục?');">
																					<input type="hidden" name="id" value="${item.id}">
																					<button type="submit" class="btn btn-sm btn-outline-warning rounded-pill px-3" title="Xin nghỉ ca khám">
																						<i class="bi bi-x-octagon"></i> Nghỉ
																					</button>
																				</form>
																			</c:if>
																		</c:if>
																	</div>
																</div>
															</div>
														</c:forEach>
													</div>
												</div>
											</div>
										</div>
								</c:forEach>
								<c:if test="${upcomingCount == 0}">
									<div class="col-12">
										<div class="text-center py-5 bg-white rounded-4 shadow-sm border-0">
											<p class="text-muted mb-0">Không có lịch rảnh nào trong thời gian tới.</p>
										</div>
									</div>
								</c:if>
							</div>
						</div>
						
						<!-- Tab Past -->
						<div class="tab-pane fade" id="past" role="tabpanel" aria-labelledby="past-tab">
							<div class="row g-4">
								<c:set var="pastCount" value="0" />
								<c:forEach var="entry" items="${pastSlots}">
									<c:set var="workDate" value="${entry.key}" />
									<c:set var="pastCount" value="${pastCount + 1}" />
									<c:set var="daySlots" value="${entry.value}" />
										
										<div class="col-12">
											<div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100 opacity-75">
												<div class="card-header bg-light border-bottom-0 pt-4 pb-0">
													<h5 class="fw-bold text-secondary mb-0">
														<i class="bi bi-calendar2-minus me-2"></i>Ngày: 
														<fmt:parseDate value="${workDate}" pattern="yyyy-MM-dd" var="parsedWorkDate" type="date" />
														<fmt:formatDate value="${parsedWorkDate}" pattern="dd-MM-yyyy" />
													</h5>
												</div>
												<div class="card-body bg-light">
													<div class="d-flex flex-wrap gap-3">
														<c:forEach var="item" items="${daySlots}">
															<c:set var="isFull" value="${item.status == 'FULL'}" />
															<c:set var="isClosed" value="${item.status == 'CLOSED'}" />
															<c:set var="maxPatients" value="${item.maxPatients > 0 ? item.maxPatients : 1}" />
															<c:set var="percentage" value="${(item.bookedCount / maxPatients) * 100}" />
															
															<div class="position-relative" style="min-width: 170px;">
																<div class="border rounded-4 p-3 text-center bg-white shadow-sm border-light">
																	<div class="fw-bold fs-6 mb-1 text-secondary">${item.startTime} - ${item.endTime}</div>
																	<div class="small fw-semibold text-muted">
																		<c:choose>
																			<c:when test="${isClosed}">Đã nghỉ / Hủy ca</c:when>
																			<c:when test="${isFull}">Đã kín chỗ</c:when>
																			<c:otherwise>${item.bookedCount} / ${item.maxPatients} bệnh nhân</c:otherwise>
																		</c:choose>
																	</div>
																	<c:if test="${!isClosed}">
																		<div class="progress mt-2" style="height: 6px; border-radius: 10px;">
																		  <div class="progress-bar bg-secondary opacity-50" role="progressbar" style="width: ${percentage}%" aria-valuenow="${percentage}" aria-valuemin="0" aria-valuemax="100"></div>
																		</div>
																	</c:if>
																</div>
															</div>
														</c:forEach>
													</div>
												</div>
											</div>
										</div>
								</c:forEach>
								<c:if test="${pastCount == 0}">
									<div class="col-12">
										<div class="text-center py-5 bg-white rounded-4 shadow-sm border-0">
											<p class="text-muted mb-0">Chưa có lịch làm nào trong quá khứ.</p>
										</div>
									</div>
								</c:if>
							</div>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="card border-0 shadow-sm rounded-4 overflow-hidden">
						<div class="card-body text-center py-5">
							<i class="bi bi-calendar-x display-5 text-muted opacity-50 d-block mb-3"></i>
							<h5 class="text-secondary fw-semibold">Bạn chưa có lịch rảnh nào</h5>
							<p class="text-muted">Hãy nhấn "Thêm Khung giờ" để bắt đầu nhận bệnh nhân.</p>
						</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</main>

	<!-- Modal Thêm Lịch rảnh -->
	<div class="modal fade" id="addSlotModal" tabindex="-1" aria-labelledby="addSlotModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered modal-lg">
			<div class="modal-content border-0 shadow rounded-4">
				<form action="${ctx}/doctor-portal/schedule/add" method="POST" id="addScheduleForm">
					<div class="modal-header border-bottom-0 pt-4 px-4 pb-0">
						<h5 class="modal-title fw-bold text-dark" id="addSlotModalLabel">Thêm Khung Giờ Rảnh</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body px-4 py-4">
						<div class="row mb-4">
							<div class="col-md-6 mb-3 mb-md-0">
								<label class="form-label fw-semibold text-secondary">Ngày bắt đầu áp dụng <span class="text-danger">*</span></label>
								<div class="input-group">
									<span class="input-group-text bg-white"><i class="bi bi-calendar3"></i></span>
									<input type="text" class="form-control" id="workDateInput" name="workDate" placeholder="Chọn ngày" required>
								</div>
							</div>
							<div class="col-md-6">
								<label class="form-label fw-semibold text-secondary">Lặp lại lịch <span class="text-danger">*</span></label>
								
								<div class="btn-group w-100 mb-2" role="group">
									<input type="radio" class="btn-check" name="recurrence" id="recurDay" value="DAY" autocomplete="off" checked>
									<label class="btn btn-outline-primary" for="recurDay">Ngày</label>
									
									<input type="radio" class="btn-check" name="recurrence" id="recurWeek" value="WEEK" autocomplete="off">
									<label class="btn btn-outline-primary" for="recurWeek">Tuần</label>
									
									<input type="radio" class="btn-check" name="recurrence" id="recurMonth" value="MONTH" autocomplete="off">
									<label class="btn btn-outline-primary" for="recurMonth">Tháng</label>
								</div>
								
								<div id="weekdaySelector" class="d-none mt-2">
									<div class="d-flex flex-wrap gap-1">
										<c:forEach var="day" items="T2,T3,T4,T5,T6,T7,CN" varStatus="st">
											<c:set var="val" value="${st.index + 1}" />
											<!-- Backend uses 1=Mon, 2=Tue... 7=Sun based on java.time.DayOfWeek -->
											<input type="checkbox" class="btn-check weekday-checkbox" name="recurDays" id="day${val}" value="${val}">
											<label class="btn btn-sm btn-outline-secondary rounded-pill" for="day${val}">${day}</label>
										</c:forEach>
									</div>
									<small class="text-muted mt-1 d-block"><i class="bi bi-info-circle me-1"></i>Chọn các thứ trong tuần để lặp lại</small>
								</div>
								
							</div>
						</div>
						
						<div class="mb-4">
							<label class="form-label fw-semibold text-secondary d-flex justify-content-between">
								<span>Khung giờ làm việc <span class="text-danger">*</span></span>
							</label>
							
							<div class="row g-3">
								<!-- Ca Sáng -->
								<div class="col-md-6">
									<div class="d-flex justify-content-between align-items-center mb-2">
										<h6 class="fw-bold text-dark m-0"><i class="bi bi-brightness-alt-high text-warning me-1"></i>Ca Sáng</h6>
										<button type="button" class="btn btn-sm btn-light text-primary fw-semibold rounded-pill px-3" onclick="selectAll('MORNING')">Chọn tất cả</button>
									</div>
									<div class="row g-2">
										<c:forEach var="h" begin="6" end="11">
											<c:set var="startHour" value="${h < 10 ? '0' : ''}${h}:00" />
											<c:set var="endHour" value="${(h+1) < 10 ? '0' : ''}${h+1}:00" />
											<div class="col-6 col-sm-4">
												<input type="checkbox" class="btn-check time-slot-checkbox ts-morning" name="timeSlots" id="timeSlot_${h}" value="${startHour}-${endHour}">
												<label class="btn btn-outline-primary w-100 py-1 fs-7 rounded-pill" for="timeSlot_${h}">${startHour} - ${endHour}</label>
											</div>
										</c:forEach>
									</div>
								</div>
								
								<!-- Ca Chiều -->
								<div class="col-md-6">
									<div class="d-flex justify-content-between align-items-center mb-2">
										<h6 class="fw-bold text-dark m-0"><i class="bi bi-moon-stars text-info me-1"></i>Ca Chiều/Tối</h6>
										<button type="button" class="btn btn-sm btn-light text-primary fw-semibold rounded-pill px-3" onclick="selectAll('AFTERNOON')">Chọn tất cả</button>
									</div>
									<div class="row g-2">
										<c:forEach var="h" begin="12" end="19">
											<c:set var="startHour" value="${h < 10 ? '0' : ''}${h}:00" />
											<c:set var="endHour" value="${(h+1) < 10 ? '0' : ''}${h+1}:00" />
											<div class="col-6 col-sm-4">
												<input type="checkbox" class="btn-check time-slot-checkbox ts-afternoon" name="timeSlots" id="timeSlot_${h}" value="${startHour}-${endHour}">
												<label class="btn btn-outline-primary w-100 py-1 fs-7 rounded-pill" for="timeSlot_${h}">${startHour} - ${endHour}</label>
											</div>
										</c:forEach>
									</div>
								</div>
							</div>
						</div>

						<div class="mb-3">
							<label class="form-label fw-semibold text-secondary">Số lượng bệnh nhân tối đa / ca <span class="text-danger">*</span></label>
							<div class="d-flex align-items-center gap-2">
								<button type="button" class="btn btn-outline-secondary rounded-circle" style="width:36px;height:36px;" onclick="stepPatients(-1)"><i class="bi bi-dash"></i></button>
								<input type="number" class="form-control text-center fw-bold text-primary fs-5 bg-light border-0" id="maxPatientsInput" name="maxPatients" min="1" max="50" value="10" style="width: 80px;" readonly>
								<button type="button" class="btn btn-outline-secondary rounded-circle" style="width:36px;height:36px;" onclick="stepPatients(1)"><i class="bi bi-plus"></i></button>
							</div>
						</div>
					</div>
					<div class="modal-footer border-top-0 pb-4 px-4 d-flex justify-content-between align-items-center">
						<div id="visualFeedback" class="text-success fw-semibold small"></div>
						<div>
							<button type="button" class="btn btn-light rounded-pill px-4 me-2" data-bs-dismiss="modal">Hủy</button>
							<button type="submit" class="btn btn-success rounded-pill px-4">Lưu khung giờ</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
	<script>
		// Init Flatpickr cho bộ lọc
		flatpickr("#filterDate", {
			dateFormat: "Y-m-d",
			altInput: true,
			altFormat: "d-m-Y",
			onChange: function(selectedDates, dateStr, instance) {
				document.getElementById('filterDate').form.submit();
			}
		});

		// Init Flatpickr cho thêm khung giờ
		flatpickr("#workDateInput", {
			dateFormat: "Y-m-d",
			altInput: true,
			altFormat: "d-m-Y",
			mode: "range",
			minDate: "today",
			defaultDate: "today",
			onChange: updateFeedback
		});

		// Stepper Logic
		function stepPatients(step) {
			const input = document.getElementById('maxPatientsInput');
			let val = parseInt(input.value) || 0;
			val += step;
			if (val < 1) val = 1;
			if (val > 50) val = 50;
			input.value = val;
		}

		// Segmented Control Logic
		const recurrenceRadios = document.querySelectorAll('input[name="recurrence"]');
		const weekdaySelector = document.getElementById('weekdaySelector');
		
		recurrenceRadios.forEach(r => {
			r.addEventListener('change', (e) => {
				if (e.target.value === 'DAY') {
					weekdaySelector.classList.add('d-none');
				} else {
					weekdaySelector.classList.remove('d-none');
				}
				updateFeedback();
			});
		});

		// Select All Time Slots Logic
		function selectAll(type) {
			const selector = type === 'MORNING' ? '.ts-morning' : '.ts-afternoon';
			const checkboxes = document.querySelectorAll(selector);
			const allChecked = Array.from(checkboxes).every(cb => cb.checked);
			checkboxes.forEach(cb => cb.checked = !allChecked);
			updateFeedback();
		}

		// Feedback Logic
		const timeSlots = document.querySelectorAll('.time-slot-checkbox');
		const weekdayCheckboxes = document.querySelectorAll('.weekday-checkbox');
		
		timeSlots.forEach(cb => cb.addEventListener('change', updateFeedback));
		weekdayCheckboxes.forEach(cb => cb.addEventListener('change', updateFeedback));

		function updateFeedback() {
			const slotsSelected = document.querySelectorAll('.time-slot-checkbox:checked').length;
			const recurType = document.querySelector('input[name="recurrence"]:checked').value;
			const daysSelected = document.querySelectorAll('.weekday-checkbox:checked').length;
			
			const fb = document.getElementById('visualFeedback');
			if (slotsSelected === 0) {
				fb.textContent = 'Vui lòng chọn ít nhất 1 khung giờ';
				fb.className = 'text-danger fw-semibold small';
				return;
			}
			
			let text = '';
			if (recurType === 'DAY') {
				text = 'Sẽ tạo ' + slotsSelected + ' khung giờ cho 1 ngày.';
			} else if (recurType === 'WEEK') {
				if (daysSelected === 0) text = 'Vui lòng chọn ngày trong tuần.';
				else text = 'Sẽ tạo ' + slotsSelected + ' khung giờ/ngày x ' + daysSelected + ' ngày = ' + (slotsSelected * daysSelected) + ' slot (Mỗi tuần).';
			} else if (recurType === 'MONTH') {
				if (daysSelected === 0) text = 'Vui lòng chọn ngày trong tuần.';
				else text = 'Sẽ tạo ' + slotsSelected + ' khung giờ cho các thứ đã chọn trong tháng.';
			}
			
			fb.textContent = text;
			fb.className = (daysSelected === 0 && recurType !== 'DAY') ? 'text-danger fw-semibold small' : 'text-success fw-semibold small';
		}
		
		updateFeedback();
	</script>
</body>
</html>
