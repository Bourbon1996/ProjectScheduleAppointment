package appointments.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MonthCalendar {
	private String monthLabel;
    private int monthIndex;       
    private List<CalendarDay> days;
}
