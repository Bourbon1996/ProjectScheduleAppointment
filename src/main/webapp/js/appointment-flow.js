// ==========================================================================
// QUẢN LÝ LUỒNG POPUP TUẦN TỰ (NGÀY -> KHOA -> BÁC SĨ/GIỜ) CHUẨN UMC
// ==========================================================================

// Kho chứa dữ liệu tạm thời trong lúc bấm chọn qua các Popup
let bookingData = {
    dateValue: "",       // Lấy ID: "2026-08-04" (Gửi về DB)
    dateDisplay: "",     // Lấy chữ: "04/08/2026 (Thứ 4)" (Hiện lên form)
    deptId: "",          // Lấy ID: "1" (Gửi về DB)
    deptName: "",        // Lấy chữ: "KHOA TIM MẠCH"
    doctorId: "",        // Lấy ID: "DOC01"
    doctorName: "",      // Lấy chữ: "BSCKII. Nguyễn Thành Luân"
    timeSlot: "",        // Lấy giờ: "07:30 - 08:30"
    price: "150.000 đồng"
};

// 1. KÍCH HOẠT MỞ POPUP ĐẦU TIÊN (CHỌN NGÀY)
function openBookingFlow() {
    const modalDateEl = document.getElementById('modalDate');
    const modalDate = bootstrap.Modal.getOrCreateInstance(modalDateEl);
    modalDate.show();
}

function safeSwitchModal(hideModalId, showModalId) {
    // 1. Tháo focus khỏi nút vừa click để không bị cảnh báo vàng aria-hidden
    if (document.activeElement) {
        document.activeElement.blur();
    }

    // 2. Ẩn Modal hiện tại
    const hideEl = document.getElementById(hideModalId);
    const hideInstance = bootstrap.Modal.getInstance(hideEl);
    if (hideInstance) {
        hideInstance.hide();
    }

    // 3. Đợi 400ms cho Bootstrap dọn sạch nền đen (backdrop) rồi mới mở Modal mới -> Chống lỗi đỏ!
    setTimeout(() => {
        const showEl = document.getElementById(showModalId);
        const showInstance = bootstrap.Modal.getOrCreateInstance(showEl);
        showInstance.show();
    }, 400); 
}

// 1. Khách bấm chọn NGÀY -> Chuyển sang Popup KHOA
function selectDate(dateVal, dateStr) {
    bookingData.dateValue = dateVal;
    bookingData.dateDisplay = dateStr;

    // Dùng hàm chuyển Modal an toàn
    safeSwitchModal('modalDate', 'modalDept');
}

// 2. Khách bấm chọn KHOA -> Chuyển sang Popup BÁC SĨ & GIỜ
function selectDept(id, name, priceStr) {
    bookingData.deptId = id;
    bookingData.deptName = name;
    bookingData.price = priceStr;

    // Cập nhật text nhắc nhở
    document.getElementById('lbl-selected-info').textContent = `${bookingData.deptName} - Ngày ${bookingData.dateDisplay}`;

    // Dùng hàm chuyển Modal an toàn
    safeSwitchModal('modalDept', 'modalDoctor');
}

// 3. Khách bấm chọn KHUNG GIỜ -> Hoàn tất, đóng Popup 3 và đổ ra Form chính
function selectTimeSlot(docId, docName, timeStr) {
    if (document.activeElement) document.activeElement.blur(); // Xóa focus
    
    bookingData.doctorId = docId;
    bookingData.doctorName = docName;
    bookingData.timeSlot = timeStr;

    // Đóng Popup 3
    const modalDocIns = bootstrap.Modal.getInstance(document.getElementById('modalDoctor'));
    if (modalDocIns) modalDocIns.hide();

    // Gọi hàm đổ dữ liệu ra giao diện chính
    updateMainForm();
}

