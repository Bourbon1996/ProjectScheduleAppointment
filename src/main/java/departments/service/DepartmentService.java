package departments.service;

import java.util.List;

import departments.dao.DepartmentDAO;
import departments.dao.DepartmentDaoImpl;
import departments.entity.Department;

public class DepartmentService {
	DepartmentDaoImpl dao = new DepartmentDaoImpl();
	
	public List<Department> getAllDepartmentParent(){
		
		return dao.findDepartmentsParent();
	}
	
}
