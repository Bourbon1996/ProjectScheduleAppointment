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
	
	<main class="py-5">
		<div class="container-fluid px-4">
			<div class="d-flex justify-content-between align-items-center mb-4">
				<div>
					<h2 class="fw-bold text-dark mb-1"><i class="bi bi-person-badge text-primary me-2"></i>Dashboard</h2>
					<p class="text-muted mb-0">Xin chào Bác sĩ ${sessionScope.user.fullName}!</p>
				</div>
			</div>

			<div class="row g-4">
				<div class="col-md-6 col-lg-4">
					<div class="card border-0 shadow-sm rounded-4 h-100">
						<div class="card-body p-4 text-center">
							<div class="display-4 text-primary mb-3">
								<i class="bi bi-calendar-check"></i>
							</div>
							<h5 class="fw-bold text-dark mb-3">Quản lý Lịch hẹn</h5>
							<p class="text-muted mb-4">Xem và xử lý các cuộc hẹn của bệnh nhân đặt với bạn.</p>
							<a href="${doc}/appointments" class="btn btn-outline-primary rounded-pill px-4">Xem danh sách</a>
						</div>
					</div>
				</div>

				<div class="col-md-6 col-lg-4">
					<div class="card border-0 shadow-sm rounded-4 h-100">
						<div class="card-body p-4 text-center">
							<div class="display-4 text-success mb-3">
								<i class="bi bi-clock-history"></i>
							</div>
							<h5 class="fw-bold text-dark mb-3">Quản lý Lịch rảnh</h5>
							<p class="text-muted mb-4">Thiết lập các khung giờ rảnh để bệnh nhân có thể đặt lịch.</p>
							<a href="${doc}/schedule" class="btn btn-outline-success rounded-pill px-4">Thiết lập ngay</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
