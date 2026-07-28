<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/shared/home/page.jsp" %>
    
<link rel="stylesheet" type="text/css" href="${ctx}/css/admin/modal-form.css">
<!-- MODAL CREATE / UPDATE DEPARTMENT -->
<div class="modal fade"
     id="departmentModal"
     tabindex="-1"
     aria-labelledby="departmentModalLabel"
     aria-hidden="true">

    <div class="modal-dialog modal-lg modal-dialog-centered">

        <div class="modal-content">

            <!-- HEADER -->
            <div class="modal-header">

                <h5 class="modal-title" id="departmentModalLabel">
                    Thông tin chuyên khoa
                </h5>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close">
                </button>

            </div>


            <!-- FORM -->
            <form action=""
                  method="post"
                  enctype="multipart/form-data">

                <div class="modal-body">

                    <!-- ID dùng khi UPDATE -->
                    <input type="hidden"
                           name="id">

                    <div class="row g-3">


                        <!-- TÊN CHUYÊN KHOA -->
                        <div class="col-md-6">

                            <label class="form-label">
                                Tên chuyên khoa
                            </label>

                            <input type="text"
                                   name="name"
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


                        <!-- GIÁ KHÁM CƠ BẢN -->
                        <div class="col-md-6">

                            <label class="form-label">
                                Giá khám cơ bản
                            </label>

                             <div class="input-group">

							        <input type="number"
							               name="basePrice"
							               class="form-control"
							               value="150000"
							               min="0"
							               step="1000"
							               required>
							
							        <span class="input-group-text">VNĐ</span>
							
							    </div>
                        </div>


                        <!-- CHUYÊN KHOA CHA -->
                        <div class="col-md-6">

                            <label class="form-label">
                                Chuyên khoa cha
                            </label>

                            <select name="parentId"
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


                        <!-- HÌNH ẢNH -->
                        <div class="col-12">

                            <label class="form-label">
                                Hình ảnh chuyên khoa
                            </label>

                            <input type="file"
                                   name="imageFile"
                                   class="form-control"
                                   accept=".jpg,.jpeg,.png,.webp,image/*">

                            <small class="image-note">
                                Chọn hình ảnh JPG, JPEG, PNG hoặc WEBP.
                            </small>

                        </div>


                        <!-- MÔ TẢ -->
                        <div class="col-12">

                            <label class="form-label">
                                Mô tả
                            </label>

                            <textarea name="description"
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
                        Lưu

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>