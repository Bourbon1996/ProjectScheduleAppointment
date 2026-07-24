document.addEventListener("DOMContentLoaded", function () {
    // Đặt ngày khám mặc định là ngày mai để form sinh động hơn
    const dateInput = document.getElementById("examDate");
    if(dateInput) {
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        dateInput.valueAsDate = tomorrow;
    }
});

// Hàm tạo hiệu ứng chọn thẻ hồ sơ ở Bước 1
function selectProfile(element, name, phone) {
    document.querySelectorAll('.profile-card').forEach(card => card.classList.remove('selected'));
    element.classList.add('selected');
    document.getElementById('hidden-patient').value = name;
    document.getElementById('success-patient-name').textContent = name;
}

// Kiểm tra form Bước 2 trước khi cho qua Bước 3
function validateAndGoToStep3() {
    const date = document.getElementById("examDate").value;
    const dept = document.getElementById("departmentSelect").value;
    const time = document.getElementById("timeSlotSelect").value;
    const doctor = document.getElementById("doctorSelect").value;

    if (!date || !dept || !time) {
        alert("Vui lòng chọn đầy đủ Ngày khám, Chuyên khoa và Giờ khám!");
        return;
    }

    // Đổ dữ liệu từ Bước 2 sang màn hình Xác nhận (Bước 3)
    document.getElementById("conf-date").textContent = formatDate(date);
    document.getElementById("conf-department").textContent = dept;
    document.getElementById("conf-time").textContent = time;
    document.getElementById("conf-doctor").textContent = doctor || "Bác sĩ phân công tự động";

    // Cập nhật thẻ hidden để sẵn sàng Submit về Backend Servlet
    document.getElementById("hidden-date").value = date;
    document.getElementById("hidden-dept").value = dept;
    document.getElementById("hidden-time").value = time;
    document.getElementById("hidden-doc").value = doctor;

    goToStep(3);
}

// Hàm điều khiển chuyển đổi giữa các Bước (1, 2, 3, 4)
function goToStep(stepNumber) {
    // 1. Ẩn tất cả các nội dung tab
    document.querySelectorAll('.step-pane').forEach(pane => {
        pane.classList.remove('active');
    });

    // 2. Hiện nội dung tab được chọn
    const targetPane = document.getElementById(`step-pane-${stepNumber}`);
    if (targetPane) {
        targetPane.classList.add('active');
    }

    // 3. Cập nhật giao diện thanh Stepper bên trên
    for (let i = 1; i <= 4; i++) {
        const stepItem = document.getElementById(`stepper-${i}`);
        if (!stepItem) continue;

        stepItem.classList.remove('active', 'completed');

        if (i < stepNumber) {
            stepItem.classList.add('completed'); // Các bước đã qua -> Màu xanh lá
            stepItem.querySelector('.step-icon').innerHTML = '<i class="bi bi-check-lg"></i>';
        } else if (i === stepNumber) {
            stepItem.classList.add('active'); // Bước hiện tại -> Màu trắng viền xanh
            restoreIcon(stepItem, i);
        } else {
            // Các bước chưa tới -> Màu xanh dương mặc định
            restoreIcon(stepItem, i);
        }
    }

    // Tự động cuộn nhẹ lên đầu form cho dễ nhìn
    window.scrollTo({ top: 150, behavior: 'smooth' });
}

// Hàm hỗ trợ trả lại Icon gốc cho Stepper
function restoreIcon(stepItem, stepIndex) {
    const icons = [
        '<i class="bi bi-person"></i>',
        '<i class="bi bi-file-earmark-medical"></i>',
        '<i class="bi bi-calendar-check"></i>',
        '<i class="bi bi-check-lg"></i>'
    ];
    stepItem.querySelector('.step-icon').innerHTML = icons[stepIndex - 1];
}

// Hàm đổi định dạng ngày YYYY-MM-DD sang DD/MM/YYYY cho đẹp
function formatDate(dateString) {
    const parts = dateString.split('-');
    return `${parts[2]}/${parts[1]}/${parts[0]}`;
}


