package departments.dao;

import java.util.List;

import departments.entity.Department;

public interface DepartmentDAO{
	public List<Department> findDepartmentsParent();

}
