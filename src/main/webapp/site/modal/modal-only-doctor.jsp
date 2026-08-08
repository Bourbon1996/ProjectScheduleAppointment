<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/site/shared/page.jsp" %>

<div class="modal fade" id="modalOnlyDoctor" tabindex="-1" aria-labelledby="modalOnlyDoctorLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
        <div class="modal-content shadow-lg">
            
            <div class="modal-header border-bottom-0 pt-4 pb-2 position-relative">
                <h5 class="modal-title text-center w-100 text-uppercase" id="modalOnlyDoctorLabel">Chọn Bác Sĩ</h5>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body px-4 pb-4 pt-2">
                <div class="mb-3">
                    <input type="text" class="form-control rounded-pill" id="searchOnlyDoctorInput" placeholder="Tìm kiếm tên bác sĩ..." onkeyup="filterOnlyDoctors()">
                </div>
                <div class="row g-3" id="only-doctor-list">
                    <c:forEach var="doc" items="${listDoctor}">
                        <div class="col-md-6 only-doc-item-filter" data-dept-id="${doc.department.id}">
                            <div class="card h-100 border rounded-3 p-3 text-start" style="cursor: pointer;" 
                                 onclick="selectOnlyDoctor('${doc.id}', '${doc.user.fullName}', '${doc.department.id}', '${doc.department.name}', '${doc.examinationFee}')">
                                <div class="d-flex align-items-center">
                                    <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px; font-size: 20px;">
                                        <i class="bi bi-person-fill"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-1 fw-bold text-dark doc-name-filter">${doc.user.fullName}</h6>
                                        <small class="text-muted d-block">${doc.department.name}</small>
                                        <small class="text-danger fw-bold"><fmt:formatNumber value="${doc.examinationFee}" type="currency" currencySymbol="VNĐ"/></small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function filterOnlyDoctors() {
    const keyword = document.getElementById("searchOnlyDoctorInput").value.toLowerCase();
    const cards = document.querySelectorAll(".only-doc-item-filter");
    
    // bookingData is global from appointment-flow.js
    let currentDept = null;
    if (typeof bookingData !== 'undefined' && bookingData.deptId) {
        currentDept = bookingData.deptId;
    }
    
    cards.forEach(card => {
        const docName = card.querySelector(".doc-name-filter").textContent.toLowerCase();
        const cardDeptId = card.getAttribute("data-dept-id");
        
        let matchSearch = docName.includes(keyword);
        let matchDept = currentDept ? (cardDeptId === currentDept) : true;
        
        if (matchSearch && matchDept) {
            card.style.setProperty("display", "block", "important");
        } else {
            card.style.setProperty("display", "none", "important");
        }
    });
}
</script>
