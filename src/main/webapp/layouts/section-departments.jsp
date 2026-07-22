<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/shared/home/page.jsp" %>
    
<div class="container mt-4">
    <h1 class="title mb-4 text-center">Chuyên Khoa</h1>
    
    <ul class="nav nav-tabs fw-bold d-flex align-items-center justify-content-center" id="myTab" role="tablist">
        <c:forEach items="${listDepartmentsParent}" var="khoaCha" varStatus="status">
            <li class="nav-item" role="presentation">
                
                <button class="nav-link ${status.first ? 'active' : ''} text-dark" 
                        id="tab-${khoaCha.id}" 
                        data-bs-toggle="tab" 
                        data-bs-target="#pane-${khoaCha.id}" 
                        type="button" role="tab">
                    ${khoaCha.name}
                </button>
            </li>
        </c:forEach>
    </ul>

    <div class="tab-content mt-4" id="myTabContent">
        <c:forEach items="${listDepartmentsParent}" var="khoaCha" varStatus="status">
            
            <div class="tab-pane fade ${status.first ? 'show active' : ''}" 
                 id="pane-${khoaCha.id}" 
                 role="tabpanel">

                <div class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-4">
                    
                    <c:forEach items="${khoaCha.subDepartments}" var="khoaCon">
                        <div class="col">
						    
						    <a href="<c:url value='/department/detail?id=${khoaCon.id}'/>" class="text-decoration-none">

						        <div class="card h-100 shadow-sm border-0 umc-card d-flex flex-column align-items-center justify-content-center">
						            
						            <div class="card-icon mx-auto mb-3" 
						                 style="-webkit-mask-image: url('${pageContext.request.contextPath}${khoaCon.imageUrl}'); mask-image: url('${pageContext.request.contextPath}${khoaCon.imageUrl}');">
						            </div>
						                 
						            <!-- Tiêu đề Khoa -->
						            <div class="card-body p-0 d-flex flex-column align-items-center w-100">
						                <h6 class="card-title fw-bold text-center m-0">
						                    ${khoaCon.name}
						                </h6>
						            </div>
						            
						        </div>
						    </a>
						</div>
                    </c:forEach>
                    
                </div> <!-- End Row -->

            </div> <!-- End Tab Pane -->
        </c:forEach>
    </div>
</div>