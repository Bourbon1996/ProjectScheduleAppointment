package com.dhakcare.utils;

import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class OtpService {
    
    // Lưu trữ OTP theo email. Dùng ConcurrentHashMap để thread-safe
    private static final ConcurrentHashMap<String, OtpData> otpStorage = new ConcurrentHashMap<>();
    private static final int OTP_EXPIRY_MINUTES = 5;

    // Class nội bộ lưu dữ liệu OTP
    private static class OtpData {
        String otp;
        long expiryTime;

        OtpData(String otp, long expiryTime) {
            this.otp = otp;
            this.expiryTime = expiryTime;
        }
    }

    static {
        // Chạy ngầm dọn dẹp các OTP hết hạn mỗi 10 phút để tránh rò rỉ bộ nhớ
        ScheduledExecutorService cleanupExecutor = Executors.newSingleThreadScheduledExecutor();
        cleanupExecutor.scheduleAtFixedRate(() -> {
            long now = System.currentTimeMillis();
            otpStorage.entrySet().removeIf(entry -> entry.getValue().expiryTime < now);
        }, 10, 10, TimeUnit.MINUTES);
    }

    /**
     * Tạo mã OTP 6 số ngẫu nhiên cho một email
     */
    public static String generateOtp(String email) {
        Random random = new Random();
        // Sinh số từ 100000 đến 999999
        int otpNumber = 100000 + random.nextInt(900000);
        String otpStr = String.valueOf(otpNumber);

        long expiryTime = System.currentTimeMillis() + (OTP_EXPIRY_MINUTES * 60 * 1000);
        
        otpStorage.put(email.toLowerCase(), new OtpData(otpStr, expiryTime));
        
        return otpStr;
    }

    /**
     * Kiểm tra OTP có hợp lệ và chưa hết hạn không
     */
    public static boolean validateOtp(String email, String otpInput) {
        if (email == null || otpInput == null) return false;
        
        String key = email.toLowerCase();
        OtpData data = otpStorage.get(key);

        if (data != null) {
            long now = System.currentTimeMillis();
            if (now <= data.expiryTime && data.otp.equals(otpInput)) {
                // Xác thực thành công thì xóa luôn để không dùng lại được
                otpStorage.remove(key);
                return true;
            } else if (now > data.expiryTime) {
                // Đã hết hạn
                otpStorage.remove(key);
            }
        }
        return false;
    }
    
    /**
     * Xóa OTP (ví dụ khi người dùng yêu cầu gửi lại OTP mới)
     */
    public static void removeOtp(String email) {
        if (email != null) {
            otpStorage.remove(email.toLowerCase());
        }
    }
}
