<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/admin/shared/page-admin.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý Bệnh nhân - Admin</title>
</head>
<body class="bg-light">
	<%@ include file="/admin/shared/header.jsp" %>
	
	<main class="py-4">
		<div class="container-fluid px-4">
			<h2 class="fw-bold mb-4">Quản lý Bệnh nhân</h2>

            <!-- Lọc & Tìm kiếm -->
			<div class="card border-0 shadow-sm rounded-4 mb-4">
			    <div class="card-body p-4">
			        <form method="GET" action="${ctx}/admin/patient" class="row g-3 align-items-center">
			            <div class="col-md-5">
			                <input type="text" class="form-control" name="search" placeholder="Tìm theo Tên, SĐT bệnh nhân..." value="${param.search}">
			            </div>
			            <div class="col-md-5">
			                <button type="submit" class="btn btn-primary px-4"><i class="bi bi-search me-1"></i> Tìm kiếm</button>
			                <a href="${ctx}/admin/patient" class="btn btn-outline-secondary px-4 ms-2"><i class="bi bi-arrow-counterclockwise me-1"></i> Làm mới</a>
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
									<th class="ps-4">Họ và tên</th>
									<th>Mối quan hệ</th>
									<th>Ngày sinh</th>
									<th>Giới tính</th>
									<th>Số điện thoại</th>
									<th>Địa chỉ</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty listPatients}">
										<c:forEach var="item" items="${listPatients}">
											<tr>
												<td class="ps-4 fw-bold text-primary">${item.fullName}</td>
												<td>
													<span class="badge bg-info-subtle text-info-emphasis px-2 py-1">${item.relationship != null ? item.relationship.displayName : 'Bản thân'}</span>
												</td>
												<td>${item.dateOfBirth}</td>
												<td>${item.gender}</td>
												<td>${item.phone}</td>
												<td><small class="text-muted">${item.address}</small></td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="6" class="text-center py-5 text-muted">Chưa có dữ liệu bệnh nhân</td>
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
