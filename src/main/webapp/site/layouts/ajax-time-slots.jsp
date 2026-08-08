<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/site/shared/page.jsp" %>

<div class="card border-0 shadow-sm mb-4 p-2">
    <div class="card-body">
        <h6 class="fw-bold mb-3 text-primary-custom">CHỌN KHUNG GIỜ (CHƯA CHỌN NGÀY)</h6>
        <p class="text-muted small mb-3">Vui lòng chọn một khung giờ. Hệ thống sẽ tự động lọc ra các ngày có bác sĩ làm việc trong khung giờ này.</p>
        
        <div class="d-flex flex-wrap gap-2">
            <c:if test="${empty timeSlots}">
                <p class="text-danger small mb-0">Không tìm thấy khung giờ nào khả dụng.</p>
            </c:if>

            <c:forEach var="timeStr" items="${timeSlots}">
                <button class="btn btn-slot slot-available" 
                        onclick="selectGenericTimeSlot('${timeStr}')">
                    ${timeStr}
                </button>
            </c:forEach>
        </div>
    </div>
</div>
