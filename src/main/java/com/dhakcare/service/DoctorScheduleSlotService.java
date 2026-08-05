package com.dhakcare.service;

import java.time.LocalDate;
import java.util.List;

import com.dhakcare.entity.DoctorScheduleSlot;

public interface DoctorScheduleSlotService {
	public boolean deleteByDoctorId(String id);
	public List<DoctorScheduleSlot> getByDoctorAndDate(String id, LocalDate workdate);
	public List<DoctorScheduleSlot> findByDoctorUser(com.dhakcare.entity.User user);
	public DoctorScheduleSlot getById(String id);
	public boolean createSlot(DoctorScheduleSlot slot);
	public boolean deleteSlot(String id);
}