// 5. HÀM CẬP NHẬT GIAO DIỆN BƯỚC 2 (HIỆN CHỮ + BẬT TICK XANH + MỞ KHÓA NÚT)
function updateMainForm() {
    // Điền chữ đẹp đẽ ra 4 ô input
    document.getElementById("input-display-date").value = bookingData.dateDisplay;
    document.getElementById("input-display-dept").value = bookingData.deptName;
    document.getElementById("input-display-time").value = bookingData.timeSlot;
    document.getElementById("input-display-doctor").value = bookingData.doctorName;

    // 🔥 BẬT 4 ICON TICK XANH LÊN (Xóa class d-none) 🔥
    document.querySelectorAll(".check-status-icon").forEach(icon => {
        icon.classList.remove("d-none");
    });

    // Cập nhật giá tiền khám
    document.getElementById("display-total-price").textContent = bookingData.price;

    // Âm thầm điền ID vào các thẻ input hidden để sẵn sàng gửi về Servlet ở Bước 3
    const setHidden = (id, val) => {
        const el = document.getElementById(id);
        if (el) el.value = val;
    };
    setHidden("hidden-date", bookingData.dateValue);
    setHidden("hidden-dept", bookingData.deptId);
    setHidden("hidden-doc", bookingData.doctorId);
    setHidden("hidden-time", bookingData.timeSlot);

    // Mở khóa nút "Tiếp tục đến Bước 3"
    document.getElementById("btn-next-step2").disabled = false;
}

// 6. CÁC NÚT QUAY LẠI GIỮA CÁC POPUP
function backToDateModal() {
    safeSwitchModal('modalDept', 'modalDate');
}

function backToDeptModal() {
    safeSwitchModal('modalDoctor', 'modalDept');
}

// 7. KIỂM TRA BẢO HIỂM Y TẾ (Kết nối với thông tin từ Bước 1)
function checkBHYT(isYes) {
    const msgEl = document.getElementById("bhyt-status-msg");
    
    if (isYes) {
        // Kiểm tra xem biến toàn cục selectedPatientData (từ Bước 1) có mã BHYT không
        if (typeof selectedPatientData !== 'undefined' && selectedPatientData && selectedPatientData.bhyt && selectedPatientData.bhyt !== 'null') {
            msgEl.textContent = `✔ Áp dụng mã BHYT: ${selectedPatientData.bhyt}`;
            msgEl.className = "small mt-1 text-success fw-bold";
        } else {
            alert("⚠️ Hồ sơ bệnh nhân này chưa được cập nhật mã Số thẻ BHYT! Vui lòng chọn 'Không' hoặc quay lại Bước 1 để cập nhật.");
            document.getElementById("bhytNo").checked = true;
            msgEl.textContent = "";
        }
    } else {
        msgEl.textContent = "";
    }
}

// Biến lưu vị trí tờ lịch đang xem (0 = Tháng hiện tại, tối đa là 3)
let activeMonthIdx = 0;

// Hàm lướt sang tháng trước/sau
function switchMonth(step) {
    // 1. Ẩn tờ lịch hiện tại đi
    document.getElementById(`month-slice-${activeMonthIdx}`).classList.add('d-none');
    
    // 2. Cộng/trừ chỉ số tháng (step là +1 hoặc -1)
    activeMonthIdx += step;
    
    // 3. Hiện tờ lịch của tháng mới lên
    document.getElementById(`month-slice-${activeMonthIdx}`).classList.remove('d-none');
}

// Hàm tìm kiếm & lọc chuyên khoa trực tiếp trên màn hình
function filterDepartments() {
    // 1. Lấy từ khóa người dùng đang gõ (chuyển về chữ thường)
    const keyword = document.getElementById("searchDeptInput").value.toLowerCase();
    
    // 2. Lấy toàn bộ thẻ chuyên khoa đang hiển thị
    const cards = document.querySelectorAll(".dept-item-filter");
    
    // 3. Lặp qua kiểm tra xem tên khoa có chứa từ khóa không
    cards.forEach(card => {
        const deptName = card.querySelector(".umc-dept-name").textContent.toLowerCase();
        if (deptName.includes(keyword)) {
            card.style.setProperty("display", "flex", "important"); // Hiện
        } else {
            card.style.setProperty("display", "none", "important"); // Ẩn
        }
    });
}