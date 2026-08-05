<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/doctor/shared/page.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctor Portal - Lịch hẹn</title>
<%@ include file="/admin/shared/page-admin.jsp" %>
</head>
<body class="bg-light">
	<%@ include file="/doctor/shared/header.jsp" %>
	
	<main class="py-5">
		<div class="container-fluid px-4">
			<div class="d-flex justify-content-between align-items-center mb-4">
				<div>
					<h2 class="fw-bold text-dark mb-1"><i class="bi bi-calendar2-check text-primary me-2"></i>Danh sách Lịch hẹn</h2>
					<p class="text-muted mb-0">Quản lý và xác nhận các lịch khám của bệnh nhân</p>
				</div>
			</div>

			<!-- Bảng dữ liệu lịch sử -->
			<div class="card border-0 shadow-sm rounded-4 overflow-hidden">
				<div class="card-body p-0">
					<div class="table-responsive">
						<table class="table table-hover align-middle mb-0">
							<thead class="bg-light text-secondary text-uppercase fs-7">
								<tr>
									<th class="ps-4">Mã phiếu</th>
									<th>Bệnh nhân</th>
									<th>Thời gian khám</th>
									<th>STT</th>
									<th>Trạng thái lịch</th>
									<th>Thanh toán</th>
									<th class="text-end pe-4">Thao tác</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty historyList}">
										<c:forEach var="item" items="${historyList}">
											<tr>
												<td class="ps-4 fw-bold text-primary">#DHAK-${item.id}</td>
												<td>
													<div class="fw-semibold text-dark">${item.patient.user.fullName}</div>
													<small class="text-muted">${item.patient.user.phone}</small>
												</td>
												<td>
													<div class="fw-medium text-dark">${item.slot.workDate}</div>
													<small class="text-danger fw-semibold">${item.slot.startTime} - ${item.slot.endTime}</small>
												</td>
												<td>
													<span class="badge bg-light text-dark border px-2 py-1">STT: #${item.queueNumber}</span>
												</td>
												<td>
													<c:choose>
														<c:when test="${item.status == 'PENDING'}">
															<span class="badge bg-warning text-dark px-3 py-2 rounded-pill">Chờ xác nhận</span>
														</c:when>
														<c:when test="${item.status == 'CONFIRMED'}">
															<span class="badge bg-info text-dark px-3 py-2 rounded-pill">Đã xác nhận</span>
														</c:when>
														<c:when test="${item.status == 'COMPLETED'}">
															<span class="badge bg-success px-3 py-2 rounded-pill">Đã hoàn thành</span>
														</c:when>
														<c:otherwise>
															<span class="badge bg-secondary px-3 py-2 rounded-pill">${item.status}</span>
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test="${item.paymentStatus == 'PAID'}">
															<span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">Đã thanh toán</span>
														</c:when>
														<c:otherwise>
															<span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-2 py-1">Chưa thanh toán</span>
														</c:otherwise>
													</c:choose>
												</td>
												<td class="text-end pe-4">
												    <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3" 
												            data-bs-toggle="modal" data-bs-target="#detailModal_${item.id}">
												        <i class="bi bi-eye me-1"></i> Chi tiết
												    </button>
												</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="7" class="text-center py-5">
												<div class="py-4">
													<i class="bi bi-inbox display-5 text-muted opacity-50 d-block mb-3"></i>
													<h5 class="text-secondary fw-semibold">Chưa có lịch hẹn nào</h5>
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
	
	<%@ include file="/site/modal/modal-detail-appointment.jsp" %>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
