package com.dhakcare.enums;

public enum ShiftEnum {

	SHIFT_1("Ca 1 (Sáng)", "07:00:00", "11:00:00"),
	
	SHIFT_2("Ca 2 (Chiều)", "13:00:00", "17:00:00"),
	
	SHIFT_3("Ca 3 (Tối)", "18:00:00", "22:00:00");
	
	
	
	private String shiftName;
	
	private String startTime;
	
	private String endTime;
	
	
	
	ShiftEnum(String shiftName, String startTime, String endTime) {
	
	this.shiftName = shiftName;
	
	this.startTime = startTime;
	
	this.endTime = endTime;
	
	}



	public String getShiftName() {
		return shiftName;
	}



	public void setShiftName(String shiftName) {
		this.shiftName = shiftName;
	}



	public String getStartTime() {
		return startTime;
	}



	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}



	public String getEndTime() {
		return endTime;
	}



	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	
	
	
	

}
