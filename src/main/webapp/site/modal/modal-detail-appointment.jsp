<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/site/shared/page.jsp" %>

		<c:if test="${not empty historyList}">
			<c:forEach var="item" items="${historyList}">
				<!-- Modal Bootstrap 5 -->
				<div class="modal fade" id="detailModal_${item.id}" tabindex="-1" aria-labelledby="modalLabel_${item.id}" aria-hidden="true">
					<div class="modal-dialog modal-dialog-centered modal-lg">
						<div class="modal-content border-0 shadow-lg rounded-4">
							
							<!-- Header Modal -->
							<div class="modal-header text-white border-bottom-0 rounded-top-4 pb-3">
								<h5 class="modal-title fw-bold" id="modalLabel_${item.id}">
									<i class="bi bi-file-earmark-medical me-2"></i>Chi Tiết Phiếu Khám #DHAK-${item.id}
								</h5>
								<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>

							<!-- Body Modal -->
							<div class="modal-body p-4 bg-light">
								<div class="row g-4">
									
									<!-- Cột 1: Thông tin bệnh nhân -->
									<div class="col-md-6">
										<div class="card border-0 shadow-sm h-100 rounded-3">
											<div class="card-header bg-white border-bottom py-3">
												<h6 class="mb-0 fw-bold text-secondary"><i class="bi bi-person-badge me-2"></i>Thông tin bệnh nhân</h6>
											</div>
											<div class="card-body">
												<p class="mb-2"><span class="text-muted">Họ và tên:</span> <strong class="float-end text-dark">${item.patient.user.fullName}</strong></p>
												<p class="mb-2"><span class="text-muted">Số điện thoại:</span> <strong class="float-end">${item.patient.user.phone}</strong></p>
												<p class="mb-2"><span class="text-muted">Giới tính:</span> <strong class="float-end">${item.patient.user.gender}</strong></p>
												<hr class="my-2 text-muted">
												<p class="mb-0"><span class="text-muted">Lý do khám:</span> <br> 
													<span class="fst-italic text-dark">${empty item.reason ? 'Không có ghi chú' : item.reason}</span>
												</p>
											</div>
										</div>
									</div>

									<!-- Cột 2: Thông tin dịch vụ -->
									<div class="col-md-6">
										<div class="card border-0 shadow-sm h-100 rounded-3">
											<div class="card-header bg-white border-bottom py-3">
												<h6 class="mb-0 fw-bold text-secondary"><i class="bi bi-hospital me-2"></i>Thông tin dịch vụ</h6>
											</div>
											<div class="card-body">
												<p class="mb-2"><span class="text-muted">Chuyên khoa:</span> <strong class="float-end">${item.department.name}</strong></p>
												<p class="mb-2"><span class="text-muted">Bác sĩ:</span> <strong class="float-end text-primary">${item.doctor.user.fullName}</strong></p>
												<p class="mb-2"><span class="text-muted">Ngày khám:</span> <strong class="float-end text-danger">${item.slot.workDate}</strong></p>
												<p class="mb-0"><span class="text-muted">Khung giờ:</span> <strong class="float-end text-danger">${item.slot.startTime} - ${item.slot.endTime}</strong></p>
											</div>
										</div>
									</div>

									<!-- Dòng dưới: Thông tin Thanh toán -->
									<div class="col-12">
										<div class="card border-0 shadow-sm rounded-3">
											<div class="card-body d-flex justify-content-between align-items-center">
												<div>
													<span class="text-muted d-block mb-1">Trạng thái thanh toán:</span>
													<c:choose>
														<c:when test="${item.paymentStatus == 'PAID'}">
															<span class="badge bg-success px-3 py-2 fs-6 rounded-pill"><i class="bi bi-check-circle me-1"></i> Đã thanh toán</span>
														</c:when>
														<c:otherwise>
															<span class="badge bg-warning text-dark px-3 py-2 fs-6 rounded-pill"><i class="bi bi-exclamation-circle me-1"></i> Chưa thanh toán</span>
														</c:otherwise>
													</c:choose>
												</div>
												<div class="text-end">
													<span class="text-muted d-block mb-1">Tổng tiền (Viện phí):</span>
													<h4 class="mb-0 fw-bold text-primary">
														<fmt:formatNumber value="${item.doctor.examinationFee}" type="currency" currencySymbol="VNĐ"/>
													</h4>
												</div>
											</div>
										</div>
									</div>

								</div>
							</div>

							<!-- Footer Modal -->
							<div class="modal-footer bg-white border-top-0 py-3 rounded-bottom-4 flex-wrap">
								<button type="button" class="btn btn-secondary px-4 rounded-pill" data-bs-dismiss="modal">Đóng</button>
								<c:if test="${item.status == 'PENDING'}">
									<button type="button" class="btn btn-outline-danger px-4 rounded-pill" onclick="cancelAppointment(${item.id})">Hủy lịch khám</button>
								</c:if>
								<c:if test="${(item.status == 'CONFIRMED' || item.status == 'PENDING') && (sessionScope.user.role == 'ADMIN' || sessionScope.user.role == 'DOCTOR')}">
									<button type="button" class="btn btn-success px-4 rounded-pill" onclick="completeAppointment(${item.id})">Hoàn thành</button>
								</c:if>
							</div>

						</div>
					</div>
				</div>
			</c:forEach>
			
			<script>
				function cancelAppointment(id) {
					if (confirm('Bạn có chắc chắn muốn hủy lịch khám này không?')) {
						fetch('${ctx}/appointment/cancel', {
							method: 'POST',
							headers: {
								'Content-Type': 'application/x-www-form-urlencoded',
							},
							body: 'id=' + id
						})
						.then(response => response.json())
						.then(data => {
							if (data.status === 'SUCCESS') {
								alert(data.message);
								window.location.reload();
							} else {
								alert(data.message || 'Hủy lịch thất bại');
							}
						})
						.catch(error => {
							console.error('Error:', error);
							alert('Có lỗi xảy ra khi hủy lịch.');
						});
					}
				}
				
				function completeAppointment(id) {
					if (confirm('Bạn có chắc chắn muốn hoàn thành phiếu khám này?')) {
						fetch('${ctx}/appointment/complete', {
							method: 'POST',
							headers: {
								'Content-Type': 'application/x-www-form-urlencoded',
							},
							body: 'id=' + id
						})
						.then(response => response.json())
						.then(data => {
							if (data.status === 'SUCCESS') {
								alert(data.message);
								window.location.reload();
							} else {
								alert(data.message || 'Cập nhật thất bại');
							}
						})
						.catch(error => {
							console.error('Error:', error);
							alert('Có lỗi xảy ra khi cập nhật.');
						});
					}
				}
			</script>
		</c:if>
