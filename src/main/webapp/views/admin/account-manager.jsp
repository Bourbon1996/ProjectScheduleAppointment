<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/shared/home/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý tài khoản</title>
<%@ include file="/shared/admin/page-admin.jsp" %>

<link rel="stylesheet" type="text/css" href="${ctx}/css/admin/account-manager.css">
</head>
<body>
<%@ include file="/shared/admin/header.jsp" %>	
	<main class="account-manager">

    <div class="account-manager-header">
        <div>
            <h1>Quản lý tài khoản</h1>
            <p>Danh sách tài khoản trong hệ thống</p>
        </div>

	     <button class="btn-add"
	        	 data-bs-toggle="modal" 
	        	 data-bs-target="#userModal">
	         	 <i class="bi bi-plus-lg"></i>
	           	 Thêm mới
	      </button>
    </div>

    <div class="account-table-wrapper">

        <table class="account-table">

            <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ và tên</th>
                    <th>Giới tính</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Mật khẩu</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th>Thao tác</th>
                </tr>
            </thead>

            <tbody>

                <c:forEach items="${listAccount}" var="account">

                    <tr>

                        <td>${account.id}</td>

                        <td class="account-name">
                            ${account.fullName}
                        </td>

                        <td>${account.gender}</td>

                        <td>${account.email}</td>

                        <td>${account.phone}</td>

                        <td class="account-password">
                            ${account.passwordHash}
                        </td>

                        <td>
                            <span class="role-badge">
                                ${account.role}
                            </span>
                        </td>

                        <td>
                            <span class="status-badge">
                                ${account.status}
                            </span>
                        </td>

                        <td>${account.createdAt}</td>

                        <td>
                            <div class="action-buttons">

                                <a href="${pageContext.request.contextPath}/admin/account/edit?id=${account.id}"
                                   class="btn-edit"
                                   data-bs-toggle="modal" 
	        	 				   data-bs-target="#userModal"
                                   >
                                  <i class="bi bi-pencil-square"></i>
                                      Sửa
                                </a>

                                <a href="${pageContext.request.contextPath}/admin/account/delete?id=${account.id}"
                                    class="btn-delete"
                                      onclick="return confirm('Bạn có chắc muốn xóa tài khoản này không?');">
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
    
    <%@ include file="/modal/admin/modal-form-user.jsp" %>
    

</main>
</body>
</html>