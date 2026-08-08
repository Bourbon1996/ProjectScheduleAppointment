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
	public List<DoctorScheduleSlot> findByDoctorUser(com.dhakcare.entity.User user) {
		return dao.findByDoctorUser(user);
	}

	@Override
	public DoctorScheduleSlot getById(String id) {
		try {
			return dao.findById(Long.parseLong(id));
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public boolean createSlot(DoctorScheduleSlot slot) {
		return dao.create(slot);
	}

	@Override
	public boolean updateSlot(DoctorScheduleSlot slot) {
		return dao.update(slot) != null;
	}

	@Override
	public boolean deleteSlot(String id) {
		try {
			return dao.delete(Long.parseLong(id));
		} catch (Exception e) {
			return false;
		}
	}

	@Override
	public List<DoctorScheduleSlot> getAllSlots() {
		return dao.findAll();
	}

}
