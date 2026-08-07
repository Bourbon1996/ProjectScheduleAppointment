<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dhakcare.enums.Relationship" %>
<%@ include file="/site/shared/page.jsp" %>

<div class="modal fade umc-modal" id="editProfileModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header text-white">
                <h5 class="modal-title fw-bold">
                    <i class="bi bi-pencil-square me-2"></i>CHỈNH SỬA HỒ SƠ BỆNH NHÂN
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
				<form id="editProfileForm" action="${ctx}/patient/update" method="POST">
				    <input type="hidden" name="patientId" id="edit-patientId">
				    <div class="row g-3 mb-4">
				        <div class="col-md-6">
				            <label class="umc-form-label">Họ và tên bệnh nhân <span class="text-danger">*</span></label>
				            <input type="text" class="form-control umc-input umc-input-name" name="fullName" id="edit-fullName" required style="text-transform: uppercase;">
				        </div>
				        <div class="col-md-6">
						    <label class="umc-form-label">Mối quan hệ <span class="text-danger">*</span></label>
						    <select class="form-select umc-input" name="relationship" id="edit-relationship" required>
						        <option value="">-- Vui lòng chọn mối quan hệ --</option>
						        <c:forEach var="rel" items="<%=Relationship.values()%>">
						            <option value="${rel}">${rel.displayName}</option>
						        </c:forEach>
						    </select>
						</div>
				        <div class="col-md-6">
				            <label class="umc-form-label">Ngày sinh <span class="text-danger">*</span></label>
				            <input type="date" class="form-control umc-input" name="dob" id="edit-dob" required>
				        </div>
				        <div class="col-md-6">
				            <label class="umc-form-label">Giới tính <span class="text-danger">*</span></label>
				            <select class="form-select umc-input" name="gender" id="edit-gender" required>
				                <option value="Nam">Nam</option>
				                <option value="Nữ">Nữ</option>
				                <option value="Khác">Khác</option>
				            </select>
				        </div>
				        <div class="col-md-6">
				            <label class="umc-form-label">Số điện thoại liên hệ <span class="text-danger">*</span></label>
				            <input type="tel" class="form-control umc-input" name="phone" id="edit-phone" required>
				        </div>
				        <div class="col-md-6">
				            <label class="umc-form-label">Email</label>
				            <input type="email" class="form-control umc-input" name="email" id="edit-email">
				        </div>
				        <div class="col-md-6">
				            <label class="umc-form-label">Căn cước công dân <span class="text-danger">*</span></label>
				            <input type="text" class="form-control umc-input" name="cccd" id="edit-cccd" required maxlength="12">
				        </div>
				        <div class="col-md-6">
				            <label class="umc-form-label">SĐT người thân khẩn cấp</label>
				            <input type="tel" class="form-control umc-input" name="emergency" id="edit-emergency">
				        </div>
				        <div class="col-12">
				            <label class="umc-form-label">Mã Bảo hiểm y tế (BHYT)</label>
				            <input type="text" class="form-control umc-input" name="bhyt" id="edit-bhyt">
				        </div>
				        <div class="col-12">
				            <label class="umc-form-label">Địa chỉ hiện tại <span class="text-danger">*</span></label>
				            <input type="text" class="form-control umc-input" name="address" id="edit-address" required>
				        </div>
				    </div>
				    <div class="modal-footer d-flex justify-content-between">
				        <span class="text-muted small">(*) Là các thông tin bắt buộc</span>
				        <div class="d-flex gap-2">
				            <button type="button" class="btn btn-umc-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
				            <button type="submit" class="btn btn-umc-primary">
				                <i class="bi bi-check2-circle me-1"></i> Cập nhật
				            </button>
				        </div>
				    </div>
				</form>
            </div>
        </div>
    </div>
</div>

<script>
function editProfile(id, name, phone, dob, gender, address, bhyt, emergency, rel, cccd, email) {
    document.getElementById('edit-patientId').value = id;
    document.getElementById('edit-fullName').value = name;
    document.getElementById('edit-phone').value = phone;
    document.getElementById('edit-email').value = email || '';
    document.getElementById('edit-cccd').value = cccd || '';
    document.getElementById('edit-dob').value = dob;
    document.getElementById('edit-gender').value = gender;
    document.getElementById('edit-address').value = address || '';
    document.getElementById('edit-bhyt').value = bhyt || '';
    document.getElementById('edit-emergency').value = emergency || '';
    document.getElementById('edit-relationship').value = rel || '';
    
    var editModal = new bootstrap.Modal(document.getElementById('editProfileModal'));
    editModal.show();
}

document.addEventListener('DOMContentLoaded', function() {
    const editForm = document.getElementById('editProfileForm');
    if (editForm) {
        editForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const btn = this.querySelector('button[type="submit"]');
            const originalHtml = btn.innerHTML;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang lưu...';
            btn.disabled = true;

            const formData = new FormData(this);
            fetch(this.action, {
                method: 'POST',
                body: new URLSearchParams(formData),
                credentials: 'same-origin',
                cache: 'no-store'
            })
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");
                
                const updatedList = doc.querySelector('#patient-list-container');
                if (updatedList) {
                    document.querySelector('#patient-list-container').innerHTML = updatedList.innerHTML;
                }
                
                const modal = bootstrap.Modal.getInstance(document.getElementById('editProfileModal'));
                if (modal) modal.hide();
                
                editForm.reset();
                alert("Cập nhật hồ sơ bệnh nhân thành công!");
            })
            .catch(error => {
                console.error("Error:", error);
                alert("Có lỗi xảy ra khi cập nhật hồ sơ. Vui lòng thử lại!");
            })
            .finally(() => {
                btn.innerHTML = originalHtml;
                btn.disabled = false;
            });
        });
    }
});
</script>
