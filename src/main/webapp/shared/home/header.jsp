<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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

            <li class="nav-item">
                <a class="nav-link" href="#">Chuyên Khoa</a>
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