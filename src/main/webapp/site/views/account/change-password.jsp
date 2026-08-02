<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="/site/shared/page.jsp" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Đổi mật khẩu</title>

    <!-- Favicon -->
    <link rel="icon"
          type="image/png"
          href="${ctx}/assets/img/logo.png">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

    <!-- Google Font -->
    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap"
          rel="stylesheet">

    <!-- CSS header hiện tại -->
    <link rel="stylesheet"
          href="${ctx}/assets/css/client/index.css">

    <!-- CSS dùng chung cho trang tài khoản -->
    <link rel="stylesheet"
          href="${ctx}/assets/css/client/account.css">
</head>

<body>

    <!-- Header -->
    <header>
        <jsp:include page="/site/shared/header.jsp"/>
    </header>

    <main class="account-page">

        <div class="account-card account-password-card">

            <!-- Phần tiêu đề -->
            <div class="account-card-header">

                <div class="account-header-icon">
                    <i class="bi bi-shield-lock"></i>
                </div>

                <div>
                    <h1>Đổi mật khẩu</h1>

                    <p>
                        Cập nhật mật khẩu để bảo vệ tài khoản của bạn.
                    </p>
                </div>

            </div>

            <div class="account-card-body">

                <!-- Biểu tượng -->
                <div class="account-avatar">
                    <i class="bi bi-key"></i>
                </div>

                <!-- Thông báo từ Servlet -->
                <c:if test="${not empty msg}">

                    <div id="accountMessage"
                         class="alert alert-${empty messageType
                            ? 'info'
                            : messageType}
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

                        <c:out value="${msg}"/>

                        <button type="button"
                                class="btn-close"
                                data-bs-dismiss="alert"
                                aria-label="Đóng">
                        </button>

                    </div>

                </c:if>

                <!-- Lỗi kiểm tra bằng JavaScript -->
                <div id="passwordClientError"
                     class="alert alert-danger d-none"
                     role="alert">
                </div>

                <!-- Form đổi mật khẩu -->
                <form action="${ctx}/account/change-password"
                      method="post"
                      id="changePasswordForm">

                    <!-- Mật khẩu hiện tại -->
                    <div class="account-form-group">

                        <label for="currentPassword"
                               class="account-form-label">

                            Mật khẩu hiện tại
                            <span class="account-required">*</span>

                        </label>

                        <div class="input-group account-password-wrapper">

                            <span class="input-group-text">
                                <i class="bi bi-lock"></i>
                            </span>

                            <input type="password"
                                   class="form-control account-input"
                                   id="currentPassword"
                                   name="currentPassword"
                                   placeholder="Nhập mật khẩu hiện tại"
                                   autocomplete="current-password"
                                   required>

                            <button type="button"
                                    class="account-password-toggle"
                                    data-input="currentPassword"
                                    title="Hiện hoặc ẩn mật khẩu">

                                <i class="bi bi-eye"></i>

                            </button>

                        </div>

                    </div>

                    <!-- Mật khẩu mới -->
                    <div class="account-form-group">

                        <label for="newPassword"
                               class="account-form-label">

                            Mật khẩu mới
                            <span class="account-required">*</span>

                        </label>

                        <div class="input-group account-password-wrapper">

                            <span class="input-group-text">
                                <i class="bi bi-shield-lock"></i>
                            </span>

                            <input type="password"
                                   class="form-control account-input"
                                   id="newPassword"
                                   name="newPassword"
                                   placeholder="Nhập mật khẩu mới"
                                   minlength="6"
                                   autocomplete="new-password"
                                   required>

                            <button type="button"
                                    class="account-password-toggle"
                                    data-input="newPassword"
                                    title="Hiện hoặc ẩn mật khẩu">

                                <i class="bi bi-eye"></i>

                            </button>

                        </div>

                        <div class="form-text">
                            Mật khẩu mới phải có ít nhất 6 ký tự.
                        </div>

                    </div>

                    <!-- Xác nhận mật khẩu -->
                    <div class="account-form-group">

                        <label for="confirmPassword"
                               class="account-form-label">

                            Xác nhận mật khẩu mới
                            <span class="account-required">*</span>

                        </label>

                        <div class="input-group account-password-wrapper">

                            <span class="input-group-text">
                                <i class="bi bi-shield-check"></i>
                            </span>

                            <input type="password"
                                   class="form-control account-input"
                                   id="confirmPassword"
                                   name="confirmPassword"
                                   placeholder="Nhập lại mật khẩu mới"
                                   minlength="6"
                                   autocomplete="new-password"
                                   required>

                            <button type="button"
                                    class="account-password-toggle"
                                    data-input="confirmPassword"
                                    title="Hiện hoặc ẩn mật khẩu">

                                <i class="bi bi-eye"></i>

                            </button>

                        </div>

                    </div>

                    <!-- Lưu ý -->
                    <div class="account-password-note">

                        <i class="bi bi-info-circle"></i>

                        <span>
                            Không chia sẻ mật khẩu cho người khác.
                        </span>

                    </div>

                    <!-- Nút thao tác -->
                    <div class="account-actions">

                        <a href="${ctx}/home/index"
                           class="btn btn-outline-secondary">

                            <i class="bi bi-arrow-left me-1"></i>
                            Quay lại

                        </a>

                        <button type="submit"
                                class="btn account-submit-button">

                            <i class="bi bi-key me-1"></i>
                            Đổi mật khẩu

                        </button>

                    </div>

                </form>

            </div>

        </div>

    </main>

    <!-- Footer -->
    <footer>
        <jsp:include page="/site/shared/footer.jsp"/>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JavaScript tài khoản -->
    <script src="${ctx}/assets/js/client/account.js"></script>

</body>
</html>