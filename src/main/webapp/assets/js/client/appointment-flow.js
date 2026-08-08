let bookingData = {
    dateValue: "",       
    dateDisplay: "",     
    deptId: "",          
    deptName: "",        
    doctorId: "",        
    doctorName: "",      
    timeSlot: "",
	slotId:"",        
    price: "",
    availableDates: []
};

function resetDependentFields(changedField) {
    if (changedField === 'date') {
        bookingData.slotId = "";
    }
    else if (changedField === 'dept') {
        bookingData.doctorId = "";
        bookingData.doctorName = "";
        bookingData.timeSlot = "";
        bookingData.slotId = "";
    }
    else if (changedField === 'doctor') {
        bookingData.slotId = "";
    }
    updateMainForm();
}

function openSpecificModal(modalType) {
    if (modalType === 'date') {
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDate'));
        modal.show();
    } 
    else if (modalType === 'dept') {
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDept'));
        modal.show();
    } 
    else if (modalType === 'only-doctor') {
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalOnlyDoctor')); 
        modal.show();
    }
    else if (modalType === 'doctor') {
        if (!bookingData.dateValue) {
            let url = '/scheduleappointment/api/get-unique-time-slots?';
            if (bookingData.doctorId) url += 'doctorId=' + bookingData.doctorId;
            else if (bookingData.deptId) url += 'deptId=' + bookingData.deptId;
            
            fetch(url)
                .then(response => response.text())
                .then(htmlString => {
                    const modalSlotBody = document.querySelector("#modalDoctor .modal-body");
                    modalSlotBody.innerHTML = htmlString;
                    const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDoctor')); 
                    modal.show();
                });
        } else {
            if (!bookingData.deptId) {
                const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalOnlyDoctor')); 
                modal.show();
            } else {
                let url = '/scheduleappointment/api/get-doctors?deptId=' + bookingData.deptId + '&workdate=' + bookingData.dateValue;
                if (bookingData.doctorId) {
                    url += '&doctorId=' + bookingData.doctorId;
                }
                fetch(url)
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
}

function selectOnlyDoctor(id, fullName, deptId, deptName, fee) {
    if (bookingData.doctorId !== id) {
        bookingData.doctorId = id;
        bookingData.doctorName = fullName;
        bookingData.deptId = deptId;
        bookingData.deptName = deptName;
        bookingData.price = fee;
        
        resetDependentFields('doctor');
        
        let url = '/scheduleappointment/api/get-available-dates?doctorId=' + id;
        if (bookingData.timeSlot) {
            url += '&timeSlot=' + encodeURIComponent(bookingData.timeSlot);
        }
        
        fetch(url)
            .then(res => res.json())
            .then(dates => {
                bookingData.availableDates = dates;
                applyDoctorDateFilter();
                checkAndAutoPopModal();
                resolveSlotIfReady();
            })
            .catch(err => console.error("Error fetching dates:", err));
    }

    const modalInstance = bootstrap.Modal.getInstance(document.getElementById('modalOnlyDoctor'));
    if (modalInstance) modalInstance.hide();
}

function applyDoctorDateFilter() {
    // Reset any previously filtered dates
    document.querySelectorAll('.doctor-filtered').forEach(btn => {
        btn.classList.remove('disabled', 'doctor-filtered');
        btn.classList.add('available');
        btn.disabled = false;
    });

    if (!bookingData.doctorId && !bookingData.deptId) return;

    // Filter dates based on availableDates
    document.querySelectorAll('.umc-day-btn').forEach(btn => {
        let dateStr = btn.getAttribute('data-date');
        if (dateStr) {
            // Only filter naturally available buttons
            if (btn.classList.contains('available') && bookingData.availableDates && !bookingData.availableDates.includes(dateStr)) {
                btn.classList.remove('available');
                btn.classList.add('disabled', 'doctor-filtered');
                btn.disabled = true;
            }
        }
    });
}

function applyDoctorFilter() {
    if (!bookingData.deptId) return;
    
    document.querySelectorAll(".only-doc-item-filter").forEach(card => {
        const cardDeptId = card.getAttribute("data-dept-id");
        if (cardDeptId !== bookingData.deptId) {
            card.style.setProperty("display", "none", "important");
        } else {
            card.style.setProperty("display", "block", "important");
        }
    });
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
    if (bookingData.dateValue !== dateVal) {
        bookingData.dateValue = dateVal;
        bookingData.dateDisplay = dateStr;
        resetDependentFields('date');
        
        checkAndAutoPopModal();
        resolveSlotIfReady();
    }
	    
    const hideEl = document.getElementById('modalDate');
    const hideInstance = bootstrap.Modal.getInstance(hideEl);
    if (hideInstance) hideInstance.hide();
}

function selectGenericTimeSlot(timeStr) {
    bookingData.timeSlot = timeStr;
    
    let url = '/scheduleappointment/api/get-available-dates?timeSlot=' + encodeURIComponent(timeStr);
    if (bookingData.doctorId) url += '&doctorId=' + bookingData.doctorId;
    else if (bookingData.deptId) url += '&deptId=' + bookingData.deptId;
    
    fetch(url)
        .then(res => res.json())
        .then(dates => {
            bookingData.availableDates = dates;
            applyDoctorDateFilter();
            checkAndAutoPopModal();
            resolveSlotIfReady();
        });
        
    const modalInstance = bootstrap.Modal.getInstance(document.getElementById('modalDoctor'));
    if (modalInstance) modalInstance.hide();
    
    updateMainForm();
}

function checkAndAutoPopModal() {
    if (bookingData.dateValue && bookingData.timeSlot && !bookingData.doctorId) {
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalOnlyDoctor'));
        modal.show();
    }
    else if (bookingData.timeSlot && bookingData.doctorId && !bookingData.dateValue) {
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDate'));
        modal.show();
    }
}

function resolveSlotIfReady() {
    if (bookingData.dateValue && bookingData.timeSlot && bookingData.doctorId) {
        let url = `/scheduleappointment/api/resolve-slot?date=${bookingData.dateValue}&timeSlot=${encodeURIComponent(bookingData.timeSlot)}&doctorId=${bookingData.doctorId}`;
        fetch(url)
            .then(res => res.json())
            .then(data => {
                if (data.slotId) {
                    bookingData.slotId = data.slotId;
                    updateMainForm();
                } else {
                    alert("Rất tiếc, bác sĩ này không có lịch rảnh vào ngày và giờ bạn đã chọn. Vui lòng chọn Bác sĩ hoặc Ngày khác!");
                    bookingData.slotId = "";
                    updateMainForm();
                }
            });
    }
}

function selectDept(id, name, priceStr) {
    if (bookingData.deptId !== id) {
        bookingData.deptId = id;
        bookingData.deptName = name;
        bookingData.price = priceStr;
        
        resetDependentFields('dept');
        applyDoctorFilter();
        
        fetch('/scheduleappointment/api/get-available-dates?deptId=' + id)
            .then(res => res.json())
            .then(dates => {
                bookingData.availableDates = dates;
                applyDoctorDateFilter();
            })
            .catch(err => console.error("Error fetching dates:", err));
    }
	
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

    const setHidden = (id, val) => {
        const el = document.getElementById(id);
        if (el) el.value = val;
    };
    setHidden("hidden-date", bookingData.dateValue);
    setHidden("hidden-dept", bookingData.deptId);
    setHidden("hidden-doc", bookingData.doctorId);
    setHidden("hidden-slot", bookingData.slotId);

    const toggleIcon = (inputId, show) => {
        const inputEl = document.getElementById(inputId);
        if (inputEl) {
            const icon = inputEl.parentElement.querySelector(".check-status-icon");
            if (icon) {
                if (show) icon.classList.remove("d-none");
                else icon.classList.add("d-none");
            }
        }
    };
    
    toggleIcon("input-display-date", bookingData.dateValue !== "");
    toggleIcon("input-display-dept", bookingData.deptId !== "");
    toggleIcon("input-display-time", bookingData.timeSlot !== "");
    toggleIcon("input-display-doctor", bookingData.doctorId !== "");

    let price = document.querySelector("#display-total-price");
    if (bookingData.price) {
        let priceFmt = parseFloat(bookingData.price);
        price.textContent = priceFmt.toLocaleString('vi-VN') + " đồng";
    } else {
        price.textContent = "0 đồng";
    }

    if (bookingData.dateValue && bookingData.deptId && bookingData.slotId) {
        document.getElementById("btn-next-step1").disabled = false;
    } else {
        document.getElementById("btn-next-step1").disabled = true;
    }
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