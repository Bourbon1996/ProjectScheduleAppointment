<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- Lớp phủ toàn bộ màn hình -->
<div class="auth-popup-overlay"
     id="loginPopup"
     data-has-login-error="${not empty loginError}">

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
              
              <c:if test="${not empty loginError}">
		        <div class="auth-server-error">
		            ${loginError}
		        </div>
		    </c:if>

            <div class="auth-form-group">
                <label for="loginPhone">
                    Số điện thoại
                </label>

                <input type="text"
                       id="loginPhone"
                       name="phone"
                       value="${loginPhone}"
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


<!-- ================================================== -->
<!-- POPUP ĐĂNG KÝ                                      -->
<!-- Popup đăng ký phải nằm ngoài popup đăng nhập       -->
<!-- ================================================== -->

<div class="auth-popup-overlay" id="registerPopup">

    <div class="auth-popup-box auth-register-box">

        <!-- Nút đóng popup đăng ký -->
        <button type="button"
                class="auth-popup-close"
                id="closeRegisterPopup">
            &times;
        </button>

        <!-- Logo -->
        <div class="auth-logo-wrapper">

            <img src="${pageContext.request.contextPath}/img/logo.png"
                 alt="Logo bệnh viện"
                 class="auth-logo">

        </div>

        <!-- Tiêu đề -->
        <h2 class="auth-title">
            Đăng ký tài khoản
        </h2>

        <!-- Hướng dẫn -->
        <p class="auth-description">
            Vui lòng nhập thông tin để tạo tài khoản đặt lịch khám.
        </p>

        <!-- Nơi hiển thị lỗi bằng JavaScript -->
        <p class="auth-error-message"
           id="registerClientError">
        </p>

        <!-- Form đăng ký -->
        <form action="${pageContext.request.contextPath}/user/register"
              method="post"
              id="registerForm">

            <!-- Họ và tên -->
            <div class="auth-form-group">

                <label for="registerFullName">
                    Họ và tên
                </label>

                <input type="text"
                       id="registerFullName"
                       name="fullName"
                       placeholder="Nhập họ và tên"
                       maxlength="100"
                       required>

            </div>

            <!-- Số điện thoại -->
            <div class="auth-form-group">

                <label for="registerPhone">
                    Số điện thoại
                </label>

                <input type="tel"
                       id="registerPhone"
                       name="phone"
                       placeholder="Nhập số điện thoại"
                       maxlength="20"
                       inputmode="numeric"
                       required>

            </div>

            <!-- Email -->
            <div class="auth-form-group">

                <label for="registerEmail">
                    Email
                </label>

                <input type="email"
                       id="registerEmail"
                       name="email"
                       placeholder="Nhập địa chỉ email"
                       maxlength="100"
                       required>

            </div>

            <!-- Mật khẩu -->
            <div class="auth-form-group">

                <label for="registerPassword">
                    Mật khẩu
                </label>

                <div class="auth-password-wrapper">

                    <input type="password"
						   id="registerPassword"
                           name="password"
                           placeholder="Nhập mật khẩu"
                           minlength="6"
                           required>

                    <button type="button"
                            class="auth-show-password"
                            id="toggleRegisterPassword"
                            title="Hiện hoặc ẩn mật khẩu">

                        <i class="bi bi-eye"
                           id="registerEyeIcon"></i>

                    </button>

                </div>

            </div>

            <!-- Xác nhận mật khẩu -->
            <div class="auth-form-group">

                <label for="registerConfirmPassword">
                    Xác nhận mật khẩu
                </label>

                <div class="auth-password-wrapper">

                    <input type="password"
                           id="registerConfirmPassword"
                           name="confirmPassword"
                           placeholder="Nhập lại mật khẩu"
                           minlength="6"
                           required>

                    <button type="button"
                            class="auth-show-password"
                            id="toggleConfirmPassword"
                            title="Hiện hoặc ẩn mật khẩu">

                        <i class="bi bi-eye"
                           id="confirmEyeIcon"></i>

                    </button>

                </div>

            </div>

            <!-- Nút đăng ký -->
            <button type="submit"
                    class="auth-submit-button">
                Đăng ký
            </button>

            <!-- Quay lại đăng nhập -->
            <p class="auth-register-text">

                Đã có tài khoản?

                <a href="#"
                   id="openLoginFromRegister">
                    Đăng nhập
                </a>

            </p>

        </form>

    </div>

</div>
