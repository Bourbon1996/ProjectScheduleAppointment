package com.dhakcare.service;

import java.util.List;

import com.dhakcare.entity.Department;


public interface DepartmentService {
	
	public List<Department> getAllDepartmentParent();
	public List<Department> getAllDepartmentChild();
	public boolean deleteById(String id);
	public Long getTotalDepartment();
	public Department findById(Long id);
	public boolean update(Department department);
	public boolean create(Department department);
}
