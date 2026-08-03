<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/site/shared/page.jsp" %>

<!-- Không cần thẻ html, head, body gì ở đây cả -->
<!-- Bắt đầu vòng lặp Danh sách Bác sĩ -->
<c:forEach var="doctor" items="${listDoctors}">
    <div class="card doctor-card border-0 shadow-sm mb-4 p-2">
        <div class="card-body">
            <!-- 1. Tên Bác sĩ -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="d-flex align-items-center text-primary-custom">
                    <div class="icon-circle me-3">
					    <c:choose>
					        
					        <c:when test="${not empty doctor.department.imageUrl}">
					            <img src="${ctx}${doctor.department.imageUrl}" 
					                 alt="${doctor.department.name}" 
					                 class="rounded-circle shadow-sm" 
					                 style="width: 40px; height: 40px; object-fit: cover; border: 2px solid #e9ecef;">
					        </c:when>
					        
					        <c:otherwise>
					            <div class="icon-circle shadow-sm" style="width: 40px; height: 40px;">
					                <i class="bi bi-stethoscope"></i>
					            </div>
					        </c:otherwise>
					    </c:choose>
					</div>
                    <span class="fw-bold fs-5">${doctor.user.fullName}</span>
                </div>
            </div>

            <!-- 2. Ngày khám -->
            <div class="d-flex align-items-center text-primary-custom mb-3">
                <span class="fw-bold me-3">Ngày: ${selectedDateStr}</span>
                <div class="flex-grow-1 dashed-line"></div>
            </div>

            <!-- 3. Danh sách Slot (Khung giờ) -->
            <div class="d-flex flex-wrap gap-2">
                <!-- Chú ý biến rỗng nếu bác sĩ không có ca làm việc ngày đó -->
                <c:if test="${empty doctor.slots}">
                    <p class="text-danger small mb-0">Bác sĩ không có lịch khám trong ngày này.</p>
                </c:if>

                <c:forEach var="slot" items="${doctor.slots}">
                    <c:choose>
                        <c:when test="${slot.status == 'FULL'}">
                            <button class="btn btn-slot slot-disabled" disabled>
                                ${slot.startTime} - ${slot.endTime}
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-slot slot-available" 
                                    onclick="selectTimeSlot('${doctor.id}', '${doctor.user.fullName}', '${slot.startTime} - ${slot.endTime}')">
                                ${slot.startTime} - ${slot.endTime}
                            </button>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </div>
    </div>
</c:forEach>