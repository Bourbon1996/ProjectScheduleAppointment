package utils;

import java.time.LocalDate;
import java.time.MonthDay;
import java.util.Set;

public class HolidayUtil {
    
    // 1. NHÓM LỄ CỐ ĐỊNH HÀNG NĂM (Chỉ cần quan tâm Tháng và Ngày)
    private static final Set<MonthDay> FIXED_SOLAR_HOLIDAYS = Set.of(
        MonthDay.of(1, 1),   // Tết Dương lịch (01/01)
        MonthDay.of(4, 30),  // Giải phóng miền Nam (30/04)
        MonthDay.of(5, 1),   // Quốc tế Lao động (01/05)
        MonthDay.of(9, 2)    // Quốc khánh (02/09)
    );

    // 2. NHÓM LỄ ÂM LỊCH / NGHỈ BÙ THAY ĐỔI THEO NĂM (Ví dụ chuẩn cho năm 2026)
    private static final Set<String> DYNAMIC_HOLIDAYS_2026 = Set.of(
        // Tết Nguyên Đán Bính Ngọ 2026 (Từ 29 Tết đến Mùng 5)
        "2026-02-15", "2026-02-16", "2026-02-17", "2026-02-18", "2026-02-19", "2026-02-20",
        
        // Giỗ Tổ Hùng Vương (10/3 Âm lịch năm 2026 rơi vào 26/04 Dương lịch)
        "2026-04-26", 
        
        // Nghỉ bù / Nghỉ thêm dịp Quốc khánh 2026
        "2026-09-03"
    );

    /**
     * Hàm kiểm tra một ngày bất kỳ có phải là Ngày nghỉ lễ Việt Nam hay không
     */
    public static boolean isHoliday(LocalDate date) {
        if (date == null) return false;

        // Kiểm tra xem có trùng vào lễ Dương lịch cố định không
        MonthDay monthDay = MonthDay.from(date);
        if (FIXED_SOLAR_HOLIDAYS.contains(monthDay)) {
            return true;
        }

        // Kiểm tra xem có rơi vào lịch nghỉ Tết/Giỗ Tổ của năm đó không
        return DYNAMIC_HOLIDAYS_2026.contains(date.toString());
    }
}
