<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="/site/shared/page.jsp"%>

<!DOCTYPE html>
<html lang="vi">

<head>
<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Chỉnh sửa hồ sơ</title>

<!-- Favicon -->
<link rel="icon" type="image/png" href="${ctx}/assets/img/logo.png">

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Bootstrap Icons -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
	
	<!-- CSS dùng cho header/navbar -->
<link rel="stylesheet"
      href="${ctx}/assets/css/client/index.css">

<!-- CSS riêng của trang tài khoản -->
<link rel="stylesheet"
      href="${ctx}/assets/css/client/account.css">

<!-- Google Font -->
<link rel="preconnect" href="https://fonts.googleapis.com">

<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link
	href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap"
	rel="stylesheet">



<body>

	<!-- Header -->
	<header>
		<jsp:include page="/site/shared/header.jsp" />
	</header>

	<main class="account-page">

		<div class="account-card">

			<!-- Phần tiêu đề -->
			<div class="account-card-header">

				<div class="account-header-icon">
					<i class="bi bi-person-gear"></i>
				</div>

				<div>
					<h1>Chỉnh sửa hồ sơ</h1>

					<p>Cập nhật thông tin cá nhân của tài khoản.</p>
				</div>

			</div>

			<div class="account-card-body">

				<!-- Avatar -->
				<div class="account-avatar">
					<i class="bi bi-person-circle"></i>
				</div>

				<!-- Thông báo từ Servlet -->
				<c:if test="${not empty msg}">

					<div id="accountMessage"
						class="alert alert-${empty messageType ? 'info' : messageType}
                                alert-dismissible fade show"
						role="alert">

						<c:choose>

							<c:when test="${messageType == 'success'}">
								<i class="bi bi-check-circle-fill me-2"></i>
							</c:when>

							<c:when test="${messageType == 'danger'}">
								<i class="bi bi-exclamation-circle-fill me-2"></i>
							</c:when>

							<c:otherwise>
								<i class="bi bi-info-circle-fill me-2"></i>
							</c:otherwise>

						</c:choose>

						<c:out value="${msg}" />

						<button type="button" class="btn-close" data-bs-dismiss="alert"
							aria-label="Đóng"></button>

					</div>

				</c:if>

				<!-- Form chỉnh sửa -->
				<form action="${ctx}/account/edit-profile" method="post"
					id="editProfileForm">

					<!-- Họ và tên -->
					<div class="account-form-group">

						<label for="fullName" class="account-form-label"> Họ và
							tên <span class="account-required">*</span>

						</label>

						<div class="input-group">

							<span class="input-group-text"> <i class="bi bi-person"></i>
							</span> <input type="text" class="form-control account-input"
								id="fullName" name="fullName"
								value="${fn:escapeXml(
                                       not empty formFullName
                                           ? formFullName
                                           : sessionScope.user.fullName
                                   )}"
								placeholder="Nhập họ và tên" maxlength="100" required>

						</div>

					</div>

					<!-- Số điện thoại -->
					<div class="account-form-group">

						<label for="phone" class="account-form-label"> Số điện
							thoại <span class="account-required">*</span>

						</label>

						<div class="input-group">

							<span class="input-group-text"> <i class="bi bi-telephone"></i>
							</span> <input type="tel" class="form-control account-input" id="phone"
								name="phone"
								value="${fn:escapeXml(
                                       not empty formPhone
                                           ? formPhone
                                           : sessionScope.user.phone
                                   )}"
								placeholder="Nhập số điện thoại" maxlength="20"
								inputmode="numeric" required>

						</div>

						<div class="form-text">Số điện thoại này đang được sử dụng
							để đăng nhập.</div>

					</div>

					<!-- Email -->
					<div class="account-form-group">

						<label for="email" class="account-form-label"> Email <span
							class="account-required">*</span>

						</label>

						<div class="input-group">

							<span class="input-group-text"> <i class="bi bi-envelope"></i>
							</span> <input type="email" class="form-control account-input"
								id="email" name="email"
								value="${fn:escapeXml(
                                       not empty formEmail
                                           ? formEmail
                                           : sessionScope.user.email
                                   )}"
								placeholder="Nhập địa chỉ email" maxlength="100" required>

						</div>

					</div>

					<!-- Giới tính -->
					<div class="account-form-group">

						<label class="account-form-label"> Giới tính <span
							class="account-required">*</span>

						</label>

						<c:set var="currentGender"
							value="${not empty formGender
                                   ? formGender
                                   : sessionScope.user.gender}" />

						<div class="gender-wrapper">

							<!-- Nam -->
							<div class="gender-option">

								<input type="radio" id="genderMale" name="gender" value="MALE"
									${currentGender == 'MALE'
                                           ? 'checked'
                                           : ''}
									required> <label for="genderMale"> <i
									class="bi bi-gender-male"></i> Nam

								</label>

							</div>

							<!-- Nữ -->
							<div class="gender-option">

								<input type="radio" id="genderFemale" name="gender"
									value="FEMALE"
									${currentGender == 'FEMALE'
                                           ? 'checked'
                                           : ''}
									required> <label for="genderFemale"> <i
									class="bi bi-gender-female"></i> Nữ

								</label>

							</div>

						</div>

					</div>
			
					<!-- Nút thao tác -->
					<div class="account-actions">

						<a href="${ctx}/home/index" class="btn btn-outline-secondary">

							<i class="bi bi-arrow-left me-1"></i> Quay lại

						</a>

						<button type="submit" class="btn account-submit-button">

							<i class="bi bi-floppy me-1"></i> Lưu thay đổi

						</button>

					</div>

				</form>

			</div>

		</div>

	</main>

	<!-- Footer -->
	<footer>
		<jsp:include page="/site/shared/footer.jsp" />
	</footer>

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

	<!-- JavaScript tài khoản -->
	<script src="${ctx}/assets/js/client/account.js"></script>

</body>
</html>  