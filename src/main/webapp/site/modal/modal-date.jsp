<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/site/shared/page.jsp" %>
<link rel="stylesheet" type="text/css" href="${ctx}/assets/css/client/modal-date.css">

<div class="modal fade" id="modalDate" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
           
            <div class="umc-modal-header d-flex justify-content-between align-items-center">
                <h5 class="umc-modal-title-center mb-0">CHỌN NGÀY KHÁM</h5>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body p-4 pt-2">
                
                
                <c:forEach var="m" items="${fourMonthsList}">
                    
                    <div class="month-slice ${m.monthIndex == 0 ? '' : 'd-none'}" id="month-slice-${m.monthIndex}">
                        
                       
                        <div class="d-flex justify-content-between align-items-center mb-4 mt-2 px-2">
                            <button type="button" class="umc-nav-btn" onclick="switchMonth(-1)" ${m.monthIndex == 0 ? 'disabled' : ''}>
                                <i class="bi bi-chevron-left"></i>
                            </button>
                            
                            <h6 class="fw-bold mb-0 fs-5 text-dark">${m.monthLabel}</h6>
                            
                            <button type="button" class="umc-nav-btn" onclick="switchMonth(1)" ${m.monthIndex == 3 ? 'disabled' : ''}>
                                <i class="bi bi-chevron-right"></i>
                            </button>
                        </div>

                       
                        <div class="umc-calendar-grid">
                            
                            <!-- Tiêu đề thứ -->
                            <div class="umc-weekday-label">CN</div>
                            <div class="umc-weekday-label">T2</div>
                            <div class="umc-weekday-label">T3</div>
                            <div class="umc-weekday-label">T4</div>
                            <div class="umc-weekday-label">T5</div>
                            <div class="umc-weekday-label">T6</div>
                            <div class="umc-weekday-label">T7</div>

                            <c:forEach var="day" items="${m.days}">
                                <div>
                                    <!-- Ô trống đầu tháng -->
                                    <c:if test="${day.dayNumber == 0}">
                                        <div style="height: 56px;"></div>
                                    </c:if>

                                   
                                    <c:if test="${day.dayNumber > 0}">
                                        
                                       
                                        <c:if test="${day.available}">
                                            <button type="button" class="umc-day-btn available" 
                                                    onclick="selectDate('${day.dateString}', '${day.displayStr}')">
                                                <span class="day-num">${day.dayNumber}</span>
                                               
                                                <c:if test="${day.today}">
                                                    <span class="day-sub text-warning fw-bold">Hôm nay</span>
                                                </c:if>
                                            </button>
                                        </c:if>

                                      
										<c:if test="${!day.available}">
										   
										    <button type="button" class="umc-day-btn disabled ${day.holiday ? 'is-holiday' : ''}" disabled>
										        <span class="day-num">${day.dayNumber}</span>
										        
										       
										        <c:if test="${day.holiday}">
										            <span class="day-sub holiday-text">Nghỉ lễ</span>
										        </c:if>
										
										        <!-- TRƯỜNG HỢP B: Nếu là CHỦ NHẬT (và không phải lễ) -> Hiện chữ "Ngày nghỉ" -->
										        <c:if test="${day.dayOff && !day.holiday}">
										            <span class="day-sub">Ngày nghỉ</span>
										        </c:if>
										
										        <!-- TRƯỜNG HỢP C: Nếu là NGÀY LÀM VIỆC ĐÃ QUA -> Không render thẻ span nào (Để trống hoàn toàn!) -->
										    </button>
										</c:if>

                                    </c:if>
                                </div>
                            </c:forEach>

                        </div> <!-- Hết lưới lịch -->

                    </div>
                </c:forEach>

                
                <div class="umc-instruction-banner">
                    Vui lòng bấm chọn ngày có <strong style="color: #0066cc;">màu xanh dương</strong> để xem đặt khám
                </div>

                
                <div class="mt-3 ps-2">
                    <div class="umc-legend-item">
                        <div class="umc-legend-box" style="background-color: #0066cc;"></div>
                        <span>Ngày có thể chọn</span>
                    </div>
                    <div class="umc-legend-item">
                        <div class="umc-legend-box" style="background-color: #e9ecef;"></div>
                        <span>Ngày ngoài vùng đăng ký khám</span>
                    </div>
                    <div class="umc-legend-item mb-0">
                        <div class="umc-legend-box" style="background-color: #f0f2f5; border: 1px solid #fd7e14;"></div>
                        <span>Ngày nghỉ, lễ, tết</span>
                    </div>
                </div>

            </div> <!-- Hết modal-body -->

        </div>
    </div>
</div>