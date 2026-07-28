<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ include file="/shared/home/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý chuyên khoa</title>
<%@ include file="/shared/admin/page-admin.jsp" %>

<link rel="stylesheet" type="text/css" href="${ctx}/css/admin/department-manager.css">
</head>
<body>
	<%@ include file="/shared/admin/header.jsp" %>	
	<main class="department-manager">

    <div class="department-manager-header">
        <div>
            <h1>Quản lý chuyên khoa</h1>
            <p>Danh sách chuyên khoa trong hệ thống</p>
        </div>

        <button class="btn-add"
	        	 data-bs-toggle="modal" 
	        	 data-bs-target="#departmentModal">
	         	 <i class="bi bi-plus-lg"></i>
	           	 Thêm mới
	      </button>
    </div>

    <div class="department-table-wrapper">

        <table class="department-table">

            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên chuyên khoa</th>
                    <th>Mô tả</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>

            <tbody>

                <c:forEach items="${listDepartmentsChild}" var="department">

                    <tr>

                        <td>${department.id}</td>

                        <td class="department-name">
                            ${department.name}
                        </td>

                        <td class="department-description">
                            ${department.description}
                        </td>

                        <td>
                            <span class="status-badge">
                                ${department.status}
                            </span>
                        </td>

                        <td>
                            <div class="action-buttons">

                                <a href="${pageContext.request.contextPath}/admin/department/edit?id=${department.id}"
                                   class="btn-edit"
                                   data-bs-toggle="modal" 
						           data-bs-target="#departmentModal"
                                   title="Chỉnh sửa">
                                    <i class="bi bi-pencil-square"></i>
                                    Sửa
                                </a>
                                
                                

                                <a href="${pageContext.request.contextPath}/admin/department/delete?id=${department.id}"
                                   class="btn-delete"
                                   title="Xóa"
                                   onclick="return confirm('Bạn có chắc muốn xóa chuyên khoa này không?');">

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
	<%@ include file="/modal/admin/modal-form-department.jsp" %>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

    