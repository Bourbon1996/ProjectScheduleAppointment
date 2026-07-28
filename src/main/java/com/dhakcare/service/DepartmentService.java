package com.dhakcare.service;

import java.util.List;

import com.dhakcare.dao.DepartmentDAO;
import com.dhakcare.dao.impl.DepartmentDaoImpl;
import com.dhakcare.entity.Department;


public interface DepartmentService {
	
	public List<Department> getAllDepartmentParent();
	public List<Department> getAllDepartmentChild();
	
}