// Mảng lưu trữ danh sách hồ sơ (Giả lập database phía Client)
// Ban đầu để mảng rỗng [] để test giao diện "Chưa có hồ sơ"
let patientProfiles = [];

// Biến lưu hồ sơ đang được chọn
let selectedProfileData = null;

document.addEventListener("DOMContentLoaded", function () {
    // 1. Vẽ danh sách hồ sơ ngay khi tải trang
    renderProfiles();

    // 2. Đặt ngày khám mặc định là ngày mai
    const dateInput = document.getElementById("examDate");
    if (dateInput) {
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        dateInput.valueAsDate = tomorrow;
    }
});

// =========================================================================
// HÀM 1: VẼ DANH SÁCH HỒ SƠ (Xử lý Empty State & Danh sách thẻ)
// =========================================================================
function renderProfiles() {
    const container = document.getElementById("profileListContainer");
    const nextBtn = document.getElementById("btn-next-step1");
    container.innerHTML = "";

    // TRƯỜNG HỢP 1: Chưa có hồ sơ nào (Empty State)
    if (patientProfiles.length === 0) {
        container.innerHTML = `
            <div class="col-12 text-center py-5 my-3 bg-light rounded-3 border border-dashed">
                <i class="bi bi-folder-x text-secondary" style="font-size: 3.5rem;"></i>
                <h6 class="fw-bold mt-3 text-secondary">Chưa có hồ sơ đặt khám nào</h6>
                <p class="text-muted small mb-3">Vui lòng tạo hồ sơ bệnh nhân mới để tiếp tục đặt lịch khám</p>
                <button type="button" class="btn btn-primary btn-sm px-3" data-bs-toggle="modal" data-bs-target="#createProfileModal">
                    <i class="bi bi-plus-circle me-1"></i> Tạo hồ sơ ngay
                </button>
            </div>
        `;
        nextBtn.disabled = true; // Khóa nút Tiếp tục
        return;
    }

    // TRƯỜNG HỢP 2: Đã có hồ sơ -> Vẽ danh sách thẻ
    patientProfiles.forEach((profile, index) => {
        const isSelected = selectedProfileData && selectedProfileData.id === profile.id;
        const relBadge = getRelationshipBadge(profile.relationship);

        const cardHtml = `
            <div class="col-md-6">
                <div class="profile-card ${isSelected ? 'selected' : ''} d-flex align-items-center justify-content-between p-3" 
                     onclick="selectProfile(${index})">
                    <div class="d-flex align-items-center">
                        <div class="profile-icon me-3">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <div>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <h6 class="mb-0 fw-bold text-primary">${profile.fullName}</h6>
                                ${relBadge}
                            </div>
                            <p class="mb-0 text-muted small"><i class="bi bi-calendar3 me-1"></i> ${formatDate(profile.dateOfBirth)} (${profile.gender})</p>
                            <p class="mb-0 text-muted small"><i class="bi bi-telephone me-1"></i> ${profile.phone}</p>
                        </div>
                    </div>
                    <i class="bi bi-check-circle-fill text-primary fs-4 ${isSelected ? '' : 'd-none'}"></i>
                </div>
            </div>
        `;
        container.insertAdjacentHTML("beforeend", cardHtml);
    });

    // Mở khóa nút Tiếp tục nếu đã chọn 1 hồ sơ
    nextBtn.disabled = (selectedProfileData === null);
}

