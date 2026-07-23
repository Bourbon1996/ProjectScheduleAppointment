<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/shared/home/page.jsp" %>

<nav class="navbar navbar-expand-sm hospital-navbar p-0">

    <div class="container-fluid pe-0">

        <ul class="navbar-nav w-100 align-items-stretch">

            <li class="nav-item">
                <a class="nav-link" href="#">
                    <img
                        src="${pageContext.request.contextPath}/img/logo.png"
                        alt="Logo"
                        class="nav-logo">
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="#">Home</a>
            </li>

            
            <!-- Chuyên Khoa (Pure CSS Mega Menu - Chỉ Hover, không cần Click) -->
            <li class="nav-item mega-dropdown">
                <a class="nav-link d-flex align-items-center" 
                   href="#" 
                   id="navbarDropdownCK">
                    Chuyên khoa <i class="bi bi-chevron-down ms-1" style="font-size: 0.75rem;"></i>
                </a>
                
                <!-- CONTAINER MEGA MENU CỐ ĐỊNH -->
                <div class="dropdown-menu mega-menu-container shadow-lg border-0" aria-labelledby="navbarDropdownCK">
                    <div class="mega-menu-content d-flex">
                        
                        
                        <div class="parent-column">
                            <ul class="parent-list list-unstyled mb-0">
                                <c:forEach items="${listDepartmentsParent}" var="parent" varStatus="loop">
                                    
                                    <li class="parent-item">
                                        <a class="parent-link d-flex justify-content-between align-items-center" 
                                           href="${pageContext.request.contextPath}/chuyen-khoa/${parent.id}">
                                            <span>${parent.name}</span>
                                            <c:if test="${not empty parent.subDepartments}">
                                                <i class="bi bi-chevron-right small"></i>
                                            </c:if>
                                        </a>
                                        
                                        
                                        <c:if test="${not empty parent.subDepartments}">
                                            <div class="child-column shadow-sm">
                                                <div class="child-scroll-box">
                                                    <ul class="child-list list-unstyled mb-0">
                                                        <c:forEach items="${parent.subDepartments}" var="child">
                                                            <li>
                                                                <a class="child-link" href="${pageContext.request.contextPath}/chuyen-khoa/${child.id}">
                                                                    ${child.name}
                                                                </a>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                    </li>

                                </c:forEach>
                            </ul>
                        </div>
                        
                        <!-- Cột phải mặc định -->
                        <div class="child-column-placeholder">
                            <div class="text-muted small p-4">Di chuột vào khoa bên trái để xem danh sách chi tiết</div>
                        </div>

                    </div>
                </div>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="#">Bác sĩ</a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="#">Về bệnh viện</a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="#">Hỗ trợ người bệnh</a>
            </li>

            <li class="nav-item ms-auto">
                <a class="nav-link appointment-link" href="#">
                    Đặt lịch khám
                </a>
            </li>

            <!-- Tài khoản -->
            <li class="nav-item">
                <a href=""
				   class="navbar-icon account-icon"
				   id="openLoginPopup"
				   title="Đăng nhập">
				
				    <i class="bi bi-person"></i>
				</a>
            </li>

            <!-- Tìm kiếm -->
            <li class="nav-item">
                <a class="navbar-icon search-icon"
                   href="${pageContext.request.contextPath}/search"
                   title="Tìm kiếm">

                    <i class="bi bi-search"></i>
                </a>
            </li>

        </ul>
    </div>
</nav>