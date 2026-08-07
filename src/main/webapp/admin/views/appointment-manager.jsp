<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/admin/shared/page-admin.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý Lịch hẹn - Admin</title>
</head>
<body class="bg-light">
	<%@ include file="/admin/shared/header.jsp" %>
	
	<main class="py-4">
		<div class="container-fluid px-4">
			<h2 class="fw-bold mb-4">Quản lý Lịch hẹn</h2>

            <!-- Lọc & Tìm kiếm -->
			<div class="card border-0 shadow-sm rounded-4 mb-4">
			    <div class="card-body p-4">
			        <form method="GET" action="${ctx}/admin/appointment" class="row g-3 align-items-center">
			            <div class="col-md-4">
			                <input type="text" class="form-control" name="search" placeholder="Tìm theo Mã phiếu, Tên bệnh nhân, SĐT..." value="${param.search}">
			            </div>
			            <div class="col-md-3">
			                <select class="form-select" name="status">
			                    <option value="">Tất cả trạng thái</option>
			                    <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
			                    <option value="CONFIRMED" ${param.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
			                    <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Đã khám xong</option>
			                    <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
			                </select>
			            </div>
			            <div class="col-md-5">
			                <button type="submit" class="btn btn-primary px-4"><i class="bi bi-search me-1"></i> Tìm kiếm</button>
			                <a href="${ctx}/admin/appointment" class="btn btn-outline-secondary px-4 ms-2"><i class="bi bi-arrow-counterclockwise me-1"></i> Làm mới</a>
			            </div>
			        </form>
			    </div>
			</div>

			<div class="card border-0 shadow-sm rounded-4 overflow-hidden">
				<div class="card-body p-0">
					<div class="table-responsive">
						<table class="table table-hover align-middle mb-0">
							<thead class="bg-light text-secondary text-uppercase fs-7">
								<tr>
									<th class="ps-4">Mã phiếu</th>
									<th>Bệnh nhân</th>
									<th>Bác sĩ</th>
									<th>Thời gian khám</th>
									<th>Trạng thái lịch</th>
									<th>Thanh toán</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty listAppointments}">
										<c:forEach var="item" items="${listAppointments}">
											<tr>
												<td class="ps-4 fw-bold text-primary">#DHAK-${item.id}</td>
												<td>
													<div class="fw-semibold text-dark">${item.patient.fullName}</div>
													<small class="text-muted">${item.patient.phone}</small>
												</td>
												<td>
													<div class="fw-semibold text-dark">${item.doctor.user.fullName}</div>
													<small class="text-muted">${item.department.name}</small>
												</td>
												<td>
													<div class="fw-medium text-dark">${item.scheduleSlot != null ? item.scheduleSlot.workDate : 'N/A'}</div>
													<small class="text-danger fw-semibold">${item.scheduleSlot != null ? item.scheduleSlot.startTime : ''} - ${item.scheduleSlot != null ? item.scheduleSlot.endTime : ''}</small>
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
															<span class="badge bg-success px-3 py-2 rounded-pill">Đã khám</span>
														</c:when>
														<c:otherwise>
															<span class="badge bg-secondary px-3 py-2 rounded-pill">${item.status}</span>
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test="${item.paymentStatus == 'PAID'}">
															<span class="badge bg-success-subtle text-success border px-2 py-1">Đã TT</span>
														</c:when>
														<c:otherwise>
															<span class="badge bg-warning-subtle text-warning-emphasis border px-2 py-1">Chưa TT</span>
														</c:otherwise>
													</c:choose>
												</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="6" class="text-center py-5 text-muted">Chưa có dữ liệu lịch hẹn</td>
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
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
