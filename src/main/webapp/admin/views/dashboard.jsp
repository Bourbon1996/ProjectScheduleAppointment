<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/admin/shared/page.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    
    <head>
    <link rel="stylesheet" href="${ctx}/assets/css/admin/style.css">
    </head>
    
    <!-- Cài đặt Favicon cho web -->
	<link rel="icon" type="image/png" href="${ctx}/assets/img/logo.png">

    <!-- Bootstrap CSS: vẫn giữ để dùng cho navbar -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons: dùng icon người dùng và icon con mắt -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
          
    
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">

</head>

<body>

	<!-- HEADER(Q.ANH) -->
	<header>
		<jsp:include page="/admin/shared/header.jsp"/>
	</header>

	<!--  Minh Hùng -->
	<main class="admin-main">

	    <div class="container-fluid">
	
	        <!-- Tiêu đề Dashboard -->
	        <div class="dashboard-heading">
	            <div>
	                <h1>Dashboard</h1>
	                <p>Chào mừng bạn quay trở lại trang quản trị.</p>
	            </div>
	
	            <div class="dashboard-date">
	                <i class="bi bi-calendar3"></i>
	                <span>Hôm nay</span>
	            </div>
	        </div>
	
	        <!-- Các thẻ thống kê -->
	        <section class="row g-4">
	
	            <!-- Tổng tài khoản -->
	            <div class="col-xl-4 col-md-6">
	                <div class="stat-card">
	                    <div class="stat-icon icon-account">
	                        <i class="bi bi-people-fill"></i>
	                    </div>
	
	                    <div class="stat-content">
	                        <p>Tổng tài khoản</p>
	                        <h2>${empty totalUser ? 0 : totalUser}</h2>
	                        <a href="${ctx}/admin/account">
	                            Xem chi tiết
	                            <i class="bi bi-arrow-right"></i>
	                        </a>
	                    </div>
	                </div>
	            </div>
	
	            <!-- Tổng bác sĩ -->
	            <div class="col-xl-4 col-md-6">
	                <div class="stat-card">
	                    <div class="stat-icon icon-doctor">
	                        <i class="bi bi-person-badge-fill"></i>
	                    </div>
	
	                    <div class="stat-content">
	                        <p>Tổng bác sĩ</p>
	                        <h2>${empty totalDoctor ? 0 : totalDoctor}</h2>
	                        <a href="${ctx}/admin/doctor">
	                            Xem chi tiết
	                            <i class="bi bi-arrow-right"></i>
	                        </a>
	                    </div>
	                </div>
	            </div>
	
	            <!-- Tổng bệnh nhân -->
	            <div class="col-xl-4 col-md-6">
	                <div class="stat-card">
	                    <div class="stat-icon icon-patient">
	                        <i class="bi bi-person-hearts"></i>
	                    </div>
	
	                    <div class="stat-content">
	                        <p>Tổng bệnh nhân</p>
	                        <h2>${empty totalPatient ? 0 : totalPatient}</h2>
	                        <a href="${ctx}/admin/patient">
	                            Xem chi tiết
	                            <i class="bi bi-arrow-right"></i>
	                        </a>
	                    </div>
	                </div>
	            </div>
	            
	            <!-- Tổng chuyên khoa -->
				<div class="col-xl-4 col-md-6">
				    <div class="stat-card">
				        <div class="stat-icon icon-department">
				            <i class="bi bi-diagram-3-fill"></i>
				        </div>
				        
				        <div class="stat-content">
				            <p>Tổng chuyên khoa</p>
				            <h2>${empty totalDepartment ? 0 : totalDepartment}</h2>
				            <a href="${ctx}/admin/department">
				                Xem chi tiết
				                <i class="bi bi-arrow-right"></i>
				            </a>
				        </div>
				    </div>
				</div>
	
	            <!-- Tổng lịch khám -->
	            <div class="col-xl-4 col-md-6">
	                <div class="stat-card">
	                    <div class="stat-icon icon-schedule">
	                        <i class="bi bi-calendar-week-fill"></i>
	                    </div>
	
	                    <div class="stat-content">
	                        <p>Tổng lịch khám</p>
	                        <h2>${empty totalSchedules ? 0 : totalSchedules}</h2>
	                        <a href="${ctx}/admin/schedules">
	                            Xem chi tiết
	                            <i class="bi bi-arrow-right"></i>
	                        </a>
	                    </div>
	                </div>
	            </div>
	
	            <!-- Tổng lịch hẹn -->
	            <div class="col-xl-4 col-md-6">
	                <div class="stat-card">
	                    <div class="stat-icon icon-appointment">
	                        <i class="bi bi-calendar-check-fill"></i>
	                    </div>
	
	                    <div class="stat-content">
	                        <p>Tổng lịch hẹn</p>
	                        <h2>${empty totalAppointments ? 0 : totalAppointments}</h2>
	                        <a href="${ctx}/admin/appointment">
	                            Xem chi tiết
	                            <i class="bi bi-arrow-right"></i>
	                        </a>
	                    </div>
	                </div>
	            </div>
	
	            <!-- Doanh thu -->
	            <div class="col-xl-4 col-md-6">
	                <div class="stat-card">
	                    <div class="stat-icon icon-revenue">
	                        <i class="bi bi-cash-stack"></i>
	                    </div>
	
	                    <div class="stat-content">
	                        <p>Tổng doanh thu</p>
	                        <h2>
	                            ${empty totalRevenue ? 0 : totalRevenue}
	                            <small>VNĐ</small>
	                        </h2>
	
	                        <a href="${ctx}/admin/revenue">
	                            Xem chi tiết
	                            <i class="bi bi-arrow-right"></i>
	                        </a>
	                    </div>
	                </div>
	            </div>
	
	        </section>
	
	        <!-- Nội dung phía dưới -->
	        <section class="row g-4 mt-1">
	
	            <!-- Danh sách lịch hẹn gần đây -->
	            <div class="col-xl-8">
	
	                <div class="dashboard-panel">
	
	                    <div class="panel-header">
	                        <div>
	                            <h3>Lịch hẹn gần đây</h3>
	                            <p>Danh sách các lịch hẹn mới nhất.</p>
	                        </div>
	
	                        <a href="${ctx}/admin/appointment"
	                           class="btn-view-all">
	                            Xem tất cả
	                        </a>
	                    </div>
	
	                    <div class="table-responsive">
	
	                        <table class="table appointment-table align-middle">
	
	                            <thead>
	                                <tr>
	                                    <th>Mã lịch hẹn</th>
	                                    <th>Bệnh nhân</th>
	                                    <th>Bác sĩ</th>
	                                    <th>Ngày khám</th>
	                                    <th>Trạng thái</th>
	                                    <th>Thao tác</th>
	                                </tr>
	                            </thead>
	
	                            <tbody>
	
	                                <!-- Dữ liệu mẫu -->
	                                <tr>
	                                    <td>#LH001</td>
	
	                                    <td>
	                                        <div class="patient-info">
	                                            <div class="patient-avatar">
	                                                N
	                                            </div>
	
	                                            <div>
	                                                <strong>Nguyễn Văn An</strong>
	                                                <span>0901234567</span>
	                                            </div>
	                                        </div>
	                                    </td>
	
	                                    <td>BS. Trần Minh Tuấn</td>
	
	                                    <td>
	                                        <span>28/07/2026</span>
	                                        <small>08:30</small>
	                                    </td>
	
	                                    <td>
	                                        <span class="status-badge status-confirmed">
	                                            Đã xác nhận
	                                        </span>
	                                    </td>
	
	                                    <td>
	                                        <a href="${ctx}/admin/appointments/detail?id=1"
	                                           class="action-button"
	                                           title="Xem chi tiết">
	                                            <i class="bi bi-eye"></i>
	                                        </a>
	                                    </td>
	                                </tr>
	
	                                <tr>
	                                    <td>#LH002</td>
	
	                                    <td>
	                                        <div class="patient-info">
	                                            <div class="patient-avatar">
	                                                T
	                                            </div>
	
	                                            <div>
	                                                <strong>Trần Thị Mai</strong>
	                                                <span>0912345678</span>
	                                            </div>
	                                        </div>
	                                    </td>
	
	                                    <td>BS. Nguyễn Hoàng Nam</td>
	
	                                    <td>
	                                        <span>28/07/2026</span>
	                                        <small>10:00</small>
	                                    </td>
	
	                                    <td>
	                                        <span class="status-badge status-pending">
	                                            Chờ xác nhận
	                                        </span>
	                                    </td>
	
	                                    <td>
	                                        <a href="${ctx}/admin/appointments/detail?id=2"
	                                           class="action-button"
	                                           title="Xem chi tiết">
	                                            <i class="bi bi-eye"></i>
	                                        </a>
	                                    </td>
	                                </tr>
	
	                                <tr>
	                                    <td>#LH003</td>
	
	                                    <td>
	                                        <div class="patient-info">
	                                            <div class="patient-avatar">
	                                                L
	                                            </div>
	
	                                            <div>
	                                                <strong>Lê Minh Khang</strong>
	                                                <span>0923456789</span>
	                                            </div>
	                                        </div>
	                                    </td>
	
	                                    <td>BS. Phạm Thanh Hà</td>
	
	                                    <td>
	                                        <span>29/07/2026</span>
	                                        <small>14:30</small>
	                                    </td>
	
	                                    <td>
	                                        <span class="status-badge status-completed">
	                                            Đã hoàn thành
	                                        </span>
	                                    </td>
	
	                                    <td>
	                                        <a href="${ctx}/admin/appointments/detail?id=3"
	                                           class="action-button"
	                                           title="Xem chi tiết">
	                                            <i class="bi bi-eye"></i>
	                                        </a>
	                                    </td>
	                                </tr>
	
	                            </tbody>
	                        </table>
	
	                    </div>
	                </div>
	            </div>
	
	            <!-- Thao tác nhanh -->
	            <div class="col-xl-4">
	
	                <div class="dashboard-panel quick-action-panel">
	
	                    <div class="panel-header">
	                        <div>
	                            <h3>Thao tác nhanh</h3>
	                            <p>Truy cập nhanh các chức năng quản lý.</p>
	                        </div>
	                    </div>
	
	                    <div class="quick-action-list">
	
	                        <a href="${ctx}/admin/doctors/create"
	                           class="quick-action-item">
	
	                            <div class="quick-action-icon">
	                                <i class="bi bi-person-plus-fill"></i>
	                            </div>
	
	                            <div>
	                                <strong>Thêm bác sĩ</strong>
	                                <span>Tạo hồ sơ bác sĩ mới</span>
	                            </div>
	
	                            <i class="bi bi-chevron-right"></i>
	                        </a>
	
	                        <a href="${ctx}/admin/schedules/create"
	                           class="quick-action-item">
	
	                            <div class="quick-action-icon">
	                                <i class="bi bi-calendar-plus-fill"></i>
	                            </div>
	
	                            <div>
	                                <strong>Tạo lịch khám</strong>
	                                <span>Thêm lịch làm việc cho bác sĩ</span>
	                            </div>
	
	                            <i class="bi bi-chevron-right"></i>
	                        </a>
	
	                        <a href="${ctx}/admin/appointments"
	                           class="quick-action-item">
	
	                            <div class="quick-action-icon">
	                                <i class="bi bi-calendar-check-fill"></i>
	                            </div>
	
	                            <div>
	                                <strong>Quản lý lịch hẹn</strong>
	                                <span>Kiểm tra và xác nhận lịch hẹn</span>
	                            </div>
	
	                            <i class="bi bi-chevron-right"></i>
	                        </a>
	
	                        <a href="${ctx}/admin/accounts"
	                           class="quick-action-item">
	
	                            <div class="quick-action-icon">
	                                <i class="bi bi-people-fill"></i>
	                            </div>
	
	                            <div>
	                                <strong>Quản lý tài khoản</strong>
	                                <span>Xem và cập nhật tài khoản</span>
	                            </div>
	
	                            <i class="bi bi-chevron-right"></i>
	                        </a>
	
	                    </div>
	                </div>
	            </div>
	
	        </section>
	
	    </div>
	
	</main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>