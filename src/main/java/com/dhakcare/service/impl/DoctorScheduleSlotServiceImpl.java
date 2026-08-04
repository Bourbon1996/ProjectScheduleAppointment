package com.dhakcare.service.impl;

import java.time.LocalDate;
import java.util.List;

import com.dhakcare.dao.DoctorscheduleslotsDAO;
import com.dhakcare.dao.impl.DoctorscheduleslotsDAOImpl;
import com.dhakcare.entity.DoctorScheduleSlot;
import com.dhakcare.service.DoctorScheduleSlotService;

public class DoctorScheduleSlotServiceImpl implements DoctorScheduleSlotService {
	DoctorscheduleslotsDAO dao = new DoctorscheduleslotsDAOImpl();

	@Override
	public boolean deleteByDoctorId(String id) {
		// TODO Auto-generated method stub
		return dao.deleteByDoctorId(id);
	}

	@Override
	public List<DoctorScheduleSlot> getByDoctorAndDate(String id, LocalDate workdate) {
		// TODO Auto-generated method stub
		return dao.findSlotsByDoctorAndDate(id, workdate);
	}

	@Override
	public DoctorScheduleSlot getById(String id) {
		// TODO Auto-generated method stub
		return dao.findById(id);
	}

}
