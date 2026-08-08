<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/admin/shared/page.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Doanh thu - Admin</title>
    <%@ include file="/admin/shared/page-admin.jsp" %>
    <link rel="stylesheet" href="${ctx}/assets/css/admin/style.css">
</head>
<body>

    <!-- Include Header & Sidebar -->
    <%@ include file="/admin/shared/header.jsp" %>
    
    <div class="admin-main">
        <!-- Tiêu đề trang -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h3 mb-1">Quản lý Doanh thu</h1>
                <p class="text-muted mb-0">Thống kê và lịch sử các giao dịch thanh toán.</p>
            </div>
            
            <form action="${ctx}/admin/revenue" method="GET" class="d-flex gap-2">
                <input type="date" name="filterDate" class="form-control form-control-sm shadow-none" value="${param.filterDate}">
                <button type="submit" class="btn btn-primary btn-sm"><i class="bi bi-filter"></i> Lọc</button>
                <a href="${ctx}/admin/revenue" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-clockwise"></i> Đặt lại</a>
            </form>
        </div>

        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Mã Giao Dịch</th>
                                <th>Bệnh Nhân</th>
                                <th>Bác Sĩ</th>
                                <th>Khoa</th>
                                <th>Phương Thức</th>
                                <th>Thời Gian</th>
                                <th>Số Tiền (VNĐ)</th>
                                <th>Trạng Thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty listPayment}">
                                    <tr>
                                        <td colspan="9" class="text-center py-4 text-muted">
                                            Không có giao dịch nào được tìm thấy.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="item" items="${listPayment}" varStatus="status">
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td><span class="badge bg-secondary">${item.transactionCode}</span></td>
                                            <td>
                                                <div class="fw-bold">${item.appointment.patient.fullName}</div>
                                                <small class="text-muted">${item.appointment.patient.phone}</small>
                                            </td>
                                            <td>
                                                BS. ${item.appointment.doctor.user.fullName}
                                            </td>
                                            <td>
                                                ${item.appointment.department.name}
                                            </td>
                                            <td>
                                                ${item.method}
                                            </td>
                                            <td>
                                                <c:if test="${not empty item.paidAt}">
                                                    ${item.paidAt.toLocalDate().toString()} <br>
                                                    <small class="text-muted">${item.paidAt.toLocalTime().toString().substring(0,5)}</small>
                                                </c:if>
                                            </td>
                                            <td class="text-end fw-bold text-success">
                                                <fmt:formatNumber value="${item.amount}" pattern="#,###"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.status == 'SUCCESS'}">
                                                        <span class="badge bg-success-subtle text-success">Thành công</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'PENDING'}">
                                                        <span class="badge bg-warning-subtle text-warning">Đang chờ</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger-subtle text-danger">${item.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function refreshAdminRevenue() {
            var url = new URL(window.location.href);
            fetch(url.toString())
                .then(res => res.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    
                    const tables = document.querySelectorAll('.table-responsive');
                    const newTables = doc.querySelectorAll('.table-responsive');
                    if (tables.length > 0 && newTables.length > 0) {
                        tables[0].innerHTML = newTables[0].innerHTML;
                    }
                })
                .catch(err => console.error("Error PJAX Revenue:", err));
        }
    </script>
</body>
</html>
