package com.dhakcare.service;

import com.dhakcare.entity.Appointment;

public interface AppointmentService {
	public boolean deleteByDoctorId(String id);
	public boolean removeDepartmentByDepartmentId(String id);
	public Boolean insert(Appointment appointment);
	

}
