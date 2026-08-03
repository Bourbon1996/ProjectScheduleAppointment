<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="doctor-actions">
  <!-- Tìm kiếm bác sĩ -->
    <form action="${ctx}/admin/doctor"
          method="get"
          class="doctor-search">

        <i class="bi bi-search"></i>

        <input type="text"
               name="keyword"
               placeholder="Tìm kiếm bác sĩ...">
    </form>

    <!-- Lọc giới tính -->
    <div class="dropdown">

        <button type="button"
                class="doctor-filter-button dropdown-toggle"
                data-bs-toggle="dropdown"
                aria-expanded="false">

            Giới tính
        </button>

        <ul class="dropdown-menu dropdown-menu-end doctor-filter-menu">
            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/doctor">
                    Tất cả giới tính
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/doctor?gender=MALE">
                    MALE
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/doctor?gender=FEMALE">
                    FEMALE
                </a>
            </li>
        </ul>
    </div>

    <!-- Lọc chuyên khoa -->
    <div class="dropdown">

        <button type="button"
                class="doctor-filter-button dropdown-toggle"
                data-bs-toggle="dropdown"
                aria-expanded="false">

            Chuyên khoa
        </button>

        <ul class="dropdown-menu dropdown-menu-end doctor-filter-menu department-menu">

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/doctor">
                    Tất cả chuyên khoa
                </a>
            </li>

            <c:forEach items="${listDepartmentsChild}" var="department">
                <li>
                    <a class="dropdown-item"
                       href="${ctx}/admin/doctor?departmentId=${department.id}">
                        ${department.name}
                    </a>
                </li>
            </c:forEach>

        </ul>
    </div>

    <!-- Sắp xếp kinh nghiệm -->
    <div class="dropdown">

        <button type="button"
                class="doctor-filter-button dropdown-toggle"
                data-bs-toggle="dropdown"
                aria-expanded="false">

            <i class="bi bi-arrow-down-up"></i>
            Kinh nghiệm
        </button>

        <ul class="dropdown-menu dropdown-menu-end doctor-filter-menu">
            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/doctor?experienceSort=asc">
                    Tăng dần
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/doctor?experienceSort=desc">
                    Giảm dần
                </a>
            </li>
        </ul>
    </div>

    <!-- Sắp xếp tiền khám -->
    <div class="dropdown">

        <button type="button"
                class="doctor-filter-button dropdown-toggle"
                data-bs-toggle="dropdown"
                aria-expanded="false">

            <i class="bi bi-arrow-down-up"></i>
            Tiền khám
        </button>

        <ul class="dropdown-menu dropdown-menu-end doctor-filter-menu">
            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/doctor?feeSort=asc">
                    Tăng dần
                </a>
            </li>

            <li>
                <a class="dropdown-item"
                   href="${ctx}/admin/doctor?feeSort=desc">
                    Giảm dần
                </a>
            </li>
        </ul>
    </div>

    <!-- Thêm mới -->
    <button type="button"
            class="btn-add btn-add-doctor"
            data-bs-toggle="modal"
            data-bs-target="#doctorModal">

        <i class="bi bi-plus-lg"></i>
        Thêm mới
    </button>
</div>
