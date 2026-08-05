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

    <title>Quên mật khẩu</title>

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

    <!-- CSS header -->
    <link rel="stylesheet"
          href="${ctx}/assets/css/client/index.css">

    <!-- CSS popup -->
    <link rel="stylesheet"
          href="${ctx}/assets/css/client/auth.css">
</head>

<body>

    <!-- Header -->
    <header>
        <jsp:include page="/site/shared/header.jsp"/>
    </header>

    <!-- ================================================== -->
    <!-- POPUP QUÊN MẬT KHẨU                               -->
    <!-- Class active giúp popup tự hiển thị khi mở trang   -->
    <!-- ================================================== -->

    <div class="auth-popup-overlay active"
         id="forgotPasswordPopup">

        <div class="auth-popup-box auth-register-box forgot-password-box">

            <!-- Đóng và quay về trang chủ -->
            <a href="${ctx}/home/index"
               class="auth-popup-close"
               aria-label="Đóng">
                &times;
            </a>

            <!-- Phần đầu màu xanh -->
            <div class="auth-register-header">

                <div class="auth-register-logo-wrapper">

                    <img src="${ctx}/assets/img/logo.png"
                         alt="Logo bệnh viện"
                         class="auth-register-logo">

                </div>

                <div class="auth-register-heading">

                    <h2>Quên mật khẩu</h2>

                    <p>
                        Nhập email đã đăng ký để nhận thông tin
                        khôi phục tài khoản.
                    </p>

                </div>

            </div>

            <!-- Nội dung -->
            <div class="auth-register-body">

                <!-- Thông báo lỗi từ Servlet -->
                <c:if test="${not empty msg}">

                    <div class="auth-server-error forgot-password-message">

                        <i class="bi bi-exclamation-circle-fill"></i>

                        <c:out value="${msg}"/>

                    </div>

                </c:if>

                <form action="${ctx}/account/forgot-password"
                      method="post"
                      id="forgotPasswordForm">

                    <!-- Lưu trữ step hiện tại để gửi về server -->
                    <input type="hidden" name="step" value="${empty step ? 'send_otp' : step}">

                    <c:choose>
                        <c:when test="${step == 'verify_otp'}">
                            <!-- Bước 2: Xác nhận OTP -->
                            <div class="auth-form-group">
                                <label for="forgotEmail">Email nhận OTP</label>
                                <div class="auth-field-wrapper">
                                    <i class="bi bi-envelope auth-field-icon"></i>
                                    <input type="email" id="forgotEmail" name="email" value="<c:out value='${email}'/>" readonly class="form-control" style="background-color: #f8f9fa;">
                                </div>
                            </div>

                            <div class="auth-form-group mt-3">
                                <label for="otp">Nhập mã OTP (6 số) <span class="auth-required">*</span></label>
                                <div class="auth-field-wrapper">
                                    <i class="bi bi-key auth-field-icon"></i>
                                    <input type="text" id="otp" name="otp" placeholder="Nhập mã OTP từ email" maxlength="6" required>
                                </div>
                            </div>
                            
                            <div class="forgot-password-note mt-2">
                                <i class="bi bi-info-circle"></i>
                                <span>Mã OTP có hiệu lực trong 5 phút. Vui lòng kiểm tra hộp thư rác nếu không thấy.</span>
                            </div>

                            <button type="submit" class="auth-submit-button auth-register-submit mt-3">
                                <i class="bi bi-check-circle-fill"></i> Xác nhận OTP
                            </button>
                        </c:when>

                        <c:when test="${step == 'reset_password'}">
                            <!-- Bước 3: Đổi mật khẩu -->
                            <div class="auth-form-group">
                                <label for="forgotEmail">Tài khoản</label>
                                <div class="auth-field-wrapper">
                                    <i class="bi bi-envelope auth-field-icon"></i>
                                    <input type="email" id="forgotEmail" name="email" value="<c:out value='${email}'/>" readonly class="form-control" style="background-color: #f8f9fa;">
                                </div>
                            </div>

                            <div class="auth-form-group mt-3">
                                <label for="newPassword">Mật khẩu mới <span class="auth-required">*</span></label>
                                <div class="auth-field-wrapper">
                                    <i class="bi bi-lock auth-field-icon"></i>
                                    <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới" minlength="6" required>
                                </div>
                            </div>

                            <div class="auth-form-group mt-3">
                                <label for="confirmPassword">Xác nhận mật khẩu <span class="auth-required">*</span></label>
                                <div class="auth-field-wrapper">
                                    <i class="bi bi-shield-lock auth-field-icon"></i>
                                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" minlength="6" required>
                                </div>
                            </div>

                            <button type="submit" class="auth-submit-button auth-register-submit mt-3">
                                <i class="bi bi-shield-check"></i> Đổi mật khẩu
                            </button>
                        </c:when>

                        <c:otherwise>
                            <!-- Bước 1: Gửi OTP (Mặc định) -->
                            <!-- Email -->
                            <div class="auth-form-group">
                                <label for="forgotEmail">Địa chỉ email <span class="auth-required">*</span></label>
                                <div class="auth-field-wrapper">
                                    <i class="bi bi-envelope auth-field-icon"></i>
                                    <input type="email" id="forgotEmail" name="email" value="<c:out value='${email}'/>" placeholder="Nhập địa chỉ email đã đăng ký" maxlength="100" autocomplete="email" required>
                                </div>
                            </div>

                            <!-- Ghi chú -->
                            <div class="forgot-password-note">
                                <i class="bi bi-info-circle"></i>
                                <span>Hệ thống sẽ gửi mã xác thực (OTP) đến địa chỉ email của bạn.</span>
                            </div>

                            <!-- Nút gửi -->
                            <button type="submit" class="auth-submit-button auth-register-submit">
                                <i class="bi bi-send-fill"></i> Gửi mã OTP
                            </button>
                        </c:otherwise>
                    </c:choose>

                    <!-- Mở lại popup đăng nhập -->
                    <p class="auth-register-text auth-register-footer mt-3">
                        Đã nhớ mật khẩu?
                        <a href="#" id="openLoginFromForgot">Quay lại đăng nhập</a>
                    </p>

                </form>

            </div>

        </div>

    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Chuyển từ popup quên mật khẩu sang popup đăng nhập -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {

            const forgotPasswordPopup =
                document.getElementById("forgotPasswordPopup");

            const loginPopup =
                document.getElementById("loginPopup");

            const openLoginFromForgot =
                document.getElementById("openLoginFromForgot");

            if (
                forgotPasswordPopup &&
                loginPopup &&
                openLoginFromForgot
            ) {
                openLoginFromForgot.addEventListener(
                    "click",
                    function (event) {

                        event.preventDefault();

                        forgotPasswordPopup.classList.remove("active");
                        loginPopup.classList.add("active");

                        document.body.style.overflow = "hidden";
                    }
                );
            }

        });
    </script>

</body>
</html>