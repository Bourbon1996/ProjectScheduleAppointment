package departments.dao;

import java.util.List;

import departments.entity.Department;
import utils.GenericDAO;

public interface DepartmentDAO extends GenericDAO<Department>{
	public List<Department> findDepartmentsParent();

}
