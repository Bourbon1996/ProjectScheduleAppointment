
let bookingData = {
    dateValue: "",       
    dateDisplay: "",     
    deptId: "",          
    deptName: "",        
    doctorId: "",        
    doctorName: "",      
    timeSlot: "",        
    price: ""
};


function openSpecificModal(modalType) {
    if (modalType === 'date') {
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDate'));
        modal.show();
    } 
    else if (modalType === 'dept') {
        
        if (!bookingData.dateValue) {
            alert("Vui lòng chọn ngày khám trước!");
            openSpecificModal('date');
            return;
        }
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDept'));
        modal.show();
    } 
    else if (modalType === 'doctor') {
        if (!bookingData.deptId) {
            alert("Vui lòng chọn chuyên khoa trước!");
            openSpecificModal('dept');
            return;
        }
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDoctor')); 
        modal.show();
    }
}

function safeSwitchModal(hideModalId, showModalId) {
	
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
	    
    safeSwitchModal('modalDate', 'modalDept');
}

function selectDept(id, name, priceStr) {
    bookingData.deptId = id;
    bookingData.deptName = name;
    bookingData.price = priceStr;
	
    document.querySelector("#input-display-dept").value = name;
    document.querySelector("#display-total-price").textContent = parseFloat(priceStr).toLocaleString('vi-VN') + " đồng";
	
    const dateVal = bookingData.dateValue; 
    
    fetch('/scheduleappointment/api/get-doctors?deptId=' + id + '&workdate=' + dateVal)
        .then(response => response.text())
        .then(htmlString => {
            
            const modalSlotBody = document.querySelector("#modalDoctor .modal-body");
            modalSlotBody.innerHTML = htmlString;

            safeSwitchModal('modalDept', 'modalDoctor');
        })
        .catch(error => {
            console.error("Lỗi:", error);
            alert("Lỗi mạng, không tải được danh sách bác sĩ!");
        });
}

function selectTimeSlot(docId, docName, timeStr) {
    if (document.activeElement) document.activeElement.blur();
    
    bookingData.doctorId = docId;
    bookingData.doctorName = docName;
    bookingData.timeSlot = timeStr;
	
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

    document.getElementById("display-total-price").textContent = bookingData.price;

    const setHidden = (id, val) => {
        const el = document.getElementById(id);
        if (el) el.value = val;
    };
    setHidden("hidden-date", bookingData.dateValue);
    setHidden("hidden-dept", bookingData.deptId);
    setHidden("hidden-doc", bookingData.doctorId);
    setHidden("hidden-time", bookingData.timeSlot);

    document.getElementById("btn-next-step2").disabled = false;
}

function backToDateModal() {
    safeSwitchModal('modalDept', 'modalDate');
}

function backToDeptModal() {
    safeSwitchModal('modalDoctor', 'modalDept');
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