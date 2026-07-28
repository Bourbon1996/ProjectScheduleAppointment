<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/shared/home/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý bác sĩ</title>
<%@ include file="/shared/admin/page-admin.jsp" %>

<link rel="stylesheet" type="text/css" href="${ctx}/css/admin/doctor-manager.css">

</head>
<body>
	<%@ include file="/shared/admin/header.jsp" %>
	
	<main class="doctor-manager">

    <div class="doctor-manager-header">
        <div>
            <h1>Quản lý bác sĩ</h1>
            <p>Danh sách bác sĩ trong hệ thống</p>
        </div>

        <button class="btn-add"
	        	 data-bs-toggle="modal" 
	        	 data-bs-target="#doctorModal">
	         	 <i class="bi bi-plus-lg"></i>
	           	 Thêm mới
	      </button>
    </div>

    <div class="doctor-table-wrapper">
        <table class="doctor-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ và tên</th>
                    <th>Giới tính</th>
                    <th>Email</th>
                    <th>Chuyên khoa</th>
                    <th>Bằng cấp</th>
                    <th>Kinh nghiệm</th>
                    <th>Tiền khám</th>
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

                        <td>${doctor.user.gender}</td>

                        <td>${doctor.user.email}</td>

                        <td>
                            ${doctor.department.name}
                        </td>

                        <td>${doctor.title}</td>

                        <td>
                            ${doctor.experienceYears} năm
                        </td>

                        <td>
                            ${doctor.examinationFee}
                        </td>

                        <td>
							<div class="action-buttons">
	                            <a href="${pageContext.request.contextPath}/admin/doctor/edit?id=${doctor.id}"
	                               class="btn-edit"
	                               data-bs-toggle="modal" 
		        	 			   data-bs-target="#doctorModal"
	                               title="Chỉnh sửa">
	                                <i class="bi bi-pencil-square"></i>
	                                Sửa
	                            </a>
	
	                            <a href="${pageContext.request.contextPath}/admin/doctor/delete?id=${doctor.id}"
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

	<%@ include file="/modal/admin/modal-form-doctor.jsp" %>
	
	 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

   