package com.dhakcare.dao.impl;

import java.util.List;

import com.dhakcare.dao.DepartmentDAO;
import com.dhakcare.entity.Department;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

public class DepartmentDaoImpl extends GenericDAOImpl<Department> implements DepartmentDAO {
	
	private final EntityManager em;

	public DepartmentDaoImpl() {
		super(Department.class);
		this.em = JpaUtil.getEntityManager();
	}

	@Override
	public List<Department> findDepartmentsParent() {
	    EntityManager em = JpaUtil.getEntityManager();
	    try {
	    	String jpql = "SELECT DISTINCT d FROM Department d LEFT JOIN FETCH d.subDepartments WHERE d.parent IS NULL";
	        
	        TypedQuery<Department> query = em.createQuery(jpql, Department.class);
	        
	        return query.getResultList();
	        
	    } catch (Exception e){
	    	
			e.printStackTrace();
			return null;
		}
	}
	
	public List<Department> findAllDepartmentChild() {
	    EntityManager em = JpaUtil.getEntityManager();
	    try {
	        
	        String jpql = "SELECT d FROM Department d WHERE d.parent IS NOT NULL"; 
	        
	        return em.createQuery(jpql, Department.class).getResultList();
	    } catch (Exception e){
	    	
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public Long countTotalDepartment() {
		String jpql = "Select count(d.id) from Department d";
		TypedQuery<Long> query = em.createQuery(jpql, Long.class);
		return query.getSingleResult();
	}

	@Override
	public boolean removeParentByParentId(String id) {
       EntityTransaction transaction = em.getTransaction();
		
		String jpql = """
				UPDATE Department d
                SET d.parent = NULL
                WHERE d.parent.id = :parentId
				""";
		try {
			transaction.begin();
			
			var query = em.createQuery(jpql);
			query.setParameter("parentId", Long.parseLong(id));
			int result = query.executeUpdate();
			
			transaction.commit();
			return result >= 0;
		}catch (Exception e){
			e.printStackTrace();
			transaction.rollback();
			return false;
		}
				
	}

	

	
}
