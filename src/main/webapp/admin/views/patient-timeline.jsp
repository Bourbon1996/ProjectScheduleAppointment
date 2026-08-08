<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/admin/shared/page.jsp" %>

<c:choose>
    <c:when test="${not empty history}">
        <div class="timeline-wrapper" style="position: relative; padding-left: 30px; border-left: 2px solid #e9ecef; margin-top: 20px;">
            <c:forEach var="apt" items="${history}">
                <div class="timeline-item mb-4 position-relative">
                    <!-- Timeline Dot -->
                    <div class="position-absolute" style="left: -37px; top: 0;">
                        <div class="rounded-circle d-flex align-items-center justify-content-center
                            ${apt.status == 'COMPLETED' ? 'bg-success' : (apt.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning')}
                            text-white" style="width: 32px; height: 32px; border: 4px solid #fff; box-shadow: 0 0 0 2px #e9ecef;">
                            <i class="bi ${apt.status == 'COMPLETED' ? 'bi-check-lg' : (apt.status == 'CANCELLED' ? 'bi-x-lg' : 'bi-hourglass')}"></i>
                        </div>
                    </div>
                    
                    <!-- Content -->
                    <div class="card shadow-sm border-0">
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <h6 class="fw-bold mb-0 text-primary">
                                    <i class="bi bi-calendar-event me-1"></i>
                                    <c:choose>
                                        <c:when test="${apt.slot != null}">
                                            ${apt.slot.workDate} (${apt.slot.startTime})
                                        </c:when>
                                        <c:otherwise>Không có lịch</c:otherwise>
                                    </c:choose>
                                </h6>
                                <span class="badge ${apt.status == 'COMPLETED' ? 'bg-success-subtle text-success' : (apt.status == 'CANCELLED' ? 'bg-danger-subtle text-danger' : 'bg-warning-subtle text-warning')}">
                                    ${apt.status}
                                </span>
                            </div>
                            
                            <div class="mb-2">
                                <strong>Bác sĩ:</strong> BS. ${apt.doctor.user.fullName} <span class="text-muted">(${apt.department.name})</span>
                            </div>
                            
                            <div class="p-3 bg-light rounded text-dark">
                                <strong>Lý do khám:</strong><br>
                                ${apt.reason != null ? apt.reason : 'Không có thông tin'}
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="text-center text-muted p-5">
            <i class="bi bi-inbox fs-1"></i>
            <p class="mt-2">Bệnh nhân này chưa có lịch sử khám.</p>
        </div>
    </c:otherwise>
</c:choose>
