package com.dhakcare.service;

public interface AppointmentService {
	public boolean deleteByDoctorId(String id);
	public boolean deleteDepartmentById(String id);
	public boolean removeDepartmentByDepartmentId(String id);

	

}
