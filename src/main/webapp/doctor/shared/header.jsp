<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/doctor/shared/page.jsp" %>
<nav class="navbar navbar-expand-lg admin-navbar shadow-sm">
    <div class="container-fluid">
        <!-- Logo -->
        <a class="navbar-brand admin-logo" href="${doc}">
            <img src="${ctx}/assets/img/logo.png" alt="Logo">
            <span class="text-primary fw-bold">Doctor Portal</span>
        </a>

        <!-- Nút ba gạch trên tablet/mobile -->
        <button class="navbar-toggler admin-navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#doctorNavbarMenu" aria-controls="doctorNavbarMenu" aria-expanded="false" aria-label="Mở menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Phần menu thu gọn -->
        <div class="collapse navbar-collapse" id="doctorNavbarMenu">
            <ul class="navbar-nav admin-menu">
                <li class="nav-item">
                    <a class="nav-link" href="${doc}">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${doc}/appointments">Quản lý Lịch hẹn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${doc}/schedule">Quản lý Lịch rảnh</a>
                </li>
            </ul>

            <!-- Tài khoản -->
            <div class="admin-account-wrapper ms-auto">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <div class="admin-user dropdown">
                            <a href="#" class="admin-avatar" data-bs-toggle="dropdown" aria-expanded="false" title="Tài khoản">
                                <i class="bi bi-person"></i>
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="admin-user dropdown">
                            <a href="#" class="admin-avatar" data-bs-toggle="dropdown" aria-expanded="false" title="Tài khoản">
                                <i class="bi bi-person-badge-fill"></i>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end admin-account-menu">
                                <li class="px-3 py-2 text-muted fw-bold border-bottom">
                                    BS. ${sessionScope.user.fullName}
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${ctx}/account/edit-profile">
                                        <i class="bi bi-person-circle me-2"></i> Hồ sơ
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${ctx}/account/change-password">
                                        <i class="bi bi-key me-2"></i> Đổi mật khẩu
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${ctx}/auth/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i> Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<!-- Toast Container for Notifications -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100">
  <div id="doctorNotificationToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body" id="doctorNotificationMessage">
        <!-- Message will be injected here -->
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  </div>
</div>

<c:if test="${not empty sessionScope.user and not empty sessionScope.user.doctor}">
<script>
    (function() {
        var doctorId = "${sessionScope.user.doctor.id}";
        var host = window.location.host;
        var ctx = "${ctx}";
        var wsProtocol = window.location.protocol === "https:" ? "wss://" : "ws://";
        
        var ws = new WebSocket(wsProtocol + host + ctx + "/ws/notifications/" + doctorId);
        
        ws.onopen = function(event) {
            console.log("Connected to Doctor Notification WebSocket.");
        };
        
        ws.onmessage = function(event) {
            console.log("Received notification: ", event.data);
            try {
                var data = JSON.parse(event.data);
                var toastEl = document.getElementById('doctorNotificationToast');
                var msgEl = document.getElementById('doctorNotificationMessage');
                if (toastEl && msgEl) {
                    msgEl.textContent = data.message || "Bạn có một lịch hẹn mới!";
                    // Use bootstrap toast
                    var toast = new bootstrap.Toast(toastEl);
                    toast.show();
                }
            } catch(e) {
                console.error("Error parsing websocket message", e);
            }
        };
        
        ws.onclose = function(event) {
            console.log("Disconnected from Doctor Notification WebSocket.");
        };
    })();
</script>
</c:if>
