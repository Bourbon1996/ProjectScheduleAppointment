package com.dhakcare.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CalendarDay {
	private int dayNumber;
	private String dateString;
	private String displayStr;
    private boolean available;
    
    private boolean today;
    
    private boolean dayOff; 
    private boolean holiday;
}
