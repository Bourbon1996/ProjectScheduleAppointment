<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/site/shared/page.jsp" %>
    
<link rel="stylesheet" type="text/css" href="${ctx}/assets/css/admin/modal-form.css">
<!-- =====================================================
        MODAL THÊM / CẬP NHẬT BÁC SĨ
===================================================== -->

<div class="modal fade"
     id="doctorModal"
     tabindex="-1"
     aria-labelledby="doctorModalLabel"
     aria-hidden="true">

    <div class="modal-dialog modal-lg modal-dialog-centered">

        <div class="modal-content">

            <!-- HEADER -->
            <div class="modal-header">

                <h4 class="modal-title"
                    id="doctorModalLabel">

                    Thông tin bác sĩ

                </h4>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal">
                </button>

            </div>


            <!-- FORM -->

            <form id="doctorForm"
                  method="post"
                  enctype="multipart/form-data">

                <div class="modal-body">

                    <input type="hidden"
                           name="id"
                           id="doctorId">

                    <div class="row g-3">

                        <!-- TÀI KHOẢN -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Tài khoản

                            </label>

                            <select class="form-select"
                                    id="doctorUser"
                                    name="userId">

                                <option value="">
                                    -- Chọn tài khoản --
                                </option>

                                <c:forEach items="${listUsers}"
                                           var="user">

                                    <option value="${user.id}">

                                        ${user.fullName}

                                    </option>

                                </c:forEach>

                            </select>

                        </div>


                        <!-- CHUYÊN KHOA -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Chuyên khoa

                            </label>

                            <select class="form-select"
                                    id="doctorDepartment"
                                    name="departmentId">

                                <option value="">
                                    -- Chọn chuyên khoa --
                                </option>

                                <c:forEach items="${listDepartments}"
                                           var="department">

                                    <option value="${department.id}">

                                        ${department.name}

                                    </option>

                                </c:forEach>

                            </select>

                        </div>


                        <!-- CHỨC DANH -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Chức danh

                            </label>

                            <input type="text"
                                   class="form-control"
                                   id="doctorTitle"
                                   name="title"
                                   placeholder="Ví dụ: Bác sĩ CKI">

                        </div>


                        <!-- KINH NGHIỆM -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Số năm kinh nghiệm

                            </label>

                            <input type="number"
                                   class="form-control"
                                   id="doctorExperience"
                                   name="experienceYears"
                                   min="0"
                                   placeholder="Ví dụ: 10">

                        </div>


                        <!-- PHÍ KHÁM -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Phí khám

                            </label>

                            <div class="input-group">

                                <input type="number"
                                       class="form-control"
                                       id="doctorFee"
                                       name="examinationFee"
                                       value="150000"
                                       min="0"
                                       step="1000">

                                <span class="input-group-text">

                                    VNĐ

                                </span>

                            </div>

                        </div>


                        <!-- ẢNH -->

                        <div class="col-md-6">

                            <label class="form-label">

                                Ảnh đại diện

                            </label>

                            <input type="file"
                                   class="form-control"
                                   id="doctorAvatar"
                                   name="avtFile"
                                   accept="image/*">

                        </div>


                        <!-- MÔ TẢ -->

                        <div class="col-12">

                            <label class="form-label">

                                Mô tả

                            </label>

                            <textarea class="form-control"
                                      id="doctorDescription"
                                      name="description"
                                      rows="5"
                                      placeholder="Nhập mô tả bác sĩ"></textarea>

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
