// Biến toàn cục lưu thông tin bệnh nhân đang được chọn trên màn hình
let selectedPatientData = null;

document.addEventListener("DOMContentLoaded", function () {
    // 1. Đặt ngày khám mặc định là ngày mai cho form sinh động
    const dateInput = document.getElementById("examDate");
    if (dateInput) {
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        dateInput.valueAsDate = tomorrow;
    }
	
	const targetPane = document.getElementById("stepper-1");
	if(targetPane.classList.contains('completed')){
		const modalDateEl = document.getElementById('modalDate');
							    
			if (modalDateEl) {
							        
				const modalDate = bootstrap.Modal.getOrCreateInstance(modalDateEl);
				modalDate.show();
			}
	}
	
	
});



// =========================================================================
// HÀM 1: CHỌN HỒ SƠ TỪ DANH SÁCH DO JSP (DATABASE) VẼ RA
// =========================================================================
function selectProfileFromDB(element, id, fullName, phone, dob, gender, bhyt, relationship) {
    // 1. Xóa hiệu ứng "selected" (viền xanh) ở tất cả các thẻ Card khác
    document.querySelectorAll('.profile-card').forEach(card => {
        card.classList.remove('selected');
        const icon = card.querySelector('.check-icon');
        if (icon) icon.classList.add('d-none');
    });

    // 2. Thêm hiệu ứng "selected" vào thẻ Card vừa được click
    element.classList.add('selected');
    const checkIcon = element.querySelector('.check-icon');
    if (checkIcon) checkIcon.classList.remove('d-none');

    // 3. Lưu thông tin vào biến toàn cục để dành cho Bước 3 (Xác nhận)
    selectedPatientData = {
        id: id,
        fullName: fullName,
        phone: phone,
        dob: dob,
        gender: gender,
        bhyt: bhyt,
        relationship: relationship
    };

    // 4. Mở khóa nút "Tiếp tục" ở Bước 1
    const nextBtn = document.getElementById("btn-next-step1");
    if (nextBtn) nextBtn.disabled = false;
}

// =========================================================================
// HÀM 2: KIỂM TRA & ĐỔ DỮ LIỆU SANG BƯỚC 3 (XÁC NHẬN)
// =========================================================================
// =========================================================================
// HÀM KIỂM TRA & ĐỔ DỮ LIỆU SANG BƯỚC 3 (XÁC NHẬN ĐẶT LỊCH)
// =========================================================================
function validateAndGoToStep3() {
    // 1. Kiểm tra an toàn: Đảm bảo bệnh nhân đã được chọn ở Bước 1
    if (!selectedPatientData) {
        alert("⚠️ Vui lòng chọn 1 hồ sơ bệnh nhân ở Bước 1 trước khi tiếp tục!");
        goToStep(1);
        return;
    }

    // 2. Lấy các giá trị đầu vào từ form Bước 2
    const date = document.getElementById("examDate").value;
    const time = document.getElementById("timeSlotSelect").value;
    const doctor = document.getElementById("doctorSelect").value;

    // 🔥 LẤY CHUYÊN KHOA (Tách riêng thẻ Select để xử lý ID và Tên)
    const deptSelect = document.getElementById("departmentSelect");
    const deptId = deptSelect.value; // Đây là con số ID (VD: "1", "2") để gửi về DB

    // 3. Kiểm tra rỗng (Validation) - Bắt buộc phải chọn Ngày, Khoa và Giờ
    if (!date || !deptId || !time) {
        alert("⚠️ Vui lòng chọn đầy đủ Ngày khám, Chuyên khoa và Giờ khám!");
        return;
    }

    // 🔥 Sau khi đã chắc chắn người dùng chọn đúng Khoa, mới lấy CHỮ ra hiển thị
    const deptName = deptSelect.options[deptSelect.selectedIndex].text; // Lấy chữ (VD: "Khoa Tim Mạch")

    // =====================================================================
    // 4. HIỆN DỮ LIỆU LÊN MÀN HÌNH XÁC NHẬN (BƯỚC 3) - DÀNH CHO NGƯỜI DÙNG ĐỌC
    // =====================================================================
    
    // --> Thông tin bệnh nhân
    document.getElementById("conf-patient-name").textContent = selectedPatientData.fullName;
    document.getElementById("conf-patient-dob").textContent = `${formatDate(selectedPatientData.dob)} (${selectedPatientData.gender})`;
    document.getElementById("conf-patient-phone").textContent = selectedPatientData.phone;
    document.getElementById("conf-patient-bhyt").textContent = (selectedPatientData.bhyt && selectedPatientData.bhyt !== 'null') 
        ? selectedPatientData.bhyt 
        : "Không có";

    // --> Thông tin phiếu khám
    document.getElementById("conf-date").textContent = formatDate(date);
    document.getElementById("conf-department").textContent = deptName; // Hiện chữ đẹp đẽ
    document.getElementById("conf-time").textContent = time;
    document.getElementById("conf-doctor").textContent = doctor || "Bác sĩ phân công tự động";

    // =====================================================================
    // 5. ĐÓNG GÓI VÀO THẺ HIDDEN - DÀNH CHO JAVA SERVLET LẤY BẰNG getParameter()
    // =====================================================================
    
    document.getElementById("hidden-patient-id").value = selectedPatientData.id;
    document.getElementById("hidden-date").value = date;
    document.getElementById("hidden-dept").value = deptId; // 🔥 Gán ID gọn gàng cho Servlet
    document.getElementById("hidden-time").value = time;
    document.getElementById("hidden-doc").value = doctor;

    // 6. Mọi thứ đã hoàn hảo -> Lướt sang giao diện Bước 3
    goToStep(3);
}

// =========================================================================
// HÀM 3: ĐIỀU KHIỂN CHUYỂN BƯỚC STEPPER (1, 2, 3, 4)
// =========================================================================
function goToStep(stepNumber) {
    document.querySelectorAll('.step-pane').forEach(pane => {
        pane.classList.remove('active');
    });
	
	document.querySelector("#input-display-date").value = "";
	document.querySelector("#input-display-dept").value = "";
	
	document.querySelectorAll(".check-status-icon").forEach(icon => {
		icon.classList.add("d-none");
	})

    const targetPane = document.getElementById(`step-pane-${stepNumber}`);
    if (targetPane) {
        targetPane.classList.add('active');
		
    }
	
	

    for (let i = 1; i <= 4; i++) {
        const stepItem = document.getElementById(`stepper-${i}`);
        if (!stepItem) continue;

        stepItem.classList.remove('active', 'completed');

        if (i < stepNumber) {
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

