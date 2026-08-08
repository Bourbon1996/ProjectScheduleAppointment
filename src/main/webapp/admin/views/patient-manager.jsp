<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/admin/shared/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hồ sơ Bệnh nhân (EMR) - Admin</title>
<%@ include file="/admin/shared/page-admin.jsp" %>
<style>
    .patient-item {
        cursor: pointer;
        transition: all 0.2s;
    }
    .patient-item:hover {
        background-color: #f8f9fa;
    }
    .patient-item.active {
        background-color: #e9ecef;
        border-left: 4px solid #0d6efd !important;
    }
</style>
</head>
<body class="bg-light">
	<%@ include file="/admin/shared/header.jsp" %>
	
	<main class="admin-main">
		<div class="container-fluid px-2">
			<h2 class="fw-bold mb-4" style="color: #0d68aa;">Hồ sơ Bệnh nhân Điện tử (EMR)</h2>

            <div class="row">
                <!-- MASTER LIST (LEFT COL) -->
                <div class="col-md-4 mb-4">
                    <div class="card border-0 shadow-sm h-100 rounded-4">
                        <div class="card-header bg-white p-3 border-bottom">
                            <form method="GET" action="${ctx}/admin/patient" class="d-flex">
                                <input type="text" class="form-control me-2" name="search" placeholder="Tìm tên, SĐT..." value="${param.search}">
                                <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i></button>
                            </form>
                        </div>
                        <div class="card-body p-0" style="height: 70vh; overflow-y: auto;">
                            <div class="list-group list-group-flush">
                                <c:forEach var="item" items="${listPatients}">
                                    <div class="list-group-item patient-item p-3 border-start border-0 border-bottom" 
                                         onclick="loadPatientDetails(this)"
                                         id="patient-item-${item.id}"
                                         data-id="${item.id}"
                                         data-name="${fn:escapeXml(item.fullName)}"
                                         data-phone="${empty item.phone ? 'Chưa có' : fn:escapeXml(item.phone)}"
                                         data-gender="${empty item.gender ? 'Chưa có' : item.gender}"
                                         data-dob="${empty item.dateOfBirth ? 'Chưa có' : item.dateOfBirth}"
                                         data-address="${empty item.address ? 'Chưa có' : fn:escapeXml(item.address)}"
                                         data-cccd="${empty item.cccd ? 'Chưa có' : fn:escapeXml(item.cccd)}"
                                         data-email="${empty item.email ? 'Chưa có' : fn:escapeXml(item.email)}"
                                         data-bhyt="${empty item.healthInsuranceCode ? 'Chưa có' : fn:escapeXml(item.healthInsuranceCode)}"
                                         data-relation="${item.relationship != null ? item.relationship.displayName : 'Bản thân'}"
                                         data-bookedby="${item.user != null ? fn:escapeXml(item.user.fullName) : 'Bản thân'}">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <h6 class="mb-0 fw-bold text-primary">${item.fullName}</h6>
                                            <span class="badge bg-light text-dark border">Tạo bởi: ${item.user.fullName}</span>
                                        </div>
                                        <div class="text-muted small">
                                            <i class="bi bi-telephone me-1"></i>${empty item.phone ? 'Chưa có SĐT' : item.phone}
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- DETAIL VIEW (RIGHT COL) -->
                <div class="col-md-8 mb-4">
                    <div class="card border-0 shadow-sm h-100 rounded-4" id="patient-detail-card" style="display: none;">
                        <div class="card-body p-4">
                            <!-- Hành chính -->
                            <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-4">
                                <div>
                                    <h3 class="fw-bold text-primary mb-1" id="detail-name">Tên Bệnh Nhân</h3>
                                    <p class="text-muted mb-0"><i class="bi bi-telephone me-1"></i> <span id="detail-phone"></span></p>
                                </div>
                                <div class="text-end text-muted">
                                    <span class="badge bg-primary px-3 py-2 fs-6" id="detail-bookedby">Booked By</span>
                                </div>
                            </div>
                            
                            <!-- Bảng thông tin chi tiết -->
                            <h6 class="fw-bold mb-3 text-secondary text-uppercase fs-7"><i class="bi bi-person-lines-fill me-2"></i>Thông tin chung</h6>
                            <div class="row g-3 mb-4">
                                <div class="col-sm-6">
                                    <p class="mb-1 text-muted small">Giới tính</p>
                                    <p class="mb-0 fw-medium" id="detail-gender"></p>
                                </div>
                                <div class="col-sm-6">
                                    <p class="mb-1 text-muted small">Ngày sinh</p>
                                    <p class="mb-0 fw-medium" id="detail-dob"></p>
                                </div>
                                <div class="col-sm-6">
                                    <p class="mb-1 text-muted small">Mối quan hệ</p>
                                    <p class="mb-0 fw-medium" id="detail-relation"></p>
                                </div>
                                <div class="col-sm-6">
                                    <p class="mb-1 text-muted small">Căn cước công dân</p>
                                    <p class="mb-0 fw-medium" id="detail-cccd"></p>
                                </div>
                                <div class="col-sm-6">
                                    <p class="mb-1 text-muted small">Email</p>
                                    <p class="mb-0 fw-medium" id="detail-email"></p>
                                </div>
                                <div class="col-sm-6">
                                    <p class="mb-1 text-muted small">Mã BHYT</p>
                                    <p class="mb-0 fw-medium" id="detail-bhyt"></p>
                                </div>
                                <div class="col-12">
                                    <p class="mb-1 text-muted small">Địa chỉ</p>
                                    <p class="mb-0 fw-medium" id="detail-address"></p>
                                </div>
                            </div>
                            
                            <!-- Tiền sử dị ứng -->
                            <div class="alert alert-danger mb-4 d-flex align-items-center">
                                <i class="bi bi-exclamation-triangle-fill fs-4 me-3"></i>
                                <div>
                                    <h6 class="alert-heading fw-bold mb-1">TIỀN SỬ DỊ ỨNG</h6>
                                    <p class="mb-0 small">Chưa ghi nhận (Cần cập nhật trong quá trình khám)</p>
                                </div>
                            </div>

                            <!-- Lịch sử khám -->
                            <h6 class="fw-bold mb-3 text-secondary text-uppercase fs-7"><i class="bi bi-clock-history me-2"></i>Lịch sử khám bệnh</h6>
                            <div class="bg-light rounded-4 p-3 border">
                                <div id="timeline-container">
                                    <!-- AJAX nội dung sẽ load vào đây -->
                                    <div class="text-center text-muted"><div class="spinner-border text-primary" role="status"></div> Đang tải...</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Placeholder khi chưa chọn bệnh nhân -->
                    <div class="card border-0 shadow-sm h-100 rounded-4 d-flex align-items-center justify-content-center text-muted" id="empty-state">
                        <div class="text-center p-5">
                            <i class="bi bi-person-vcard fs-1 mb-3 text-secondary"></i>
                            <h5>Chọn một bệnh nhân</h5>
                            <p>Vui lòng chọn bệnh nhân ở danh sách bên trái để xem Hồ sơ Bệnh án Điện tử.</p>
                        </div>
                    </div>
                </div>
            </div>

		</div>
	</main>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function loadPatientDetails(el) {
            // Update UI
            document.querySelectorAll('.patient-item').forEach(e => e.classList.remove('active'));
            el.classList.add('active');
            
            document.getElementById('empty-state').classList.remove('d-flex');
            document.getElementById('empty-state').style.display = 'none';
            document.getElementById('patient-detail-card').style.display = 'block';
            
            const ds = el.dataset;
            document.getElementById('detail-name').innerText = ds.name;
            document.getElementById('detail-phone').innerText = ds.phone;
            document.getElementById('detail-gender').innerText = ds.gender;
            document.getElementById('detail-dob').innerText = ds.dob;
            document.getElementById('detail-address').innerText = ds.address;
            document.getElementById('detail-cccd').innerText = ds.cccd;
            document.getElementById('detail-email').innerText = ds.email;
            document.getElementById('detail-bhyt').innerText = ds.bhyt;
            document.getElementById('detail-relation').innerText = ds.relation;
            document.getElementById('detail-bookedby').innerHTML = 'Tạo bởi: ' + ds.bookedby;
            
            // Show loading
            const timelineContainer = document.getElementById('timeline-container');
            timelineContainer.innerHTML = '<div class="text-center text-muted py-5"><div class="spinner-border text-primary mb-3" role="status"></div><br>Đang lấy dữ liệu bệnh án...</div>';
            
            // Fetch History via AJAX
            fetch('${ctx}/admin/patients/history?id=' + ds.id)
                .then(response => response.text())
                .then(html => {
                    timelineContainer.innerHTML = html;
                })
                .catch(err => {
                    console.error("Error loading timeline:", err);
                    timelineContainer.innerHTML = '<div class="alert alert-danger">Lỗi kết nối khi lấy bệnh án!</div>';
                });
        }
    </script>
</body>
</html>
