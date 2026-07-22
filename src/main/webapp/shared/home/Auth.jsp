<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- Lớp phủ toàn bộ màn hình -->
<div class="auth-popup-overlay" id="loginPopup">

    <!-- Khung đăng nhập -->
    <div class="auth-popup-box">

        <!-- Nút đóng -->
        <button type="button"
                class="auth-popup-close"
                id="closeLoginPopup">
            &times;
        </button>

        <!-- Logo -->
        <div class="auth-logo-wrapper">
            <img
                src="${pageContext.request.contextPath}/img/logo.png"
                alt="Logo bệnh viện"
                class="auth-logo">
        </div>

        <!-- Nội dung hướng dẫn -->
        <p class="auth-description">
            Vui lòng đăng nhập để sử dụng chức năng đặt lịch khám.
        </p>

        <!-- Form đăng nhập -->
        <form action="${pageContext.request.contextPath}/user/login"
              method="post">

            <div class="auth-form-group">
                <label for="loginPhone">
                    Số điện thoại
                </label>

                <input type="text"
                       id="loginPhone"
                       name="phone"
                       placeholder="Nhập số điện thoại"
                       required>
            </div>

            <div class="auth-form-group">
                <label for="loginPassword">
                    Mật khẩu
                </label>

                <div class="auth-password-wrapper">

                    <input type="password"
                           id="loginPassword"
                           name="password"
                           placeholder="Nhập mật khẩu"
                           required>

                    <button type="button"
                            class="auth-show-password"
                            id="toggleLoginPassword">

                        <i class="bi bi-eye"
                           id="loginEyeIcon"></i>

                    </button>
                </div>
            </div>

            <button type="submit"
                    class="auth-submit-button">
                Đăng nhập
            </button>

            <p class="auth-register-text">
                Chưa có tài khoản?

                <a href="#" id="openRegisterPopup">
                    Đăng ký ngay
                </a>
            </p>

        </form>
    </div>
</div>