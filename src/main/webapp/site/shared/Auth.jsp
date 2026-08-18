<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!-- CSS popup đăng nhập -->
    <link rel="stylesheet"
          href="${ctx}/assets/css/client/auth.css">
<!-- Lớp phủ toàn bộ màn hình -->
<div class="auth-popup-overlay"
     id="loginPopup"
     data-has-login-error="${not empty loginError}"
     data-open-login="${openLoginPopup == true}">
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
                src="${pageContext.request.contextPath}/assets/img/logo.png"
                alt="Logo bệnh viện"
                class="auth-logo">
        </div>

        <!-- Nội dung hướng dẫn -->
        <p class="auth-description">
            Vui lòng đăng nhập để sử dụng chức năng đặt lịch khám.
        </p>

        <!-- Form đăng nhập -->
        <form action="${pageContext.request.contextPath}/auth/login"
		      method="post">
		
		    <c:if test="${not empty loginError}">
		        <div class="auth-server-error">
		            <c:out value="${loginError}"/>
		        </div>
		    </c:if>
		
		    <c:if test="${not empty loginSuccess}">
		        <div class="auth-server-success">
		            <i class="bi bi-check-circle-fill"></i>
		            <c:out value="${loginSuccess}"/>
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
            
            <div class="auth-remember-wrapper">
			
			    <label class="auth-remember-label">
			
			        <input type="checkbox"
			               name="remember"
			               value="true">
			
			        <span>Ghi nhớ đăng nhập</span>
			
			    </label>
			
			</div>
				<div class="auth-forgot-password"
				     style="display: flex;
				            justify-content: center;
				            width: 100%;
				            margin: 10px 0 14px;">
				
				    <a href="${ctx}/account/forgot-password"
				       style="color: #dc3545 !important;
				              font-size: 13px !important;
				              text-decoration: none;">
				        Quên mật khẩu?
				    </a>
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
<!-- ================================================== -->

