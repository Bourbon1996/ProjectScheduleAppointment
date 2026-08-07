
let bookingData = {
    dateValue: "",       
    dateDisplay: "",     
    deptId: "",          
    deptName: "",        
    doctorId: "",        
    doctorName: "",      
    timeSlot: "",
	slotId:"",        
    price: ""
};


function openSpecificModal(modalType) {
    if (modalType === 'date') {
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDate'));
        modal.show();
    } 
    else if (modalType === 'dept') {
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDept'));
        modal.show();
    } 
    else if (modalType === 'doctor') {
        if (!bookingData.dateValue || !bookingData.deptId) {
            // Nếu chưa chọn ngày hoặc khoa, mở modal chọn bác sĩ chung
            const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalOnlyDoctor')); 
            modal.show();
        } else {
            // Nếu đã chọn ngày và khoa, gọi API lấy giờ khám rồi mới mở modal
            fetch('/scheduleappointment/api/get-doctors?deptId=' + bookingData.deptId + '&workdate=' + bookingData.dateValue)
                .then(response => response.text())
                .then(htmlString => {
                    const modalSlotBody = document.querySelector("#modalDoctor .modal-body");
                    modalSlotBody.innerHTML = htmlString;
                    const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDoctor')); 
                    modal.show();
                });
        }
    }
}

function selectOnlyDoctor(id, fullName, deptId, deptName, fee) {
    bookingData.doctorId = id;
    bookingData.doctorName = fullName;
    bookingData.deptId = deptId;
    bookingData.deptName = deptName;
    bookingData.price = fee;

    document.getElementById("input-display-doctor").value = fullName;
    document.getElementById("input-display-dept").value = deptName;

    let price = document.querySelector("#display-total-price");
    let priceFmt = parseFloat(fee);
    price.textContent = priceFmt.toLocaleString('vi-VN') + " đồng";

    const modalInstance = bootstrap.Modal.getInstance(document.getElementById('modalOnlyDoctor'));
    if (modalInstance) modalInstance.hide();
}

function changeModal(hideModalId, showModalId) {
	
    if (document.activeElement) {
        document.activeElement.blur();
    }

    const hideEl = document.getElementById(hideModalId);
    const hideInstance = bootstrap.Modal.getInstance(hideEl);
    if (hideInstance) {
        hideInstance.hide();
    }

    setTimeout(() => {
        const showEl = document.getElementById(showModalId);
        const showInstance = bootstrap.Modal.getOrCreateInstance(showEl);
        showInstance.show();
    }, 400); 
}

function selectDate(dateVal, dateStr) {
    bookingData.dateValue = dateVal;
    bookingData.dateDisplay = dateStr;
	
	document.querySelector("#input-display-date").value = dateStr;
	    
    const hideEl = document.getElementById('modalDate');
    const hideInstance = bootstrap.Modal.getInstance(hideEl);
    if (hideInstance) hideInstance.hide();
}

function selectDept(id, name, priceStr) {
    bookingData.deptId = id;
    bookingData.deptName = name;
    bookingData.price = priceStr;
	
    document.querySelector("#input-display-dept").value = name;
	
	let price = document.querySelector("#display-total-price");
    let priceFmt = parseFloat(priceStr);
    price.textContent = priceFmt.toLocaleString('vi-VN') + " đồng";
	
    const hideEl = document.getElementById('modalDept');
    const hideInstance = bootstrap.Modal.getInstance(hideEl);
    if (hideInstance) hideInstance.hide();
}

function selectTimeSlot(slotId, docId, docName, timeStr, fee) {
    if (document.activeElement) document.activeElement.blur();
    
    bookingData.doctorId = docId;
    bookingData.doctorName = docName;
    bookingData.timeSlot = timeStr;
	bookingData.price = fee;
	bookingData.slotId = slotId;
	
	document.getElementById("input-display-doctor").value = docName;

    const modalDocIns = bootstrap.Modal.getInstance(document.getElementById('modalDoctor'));
    if (modalDocIns) modalDocIns.hide();

    updateMainForm();
}

function updateMainForm() {
    
    document.getElementById("input-display-date").value = bookingData.dateDisplay;
    document.getElementById("input-display-dept").value = bookingData.deptName;
    document.getElementById("input-display-time").value = bookingData.timeSlot;
    document.getElementById("input-display-doctor").value = bookingData.doctorName;

    document.querySelectorAll(".check-status-icon").forEach(icon => {
        icon.classList.remove("d-none");
    });
	
	let price = document.querySelector("#display-total-price");
	    let priceFmt = parseFloat(bookingData.price);
	    price.textContent = priceFmt.toLocaleString('vi-VN') + " đồng";

    const setHidden = (id, val) => {
        const el = document.getElementById(id);
        if (el) el.value = val;
    };
    setHidden("hidden-date", bookingData.dateValue);
    setHidden("hidden-dept", bookingData.deptId);
    setHidden("hidden-doc", bookingData.doctorId);
    setHidden("hidden-slot", bookingData.slotId);

    document.getElementById("btn-next-step1").disabled = false;
}

function backToDateModal() {
    changeModal('modalDept', 'modalDate');
}

function backToDeptModal() {
    changeModal('modalDoctor', 'modalDept');
}

function checkBHYT(isYes) {
    const msgEl = document.getElementById("bhyt-status-msg");
    
    if (isYes) {

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

let activeMonthIdx = 0;

function switchMonth(step) {
    document.getElementById(`month-slice-${activeMonthIdx}`).classList.add('d-none');

    activeMonthIdx += step;

    document.getElementById(`month-slice-${activeMonthIdx}`).classList.remove('d-none');
}

function filterDepartments() {
    const keyword = document.getElementById("searchDeptInput").value.toLowerCase();
    
    const cards = document.querySelectorAll(".dept-item-filter");
    
    cards.forEach(card => {
        const deptName = card.querySelector(".umc-dept-name").textContent.toLowerCase();
        if (deptName.includes(keyword)) {
            card.style.setProperty("display", "flex", "important");
        } else {
            card.style.setProperty("display", "none", "important");
        }
    });
}