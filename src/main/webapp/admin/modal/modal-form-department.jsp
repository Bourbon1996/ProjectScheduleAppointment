<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/site/shared/page.jsp" %>

<link rel="stylesheet"
      type="text/css"
      href="${ctx}/assets/css/admin/modal-form.css">

<div class="modal fade"
     id="departmentModal"
     tabindex="-1"
     aria-labelledby="departmentModalLabel"
     aria-hidden="true">

    <div class="modal-dialog modal-lg modal-dialog-centered">

        <div class="modal-content">

            <!-- HEADER -->
            <div class="modal-header">

                <h5 class="modal-title"
                    id="departmentModalLabel">
                    Cập nhật chuyên khoa
                </h5>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close">
                </button>

            </div>

            <!-- FORM -->
            <form id="departmentForm"
            	  action="${ctx}/department/update"
                  method="post"
                  enctype="multipart/form-data">

                <div class="modal-body">

                    <!-- ID Department -->
                    <input type="hidden"
                           name="id"
                           id="departmentId">

                    <!-- Ảnh cũ -->
                    <input type="hidden"
                           name="oldImageUrl"
                           id="oldImageUrl">

                    <div class="row g-3">

                        <!-- TÊN CHUYÊN KHOA -->
                        <div class="col-md-6">

                            <label class="form-label">
                                Tên chuyên khoa
                            </label>

                            <input type="text"
                                   name="name"
                                   id="departmentName"
                                   class="form-control"
                                   placeholder="Nhập tên chuyên khoa"
                                   required>

                        </div>

                        <!-- TRẠNG THÁI -->
                        <div class="col-md-6">

                            <label class="form-label">
                                Trạng thái
                            </label>

                            <select name="status"
                                    id="departmentStatus"
                                    class="form-select"
                                    required>

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

                        <!-- GIÁ KHÁM -->
                        <div class="col-md-6">

                            <label class="form-label">
                                Giá khám cơ bản
                            </label>

                            <div class="input-group">

                                <input type="number"
                                       name="basePrice"
                                       id="departmentBasePrice"
                                       class="form-control"
                                       min="0"
                                       step="1000"
                                       required>

                                <span class="input-group-text">
                                    VNĐ
                                </span>

                            </div>

                        </div>

                        <!-- CHUYÊN KHOA CHA -->
                        <div class="col-md-6">

                            <label class="form-label">
                                Chuyên khoa cha
                            </label>

                            <select name="parentId"
                                    id="departmentParentId"
                                    class="form-select">

                                <option value="">
                                    -- Không có chuyên khoa cha --
                                </option>

                                <c:forEach items="${listDepartmentsParent}"
                                           var="parent">

                                    <option value="${parent.id}">
                                        ${parent.name}
                                    </option>

                                </c:forEach>

                            </select>

                        </div>

                        <!-- ẢNH HIỆN TẠI -->
                        <div class="col-12"
                             id="currentImageContainer"
                             style="display: none;">

                            <label class="form-label">
                                Hình ảnh hiện tại
                            </label>

                            <div>
                                <img id="currentDepartmentImage"
                                     src=""
                                     alt="Ảnh chuyên khoa"
                                     style="width: 120px;
                                            height: 80px;
                                            object-fit: cover;
                                            border-radius: 6px;">
                            </div>

                        </div>

                        <!-- CHỌN ẢNH MỚI -->
                        <div class="col-12">

                            <label class="form-label">
                                Chọn hình ảnh mới
                            </label>

                            <input type="file"
                                   name="imageFile"
                                   id="departmentImageFile"
                                   class="form-control"
                                   accept=".jpg,.jpeg,.png,.webp,image/*">

                            <small class="image-note">
                                Không chọn ảnh mới thì hệ thống giữ nguyên ảnh cũ.
                            </small>

                        </div>

                        <!-- MÔ TẢ -->
                        <div class="col-12">

                            <label class="form-label">
                                Mô tả
                            </label>

                            <textarea name="description"
                                      id="departmentDescription"
                                      class="form-control"
                                      rows="4"
                                      placeholder="Nhập mô tả chuyên khoa"></textarea>

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
					
					    <i class="bi bi-save"></i>
					
					    <span id="departmentSubmitText">
					        Lưu
					    </span>
					</button>

                </div>

            </form>

        </div>

    </div>