// =========================================================================
// HÀM 2: LƯU HỒ SƠ MỚI TỪ MODAL
// =========================================================================
function saveNewProfile() {
    const form = document.getElementById("newProfileForm");
    if (!form.checkValidity()) {
        form.reportValidity(); // Bắt lỗi HTML5 (chưa nhập các trường required)
        return;
    }

    // Tạo object mới theo đúng Entity Patient & Appointment
    const newProfile = {
        id: Date.now(), // Tạo ID tạm bằng timestamp
        fullName: document.getElementById("form-fullName").value.trim().toUpperCase(),
        relationship: document.getElementById("form-relationship").value,
        dateOfBirth: document.getElementById("form-dob").value,
        gender: document.getElementById("form-gender").value,
        phone: document.getElementById("form-phone").value.trim(),
        emergencyContact: document.getElementById("form-emergency").value.trim(),
        healthInsuranceCode: document.getElementById("form-bhyt").value.trim(),
        address: document.getElementById("form-address").value.trim()
    };

    // Thêm vào mảng
    patientProfiles.push(newProfile);

    // Tự động chọn luôn hồ sơ vừa tạo cho tiện UX
    selectedProfileData = newProfile;

    // Đóng Modal & Reset Form
    const modalEl = document.getElementById("createProfileModal");
    const modalInstance = bootstrap.Modal.getInstance(modalEl);
    modalInstance.hide();
    form.reset();

    // Vẽ lại danh sách
    renderProfiles();
}

// =========================================================================
// HÀM 3: CHỌN HỒ SƠ
// =========================================================================
function selectProfile(index) {
    selectedProfileData = patientProfiles[index];
    renderProfiles(); // Vẽ lại để cập nhật hiệu ứng thẻ Active
}

// Hàm hỗ trợ đổi mã Relationship thành Badge tiếng Việt cho đẹp
function getRelationshipBadge(relCode) {
    const map = {
        'BAN_THAN': '<span class="badge bg-success small">Bản thân</span>',
        'CHA_ME': '<span class="badge bg-info text-dark small">Cha / Mẹ</span>',
        'CON_CAI': '<span class="badge bg-warning text-dark small">Con cái</span>',
        'VO_CHONG': '<span class="badge bg-danger small">Vợ / Chồng</span>',
        'KHAC': '<span class="badge bg-secondary small">Khác</span>'
    };
    return map[relCode] || '';
}

// =========================================================================
// HÀM 4: KIỂM TRA & ĐỔ DỮ LIỆU SANG BƯỚC 3 (XÁC NHẬN)
// =========================================================================
function validateAndGoToStep3() {
    const date = document.getElementById("examDate").value;
    const dept = document.getElementById("departmentSelect").value;
    const time = document.getElementById("timeSlotSelect").value;
    const doctor = document.getElementById("doctorSelect").value;

    if (!date || !dept || !time) {
        alert("Vui lòng chọn đầy đủ Ngày khám, Chuyên khoa và Giờ khám!");
        return;
    }

    // 1. Đổ dữ liệu Bệnh nhân (Từ Bước 1)
    document.getElementById("conf-patient-name").textContent = selectedProfileData.fullName;
    document.getElementById("conf-patient-dob").textContent = `${formatDate(selectedProfileData.dateOfBirth)} (${selectedProfileData.gender})`;
    document.getElementById("conf-patient-phone").textContent = selectedProfileData.phone;
    document.getElementById("conf-patient-bhyt").textContent = selectedProfileData.healthInsuranceCode || "Không có";

    // 2. Đổ dữ liệu Khám bệnh (Từ Bước 2)
    document.getElementById("conf-date").textContent = formatDate(date);
    document.getElementById("conf-department").textContent = dept;
    document.getElementById("conf-time").textContent = time;
    document.getElementById("conf-doctor").textContent = doctor || "Bác sĩ phân công tự động";

    // 3. Gán vào các thẻ Hidden Input để sẵn sàng Submit về Backend Servlet
    document.getElementById("hidden-patient-id").value = selectedProfileData.id;
    document.getElementById("hidden-relationship").value = selectedProfileData.relationship;
    document.getElementById("hidden-date").value = date;
    document.getElementById("hidden-dept").value = dept;
    document.getElementById("hidden-time").value = time;
    document.getElementById("hidden-doc").value = doctor;

    goToStep(3);
}

// CÁC HÀM CŨ GIỮ NGUYÊN: goToStep(stepNumber), restoreIcon(...), formatDate(...)