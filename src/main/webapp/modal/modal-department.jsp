<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/shared/home/page.jsp" %>
<link rel="stylesheet" type="text/css" href="${ctx}/css/client/modal-department.css">

<div class="modal fade" id="modalDept" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">

            <div class="umc-dept-header d-flex justify-content-between align-items-center">
                <h5 class="umc-dept-title mb-0">CHỌN CHUYÊN KHOA</h5>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body p-4 pt-3">

                <div class="input-group mb-4 umc-search-box">
                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                    <input type="text" class="form-control" id="searchDeptInput" 
                           placeholder="Tìm nhanh chuyên khoa..." onkeyup="filterDepartments()">
                </div>

                <!-- Danh sách chuyên khoa -->
                <div class="department-list" id="deptListContainer">
                    
                    
                    <c:forEach var="dept" items="${listDepartmentsChild}">
                        <div class="umc-dept-card dept-item-filter" 
                             onclick="selectDept('${dept.id}', '${dept.name}', '${dept.basePrice} đồng')">
                            
                            <div class="umc-dept-left">
                                
                                <div class="umc-dept-icon">
                                    <i class="bi bi-info-circle-fill"></i>
                                </div>
                                
                                <h6 class="umc-dept-name">${dept.name}</h6>
                            </div>

                            
                            <div class="umc-dept-price">
                                <fmt:formatNumber value="${dept.basePrice}" pattern="#,###"/> đồng
                            </div>

                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Footer gọn gàng nút quay lại -->
            <div class="modal-footer bg-light py-2">
                <button type="button" class="btn btn-outline-secondary btn-sm px-3" onclick="backToDateModal()">
                    <i class="bi bi-arrow-left me-1"></i> Chọn lại ngày
                </button>
            </div>

        </div>
    </div>
</div>