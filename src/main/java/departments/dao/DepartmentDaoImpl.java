package departments.dao;

import java.util.List;

import departments.entity.Department;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.GenericCRUDUtil;
import utils.JpaUtil;

public class DepartmentDaoImpl extends GenericCRUDUtil<Department> implements DepartmentDAO {

	public DepartmentDaoImpl() {
		super(Department.class);
	}

	@Override
	public List<Department> findDepartmentsParent() {
	    EntityManager em = JpaUtil.getEntityManager();
	    try {
	    	String jpql = "SELECT DISTINCT d FROM Department d LEFT JOIN FETCH d.subDepartments WHERE d.parent IS NULL";
	        
	        TypedQuery<Department> query = em.createQuery(jpql, Department.class);
	        
	        return query.getResultList();
	        
	    } finally {
	        em.close();
	    }
	}
	

	
}
