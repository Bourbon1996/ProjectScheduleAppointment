package com.dhakcare.service;

import java.util.List;

import com.dhakcare.entity.Doctor;

public interface DoctorService {
	public List<Doctor> getAll();
	public Doctor getById(Long id);
	public boolean deleteById(Long id);
	public Long getTotalDoctor();
	public boolean removeDepartmentByDepartmentId(String id);
	public List<Doctor> getDoctorbyDeptId(String id);
	public Doctor getByUser(com.dhakcare.entity.User user);
	public boolean update(Doctor doctor);
	public boolean create(Doctor doctor);


}
