<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="com.dhakcare.enums.Relationship" %>
    <%@ include file="/site/shared/page.jsp" %>


<div class="modal fade umc-modal" id="createProfileModal" tabindex="-1" aria-labelledby="modalTitle" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            
            <!-- HEADER -->
            <div class="modal-header text-white">
                <h5 class="modal-title fw-bold" id="modalTitle">
                    <i class="bi bi-person-vcard me-2"></i>TẠO HỒ SƠ BỆNH NHÂN MỚI
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <!-- BODY -->
            <div class="modal-body p-4">
                <!-- Thêm action trỏ về Servlet và method="POST" -->
				<form id="newProfileForm" action="${pageContext.request.contextPath}/patient/create" method="POST">
				    
				    <div class="row g-3 mb-4">
				        
				        <div class="col-12 mb-2">
				            <label class="umc-form-label fw-bold text-primary">Loại hồ sơ <span class="text-danger">*</span></label>
				            <select class="form-select umc-input border-primary" id="profileType" name="profileType" onchange="toggleProfileType()">
				                <option value="FULL">Hồ sơ đầy đủ (Hỗ trợ thanh toán Online)</option>
				                <option value="QUICK">Đặt lịch nhanh (Thanh toán tại quầy)</option>
				            </select>
				        </div>
				        
				        <div class="col-md-6">
				            <label class="umc-form-label">Họ và tên bệnh nhân <span class="text-danger">*</span></label>
				            <input type="text" class="form-control umc-input umc-input-name" name="fullName" id="newFullName" required style="text-transform: uppercase;">
				        </div>
				
				        <div class="col-md-6">
						    <label class="umc-form-label">Mối quan hệ với bạn <span class="text-danger">*</span></label>
						    <select class="form-select umc-input" name="relationship" id="newRelationship" required onchange="handleRelationshipChange()">
						        <option value="">-- Vui lòng chọn mối quan hệ --</option>
						        
						        
						        <c:forEach var="rel" items="<%=Relationship.values()%>">
						            <option value="${rel}">${rel.displayName}</option>
						        </c:forEach>
						        
						    </select>
						</div>
				
				        <div class="col-md-6">
				            <label class="umc-form-label">Số điện thoại liên hệ <span class="text-danger">*</span></label>
				            <input type="tel" class="form-control umc-input" name="phone" id="newPhone" required>
				        </div>
				
				        <div class="col-md-6">
				            <label class="umc-form-label">Email</label>
				            <input type="email" class="form-control umc-input" name="email" id="newEmail">
				        </div>
				        
				        <div id="fullProfileFields" class="row g-3 m-0 p-0 w-100">
				        <div class="col-md-6">
				            <label class="umc-form-label">Căn cước công dân <span class="text-danger">*</span></label>
				            <input type="text" class="form-control umc-input full-req" name="cccd" required maxlength="12">
				        </div>
				        
				        <div class="col-md-6">
				            <label class="umc-form-label">Ngày sinh <span class="text-danger">*</span></label>
				            <input type="date" class="form-control umc-input full-req" name="dob" required>
				        </div>
				
				        <div class="col-md-6">
				            <label class="umc-form-label">Giới tính <span class="text-danger">*</span></label>
				            <select class="form-select umc-input full-req" name="gender" required>
				                <option value="Nam">Nam</option>
				                <option value="Nữ">Nữ</option>
				                <option value="Khác">Khác</option>
				            </select>
				        </div>
				        

				        <div class="col-md-6">
				            <label class="umc-form-label">SĐT người thân khẩn cấp</label>
				            <input type="tel" class="form-control umc-input" name="emergency">
				        </div>
				
				        <div class="col-12">
				            <label class="umc-form-label">Mã Bảo hiểm y tế (BHYT)</label>
				            <input type="text" class="form-control umc-input" name="bhyt">
				        </div>
				
				        <div class="col-12">
				            <label class="umc-form-label">Địa chỉ hiện tại <span class="text-danger">*</span></label>
				            <input type="text" class="form-control umc-input full-req" name="address" required>
				        </div>
				        </div> <!-- End fullProfileFields -->
				    </div>
					
					<!-- FOOTER -->
            		<!-- Đổi nút bấm thành type="submit" và đặt bên trong form (Hoặc dùng thuộc tính form="newProfileForm") -->
				    <div class="modal-footer d-flex justify-content-between">
				        <span class="text-muted small">(*) Là các thông tin bắt buộc</span>
				        <div class="d-flex gap-2">
				            <button type="button" class="btn btn-umc-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
				            <!-- Nút Submit chính thức của Form -->
				            <button type="submit" class="btn btn-umc-primary">
				                <i class="bi bi-check2-circle me-1"></i> Lưu hồ sơ
				            </button>
				        </div>
				    </div>
				    
				</form>
            </div>

            

        </div>
    </div>
</div>

<script>
function toggleProfileType() {
    const type = document.getElementById("profileType").value;
    const fullFields = document.getElementById("fullProfileFields");
    const reqInputs = fullFields.querySelectorAll(".full-req");
    
    if (type === 'QUICK') {
        fullFields.style.display = 'none';
        reqInputs.forEach(input => input.removeAttribute('required'));
    } else {
        fullFields.style.display = 'flex';
        reqInputs.forEach(input => input.setAttribute('required', 'required'));
    }
}

function handleRelationshipChange() {
    const rel = document.getElementById("newRelationship").value;
    if (rel === 'SELF') {
        document.getElementById("newFullName").value = "${sessionScope.user.fullName}";
        document.getElementById("newPhone").value = "${sessionScope.user.phone}";
        document.getElementById("newEmail").value = "${sessionScope.user.email}";
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('newProfileForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Show loading state on button
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
                // Parse the returned HTML (which is /appointment page)
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");
                
                // Extract the updated patient list
                const updatedList = doc.querySelector('#patient-list-container');
                if (updatedList) {
                    document.querySelector('#patient-list-container').innerHTML = updatedList.innerHTML;
                } else {
                    console.error("Could not find patient list in response");
                }
                
                // Hide modal
                const modal = bootstrap.Modal.getInstance(document.getElementById('createProfileModal'));
                if (modal) modal.hide();
                
                // Reset form and UI
                form.reset();
                toggleProfileType(); // Reset visibility
                
                // Alert success
                alert("Thêm hồ sơ bệnh nhân thành công!");
                
            })
            .catch(error => {
                console.error("Error:", error);
                alert("Có lỗi xảy ra khi lưu hồ sơ. Vui lòng thử lại!");
            })
            .finally(() => {
                btn.innerHTML = originalHtml;
                btn.disabled = false;
            });
        });
    }
});
</script>