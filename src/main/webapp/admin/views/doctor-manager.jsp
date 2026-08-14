<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/admin/shared/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý bác sĩ</title>
<%@ include file="/admin/shared/page-admin.jsp" %>

<link rel="stylesheet" type="text/css" href="${ctx}/assets/css/admin/doctor-manager.css">

</head>
<body>
	<%@ include file="/admin/shared/header.jsp" %>
	
	<main class="doctor-manager">

    <div class="doctor-manager-header">
        <div>
            <h1>Quản lý bác sĩ</h1>
            <p>Danh sách bác sĩ trong hệ thống</p>
        </div>
        <%@ include file="/admin/layouts/doctor-filter.jsp" %>
    </div>
    
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>
    
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
            <i class="bi bi-check-circle-fill me-1"></i> ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="doctor-table-wrapper">
        <table class="doctor-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ và tên</th>
                    <th>Giới tính</th>
                    <th>Chuyên khoa</th>
                    <th>Lịch làm việc (Ngày)</th>
                    <th>Năng suất (Giờ)</th>
                    <th>Tiến độ KPI (Khám)</th>
                    <th>Thao tác</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach items="${listDoctor}" var="doctor">
                    <tr>
                        <td>${doctor.id}</td>

                        <td class="doctor-name">
                            ${doctor.user.fullName}
                        </td>

                        <td>
                            ${doctor.user.gender == 'MALE'? 'Nam': 'Nữ'}
                        </td>

                        <td>
                            ${doctor.department.name}
                        </td>
                        
                        <c:set var="stats" value="${kpiMap[doctor.id]}" />
                        <c:set var="kDays" value="${doctor.kpiDays != null ? doctor.kpiDays : 26}" />
                        <c:set var="kHours" value="${doctor.kpiHours != null ? doctor.kpiHours : 156}" />
                        <c:set var="kPats" value="${doctor.kpiPatients != null ? doctor.kpiPatients : 1500}" />
                        
                        <c:set var="workedDays" value="${stats != null ? stats['workedDays'] : 0}" />
                        <c:set var="workedHours" value="${stats != null ? stats['workedHours'] : 0}" />
                        <c:set var="workedPats" value="${stats != null ? stats['completedPatients'] : 0}" />
                        
                        <!-- Lịch làm việc (Ngày) -->
                        <td>
                            <span class="${workedDays < kDays ? 'text-danger fw-bold' : 'text-success'}">
                                ${workedDays} / ${kDays}
                            </span>
                        </td>
                        
                        <!-- Năng suất (Giờ) -->
                        <td>
                            <span class="${workedHours < kHours ? 'text-warning fw-bold' : 'text-success'}">
                                ${workedHours} / ${kHours}
                            </span>
                        </td>
                        
                        <!-- Tiến độ KPI Khám -->
                        <td style="width: 200px;">
                            <div class="d-flex justify-content-between small mb-1">
                                <span>${workedPats} / ${kPats}</span>
                                <span><fmt:formatNumber value="${workedPats * 100 / kPats}" maxFractionDigits="0"/>%</span>
                            </div>
                            <div class="progress" style="height: 6px;">
                                <c:set var="pct" value="${workedPats * 100 / kPats}" />
                                <div class="progress-bar ${pct < 50 ? 'bg-danger' : (pct < 80 ? 'bg-warning' : 'bg-success')}" 
                                     role="progressbar" 
                                     style="width: ${pct > 100 ? 100 : pct}%;"></div>
                            </div>
                        </td>

                        <td>
							<div class="action-buttons">
	                            <a href="javascript:void(0)"
                               class="btn-edit"
                               data-bs-toggle="modal" 
                               data-bs-target="#doctorModal"
                               title="Chỉnh sửa"
                               data-id="${doctor.id}"
                               data-fullname="${doctor.user.fullName}"
                               data-phone="${doctor.user.phone}"
                               data-email="${doctor.user.email}"
                               data-gender="${doctor.user.gender}"
                               data-department="${doctor.department.id}"
                               data-title="${doctor.title}"
                               data-experience="${doctor.experienceYears}"
                               data-fee="${doctor.examinationFee}"
                               data-description="${doctor.description}">
                                <i class="bi bi-pencil-square"></i>
                                Sửa
                            </a>
	
	                            <a href="${pageContext.request.contextPath}/doctor/delete?id=${doctor.id}"
	                               class="btn-delete"
	                               title="Xóa"
	                               onclick="return confirm('Bạn có chắc muốn xóa bác sĩ này không?');">
	                                <i class="bi bi-trash"></i>
	                                Xóa
	                            </a>
							
							</div>

                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</main>

	<%@ include file="/admin/modal/modal-form-doctor.jsp" %>
	
	 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	 <script>
        document.addEventListener("DOMContentLoaded", function() {
            const doctorForm = document.getElementById('doctorForm');
            const modalTitle = document.getElementById('doctorModalLabel');
            
            // Add Doctor
            document.querySelectorAll('.btn-add-doctor').forEach(btn => {
                btn.addEventListener('click', function() {
                    doctorForm.reset();
                    doctorForm.action = "${ctx}/doctor/create";
                    modalTitle.textContent = "Thêm mới bác sĩ";
                    document.getElementById('doctorId').value = "";
                    document.getElementById('passwordHint').textContent = "(Bắt buộc)";
                    document.getElementById('userPassword').required = true;
                });
            });

            // Edit Doctor
            document.querySelectorAll('.btn-edit').forEach(btn => {
                btn.addEventListener('click', function() {
                    doctorForm.reset();
                    doctorForm.action = "${ctx}/doctor/update";
                    modalTitle.textContent = "Cập nhật thông tin bác sĩ";
                    document.getElementById('passwordHint').textContent = "(Bỏ trống nếu không đổi)";
                    document.getElementById('userPassword').required = false;

                    // Populate fields
                    document.getElementById('doctorId').value = this.getAttribute('data-id');
                    document.getElementById('userFullName').value = this.getAttribute('data-fullname');
                    document.getElementById('userPhone').value = this.getAttribute('data-phone');
                    document.getElementById('userEmail').value = this.getAttribute('data-email');
                    document.getElementById('userGender').value = this.getAttribute('data-gender');
                    document.getElementById('doctorDepartment').value = this.getAttribute('data-department');
                    document.getElementById('doctorTitle').value = this.getAttribute('data-title');
                    document.getElementById('doctorExperience').value = this.getAttribute('data-experience');
                    document.getElementById('doctorFee').value = this.getAttribute('data-fee');
                    document.getElementById('doctorDescription').value = this.getAttribute('data-description');
                });
            });
        });
     </script>
</body>
</html>

   