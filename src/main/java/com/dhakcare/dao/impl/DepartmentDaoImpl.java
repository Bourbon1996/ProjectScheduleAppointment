package com.dhakcare.dao.impl;

import java.util.Collections;
import java.util.List;

import com.dhakcare.dao.DepartmentDAO;
import com.dhakcare.entity.Department;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

public class DepartmentDaoImpl extends GenericDAOImpl<Department> implements DepartmentDAO {
	

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
	        
	    } catch (Exception e){
	    	
			e.printStackTrace();
			return Collections.emptyList();
		} finally {
			em.close();
		}
	}
	
	public List<Department> findAllDepartmentChild() {
	    EntityManager em = JpaUtil.getEntityManager();
	    try {
	        
	        String jpql = "SELECT d FROM Department d WHERE d.parent IS NOT NULL"; 
	        
	        return em.createQuery(jpql, Department.class).getResultList();
	    } catch (Exception e){
	    	
			e.printStackTrace();
			return Collections.emptyList();
		} finally {
			em.close();
		}
	}

	@Override
	public Long countTotalDepartment() {
		EntityManager em = JpaUtil.getEntityManager();
		try {
			String jpql = "Select count(d.id) from Department d";
			TypedQuery<Long> query = em.createQuery(jpql, Long.class);
			return query.getSingleResult();
		} catch (Exception e) {
			e.printStackTrace();
			return 0L;
		} finally {
			em.close();
		}
	}

	@Override
	public boolean removeParentByParentId(Long id) {
		EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction transaction = em.getTransaction();
		
		String jpql = """
				UPDATE Department d
                SET d.parent = NULL
                WHERE d.id = :id
				""";
		try {
			transaction.begin();
			
			var query = em.createQuery(jpql);
			query.setParameter("id", id);
			int result = query.executeUpdate();
			
			transaction.commit();
			return result >= 0;
		} catch (Exception e){
			e.printStackTrace();
			transaction.rollback();
			return false;
		} finally {
			em.close();
		}
				
	}

	
	

	
}
