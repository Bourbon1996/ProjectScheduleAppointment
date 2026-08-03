package com.dhakcare.dao;

import java.util.List;

import com.dhakcare.entity.Department;
import com.dhakcare.utils.GenericDAO;

public interface DepartmentDAO extends GenericDAO<Department>{
	public List<Department> findDepartmentsParent();
	public List<Department> findAllDepartmentChild();
	public Long countTotalDepartment();
	public boolean removeParentByParentId(Long id);
	public List<Department> filter (
			Long id,
			String name,
			String status,
			String sort
			
			);
	
}
