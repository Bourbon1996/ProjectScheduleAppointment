package com.dhakcare.dao;

import com.dhakcare.entity.DoctorScheduleSlot;
import com.dhakcare.utils.GenericDAO;

public interface DoctorscheduleslotsDAO extends GenericDAO<DoctorScheduleSlot> {
	public boolean deleteByDoctorId(String id);

}
