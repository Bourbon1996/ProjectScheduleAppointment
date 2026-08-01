package com.dhakcare.service;

import java.util.List;

import com.dhakcare.entity.Doctor;

public interface DoctorService {
	public List<Doctor> getAll();
	public Doctor getById(String id);
	public boolean deleteById(String id);
	public Long getTotalDoctor();
	public boolean removeDepartmentByDepartmentId(String id);


}
