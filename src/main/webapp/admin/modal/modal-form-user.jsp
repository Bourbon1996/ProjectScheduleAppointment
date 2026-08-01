<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/site/shared/page.jsp" %>
    
<link rel="stylesheet" type="text/css" href="${ctx}/assets/css/admin/modal-form.css">


<div class="modal fade"
     id="userModal"
     tabindex="-1"
     aria-labelledby="userModalLabel"
     aria-hidden="true">

    <div class="modal-dialog modal-lg modal-dialog-centered">

        <div class="modal-content">

            <!-- HEADER -->

            <div class="modal-header">

                <h4 class="modal-title"
                    id="userModalLabel">

                    Thông tin tài khoản

                </h4>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal">
                </button>

            </div>


            <!-- FORM -->

            <form id="userForm"
                  method="post">

                <div class="modal-body">

                    
                    <div class="row g-3">
                    
                    <!-- ID -->
                    
                     <div class="col-md-6">

                            <label class="form-label">

                                ID
                                <span class="required">*</span>

                            </label>

                             <input class="form-control"
	                    	   type="text"
	                           id="userId"
	                           name="id" 
	                           readonly>

                        </div>
                    
                   
						<!-- HỌ TÊN -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Họ và tên
                                <span class="required">*</span>

                            </label>

                            <input type="text"
                                   class="form-control"
                                   id="userFullName"
                                   name="fullName"
                                   placeholder="Nhập họ và tên"
                                   required>

                        </div>


                        <!-- EMAIL -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Email
                                <span class="required">*</span>

                            </label>

                            <input type="email"
                                   class="form-control"
                                   id="userEmail"
                                   name="email"
                                   placeholder="Nhập email"
                                   required>

                        </div>


                        <!-- PHONE -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Số điện thoại

                            </label>

                            <input type="text"
                                   class="form-control"
                                   id="userPhone"
                                   name="phone"
                                   placeholder="Nhập số điện thoại">

                        </div>


                        <!-- GENDER -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Giới tính

                            </label>

                            <select class="form-select"
                                    id="userGender"
                                    name="gender">

                                <option value="">
                                    -- Chọn giới tính --
                                </option>

                                <option value="MALE">
                                    Nam
                                </option>

                                <option value="FEMALE">
                                    Nữ
                                </option>

                                <option value="OTHER">
                                    Khác
                                </option>

                            </select>

                        </div>


                        <!-- PASSWORD -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Mật khẩu
                                <span class="required">*</span>

                            </label>

                            <div class="password-wrapper">

                                <input type="password"
                                       class="form-control"
                                       id="userPassword"
                                       name="password"
                                       placeholder="Nhập mật khẩu">

                                <button type="button"
                                        class="password-toggle"
                                        id="toggleUserPassword">

                                    <i class="bi bi-eye"
                                       id="userPasswordIcon"></i>

                                </button>

                            </div>

                        </div>


                        <!-- ROLE -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Vai trò
                                <span class="required">*</span>

                            </label>

                            <select class="form-select"
                                    id="userRole"
                                    name="role">

                                <option value="">
                                    -- Chọn vai trò --
                                </option>

                                <option value="PATIENT">
                                    Bệnh nhân
                                </option>

                                <option value="DOCTOR">
                                    Bác sĩ
                                </option>

                                <option value="STAFF">
                                    Nhân viên
                                </option>

                                <option value="ADMIN">
                                    Quản trị viên
                                </option>

                            </select>

                        </div>


                        <!-- STATUS -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Trạng thái
                                <span class="required">*</span>

                            </label>

                            <select class="form-select"
                                    id="userStatus"
                                    name="status">

                                <option value="">
                                    -- Chọn trạng thái --
                                </option>

                                <option value="ACTIVE">
                                    Hoạt động
                                </option>

                                <option value="INACTIVE">
                                    Ngừng hoạt động
                                </option>

                            </select>

                        </div>

                    </div>

                </div>


                <!-- FOOTER -->

                <div class="modal-footer">

                    <button type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">

                        Hủy

                    </button>

                    <button type="submit"
                            class="btn btn-primary">

                        Lưu

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const userForm = document.getElementById("userForm");
    const modalTitle = document.getElementById("userModalLabel");

    const userId = document.getElementById("userId");
    const userFullName = document.getElementById("userFullName");
    const userGender = document.getElementById("userGender");
    const userEmail = document.getElementById("userEmail");
    const userPhone = document.getElementById("userPhone");
    const userPassword = document.getElementById("userPassword");
    const userRole = document.getElementById("userRole");
    const userStatus = document.getElementById("userStatus");

    // Chỉ xử lý nút Sửa
    document.querySelectorAll(".btn-edit-user").forEach(function (button) {

        button.addEventListener("click", function () {

            modalTitle.textContent = "Sửa thông tin tài khoản";

            // Khi nhấn Lưu sẽ gửi POST tới UserServlet
            userForm.action = "${ctx}/user/edit";

            // Hiện thông tin cũ
            userId.value = this.dataset.id;
            userFullName.value = this.dataset.fullName;
            userGender.value = this.dataset.gender;
            userEmail.value = this.dataset.email;
            userPhone.value = this.dataset.phone;
            userRole.value = this.dataset.role;
            userStatus.value = this.dataset.status;

            // Không hiện mật khẩu cũ
            userPassword.value = "";
            userPassword.required = false;
            userPassword.placeholder =
                "Bỏ trống nếu không muốn đổi mật khẩu";
        });
    });

    // Hiện hoặc ẩn mật khẩu
    const toggle = document.getElementById("toggleUserPassword");
    const icon = document.getElementById("userPasswordIcon");

    if (toggle && userPassword && icon) {

        toggle.addEventListener("click", function () {

            if (userPassword.type === "password") {

                userPassword.type = "text";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");

            } else {

                userPassword.type = "password";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            }
        });
    }
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>