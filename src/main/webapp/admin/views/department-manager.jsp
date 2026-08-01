<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ include file="/admin/shared/page.jsp" %>
     <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý chuyên khoa</title>
<%@ include file="/admin/shared/page-admin.jsp" %>

<link rel="stylesheet" type="text/css" href="${ctx}/assets/css/admin/department-manager.css">
</head>
<body>
	<%@ include file="/admin/shared/header.jsp" %>	
	<main class="department-manager">

    <div class="department-manager-header">
        <div>
            <h1>Quản lý chuyên khoa</h1>
            <p>Danh sách chuyên khoa trong hệ thống</p>
        </div>

        <button  type = "button"
        		 class="btn-add btn-add-department"
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

                                <button type="button"
								        class="btn-edit btn-edit-department"
								        data-bs-toggle="modal"
								        data-bs-target="#departmentModal"
								
								        data-id="${department.id}"
								        data-name="${fn:escapeXml(department.name)}"
								        data-description="${fn:escapeXml(department.description)}"
								        data-status="${department.status}"
								        data-base-price="${department.basePrice}"
								        data-parent-id="${department.parent != null
								                            ? department.parent.id
								                            : ''}"
								        data-image-url="${fn:escapeXml(department.imageUrl)}">
								
								    <i class="bi bi-pencil-square"></i>
								    Sửa
								</button>
								                                
                                

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
	<%@ include file="/admin/modal/modal-form-department.jsp" %>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

    