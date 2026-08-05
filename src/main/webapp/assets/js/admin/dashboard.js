
document.addEventListener("DOMContentLoaded", function() {
    
    const protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
    const wsUrl = protocol + window.location.host + CTX + "/ws/admin-dashboard";
    
    let socket = new WebSocket(wsUrl);

    socket.onopen = function() {
        console.log("Đã kết nối thành công đến Server");
    };

    socket.onmessage = function(event) {
        const data = JSON.parse(event.data);
        const type = data.type;
        const payload = data.payload;

        switch (type) {
            case 'NEW_USER':
                updateCounter('stat-totalUser', payload.totalUser);
                showToast('Người dùng mới', 'Vừa có một tài khoản mới được đăng ký!', 'info');
                break;

            case 'NEW_PATIENT':
                updateCounter('stat-totalPatient', payload.totalPatient);
                showToast('Hồ sơ bệnh nhân', 'Một hồ sơ bệnh nhân mới vừa được tạo.', 'info');
                break;

            case 'NEW_APPOINTMENT':
                updateCounter('stat-totalSchedules', payload.totalAppointments);
                showToast('Lịch khám mới', 'Vừa có bệnh nhân đặt lịch hẹn thành công!', 'success');
                break;

            case 'PAYMENT_SUCCESS':
                
                const revEl = document.getElementById('stat-totalRevenue');
                if (revEl) {
                    const formattedMoney = new Intl.NumberFormat('vi-VN').format(payload.totalRevenue);
                    revEl.innerHTML = formattedMoney + ' <small>VNĐ</small>';
                    highlightElement(revEl);
                }

                if (payload.totalAppointments) {
                    updateCounter('stat-totalSchedules', payload.totalAppointments);
                }
                showToast('Thanh toán thành công', 'Doanh thu hệ thống vừa được cập nhật!', 'success');
                break;
                
            default:
                console.warn("Bỏ qua sự kiện không xác định:", type);
        }
    };

    socket.onclose = function() {
        console.warn("Mất kết nối WebSocket. Hãy refresh trang nếu cần.");
    };

    function updateCounter(elementId, newValue) {
        const el = document.getElementById(elementId);
        if (el && newValue !== undefined) {
            el.innerText = newValue;
            highlightElement(el);
        }
    }

    function highlightElement(el) {
        el.style.transition = "color 0.3s ease";
        el.style.color = "#198754";
        setTimeout(() => {
            el.style.color = "";
        }, 1500);
    }

    function showToast(title, message, theme = 'info') {
        let toastContainer = document.getElementById('admin-toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.id = 'admin-toast-container';
            toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-4';
            toastContainer.style.zIndex = '9999';
            document.body.appendChild(toastContainer);
        }

        const bgClass = theme === 'success' ? 'bg-success' : 'bg-primary';
        const icon = theme === 'success' ? 'bi-check-circle-fill' : 'bi-info-circle-fill';

        // Khung HTML của Toast
        const toastHtml = `
            <div class="toast align-items-center text-white ${bgClass} border-0 mb-3 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <h6 class="mb-1 fw-bold"><i class="bi ${icon} me-2"></i>\${title}</h6>
                        <span class="fs-7">\${message}</span>
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        `;
        
        toastContainer.insertAdjacentHTML('beforeend', toastHtml);

        const toastElement = toastContainer.lastElementChild;
        const toast = new bootstrap.Toast(toastElement, { delay: 4000 }); // 4 giây tự tắt
        toast.show();

        toastElement.addEventListener('hidden.bs.toast', () => {
            toastElement.remove();
        });
    }
});