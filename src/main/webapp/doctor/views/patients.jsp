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
									<th class="ps-4">Họ và Tên</th>
									<th>Ngày sinh</th>
									<th>Giới tính</th>
									<th>Số điện thoại</th>
									<th>Mối quan hệ (với tài khoản)</th>
									<th>Địa chỉ</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty uniquePatients}">
										<c:forEach var="item" items="${uniquePatients}">
											<tr>
												<td class="ps-4 fw-bold text-primary">${item.fullName}</td>
												<td>
													<div class="fw-medium text-dark">
														<c:if test="${not empty item.dateOfBirth}">
															<fmt:parseDate value="${item.dateOfBirth}" pattern="yyyy-MM-dd" var="parsedDob" type="date" />
															<fmt:formatDate value="${parsedDob}" pattern="dd-MM-yyyy" />
														</c:if>
													</div>
												</td>
												<td>
													<span class="badge bg-light text-dark border px-2 py-1">${item.gender}</span>
												</td>
												<td>
												    <div class="text-dark"><i class="bi bi-telephone me-1"></i>${item.phone}</div>
												</td>
												<td>
													<span class="badge bg-info-subtle text-info-emphasis px-2 py-1">${item.relationship != null ? item.relationship.displayName : 'Bản thân'}</span>
												</td>
												<td>
													<small class="text-muted">${item.address}</small>
												</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="6" class="text-center py-5">
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
