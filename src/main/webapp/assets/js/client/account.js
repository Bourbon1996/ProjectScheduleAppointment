document.addEventListener("DOMContentLoaded", function () {

    // =====================================
    // 1. KIỂM TRA FORM CHỈNH SỬA HỒ SƠ
    // =====================================

    const editProfileForm =
        document.getElementById("editProfileForm");

    const fullName =
        document.getElementById("fullName");

    const phone =
        document.getElementById("phone");

    const email =
        document.getElementById("email");

    if (
        editProfileForm &&
        fullName &&
        phone &&
        email
    ) {
        editProfileForm.addEventListener(
            "submit",
            function (event) {

                fullName.value = fullName.value.trim();
                phone.value = phone.value.trim();
                email.value = email.value.trim();

                if (
                    fullName.value === "" ||
                    phone.value === "" ||
                    email.value === ""
                ) {
                    event.preventDefault();

                    alert(
                        "Vui lòng nhập đầy đủ thông tin."
                    );
                }
            }
        );
    }


    // =====================================
    // 2. HIỆN HOẶC ẨN MẬT KHẨU
    // =====================================

    const passwordToggleButtons =
        document.querySelectorAll(
            ".account-password-toggle"
        );

    passwordToggleButtons.forEach(function (button) {

        button.addEventListener("click", function () {

            const inputId = button.dataset.input;

            const input =
                document.getElementById(inputId);

            const icon =
                button.querySelector("i");

            if (!input || !icon) {
                return;
            }

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
    });


    // =====================================
    // 3. KIỂM TRA FORM ĐỔI MẬT KHẨU
    // =====================================

    const changePasswordForm =
        document.getElementById("changePasswordForm");

    const currentPassword =
        document.getElementById("currentPassword");

    const newPassword =
        document.getElementById("newPassword");

    const confirmPassword =
        document.getElementById("confirmPassword");

    const passwordClientError =
        document.getElementById("passwordClientError");

    if (
        changePasswordForm &&
        currentPassword &&
        newPassword &&
        confirmPassword &&
        passwordClientError
    ) {
        changePasswordForm.addEventListener(
            "submit",
            function (event) {

                hidePasswordError();

                if (currentPassword.value === "") {

                    event.preventDefault();

                    showPasswordError(
                        "Vui lòng nhập mật khẩu hiện tại."
                    );

                    currentPassword.focus();
                    return;
                }

                if (newPassword.value.length < 6) {

                    event.preventDefault();

                    showPasswordError(
                        "Mật khẩu mới phải có ít nhất 6 ký tự."
                    );

                    newPassword.focus();
                    return;
                }

                if (
                    newPassword.value ===
                    currentPassword.value
                ) {
                    event.preventDefault();

                    showPasswordError(
                        "Mật khẩu mới phải khác mật khẩu hiện tại."
                    );

                    newPassword.focus();
                    return;
                }

                if (
                    newPassword.value !==
                    confirmPassword.value
                ) {
                    event.preventDefault();

                    showPasswordError(
                        "Xác nhận mật khẩu mới không khớp."
                    );

                    confirmPassword.focus();
                }
            }
        );
    }


    // =====================================
    // 4. TỰ ẨN THÔNG BÁO TỪ SERVLET
    // =====================================

    const accountMessage =
        document.getElementById("accountMessage");

    if (
        accountMessage &&
        typeof bootstrap !== "undefined"
    ) {
        setTimeout(function () {

            const alertInstance =
                bootstrap.Alert.getOrCreateInstance(
                    accountMessage
                );

            alertInstance.close();

        }, 3000);
    }


    // =====================================
    // HÀM DÙNG CHUNG
    // =====================================

    function showPasswordError(message) {

        if (!passwordClientError) {
            return;
        }

        passwordClientError.textContent = message;
        passwordClientError.classList.remove("d-none");
    }

    function hidePasswordError() {

        if (!passwordClientError) {
            return;
        }

        passwordClientError.textContent = "";
        passwordClientError.classList.add("d-none");
    }

});