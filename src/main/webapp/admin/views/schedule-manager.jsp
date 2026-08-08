<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/admin/shared/page.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Lịch Bác sĩ - Admin</title>
    <%@ include file="/admin/shared/page-admin.jsp" %>
    <link rel="stylesheet" href="${ctx}/assets/css/admin/style.css">
    
    <!-- FullCalendar CSS -->
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' rel='stylesheet' />
    
    <style>
        .fc-event {
            cursor: pointer;
        }
        .status-available { background-color: #198754 !important; border-color: #198754 !important; color: white !important; }
        .status-full { background-color: #dc3545 !important; border-color: #dc3545 !important; color: white !important; }
        .status-closed { background-color: #6c757d !important; border-color: #6c757d !important; color: white !important; }
        .status-pending { background-color: #fd7e14 !important; border-color: #fd7e14 !important; color: white !important; }
    </style>
</head>
<body>

    <!-- Include Header & Sidebar -->
    <%@ include file="/admin/shared/header.jsp" %>
    
    <div class="admin-main">
        <div class="container-fluid px-4">
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-1"></i> ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-1"></i> ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

        <div class="d-flex justify-content-between align-items-center mb-4 mt-3">
            <div>
                <h1 class="h3 mb-1">Quản lý Lịch & Điều phối</h1>
                <p class="text-muted mb-0">Duyệt yêu cầu nghỉ phép và xem lịch làm việc tổng quan.</p>
            </div>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#autoGenModal">
                <i class="bi bi-magic me-1"></i> Xếp Lịch Tự Động
            </button>
        </div>

        <!-- YÊU CẦU CHỜ DUYỆT -->
        <c:if test="${not empty pendingSlots}">
            <div class="card border-warning mb-4 shadow-sm">
                <div class="card-header bg-warning text-dark fw-bold">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> Yêu cầu Xóa Ca Khám Cần Duyệt (${pendingSlots.size()})
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Bác sĩ</th>
                                    <th>Ngày</th>
                                    <th>Thời gian</th>
                                    <th>Bệnh nhân đã đặt</th>
                                    <th class="text-end">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="slot" items="${pendingSlots}">
                                    <tr>
                                        <td>
                                            <div class="fw-bold">BS. ${slot.doctor.user.fullName}</div>
                                            <small class="text-muted">${slot.doctor.department.name}</small>
                                        </td>
                                        <td>${slot.workDate}</td>
                                        <td>${slot.startTime} - ${slot.endTime}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${slot.bookedCount > 0}">
                                                    <span class="badge bg-danger">${slot.bookedCount} bệnh nhân</span>
                                                    <br><small class="text-danger">Cần xử lý hoàn tiền/hủy lịch nếu duyệt!</small>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success">Trống (0 bệnh nhân)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <form action="${ctx}/admin/schedules/approve" method="POST" class="d-inline" onsubmit="return confirm('Bạn chắc chắn muốn XÓA ca khám này?');">
                                                <input type="hidden" name="id" value="${slot.id}">
                                                <input type="hidden" name="action" value="APPROVE">
                                                <button type="submit" class="btn btn-sm btn-success"><i class="bi bi-check-lg"></i> Duyệt Xóa</button>
                                            </form>
                                            <form action="${ctx}/admin/schedules/approve" method="POST" class="d-inline">
                                                <input type="hidden" name="id" value="${slot.id}">
                                                <input type="hidden" name="action" value="REJECT">
                                                <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-x-lg"></i> Từ Chối</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- MASTER CALENDAR -->
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <div id="calendar"></div>
            </div>
        </div>
        </div>
    </div>
    
    <!-- Auto-Gen Modal -->
    <div class="modal fade" id="autoGenModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${ctx}/admin/schedules/auto-generate" method="POST">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-magic me-2"></i>Xếp Lịch Tự Động (Auto-Gen)</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-warning">
                            <i class="bi bi-info-circle-fill me-1"></i> Tính năng này sẽ tạo lịch làm việc từ <strong>Thứ 2 đến Thứ 7</strong> cho <strong>TẤT CẢ Bác sĩ</strong> trong tháng được chọn.
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Chọn Tháng/Năm</label>
                            <input type="month" name="month" class="form-control" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Ca Sáng (Bắt đầu)</label>
                                <input type="time" name="morningStart" class="form-control" value="08:00" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Ca Sáng (Kết thúc)</label>
                                <input type="time" name="morningEnd" class="form-control" value="12:00" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Ca Chiều (Bắt đầu)</label>
                                <input type="time" name="afternoonStart" class="form-control" value="13:00" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Ca Chiều (Kết thúc)</label>
                                <input type="time" name="afternoonEnd" class="form-control" value="17:00" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Giới hạn Bệnh nhân/Ca</label>
                            <input type="number" name="maxPatients" class="form-control" value="25" min="1" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary" onclick="return confirm('Bạn có chắc chắn muốn phát sinh lịch hàng loạt không?');">Xếp Lịch Tự Động</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/locales-all.min.js'></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            
            // Build events from allSlots
            var eventsList = [
                <c:forEach var="slot" items="${allSlots}" varStatus="status">
                    {
                        id: '${slot.id}',
                        title: 'BS. ${slot.doctor.user.fullName} (${slot.bookedCount}/${slot.maxPatients})',
                        start: '${slot.workDate}T${slot.startTime}',
                        end: '${slot.workDate}T${slot.endTime}',
                        <c:choose>
                            <c:when test="${slot.status == 'PENDING_DELETE'}">className: 'status-pending'</c:when>
                            <c:when test="${slot.status == 'CLOSED'}">className: 'status-closed'</c:when>
                            <c:when test="${slot.status == 'FULL' || slot.bookedCount >= slot.maxPatients}">className: 'status-full'</c:when>
                            <c:otherwise>className: 'status-available'</c:otherwise>
                        </c:choose>
                    }${!status.last ? ',' : ''}
                </c:forEach>
            ];

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'timeGridWeek',
                locale: 'vi',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
                },
                slotMinTime: '06:00:00',
                slotMaxTime: '22:00:00',
                allDaySlot: false,
                events: eventsList,
                eventClick: function(info) {
                    // Optional: show details
                }
            });
            calendar.render();
        });
    </script>
</body>
</html>
