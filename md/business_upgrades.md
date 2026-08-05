# Các Nâng Cấp Nghiệp Vụ (Business Upgrades)

Dưới đây là danh sách các nghiệp vụ sẽ được nâng cấp cho hệ thống Quản lý Đặt lịch Khám bệnh:

## 1. Hoàn thiện luồng Trạng thái Cuộc hẹn (Appointment Lifecycle)
- **Hủy lịch (Cancel):** Bệnh nhân có thể chủ động hủy lịch khám. Khi hủy, hệ thống giải phóng slot và đánh dấu trạng thái lịch hẹn là `CANCELLED`. Nếu đã thanh toán, trạng thái thanh toán có thể cập nhật để chờ xử lý (ví dụ: `REFUNDED`).
- **Hoàn thành (Completed):** Bác sĩ (hoặc Admin) cập nhật trạng thái cuộc hẹn thành `COMPLETED` sau khi khám xong.
- **Ghi chú/Chẩn đoán:** Bác sĩ có thể nhập kết quả khám hoặc lời khuyên cho bệnh nhân sau khi hoàn tất.

## 2. Hệ thống Thông báo (Notification & Reminder System)
- **Email Thông báo Đặt lịch:** Tự động gửi email thông báo chi tiết cuộc hẹn (thời gian, bác sĩ, khoa) ngay sau khi bệnh nhân đặt lịch và thanh toán thành công.
- **Nhắc lịch Tự động:** Một tiến trình chạy ngầm (Background Job) chạy mỗi ngày để tìm các cuộc hẹn vào ngày mai và gửi email nhắc nhở bệnh nhân.
- **Thông báo Realtime cho Bác sĩ:** Sử dụng WebSocket để đẩy thông báo trực tiếp lên màn hình của bác sĩ khi có bệnh nhân mới đặt lịch với họ.

## 3. Portal dành riêng cho Bác sĩ (Doctor Portal)
- **Dashboard Bác sĩ:** Giao diện riêng biệt cho người dùng có role `DOCTOR` đăng nhập.
- **Quản lý Cuộc hẹn:** Bác sĩ chỉ nhìn thấy và quản lý những cuộc hẹn của riêng mình.
- **Quản lý Lịch làm việc:** Bác sĩ có thể tự cấu hình, thêm/sửa/xóa các khung giờ làm việc (`DoctorScheduleSlot`) của mình.
- **Xin Nghỉ Phép:** Bác sĩ có thể block các ngày không thể đi làm để bệnh nhân không thể đặt lịch.

## 4. Thống kê, Báo cáo nâng cao (Advanced Analytics)
- **Biểu đồ Trực quan:** Hiển thị biểu đồ doanh thu theo tháng/tuần trên Admin Dashboard.
- **Thống kê Hiệu suất:** Thống kê Khoa (Department) có lượt khám nhiều nhất, và Bác sĩ có doanh thu/lượt khám cao nhất.
- Phục vụ việc ra quyết định kinh doanh cho quản lý phòng khám.

## 5. Cải tiến Luồng Quên Mật Khẩu (Security Flow với OTP)
- **Xác thực OTP:** Thay vì random mật khẩu mới và lưu đè ngay lập tức, hệ thống sẽ gửi một mã OTP (6 số) qua email.
- **Tính Thời Gian Thực:** Mã OTP chỉ có hiệu lực trong khoảng thời gian ngắn (ví dụ: 5 phút).
- **Tự Đặt Lại Mật Khẩu:** Sau khi nhập đúng OTP, người dùng được quyền tự nhập mật khẩu mới của mình trên màn hình web.
