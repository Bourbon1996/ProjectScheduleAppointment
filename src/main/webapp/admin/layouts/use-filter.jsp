<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="user-filter-actions">

    <!-- Tìm kiếm tài khoản -->
    <form action="${ctx}/admin/user"
          method="get"
          class="user-search">

        <i class="bi bi-search"></i>

        <input type="text"
               name="keyword"
               placeholder="Tìm kiếm tài khoản...">
    </form>
    

	<!-- Lọc giới tính -->
    <div class="dropdown hover-dropdown gender-filter">

        <button type="button"
                class="btn-tool dropdown-toggle"
                data-bs-toggle="dropdown"
                aria-expanded="false">

            <i class="bi bi-gender-ambiguous"></i>
            Giới tính
        </button>

        <ul class="dropdown-menu">
            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user">
                    Tất cả giới tính
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user?gender=MALE">
                    Nam
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user?gender=FEMALE">
                    Nữ
                </a>
            </li>
        </ul>

    </div>
    

    <!-- Lọc vai trò -->
    <div class="dropdown hover-dropdown role-filter">

        <button type="button"
                class="btn-tool dropdown-toggle"
                data-bs-toggle="dropdown"
                aria-expanded="false">

            <i class="bi bi-person-badge"></i>
            Vai trò
        </button>

        <ul class="dropdown-menu">
            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user">
                    Tất cả vai trò
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user?role=ADMIN">
                    Quản trị viên
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user?role=DOCTOR">
                    Bác sĩ
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user?role=PATIENT">
                    Bệnh nhân
                </a>
            </li>
        </ul>

    </div>


    <!-- Lọc trạng thái -->
    <div class="dropdown hover-dropdown status-filter">

        <button type="button"
                class="btn-tool dropdown-toggle"
                data-bs-toggle="dropdown"
                aria-expanded="false">

            <i class="bi bi-funnel"></i>
            Trạng thái
        </button>

        <ul class="dropdown-menu">
            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user">
                    Tất cả trạng thái
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user?status=ACTIVE">
                    ACTIVE
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user?status=INACTIVE">
                    INACTIVE
                </a>
            </li>
        </ul>

    </div>


    <!-- Sắp xếp -->
    <div class="dropdown hover-dropdown sort-filter">

        <button type="button"
                class="btn-tool dropdown-toggle"
                data-bs-toggle="dropdown"
                aria-expanded="false">

            <i class="bi bi-arrow-down-up"></i>
            Sắp xếp
        </button>

        <ul class="dropdown-menu dropdown-menu-end">
            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user?sort=az">
                    Giảm dần
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/user?sort=za">
                    Tăng dần
                </a>
            </li>
        </ul>

    </div>

</div>