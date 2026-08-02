package com.dhakcare.dao;

import java.time.LocalDate;
import java.util.List;

import com.dhakcare.entity.DoctorScheduleSlot;
import com.dhakcare.utils.GenericDAO;

public interface DoctorscheduleslotsDAO extends GenericDAO<DoctorScheduleSlot> {

	public boolean deleteByDoctorId(String id);
	
	public List<DoctorScheduleSlot> findSlotsByDoctorAndDate(String id, LocalDate workDate);


}
