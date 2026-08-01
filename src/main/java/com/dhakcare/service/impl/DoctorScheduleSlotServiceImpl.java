package com.dhakcare.service.impl;

import com.dhakcare.dao.DoctorscheduleslotsDAO;
import com.dhakcare.dao.impl.DoctorscheduleslotsDAOImpl;
import com.dhakcare.service.DoctorScheduleSlotService;

public class DoctorScheduleSlotServiceImpl implements DoctorScheduleSlotService {
	DoctorscheduleslotsDAO dao = new DoctorscheduleslotsDAOImpl();

	@Override
	public boolean deleteByDoctorId(String id) {
		// TODO Auto-generated method stub
		return dao.deleteByDoctorId(id);
	}

}
