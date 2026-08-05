package com.dhakcare.dao;

import java.util.List;

import com.dhakcare.entity.Doctor;
import com.dhakcare.utils.GenericDAO;

public interface DoctorDAO extends GenericDAO<Doctor>{


	public Long countTotalDoctor();
	public boolean removeDepartmentByDepartmentId(String id);
	public List<Doctor> finDoctorbyDeptId(String id);


  
}
