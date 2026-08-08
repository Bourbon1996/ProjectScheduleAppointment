<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/doctor/shared/page.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctor Portal - Dashboard</title>
<%@ include file="/admin/shared/page-admin.jsp" %>
</head>
<body class="bg-light">
	<%@ include file="/doctor/shared/header.jsp" %>
	
	<main class="py-4 bg-light" style="min-height: calc(100vh - 70px);">
		<div class="container-fluid px-4">
			
			<!-- Welcome Banner -->
			<div class="row mb-4">
				<div class="col-12">
					<div class="card border-0 rounded-4 shadow-sm" style="background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);">
						<div class="card-body p-4 p-md-5 text-white position-relative overflow-hidden">
							<div class="position-relative" style="z-index: 1;">
								<h2 class="fw-bold mb-2"><i class="bi bi-emoji-smile me-2"></i>Xin chào Bác sĩ, ${sessionScope.user.fullName}!</h2>
								<p class="fs-5 mb-0 opacity-75">Chúc bạn một ngày làm việc hiệu quả và mang lại nhiều sức khỏe cho bệnh nhân.</p>
							</div>
							<i class="bi bi-heart-pulse-fill position-absolute text-white opacity-25" style="font-size: 10rem; bottom: -20px; right: 20px; transform: rotate(-15deg);"></i>
						</div>
					</div>
				</div>
			</div>

			<!-- KPI Stats Cards -->
			<div class="row g-3 mb-4" id="dashboard-stats">
				<!-- Đặt lịch hôm nay -->
				<div class="col-6 col-lg-3">
					<div class="card border-0 shadow-sm rounded-4 h-100 stat-card">
						<div class="card-body p-4 d-flex align-items-center">
							<div class="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0 me-3" style="width: 56px; height: 56px; background: rgba(13, 110, 253, 0.1);">
								<i class="bi bi-calendar-plus-fill fs-4 text-primary"></i>
							</div>
							<div>
								<div class="text-muted small fw-semibold text-uppercase">Đặt lịch hôm nay</div>
								<div class="fw-bold fs-3 text-dark">${todayBooked}</div>
							</div>
						</div>
					</div>
				</div>
				<!-- Đang chờ khám -->
				<div class="col-6 col-lg-3">
					<div class="card border-0 shadow-sm rounded-4 h-100 stat-card">
						<div class="card-body p-4 d-flex align-items-center">
							<div class="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0 me-3" style="width: 56px; height: 56px; background: rgba(255, 193, 7, 0.15);">
								<i class="bi bi-hourglass-split fs-4 text-warning"></i>
							</div>
							<div>
								<div class="text-muted small fw-semibold text-uppercase">Đang chờ khám</div>
								<div class="fw-bold fs-3 text-dark">${todayWaiting}</div>
							</div>
						</div>
					</div>
				</div>
				<!-- Hoàn thành hôm nay -->
				<div class="col-6 col-lg-3">
					<div class="card border-0 shadow-sm rounded-4 h-100 stat-card">
						<div class="card-body p-4 d-flex align-items-center">
							<div class="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0 me-3" style="width: 56px; height: 56px; background: rgba(25, 135, 84, 0.1);">
								<i class="bi bi-check-circle-fill fs-4 text-success"></i>
							</div>
							<div>
								<div class="text-muted small fw-semibold text-uppercase">Hoàn thành hôm nay</div>
								<div class="fw-bold fs-3 text-dark">${todayCompleted}</div>
							</div>
						</div>
					</div>
				</div>
				<!-- Tổng đã khám (All time) -->
				<div class="col-6 col-lg-3">
					<div class="card border-0 shadow-sm rounded-4 h-100 stat-card">
						<div class="card-body p-4 d-flex align-items-center">
							<div class="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0 me-3" style="width: 56px; height: 56px; background: rgba(111, 66, 193, 0.1);">
								<i class="bi bi-award-fill fs-4" style="color: #6f42c1;"></i>
							</div>
							<div>
								<div class="text-muted small fw-semibold text-uppercase">Tổng đã khám</div>
								<div class="fw-bold fs-3 text-dark">${allTimeCompleted}</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Bottom Section: Top 5 + Action Cards -->
			<div class="row g-4">
				<!-- Top 5 Ca khám sớm nhất hôm nay -->
				<div class="col-lg-7">
					<div class="card border-0 shadow-sm rounded-4 h-100" id="dashboard-table-card">
						<div class="card-header bg-white border-bottom pt-4 pb-3 px-4 rounded-top-4">
							<h5 class="fw-bold text-dark mb-0">
								<i class="bi bi-list-ol text-primary me-2"></i>Lịch khám hôm nay
							</h5>
							<small class="text-muted">Top 5 ca khám sớm nhất trong ngày</small>
						</div>
						<div class="card-body p-0">
							<c:choose>
								<c:when test="${not empty top5Earliest}">
									<div class="table-responsive">
										<table class="table table-hover align-middle mb-0">
											<thead class="bg-light">
												<tr>
													<th class="ps-4 text-secondary small text-uppercase fw-semibold">STT</th>
													<th class="text-secondary small text-uppercase fw-semibold">Bệnh nhân</th>
													<th class="text-secondary small text-uppercase fw-semibold">Khung giờ</th>
													<th class="text-secondary small text-uppercase fw-semibold">Số thứ tự</th>
													<th class="pe-4 text-secondary small text-uppercase fw-semibold">Trạng thái</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="apt" items="${top5Earliest}" varStatus="loop">
													<tr>
														<td class="ps-4">
															<span class="badge bg-primary-subtle text-primary rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 30px; height: 30px;">${loop.index + 1}</span>
														</td>
														<td>
															<div class="d-flex align-items-center">
																<div class="rounded-circle bg-light d-flex align-items-center justify-content-center me-2 flex-shrink-0" style="width: 36px; height: 36px;">
																	<i class="bi bi-person-fill text-secondary"></i>
																</div>
																<div>
																	<div class="fw-semibold text-dark">${apt.patient.fullName}</div>
																	<div class="text-muted small">${apt.patient.phone}</div>
																</div>
															</div>
														</td>
														<td>
															<span class="badge bg-light text-primary border px-2 py-1">
																<i class="bi bi-clock me-1"></i>${apt.slot.startTime} - ${apt.slot.endTime}
															</span>
														</td>
														<td>
															<span class="fw-bold text-primary">#${apt.queueNumber}</span>
														</td>
														<td class="pe-4">
															<c:choose>
																<c:when test="${apt.status == 'PENDING'}">
																	<span class="badge bg-warning-subtle text-warning border border-warning-subtle px-2 py-1">Chờ xác nhận</span>
																</c:when>
																<c:when test="${apt.status == 'CONFIRMED'}">
																	<span class="badge bg-info-subtle text-info border border-info-subtle px-2 py-1">Đã xác nhận</span>
																</c:when>
																<c:when test="${apt.status == 'COMPLETED'}">
																	<span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">Hoàn thành</span>
																</c:when>
																<c:otherwise>
																	<span class="badge bg-secondary-subtle text-secondary border px-2 py-1">${apt.status}</span>
																</c:otherwise>
															</c:choose>
														</td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
									</div>
								</c:when>
								<c:otherwise>
									<div class="text-center py-5">
										<i class="bi bi-calendar-x display-5 text-muted opacity-50 d-block mb-3"></i>
										<h6 class="text-secondary fw-semibold">Chưa có lịch khám nào hôm nay</h6>
										<p class="text-muted small">Khi bệnh nhân đặt lịch, danh sách sẽ hiện ở đây.</p>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
						<c:if test="${todayBooked > 5}">
							<div class="card-footer bg-white text-center border-top-0 pb-3">
								<a href="${doc}/appointments" class="text-primary fw-semibold text-decoration-none">
									Xem tất cả ${todayBooked} lịch hẹn <i class="bi bi-arrow-right"></i>
								</a>
							</div>
						</c:if>
					</div>
				</div>

				<!-- Quick Actions -->
				<div class="col-lg-5">
					<div class="row g-4">
						<!-- Card Quản lý Lịch hẹn -->
						<div class="col-12">
							<div class="card border-0 shadow-sm rounded-4 action-card" style="transition: transform 0.2s ease, box-shadow 0.2s ease;">
								<div class="card-body p-4 d-flex align-items-center">
									<div class="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0 me-4" style="width: 64px; height: 64px; background: rgba(13, 110, 253, 0.1);">
										<i class="bi bi-calendar2-check-fill fs-2 text-primary"></i>
									</div>
									<div class="flex-grow-1">
										<h5 class="fw-bold text-dark mb-1">Quản lý Lịch hẹn</h5>
										<p class="text-muted small mb-2">Theo dõi, xác nhận và hoàn thành các cuộc hẹn.</p>
										<a href="${doc}/appointments" class="btn btn-sm btn-primary rounded-pill px-4 fw-semibold shadow-sm">
											Truy cập <i class="bi bi-arrow-right ms-1"></i>
										</a>
									</div>
								</div>
							</div>
						</div>
						<!-- Card Quản lý Lịch rảnh -->
						<div class="col-12">
							<div class="card border-0 shadow-sm rounded-4 action-card" style="transition: transform 0.2s ease, box-shadow 0.2s ease;">
								<div class="card-body p-4 d-flex align-items-center">
									<div class="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0 me-4" style="width: 64px; height: 64px; background: rgba(25, 135, 84, 0.1);">
										<i class="bi bi-clock-fill fs-2 text-success"></i>
									</div>
									<div class="flex-grow-1">
										<h5 class="fw-bold text-dark mb-1">Quản lý Lịch làm</h5>
										<p class="text-muted small mb-2">Thiết lập khung giờ khám để bệnh nhân đặt lịch.</p>
										<a href="${doc}/schedule" class="btn btn-sm btn-success rounded-pill px-4 fw-semibold shadow-sm">
											Thiết lập <i class="bi bi-arrow-right ms-1"></i>
										</a>
									</div>
								</div>
							</div>
						</div>
						<!-- Card Lịch sử Bệnh nhân -->
						<div class="col-12">
							<div class="card border-0 shadow-sm rounded-4 action-card" style="transition: transform 0.2s ease, box-shadow 0.2s ease;">
								<div class="card-body p-4 d-flex align-items-center">
									<div class="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0 me-4" style="width: 64px; height: 64px; background: rgba(111, 66, 193, 0.1);">
										<i class="bi bi-people-fill fs-2" style="color: #6f42c1;"></i>
									</div>
									<div class="flex-grow-1">
										<h5 class="fw-bold text-dark mb-1">Lịch sử Bệnh nhân</h5>
										<p class="text-muted small mb-2">Xem toàn bộ bệnh nhân đã từng khám với bạn.</p>
										<a href="${doc}/patients" class="btn btn-sm btn-outline-secondary rounded-pill px-4 fw-semibold">
											Xem lịch sử <i class="bi bi-arrow-right ms-1"></i>
										</a>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- CSS for Hover Effects -->
			<style>
				.action-card:hover {
					transform: translateY(-4px);
					box-shadow: 0 8px 25px rgba(0,0,0,0.1) !important;
				}
				.stat-card {
					transition: transform 0.15s ease;
				}
				.stat-card:hover {
					transform: translateY(-2px);
				}
			</style>
		</div>
	</main>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		function refreshDashboard() {
			fetch(window.location.href)
				.then(res => res.text())
				.then(html => {
					const parser = new DOMParser();
					const doc = parser.parseFromString(html, 'text/html');
					
					// Replace stats
					const currentStats = document.getElementById('dashboard-stats');
					const newStats = doc.getElementById('dashboard-stats');
					if (currentStats && newStats) {
						currentStats.innerHTML = newStats.innerHTML;
					}
					
					// Replace table
					const currentTable = document.getElementById('dashboard-table-card');
					const newTable = doc.getElementById('dashboard-table-card');
					if (currentTable && newTable) {
						currentTable.innerHTML = newTable.innerHTML;
					}
				})
				.catch(err => console.error("Error refreshing dashboard:", err));
		}
	</script>
</body>
</html>
