<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/doctor/shared/page.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctor Portal - Quản lý Giờ rảnh</title>
<%@ include file="/admin/shared/page-admin.jsp" %>
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
			
			<c:if test="${not empty sessionScope.error}">
				<div class="alert alert-danger alert-dismissible fade show" role="alert">
					${sessionScope.error}
					<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
				</div>
				<c:remove var="error" scope="session"/>
			</c:if>

			<div class="card border-0 shadow-sm rounded-4 overflow-hidden">
				<div class="card-body p-0">
					<div class="table-responsive">
						<table class="table table-hover align-middle mb-0">
							<thead class="bg-light text-secondary text-uppercase fs-7">
								<tr>
									<th class="ps-4">Ngày làm việc</th>
									<th>Khung giờ</th>
									<th>Số bệnh nhân tối đa</th>
									<th>Đã đặt</th>
									<th>Trạng thái</th>
									<th class="text-end pe-4">Thao tác</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty slotList}">
										<c:forEach var="item" items="${slotList}">
											<tr>
												<td class="ps-4 fw-bold text-dark">${item.workDate}</td>
												<td>
													<span class="badge bg-light text-primary border px-2 py-1">${item.startTime} - ${item.endTime}</span>
												</td>
												<td>${item.maxPatients} người</td>
												<td>
													<span class="${item.bookedCount >= item.maxPatients ? 'text-danger fw-bold' : 'text-success fw-bold'}">
														${item.bookedCount} / ${item.maxPatients}
													</span>
												</td>
												<td>
													<c:choose>
														<c:when test="${item.status == 'AVAILABLE'}">
															<span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">Còn trống</span>
														</c:when>
														<c:otherwise>
															<span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">Đã kín</span>
														</c:otherwise>
													</c:choose>
												</td>
												<td class="text-end pe-4">
													<c:if test="${item.bookedCount == 0}">
														<form action="${doc}/schedule/delete" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa khung giờ này?');">
															<input type="hidden" name="id" value="${item.id}">
															<button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">
																<i class="bi bi-trash"></i> Xóa
															</button>
														</form>
													</c:if>
													<c:if test="${item.bookedCount > 0}">
														<button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-3" disabled title="Đã có bệnh nhân đặt, không thể xóa">
															<i class="bi bi-lock"></i> Khóa
														</button>
													</c:if>
												</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="6" class="text-center py-5">
												<div class="py-4">
													<i class="bi bi-calendar-x display-5 text-muted opacity-50 d-block mb-3"></i>
													<h5 class="text-secondary fw-semibold">Bạn chưa có lịch rảnh nào</h5>
													<p class="text-muted">Hãy nhấn "Thêm Khung giờ" để bắt đầu nhận bệnh nhân.</p>
												</div>
											</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</main>

	<!-- Modal Thêm Lịch rảnh -->
	<div class="modal fade" id="addSlotModal" tabindex="-1" aria-labelledby="addSlotModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered modal-lg">
			<div class="modal-content border-0 shadow rounded-4">
				<form action="${doc}/schedule/add" method="POST">
					<div class="modal-header border-bottom-0 pt-4 px-4 pb-0">
						<h5 class="modal-title fw-bold text-dark" id="addSlotModalLabel">Thêm Khung Giờ Rảnh</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body px-4 py-4">
						<div class="row mb-4">
							<div class="col-md-6 mb-3 mb-md-0">
								<label class="form-label fw-semibold text-secondary">Ngày làm việc <span class="text-danger">*</span></label>
								<input type="date" class="form-control rounded-3" name="workDate" required>
							</div>
							<div class="col-md-6">
								<label class="form-label fw-semibold text-secondary">Lặp lại lịch <span class="text-danger">*</span></label>
								<div class="d-flex flex-column gap-2 mt-2">
									<div class="form-check">
										<input class="form-check-input" type="radio" name="recurrence" id="recurDay" value="DAY" checked>
										<label class="form-check-label" for="recurDay">Chỉ áp dụng cho ngày đã chọn</label>
									</div>
									<div class="form-check">
										<input class="form-check-input" type="radio" name="recurrence" id="recurWeek" value="WEEK">
										<label class="form-check-label" for="recurWeek">Áp dụng cho tất cả các ngày trong tuần (T2-CN)</label>
									</div>
									<div class="form-check">
										<input class="form-check-input" type="radio" name="recurrence" id="recurMonth" value="MONTH">
										<label class="form-check-label" for="recurMonth">Áp dụng cho tất cả các ngày trong tháng</label>
									</div>
								</div>
							</div>
						</div>
						
						<div class="mb-4">
							<label class="form-label fw-semibold text-secondary d-flex justify-content-between">
								<span>Khung giờ làm việc <span class="text-danger">*</span></span>
								<div class="form-check m-0">
									<input class="form-check-input" type="checkbox" id="selectAllTimes">
									<label class="form-check-label text-primary" style="cursor:pointer;" for="selectAllTimes">Chọn tất cả</label>
								</div>
							</label>
							<div class="row g-2">
								<c:forEach var="h" begin="6" end="19">
									<c:set var="startHour" value="${h < 10 ? '0' : ''}${h}:00" />
									<c:set var="endHour" value="${(h+1) < 10 ? '0' : ''}${h+1}:00" />
									<div class="col-4 col-sm-3 col-md-2">
										<input type="checkbox" class="btn-check time-slot-checkbox" name="timeSlots" id="timeSlot_${h}" value="${startHour}-${endHour}">
										<label class="btn btn-outline-primary w-100 py-2 fs-7" for="timeSlot_${h}">${startHour} - ${endHour}</label>
									</div>
								</c:forEach>
							</div>
						</div>

						<div class="mb-3">
							<label class="form-label fw-semibold text-secondary">Số lượng bệnh nhân tối đa mỗi khung giờ <span class="text-danger">*</span></label>
							<input type="number" class="form-control rounded-3" name="maxPatients" min="1" max="50" value="10" required>
					
						</div>
					</div>
					<div class="modal-footer border-top-0 pb-4 px-4">
						<button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
						<button type="submit" class="btn btn-success rounded-pill px-4">Lưu khung giờ</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		document.getElementById('selectAllTimes').addEventListener('change', function() {
			var checkboxes = document.querySelectorAll('.time-slot-checkbox');
			checkboxes.forEach(cb => cb.checked = this.checked);
		});
	</script>
</body>
</html>
