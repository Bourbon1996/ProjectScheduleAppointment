<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/site/shared/page.jsp"%>

<nav class="navbar navbar-expand-sm hospital-navbar p-0">

	<div class="container-fluid pe-0">

		<ul class="navbar-nav w-100 align-items-stretch">

			<li class="nav-item"><a class="nav-link"
				href="${ctx}/home/index"> <img
					src="${pageContext.request.contextPath}/assets/img/logo.png"
					alt="Logo" class="nav-logo">
			</a></li>

			<li class="nav-item"><a class="nav-link"
				href="${ctx}/home/index">Home</a></li>


			<!-- Chuyên Khoa (Pure CSS Mega Menu - Chỉ Hover, không cần Click) -->
			<li class="nav-item mega-dropdown"><a
				class="nav-link d-flex align-items-center" href="#"
				id="navbarDropdownCK"> Chuyên khoa <i
					class="bi bi-chevron-down ms-1" style="font-size: 0.75rem;"></i>
			</a> <!-- CONTAINER MEGA MENU CỐ ĐỊNH -->
				<div class="dropdown-menu mega-menu-container shadow-lg border-0"
					aria-labelledby="navbarDropdownCK">
					<div class="mega-menu-content d-flex">


						<div class="parent-column">
							<ul class="parent-list list-unstyled mb-0">
								<c:forEach items="${listDepartmentsParent}" var="parent"
									varStatus="loop">

									<li class="parent-item"><a
										class="parent-link d-flex justify-content-between align-items-center"
										href="${pageContext.request.contextPath}/chuyen-khoa/${parent.id}">
											<span>${parent.name}</span> <c:if
												test="${not empty parent.subDepartments}">
												<i class="bi bi-chevron-right small"></i>
											</c:if>
									</a> <c:if test="${not empty parent.subDepartments}">
											<div class="child-column shadow-sm">
												<div class="child-scroll-box">
													<ul class="child-list list-unstyled mb-0">
														<c:forEach items="${parent.subDepartments}" var="child">
															<li><a class="child-link"
																href="${pageContext.request.contextPath}/chuyen-khoa/${child.id}">
																	${child.name} </a></li>
														</c:forEach>
													</ul>
												</div>
											</div>
										</c:if></li>

								</c:forEach>
							</ul>
						</div>

						<!-- Cột phải mặc định -->
						<div class="child-column-placeholder">
							<div class="text-muted small p-4">Di chuột vào khoa bên
								trái để xem danh sách chi tiết</div>
						</div>

					</div>
				</div></li>

			<li class="nav-item"><a class="nav-link" href="${ctx}/home/doctor">Bác
					sĩ</a></li>
					
			<c:if test="${not empty sessionScope.user}">
				<li class="nav-item"><a class="nav-link" href="${ctx}/appointment/history"> Lịch sử đặt lịch</a></li>
			</c:if>

			<li class="nav-item dropdown mega-dropdown"><a
				class="nav-link dropdown-toggle-custom" href="#" role="button"
				aria-expanded="false"> Về bệnh viện <i
					class="bi bi-chevron-down ms-1" style="font-size: 0.75rem;"></i>
			</a>

				<div class="dropdown-menu mega-menu p-0">
					<div class="row g-0">

						<div class="col-md-8 mega-menu-intro">
							<h3 class="mega-menu-title">Về Bệnh viện</h3>
							<p>Bệnh viện Đại học Y Dược TP. Hồ Chí Minh là bệnh viện công
								lập hạng I, đa khoa chuyên sâu kỹ thuật cao, trực thuộc Đại học
								Y Dược TP. Hồ Chí Minh có chất lượng hàng đầu cả nước. Sự kết
								hợp hài hòa giữa người Thầy giáo - Thầy thuốc và Nhà khoa học,
								sự gắn kết Trường - Viện đã tạo nên thế mạnh của Bệnh viện.</p>
							<p>Những trụ cột quan trọng: Điều trị chuyên sâu - Đào tạo
								chuẩn mực - Nghiên cứu đột phá - Quản trị hiện đại tạo nền móng
								vững chắc để Bệnh viện khẳng định vị thế trên bản đồ y khoa
								trong nước và quốc tế.</p>
						</div>

						<div class="col-md-4 about-links">
							<a class="about-link"
								href="${pageContext.request.contextPath}/ve-benh-vien/gioi-thieu">
								Giới thiệu tổng quan </a> <a class="about-link"
								href="${pageContext.request.contextPath}/ve-benh-vien/lich-su">
								Lịch sử Bệnh viện </a> <a class="about-link"
								href="${pageContext.request.contextPath}/ve-benh-vien/tam-nhin">
								Tầm nhìn - Sứ mệnh - Giá trị cốt lõi </a> <a class="about-link"
								href="${pageContext.request.contextPath}/ve-benh-vien/ban-lanh-dao">
								Ban lãnh đạo </a> <a class="about-link"
								href="${pageContext.request.contextPath}/ve-benh-vien/don-vi">
								Các đơn vị </a> <a class="about-link"
								href="${pageContext.request.contextPath}/ve-benh-vien/thanh-tuu">
								Thành tựu và giải thượng </a> <a class="about-link"
								href="${pageContext.request.contextPath}/ve-benh-vien/lien-he">
								Liên hệ </a>
						</div>
					</div>
				</div></li>

			<li class="nav-item ms-auto"><a
				class="nav-link appointment-link" href="${ctx}/appointment"> Đặt
					lịch khám </a></li>

			<!-- Tài khoản -->
			
			<c:choose>

				<%-- Chưa đăng nhập --%>
				<c:when test="${empty sessionScope.user}">

					<li class="nav-item"><a href="#"
						class="navbar-icon account-icon" id="openLoginPopup"
						title="Đăng nhập"> <i class="bi bi-person"></i>
					</a></li>

				</c:when>

				<%-- Đã đăng nhập --%>
				<c:otherwise>

					<li class="nav-item dropdown account-dropdown">
						<!-- Icon tài khoản -->
						<button type="button"
							class="navbar-icon account-icon account-dropdown-button"
							data-bs-toggle="dropdown" aria-expanded="false"
							title="${sessionScope.user.fullName}">

							<i class="bi bi-person-check-fill"></i>

						</button> <!-- Menu tài khoản -->
						<ul
							class="dropdown-menu dropdown-menu-end account-dropdown-menu shadow">

							<!-- Thông tin người dùng -->
							<li>
								<div class="dropdown-item-text">

									<div class="fw-bold text-dark">
										<c:out value="${sessionScope.user.fullName}" />
									</div>

							<%-- <div class="small text-muted">
										<c:out value="${sessionScope.user.email}" />
								</div> --%>

								</div>
							</li>

							<li>
								<hr class="dropdown-divider">
							</li>

							<!-- Chỉnh sửa thông tin -->
							<c:if test="${sessionScope.user.role == 'DOCTOR'}">
								<li>
								    <a class="dropdown-item text-primary fw-bold"
								       href="${ctx}/doctor-portal">
								        <i class="bi bi-briefcase-medical me-2"></i>
								        Doctor Portal
								    </a>
								</li>
								<li><hr class="dropdown-divider"></li>
							</c:if>
							
							<c:if test="${sessionScope.user.role == 'ADMIN'}">
								<li>
								    <a class="dropdown-item text-primary fw-bold"
								       href="${ctx}/admin/dashboard">
								        <i class="bi bi-speedometer2 me-2"></i>
								        Admin Portal
								    </a>
								</li>
								<li><hr class="dropdown-divider"></li>
							</c:if>

							<li>
							    <a class="dropdown-item"
							       href="${ctx}/account/edit-profile">
							
							        <i class="bi bi-person-gear me-2"></i>
							        Chỉnh sửa hồ sơ
							    </a>
							</li>
							
							<li>
							    <a class="dropdown-item"
							       href="${ctx}/account/change-password">
							
							        <i class="bi bi-key me-2"></i>
							        Đổi mật khẩu
							    </a>
							</li>
							<!-- Đăng xuất -->							
								<li>
								    <a class="dropdown-item text-danger"
								       href="${ctx}/auth/logout">
								
								        <i class="bi bi-box-arrow-right me-2"></i>
								        Đăng xuất
								    </a>
								</li>

						</ul>

					</li>

				</c:otherwise>

			</c:choose>

			<!-- Tìm kiếm -->
			<li class="nav-item"><a class="navbar-icon search-icon"
				href="${ctx}/search" title="Tìm kiếm"> <i class="bi bi-search"></i>
			</a></li>

		</ul>
	</div>
</nav>
<!-- Popup Auth -->
<jsp:include page="/site/shared/Auth.jsp" />
<script src="${ctx}/assets/js/client/auth.js"></script>