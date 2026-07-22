/**
 * 
 */document.addEventListener("DOMContentLoaded", function () {

    const openLoginButton =
        document.getElementById("openLoginPopup");

    const closeLoginButton =
        document.getElementById("closeLoginPopup");

    const loginPopup =
        document.getElementById("loginPopup");

    const togglePasswordButton =
        document.getElementById("toggleLoginPassword");

    const passwordInput =
        document.getElementById("loginPassword");

    const eyeIcon =
        document.getElementById("loginEyeIcon");


    // Nhấn icon tài khoản để mở popup
    if (openLoginButton && loginPopup) {

        openLoginButton.addEventListener("click", function (event) {

            event.preventDefault();

            loginPopup.classList.add("active");

            document.body.style.overflow = "hidden";
        });
    }


    // Nhấn dấu X để đóng popup
    if (closeLoginButton && loginPopup) {

        closeLoginButton.addEventListener("click", function () {

            closeLoginPopup();
        });
    }


    // Nhấn vào vùng nền tối để đóng popup
    if (loginPopup) {

        loginPopup.addEventListener("click", function (event) {

            if (event.target === loginPopup) {
                closeLoginPopup();
            }
        });
    }


    // Nhấn phím Escape để đóng popup
    document.addEventListener("keydown", function (event) {

        if (event.key === "Escape" &&
            loginPopup &&
            loginPopup.classList.contains("active")) {

            closeLoginPopup();
        }
    });


    // Hiện hoặc ẩn mật khẩu
    if (togglePasswordButton && passwordInput && eyeIcon) {

        togglePasswordButton.addEventListener("click", function () {

            if (passwordInput.type === "password") {

                passwordInput.type = "text";

                eyeIcon.classList.remove("bi-eye");
                eyeIcon.classList.add("bi-eye-slash");

            } else {

                passwordInput.type = "password";

                eyeIcon.classList.remove("bi-eye-slash");
                eyeIcon.classList.add("bi-eye");
            }
        });
    }


    function closeLoginPopup() {

        loginPopup.classList.remove("active");

        document.body.style.overflow = "";
    }
});