<div class="auth-popup-overlay"
     id="registerPopup"
     data-has-register-error="${not empty registerError}">

    <div class="auth-popup-box auth-register-box">

        <!-- Nút đóng -->
        <button type="button"
                class="auth-popup-close"
                id="closeRegisterPopup"
                aria-label="Đóng">
            &times;
        </button>

        <!-- Phần đầu popup -->
        <div class="auth-register-header">

            <div class="auth-register-logo-wrapper">
                <img src="${ctx}/assets/img/logo.png"
                     alt="Logo bệnh viện"
                     class="auth-register-logo">
            </div>

            <div class="auth-register-heading">

                <h2>
                    Đăng ký tài khoản
                </h2>

                <p>
                    Tạo tài khoản để sử dụng dịch vụ đặt lịch khám.
                </p>

            </div>

        </div>

        <!-- Nội dung popup -->
        <div class="auth-register-body">

            <!-- Lỗi từ Servlet -->
            <c:if test="${not empty registerError}">
                <div class="auth-server-error auth-register-message">

                    <i class="bi bi-exclamation-circle-fill"></i>

                    <c:out value="${registerError}"/>

                </div>
            </c:if>

            <!-- Lỗi kiểm tra bằng JavaScript -->
            <p class="auth-error-message"
               id="registerClientError">
            </p>

            <form action="${ctx}/auth/register"
                  method="post"
                  id="registerForm">

                <!-- Họ và tên -->
                <div class="auth-form-group">

                    <label for="registerFullName">
                        Họ và tên
                        <span class="auth-required">*</span>
                    </label>

                    <div class="auth-field-wrapper">

                        <i class="bi bi-person auth-field-icon"></i>

                        <input type="text"
                               id="registerFullName"
                               name="fullName"
                               value="${registerFullName}"
                               placeholder="Nhập họ và tên"
                               maxlength="100"
                               required>

                    </div>

                </div>

                <!-- Giới tính -->
                <div class="auth-form-group">

                    <label>
                        Giới tính
                        <span class="auth-required">*</span>
                    </label>

                    <div class="gender-toggle-group">

                        <label class="gender-toggle-item">

                            <input type="radio"
                                   name="gender"
                                   value="MALE"
                                   required
                                   ${registerGender == 'MALE'
                                       ? 'checked'
                                       : ''}>

                            <span class="gender-toggle-text">

                                <i class="bi bi-gender-male"></i>
                                Nam

                            </span>

                        </label>

                        <label class="gender-toggle-item">

                            <input type="radio"
                                   name="gender"
                                   value="FEMALE"
                                   required
                                   ${registerGender == 'FEMALE'
                                       ? 'checked'
                                       : ''}>

                            <span class="gender-toggle-text">

                                <i class="bi bi-gender-female"></i>
                                Nữ

                            </span>

                        </label>

                    </div>

                </div>

                <!-- Số điện thoại -->
                <div class="auth-form-group">

                    <label for="registerPhone">
                        Số điện thoại
                        <span class="auth-required">*</span>
                    </label>

                    <div class="auth-field-wrapper">

                        <i class="bi bi-telephone auth-field-icon"></i>

                        <input type="tel"
                               id="registerPhone"
                               name="phone"
                               value="${registerPhone}"
                               placeholder="Nhập số điện thoại"
                               maxlength="20"
                               inputmode="numeric"
                               required>

                    </div>

                </div>

                <!-- Email -->
                <div class="auth-form-group">

                    <label for="registerEmail">
                        Email
                        <span class="auth-required">*</span>
                    </label>

                    <div class="auth-field-wrapper">

                        <i class="bi bi-envelope auth-field-icon"></i>

                        <input type="email"
                               id="registerEmail"
                               name="email"
                               value="${registerEmail}"
                               placeholder="Nhập địa chỉ email"
                               maxlength="100"
                               required>

                    </div>

                </div>

                <!-- Mật khẩu -->
                <div class="auth-form-group">

                    <label for="registerPassword">
                        Mật khẩu
                        <span class="auth-required">*</span>
                    </label>

                    <div class="auth-field-wrapper auth-password-wrapper">

                        <i class="bi bi-lock auth-field-icon"></i>

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

                    <div class="auth-field-note">
                        Mật khẩu phải có ít nhất 6 ký tự.
                    </div>

                </div>

                <!-- Xác nhận mật khẩu -->
                <div class="auth-form-group">

                    <label for="registerConfirmPassword">
                        Xác nhận mật khẩu
                        <span class="auth-required">*</span>
                    </label>

                    <div class="auth-field-wrapper auth-password-wrapper">

                        <i class="bi bi-shield-lock auth-field-icon"></i>

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
                        class="auth-submit-button auth-register-submit">

                    <i class="bi bi-person-plus-fill"></i>
                    Đăng ký tài khoản

                </button>

                <!-- Quay lại đăng nhập -->
                <p class="auth-register-text auth-register-footer">

                    Đã có tài khoản?

                    <a href="#"
                       id="openLoginFromRegister">
                        Đăng nhập ngay
                    </a>

                </p>

            </form>

        </div>

    </div>

</div>
<!-- ================================================== -->
<!-- THÔNG BÁO ĐĂNG XUẤT                                -->
<!-- ================================================== -->

<c:if test="${not empty logoutMessage}">
	<div class="toast-container position-fixed top-0 end-0 p-3"
	     style="z-index: 10000; margin-top: 75px;">

		<div id="logoutToast"
		     class="toast show"
		     role="alert"
		     aria-live="assertive"
		     aria-atomic="true">

			<div class="toast-header">
				<i class="bi bi-check-circle-fill text-success me-2"></i>

				<strong class="me-auto">Thông báo</strong>

				<button type="button"
				        class="btn-close"
				        data-bs-dismiss="toast"
				        aria-label="Đóng">
				</button>
			</div>

			<div class="toast-body">
				<c:out value="${logoutMessage}"/>
			</div>
		</div>
	</div>
</c:if>