</div>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const contextPath = "${pageContext.request.contextPath}";

    const form =
        document.getElementById("departmentForm");

    const modalTitle =
        document.getElementById("departmentModalLabel");

    const submitText =
        document.getElementById("departmentSubmitText");

    const departmentId =
        document.getElementById("departmentId");

    const departmentName =
        document.getElementById("departmentName");

    const departmentDescription =
        document.getElementById("departmentDescription");

    const departmentStatus =
        document.getElementById("departmentStatus");

    const departmentBasePrice =
        document.getElementById("departmentBasePrice");

    const departmentParentId =
        document.getElementById("departmentParentId");

    const oldImageUrl =
        document.getElementById("oldImageUrl");

    const departmentImageFile =
        document.getElementById("departmentImageFile");

    const currentImageContainer =
        document.getElementById("currentImageContainer");

    const currentDepartmentImage =
        document.getElementById("currentDepartmentImage");


    /*
     * Mở modal THÊM MỚI
     */
    const addButton =
        document.querySelector(".btn-add-department");

    if (addButton != null) {

        addButton.addEventListener("click", function () {

            // Xóa toàn bộ dữ liệu cũ trong form
            form.reset();

            // Chuyển form sang chức năng create
            form.action =
                contextPath + "/department/create";

            modalTitle.textContent =
                "Thêm mới chuyên khoa";

            submitText.textContent =
                "Thêm mới";

            departmentId.value = "";
            oldImageUrl.value = "";

            // Giá mặc định
            departmentBasePrice.value = "150000";

            // Cho phép chọn lại toàn bộ chuyên khoa cha
            Array.from(departmentParentId.options)
                .forEach(function (option) {
                    option.disabled = false;
                });

            // Ẩn hình ảnh cũ
            currentDepartmentImage.src = "";
            currentImageContainer.style.display = "none";
        });
    }


    /*
     * Mở modal CẬP NHẬT
     */
    const editButtons =
        document.querySelectorAll(".btn-edit-department");

    editButtons.forEach(function (button) {

        button.addEventListener("click", function () {

            // Xóa dữ liệu từ lần mở trước
            form.reset();

            // Chuyển form sang chức năng update
            form.action =
                contextPath + "/department/update";

            modalTitle.textContent =
                "Cập nhật chuyên khoa";

            submitText.textContent =
                "Cập nhật";

            const id =
                this.dataset.id || "";

            const name =
                this.dataset.name || "";

            const description =
                this.dataset.description || "";

            const status =
                this.dataset.status || "";

            const basePrice =
                this.dataset.basePrice || "";

            const parentId =
                this.dataset.parentId || "";

            const imageUrl =
                this.dataset.imageUrl || "";

            // Đưa dữ liệu vào form
            departmentId.value = id;
            departmentName.value = name;
            departmentDescription.value = description;
            departmentStatus.value = status;
            departmentBasePrice.value = basePrice;
            oldImageUrl.value = imageUrl;

            // Không giữ file đã chọn từ lần trước
            departmentImageFile.value = "";

            /*
             * Không cho Department chọn chính nó
             * làm chuyên khoa cha.
             */
            Array.from(departmentParentId.options)
                .forEach(function (option) {

                    option.disabled =
                        option.value !== ""
                        && option.value === id;
                });

            departmentParentId.value = parentId;

            
            if (imageUrl !== "") {

                if (imageUrl.startsWith("http://")
                        || imageUrl.startsWith("https://")) {

                    currentDepartmentImage.src =
                        imageUrl;

                } else {

                    currentDepartmentImage.src =
                        contextPath
                        + (imageUrl.startsWith("/")
                            ? imageUrl
                            : "/" + imageUrl);
                }

                currentImageContainer.style.display =
                    "block";

            } else {

                currentDepartmentImage.src = "";

                currentImageContainer.style.display =
                    "none";
            }
        });
    });
});

</script>