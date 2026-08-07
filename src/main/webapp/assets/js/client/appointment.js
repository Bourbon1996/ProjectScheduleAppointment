// Biến toàn cục lưu thông tin bệnh nhân đang được chọn trên màn hình
let selectedPatientData = null;
let lastConfirmedPatientId = null;

document.addEventListener("DOMContentLoaded", function () {
    // 1. Đặt ngày khám mặc định là ngày mai cho form sinh động
    const dateInput = document.getElementById("examDate");
    if (dateInput) {
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        dateInput.valueAsDate = tomorrow;
    }
	
});



function selectProfileFromDB(element, id, fullName, phone, dob, gender, bhyt, relationship, isFullProfile) {

    document.querySelectorAll('.profile-card').forEach(card => {
        card.classList.remove('selected');
        const icon = card.querySelector('.check-icon');
        if (icon) icon.classList.add('d-none');
    });

    element.classList.add('selected');
    const checkIcon = element.querySelector('.check-icon');
    if (checkIcon) checkIcon.classList.remove('d-none');

    selectedPatientData = {
        id: id,
        fullName: fullName,
        phone: phone,
        dob: dob,
        gender: gender,
        bhyt: bhyt,
        relationship: relationship,
        isFullProfile: isFullProfile
    };
	

    const nextBtn = document.getElementById("btn-next-step2");
    if (nextBtn) nextBtn.disabled = false;
}

function validateAndGoToStep2() {
    const date = document.getElementById("input-display-date").value;
    const time = document.getElementById("input-display-time").value;
    const deptSelect = document.getElementById("input-display-dept").value;

    if (!date || !deptSelect || !time ) {
        alert("⚠️ Vui lòng chọn đầy đủ Ngày khám, Chuyên khoa và Giờ khám!");
        return;
    }
    goToStep(2);
}

function validateAndGoToStep3() {
    if (!selectedPatientData) {
        alert("⚠️ Vui lòng chọn 1 hồ sơ bệnh nhân ở Bước 2 trước khi tiếp tục!");
        goToStep(2);
        return;
    }

    const date = document.getElementById("input-display-date").value;
    const time = document.getElementById("input-display-time").value;
    const doctor = document.getElementById("input-display-doctor").value;
    const deptSelect = document.getElementById("input-display-dept").value;

    if (!date || !deptSelect || !time ) {
        alert("⚠️ Vui lòng chọn đầy đủ Ngày khám, Chuyên khoa và Giờ khám!");
        return;
    }
    
    // --> Thông tin bệnh nhân
    document.getElementById("conf-patient-name").textContent = selectedPatientData.fullName;
    
    if (selectedPatientData.isFullProfile) {
        document.getElementById("conf-patient-dob").textContent = `${formatDate(selectedPatientData.dob)} (${selectedPatientData.gender})`;
    } else {
        document.getElementById("conf-patient-dob").textContent = "Hồ sơ đặt lịch nhanh";
    }
    
    document.getElementById("conf-patient-phone").textContent = selectedPatientData.phone;
    document.getElementById("conf-patient-bhyt").textContent = (selectedPatientData.bhyt && selectedPatientData.bhyt !== 'null') 
        ? selectedPatientData.bhyt 
        : "Không có";

    // --> Thông tin phiếu khám
    document.getElementById("conf-date").textContent = formatDate(date);
    document.getElementById("conf-department").textContent = deptSelect;
    document.getElementById("conf-time").textContent = time;
    document.getElementById("conf-doctor").textContent = doctor || "Bác sĩ phân công tự động";
	document.getElementById("price-form").textContent = parseFloat(bookingData.price).toLocaleString('vi-VN') + " đồng";
	document.getElementById("price").textContent = parseFloat(bookingData.price).toLocaleString('vi-VN') + " đồng";

    
    document.getElementById("hidden-patient-id").value = selectedPatientData.id;
	
	console.log(bookingData);
	console.log(selectedPatientData);
    
    // Xử lý VNPAY restriction
    const vnpayRadio = document.getElementById("pay-vnpay");
    const vnpayLabel = document.querySelector('label[for="pay-vnpay"]');
    const cashRadio = document.getElementById("pay-cash");
    const quickProfileWarning = document.getElementById("quick-profile-warning");
    
    if (vnpayRadio && cashRadio) {
        if (!selectedPatientData.isFullProfile) {
            vnpayRadio.disabled = true;
            vnpayRadio.checked = false;
            cashRadio.checked = true;
            updatePaymentMethod('CASH');
            
            if (vnpayLabel) vnpayLabel.classList.add('text-muted');
            if (quickProfileWarning) quickProfileWarning.classList.remove('d-none');
        } else {
            vnpayRadio.disabled = false;
            if (vnpayLabel) vnpayLabel.classList.remove('text-muted');
            if (quickProfileWarning) quickProfileWarning.classList.add('d-none');
        }
    }

    goToStep(3);
}


