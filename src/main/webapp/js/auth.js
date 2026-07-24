document.addEventListener("DOMContentLoaded", function () {

    // =====================================
    // 1. LẤY CÁC THÀNH PHẦN HTML
    // =====================================

    // Icon tài khoản trên navbar
    const openLoginButton =
        document.getElementById("openLoginPopup");

    // Popup đăng nhập
    const loginPopup =
        document.getElementById("loginPopup");

    const closeLoginButton =
        document.getElementById("closeLoginPopup");

    // Popup đăng ký
    const registerPopup =
        document.getElementById("registerPopup");

    const closeRegisterButton =
        document.getElementById("closeRegisterPopup");

    // Link chuyển đổi popup
    const openRegisterButton =
        document.getElementById("openRegisterPopup");

    const openLoginFromRegister =
        document.getElementById("openLoginFromRegister");


    // =====================================
    // 2. MỞ POPUP ĐĂNG NHẬP
    // =====================================

    if (openLoginButton && loginPopup) {

        openLoginButton.addEventListener("click", function (event) {

            event.preventDefault();

            showPopup(loginPopup);
        });
    }


    // =====================================
    // 3. ĐÓNG POPUP ĐĂNG NHẬP
    // =====================================

    if (closeLoginButton && loginPopup) {

        closeLoginButton.addEventListener("click", function () {

            hidePopup(loginPopup);
        });
    }


    // =====================================
    // 4. CHUYỂN ĐĂNG NHẬP → ĐĂNG KÝ
    // =====================================

    if (openRegisterButton && loginPopup && registerPopup) {

        openRegisterButton.addEventListener("click", function (event) {

            event.preventDefault();

            hidePopup(loginPopup);
            showPopup(registerPopup);
        });
    }


    // =====================================
    // 5. ĐÓNG POPUP ĐĂNG KÝ
    // =====================================

    if (closeRegisterButton && registerPopup) {

        closeRegisterButton.addEventListener("click", function () {

            hidePopup(registerPopup);
        });
    }


    // =====================================
    // 6. CHUYỂN ĐĂNG KÝ → ĐĂNG NHẬP
    // =====================================

    if (openLoginFromRegister && registerPopup && loginPopup) {

        openLoginFromRegister.addEventListener(
            "click",
            function (event) {

                event.preventDefault();

                hidePopup(registerPopup);
                showPopup(loginPopup);
            }
        );
    }


    // =====================================
    // 7. CLICK NỀN TỐI ĐỂ ĐÓNG
    // =====================================

    if (loginPopup) {

        loginPopup.addEventListener("click", function (event) {

            /*
             * Chỉ đóng khi click đúng vào lớp nền.
* Nếu click vào form thì không đóng.
             */
            if (event.target === loginPopup) {
                hidePopup(loginPopup);
            }
        });
    }

    if (registerPopup) {

        registerPopup.addEventListener("click", function (event) {

            if (event.target === registerPopup) {
                hidePopup(registerPopup);
            }
        });
    }


    // =====================================
    // 8. NHẤN ESCAPE ĐỂ ĐÓNG
    // =====================================

    document.addEventListener("keydown", function (event) {

        if (event.key !== "Escape") {
            return;
        }

        if (
            loginPopup &&
            loginPopup.classList.contains("active")
        ) {
            hidePopup(loginPopup);
        }

        if (
            registerPopup &&
            registerPopup.classList.contains("active")
        ) {
            hidePopup(registerPopup);
        }
    });


    // =====================================
    // 9. HIỆN / ẨN MẬT KHẨU
    // =====================================

    setupPasswordToggle(
        "toggleLoginPassword",
        "loginPassword",
        "loginEyeIcon"
    );

    setupPasswordToggle(
        "toggleRegisterPassword",
        "registerPassword",
        "registerEyeIcon"
    );

    setupPasswordToggle(
        "toggleConfirmPassword",
        "registerConfirmPassword",
        "confirmEyeIcon"
    );


    // =====================================
    // 10. KIỂM TRA XÁC NHẬN MẬT KHẨU
    // =====================================

    const registerForm =
        document.getElementById("registerForm");

    const registerPassword =
        document.getElementById("registerPassword");

    const registerConfirmPassword =
        document.getElementById("registerConfirmPassword");

    const registerClientError =
        document.getElementById("registerClientError");

    if (
        registerForm &&
        registerPassword &&
        registerConfirmPassword &&
        registerClientError
    ) {

        registerForm.addEventListener("submit", function (event) {

            /*
             * Xóa thông báo lỗi cũ trước khi kiểm tra.
             */
            registerClientError.textContent = "";
            registerClientError.classList.remove("show");

            /*
             * So sánh mật khẩu và xác nhận mật khẩu.
             */
            if (
                registerPassword.value !==
                registerConfirmPassword.value
            ) {

                /*
                 * Ngăn không cho form gửi đến Servlet.
                 */
                event.preventDefault();

                registerClientError.textContent =
                    "Mật khẩu xác nhận không khớp.";

                registerClientError.classList.add("show");

                registerConfirmPassword.focus();
            }
        });
    }
	
	// Tự mở lại popup khi đăng nhập thất bại
	if (
	    loginPopup &&
	    loginPopup.dataset.hasLoginError === "true"
	) {
	    showPopup(loginPopup);
	}
// =====================================
    // CÁC HÀM DÙNG CHUNG
    // =====================================

    function showPopup(popup) {

        if (!popup) {
            return;
        }

        popup.classList.add("active");

        /*
         * Không cho trang phía sau cuộn khi popup mở.
         */
        document.body.style.overflow = "hidden";
    }


    function hidePopup(popup) {

        if (!popup) {
            return;
        }

        popup.classList.remove("active");

        /*
         * Cho phép trang cuộn lại.
         */
        document.body.style.overflow = "";
    }


    function setupPasswordToggle(
        buttonId,
        inputId,
        iconId
    ) {

        const button =
            document.getElementById(buttonId);

        const input =
            document.getElementById(inputId);

        const icon =
            document.getElementById(iconId);

        if (!button || !input || !icon) {
            return;
        }

        button.addEventListener("click", function () {

            if (input.type === "password") {

                input.type = "text";

                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");

            } else {

                input.type = "password";

                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            }
        });
    }

});