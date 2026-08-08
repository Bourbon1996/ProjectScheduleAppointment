package com.dhakcare.enums;

public enum WsEventType {
    NEW_USER,           // Có người dùng mới đăng ký
    NEW_PATIENT,        // Có hồ sơ bệnh nhân mới
    NEW_APPOINTMENT,    // Có lịch đặt mới (chưa thanh toán)
    PAYMENT_SUCCESS,    // Thanh toán thành công (cập nhật doanh thu)
    APPOINTMENT_CANCELED, // Hủy lịch
    LEAVE_REQUEST       // Xin xóa ca/nghỉ phép
}