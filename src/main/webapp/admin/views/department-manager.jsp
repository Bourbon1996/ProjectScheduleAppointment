<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ include file="/admin/shared/page.jsp" %>
     <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
     <%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
        
        <div class="department-actions">
        <!-- Nút sắp xếp -->
        <div class="dropdown">
            <button type="button"
                    class="btn-tool dropdown-toggle"
                    data-bs-toggle="dropdown"
                    aria-expanded="false">

                <i class="bi bi-arrow-down-up"></i>
                Sắp xếp
            </button>

            <ul class="dropdown-menu dropdown-menu-end sort-menu">
                <li>
                    <a class="dropdown-item"
                       href="${ctx}/admin/department?sort=az">

                        Tên chuyên khoa A → Z
                    </a>
                </li>

                <li>
                    <a class="dropdown-item"
                       href="${ctx}/admin/department?sort=za">

                        Tên chuyên khoa Z → A
                    </a>
                </li>
            </ul>
        </div>

        <!-- Nút bộ lọc -->
        <div class="dropdown">
            <button type="button"
                    class="btn-tool dropdown-toggle"
                    data-bs-toggle="dropdown"
                    data-bs-auto-close="outside"
                    aria-expanded="false">

                <i class="bi bi-sliders"></i>
                Bộ lọc
            </button>

            <div class="dropdown-menu dropdown-menu-end filter-menu">

              <form action="${ctx}/admin/department"
                    method="get"
                    class="filter-form">

				    <div class="filter-header">
				        <h5>Bộ lọc chuyên khoa</h5>
				    </div>

					    <!-- Lọc theo ID -->
					    <div class="filter-group">
					        <label for="departmentId">
					            ID chuyên khoa
					        </label>
					
					        <select id="departmentId"
					                name="departmentId"
					                class="form-select">
					
					            <option value="">
					                Tất cả ID
					            </option>
					
					            <c:forEach items="${filterDepartments}" var="department">
					                <option value="${department.id}"
					                    ${param.departmentId == department.id.toString()
					                        ? 'selected' : ''}>
					
					                    ID ${department.id}
					                </option>
					            </c:forEach>
					        </select>
					    </div>
					
					    <!-- Lọc theo tên -->
					    <div class="filter-group">
					        <label for="departmentName">
					            Tên chuyên khoa
					        </label>
					
					        <select id="departmentName"
					                name="departmentName"
					                class="form-select">
					
					            <option value="">
					                Tất cả chuyên khoa
					            </option>
					
					            <c:forEach items="${filterDepartments}" var="department">
					                <option value="${department.name}"
					                    ${param.departmentName == department.name
					                        ? 'selected' : ''}>
					
					                    ${department.name}
					                </option>
					            </c:forEach>
					        </select>
					    </div>
					
					    <!-- Lọc theo trạng thái -->
					    <div class="filter-group">
					        <label for="status">
					            Trạng thái
					        </label>
					
					        <select id="status"
					                name="status"
					                class="form-select">
					
					            <option value="">
					                Tất cả trạng thái
					            </option>
					
					            <option value="ACTIVE"
					                ${param.status == 'ACTIVE' ? 'selected' : ''}>
					
					                ACTIVE
					            </option>
					
					            <option value="INACTIVE"
					                ${param.status == 'INACTIVE' ? 'selected' : ''}>
					
					            </option>
					        </select>
					    </div>
					
					    <!-- Giữ lại lựa chọn sắp xếp -->
					    <input type="hidden"
					           name="sort"
					           value="${param.sort}">
					
					    <div class="filter-footer">
					        <a href="${ctx}/admin/department"
					           class="btn-reset-filter">
					
					            Đặt lại
					        </a>
					
					        <button type="submit"
					                class="btn-apply-filter">
					
					            Áp dụng
					        </button>
					    </div>
					</form>

            </div>
        </div>

         <button  type = "button"
        		 class="btn-add btn-add-department"
	        	 data-bs-toggle="modal" 
	        	 data-bs-target="#departmentModal">
	         	 <i class="bi bi-plus-lg"></i>
	           	 Thêm mới
	     </button>
	     
	    </div>
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
								                                
                                

                                <a href="${pageContext.request.contextPath}/department/delete?id=${department.id}"
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

    