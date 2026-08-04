<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/admin/shared/page.jsp" %>
<nav class="navbar navbar-expand-lg admin-navbar">
    <div class="container-fluid">
      <a class="navbar-brand admin-logo"
         href="${pageContext.request.contextPath}/admin/dashboard">
        <img
          src="${pageContext.request.contextPath}/assets/img/logo.png"
          alt="Logo">
        <span>Hospital Admin</span>
       </a>
       
       <ul class="navbar-nav admin-menu">

    <li class="nav-item">
        <a class="nav-link"
           href="${pageContext.request.contextPath}/admin/dashboard">
            Dashboard
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link"
           href="${pageContext.request.contextPath}/admin/department">
            Quản lý Chuyên Khoa
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link"
           href="${pageContext.request.contextPath}/admin/doctor">
            Quản lý Bác Sĩ
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link"
           href="${pageContext.request.contextPath}/admin/user">
            Quản lý Tài Khoản
        </a>
    </li>

     </ul>
     
     <c:choose>
     	<c:when test="${empty sessionScope.user}">
     		<div class="admin-user ms-auto">
		        <a href="#" 
			        class="admin-avatar"
			        data-bs-toggle="dropdown"
			        aria-expanded="false"
			        title="Tài khoản">
			        
			        <i class="bi bi-person"></i>
		        </a>
		     </div>
     	</c:when>
     	
     	<c:otherwise>
     		<div class="admin-user ms-auto dropdown">
		        <a href="#" 
			        class="admin-avatar"
			        data-bs-toggle="dropdown"
			        aria-expanded="false"
			        title="Tài khoản">
			        
			        <i class="bi bi-person-check-fill"></i>
		        </a>
		        
		        <ul class="dropdown-menu dropdown-menu-end admin-account-menu">
			         <li>
			            <a class="dropdown-item" href="${ctx}/account/edit-profile">
			                <i class="bi bi-person-circle me-2"></i>
			                Tài khoản
			            </a>
			        </li>
			
			        <li>
			            <a class="dropdown-item" href="${ctx}/account/change-password">
			                <i class="bi bi-key me-2"></i>
			                Đổi mật khẩu
			            </a>
			        </li>
			        
			        <li>
			            <a class="dropdown-item text-danger" href="${ctx}/auth/logout">
			                <i class="bi bi-box-arrow-right me-2"></i>
			                Đăng xuất
			            </a>
			        </li>
		        
		        </ul>
		     </div>
     	</c:otherwise>
     
     </c:choose>
     

     
        
        
     
     
    </div>


</nav>
