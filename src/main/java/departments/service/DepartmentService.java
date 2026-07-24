package departments.service;

import java.util.List;

import departments.dao.DepartmentDAO;
import departments.dao.DepartmentDaoImpl;
import departments.entity.Department;


public interface DepartmentService {
	
	public List<Department> getAllDepartmentParent();
	
}
