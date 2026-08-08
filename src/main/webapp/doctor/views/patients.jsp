<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/doctor/shared/page.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctor Portal - Lịch sử Bệnh nhân</title>
<%@ include file="/admin/shared/page-admin.jsp" %>
</head>
<body class="bg-light">
	<%@ include file="/doctor/shared/header.jsp" %>
	
	<main class="py-5">
		<div class="container-fluid px-4">
			<div class="d-flex justify-content-between align-items-center mb-4">
				<div>
					<h2 class="fw-bold text-dark mb-1"><i class="bi bi-people text-primary me-2"></i>Lịch sử Bệnh nhân</h2>
					<p class="text-muted mb-0">Danh sách các bệnh nhân đã từng đặt lịch khám</p>
				</div>
			</div>

			<!-- Bảng dữ liệu lịch sử -->
			<div class="card border-0 shadow-sm rounded-4 overflow-hidden">
				<div class="card-body p-0">
					<div class="table-responsive">
						<table class="table table-hover align-middle mb-0">
							<thead class="bg-light text-secondary text-uppercase fs-7">
								<tr>
									<th class="ps-4">Mã BN</th>
									<th>Họ và Tên</th>
									<th>Ngày sinh (Tuổi)</th>
									<th>Giới tính</th>
									<th>Số điện thoại</th>
									<th>CCCD</th>
									<th>Mã BHYT</th>
									<th class="text-end pe-4">Thao tác</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty uniquePatients}">
										<c:forEach var="item" items="${uniquePatients}">
											<tr>
												<td class="ps-4 fw-bold text-primary">#BN-${item.id}</td>
												<td>
													<div class="fw-bold text-dark">${item.fullName}</div>
												</td>
												<td>
													<div class="fw-medium text-dark d-flex align-items-center gap-2">
														<c:if test="${not empty item.dateOfBirth}">
															<fmt:parseDate value="${item.dateOfBirth}" pattern="yyyy-MM-dd" var="parsedDob" type="date" />
															<fmt:formatDate value="${parsedDob}" pattern="dd-MM-yyyy" />
															<c:set var="dobYear" value="${fn:substring(item.dateOfBirth, 0, 4)}" />
															<span class="badge bg-secondary-subtle text-secondary rounded-pill">~${2026 - dobYear} tuổi</span>
														</c:if>
														<c:if test="${empty item.dateOfBirth}">
															<span class="text-muted fst-italic">Chưa cập nhật</span>
														</c:if>
													</div>
												</td>
												<td>
													<span class="badge bg-light text-dark border px-2 py-1">${not empty item.gender ? item.gender : 'N/A'}</span>
												</td>
												<td>
												    <div class="text-dark"><i class="bi bi-telephone me-1"></i>${item.phone}</div>
												</td>
												<td>
													<c:choose>
														<c:when test="${not empty item.cccd}">
															<div class="text-dark fw-medium"><i class="bi bi-person-badge me-1"></i>${item.cccd}</div>
														</c:when>
														<c:otherwise>
															<span class="text-muted small fst-italic">Chưa có</span>
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test="${not empty item.healthInsuranceCode}">
															<div class="fw-semibold text-success"><i class="bi bi-card-heading me-1"></i>${item.healthInsuranceCode}</div>
														</c:when>
														<c:otherwise>
															<span class="text-muted small fst-italic">Chưa có</span>
														</c:otherwise>
													</c:choose>
												</td>
												<td class="text-end pe-4">
													<button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#patientModal_${item.id}">
														<i class="bi bi-journal-medical me-1"></i> Hồ sơ
													</button>
												</td>
											</tr>
											
											<!-- Modal Chi tiết Bệnh nhân -->
											<div class="modal fade" id="patientModal_${item.id}" tabindex="-1" aria-hidden="true">
												<div class="modal-dialog modal-dialog-centered">
													<div class="modal-content border-0 shadow">
														<div class="modal-header border-bottom-0 bg-primary text-white">
															<h5 class="modal-title fw-bold"><i class="bi bi-person-lines-fill me-2"></i>Hồ sơ Bệnh nhân</h5>
															<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
														</div>
														<div class="modal-body p-4">
															<div class="text-center mb-4">
																<div class="bg-primary-subtle text-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 70px; height: 70px; font-size: 32px;">
																	<i class="bi bi-person-fill"></i>
																</div>
																<h4 class="fw-bold mb-1">${item.fullName}</h4>
																<p class="text-muted mb-0">Mã bệnh nhân: <span class="fw-semibold text-primary">#BN-${item.id}</span></p>
															</div>
															
															<div class="row g-3">
																<div class="col-6">
																	<div class="text-muted small mb-1">Ngày sinh</div>
																	<div class="fw-medium">
																		<c:if test="${not empty item.dateOfBirth}">
																			<fmt:parseDate value="${item.dateOfBirth}" pattern="yyyy-MM-dd" var="mParsedDob" type="date" />
																			<fmt:formatDate value="${mParsedDob}" pattern="dd-MM-yyyy" />
																		</c:if>
																		<c:if test="${empty item.dateOfBirth}">Chưa có</c:if>
																	</div>
																</div>
																<div class="col-6">
																	<div class="text-muted small mb-1">Giới tính</div>
																	<div class="fw-medium">${not empty item.gender ? item.gender : 'Chưa có'}</div>
																</div>
																<div class="col-6">
																	<div class="text-muted small mb-1">Số điện thoại</div>
																	<div class="fw-medium">${item.phone}</div>
																</div>
																<div class="col-6">
																	<div class="text-muted small mb-1">SĐT Khẩn cấp</div>
																	<div class="fw-medium">${not empty item.emergencyContact ? item.emergencyContact : 'Chưa có'}</div>
																</div>
																<div class="col-12">
																	<div class="text-muted small mb-1">Địa chỉ</div>
																	<div class="fw-medium">${not empty item.address ? item.address : 'Chưa có'}</div>
																</div>
																<div class="col-6">
																	<div class="text-muted small mb-1">Số CCCD</div>
																	<div class="fw-medium">${not empty item.cccd ? item.cccd : 'Chưa có'}</div>
																</div>
																<div class="col-6">
																	<div class="text-muted small mb-1">Mã BHYT</div>
																	<div class="fw-medium text-success">${not empty item.healthInsuranceCode ? item.healthInsuranceCode : 'Chưa có'}</div>
																</div>
																<div class="col-12 mt-4 text-center">
																	<p class="text-muted small fst-italic mb-0">Tính năng xem lịch sử khám bệnh chi tiết đang được phát triển thêm.</p>
																</div>
															</div>
														</div>
														<div class="modal-footer border-top-0">
															<button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
														</div>
													</div>
												</div>
											</div>
											<!-- End Modal -->
											
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="8" class="text-center py-5">
												<div class="py-4">
													<i class="bi bi-people display-5 text-muted opacity-50 d-block mb-3"></i>
													<h5 class="text-secondary fw-semibold">Chưa có bệnh nhân nào</h5>
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
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
