<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="department-actions">
		    <!-- Tìm kiếm chuyên khoa -->
		    <form action="${ctx}/admin/department"
			      method="get"
			      class="department-search">
			
			    <i class="bi bi-search"></i>
			
			    <input type="text"
			           name="keyword"
			           placeholder="Tìm kiếm chuyên khoa...">
			</form>
		
		   <!-- Lọc trạng thái -->
			<div class="dropdown hover-dropdown">
			
			    <button type="button"
			            class="btn-tool dropdown-toggle"
			            data-bs-toggle="dropdown"
			            aria-expanded="false">
			
			        <i class="bi bi-funnel"></i>
			        Tất cả trạng thái
			    </button>
			
			    <ul class="dropdown-menu status-menu">
			
			        <li>
			            <a class="dropdown-item"
			               href="${ctx}/admin/department">
			                Tất cả trạng thái
			            </a>
			        </li>
			
			        <li>
			            <a class="dropdown-item"
			               href="${ctx}/admin/department?status=ACTIVE">
			                ACTIVE
			            </a>
			        </li>
			
			        <li>
			            <a class="dropdown-item"
			               href="${ctx}/admin/department?status=INACTIVE">
			                INACTIVE
			            </a>
			        </li>
			
			    </ul>
			</div>
		
		   <!-- Sắp xếp -->
			<div class="dropdown hover-dropdown">
			
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

			    <!-- Thêm mới -->
			    <button type="button"
			            class="btn-add btn-add-department"
			            data-bs-toggle="modal"
			            data-bs-target="#departmentModal">
			
			        <i class="bi bi-plus-lg"></i>
			        Thêm mới
			    </button>
</div>