function goToStep(stepNumber) {
    document.querySelectorAll('.step-pane').forEach(pane => {
        pane.classList.remove('active');
    });

    const targetPane = document.getElementById(`step-pane-${stepNumber}`);
    if (targetPane) {
        targetPane.classList.add('active');
    }

    for (let i = 1; i <= 4; i++) {
        const stepItem = document.getElementById(`stepper-${i}`);
        if (!stepItem) continue;

        stepItem.classList.remove('active', 'completed');

        if (i <= stepNumber) {
            stepItem.classList.add('completed');
            stepItem.querySelector('.step-icon').innerHTML = '<i class="bi bi-check-lg"></i>';
        } else if (i === stepNumber) {
            stepItem.classList.add('active');
            restoreIcon(stepItem, i);
        } else {
            restoreIcon(stepItem, i);
        }
    }

    window.scrollTo({ top: 150, behavior: 'smooth' });
}

function restoreIcon(stepItem, stepIndex) {
    const icons = [
        '<i class="bi bi-person"></i>',
        '<i class="bi bi-file-earmark-medical"></i>',
        '<i class="bi bi-calendar-check"></i>',
        '<i class="bi bi-check-lg"></i>'
    ];
    stepItem.querySelector('.step-icon').innerHTML = icons[stepIndex - 1];
}

function formatDate(dateString) {
    if (!dateString || !dateString.includes('-')) return dateString;
    const parts = dateString.split('-');
    return `${parts[2]}/${parts[1]}/${parts[0]}`;
}

// Tự động bỏ focus khi đóng Modal để không bị cảnh báo vàng trong Console
document.addEventListener('hidden.bs.modal', function () {
    if (document.activeElement) {
        document.activeElement.blur();
    }
});

function updatePaymentMethod(method) {
    // 1. Lưu vào thẻ hidden để đẩy xuống Servlet
    document.getElementById("hidden-payment-method").value = method;
    
    // 2. Đổi màu nút cho hợp ngữ cảnh
    const btnSubmit = document.getElementById("btn-final-submit");
    if (method === 'VNPAY') {
        btnSubmit.innerHTML = 'Thanh toán VNPAY <i class="bi bi-credit-card ms-1"></i>';
        btnSubmit.className = 'btn btn-primary px-5 fw-bold';
    } else {
        btnSubmit.innerHTML = 'Xác nhận Đặt lịch <i class="bi bi-check-circle ms-1"></i>';
        btnSubmit.className = 'btn btn-success px-5 fw-bold';
    }
}

function submitBookingForm() {
    
    const patientId = document.getElementById("hidden-patient-id").value;
    const deptId = document.getElementById("hidden-dept").value;
    const slotId = document.getElementById("hidden-slot").value;
    const doctorId = document.getElementById("hidden-doc").value;

    console.log(patientId)
	console.log(deptId)
	console.log(slotId)
	console.log(doctorId)

    const form = document.getElementById("realSubmitForm");
    const formData = new FormData(form);

    // Tiến hành fetch như bình thường...
    fetch(form.action, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'VNPAY') {
            window.location.href = data.redirectUrl;
        } else if (data.status === 'SUCCESS') {
            const codeEl = document.querySelector("#step-pane-4 .text-primary");
            if(codeEl) codeEl.textContent = "#UMC-2026-" + data.appointmentId;
            goToStep(4);
        } else {
            alert("⚠️ Lỗi: " + (data.message || "Không thể tạo lịch khám!"));
        }
    })
    .catch(error => {
        console.error("Lỗi hệ thống:", error);
        alert("⚠️ Đã xảy ra lỗi kết nối đến máy chủ!");
    });
}

