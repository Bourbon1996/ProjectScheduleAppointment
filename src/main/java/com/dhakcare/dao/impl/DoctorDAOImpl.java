package com.dhakcare.dao.impl;

import java.util.Collections;
import java.util.List;

import com.dhakcare.dao.DoctorDAO;
import com.dhakcare.entity.Doctor;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

public class DoctorDAOImpl extends GenericDAOImpl<Doctor> implements DoctorDAO{

	
	public DoctorDAOImpl() {
		super(Doctor.class);
	}

	@Override
	public Long countTotalDoctor() {
		EntityManager em = JpaUtil.getEntityManager();
		try {
			String jpql = "select count(d.id) from Doctor d";
			TypedQuery<Long> query = em.createQuery(jpql, Long.class);
			return query.getSingleResult();
		} catch (Exception e){
			e.printStackTrace();
			return 0L;
		} finally {
			em.close();
		}
	}


	@Override
	public boolean removeDepartmentByDepartmentId(String id) {
		EntityManager em = JpaUtil.getEntityManager();
		EntityTransaction transaction = em.getTransaction();
		
		String jpql = """
				UPDATE Doctor d
                SET d.department = NULL
                WHERE d.department.id = :departmentId
				""";
		try {
			transaction.begin();
			
			var query = em.createQuery(jpql);
			query.setParameter("departmentId", Long.parseLong(id));
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

	@Override
	public List<Doctor> finDoctorbyDeptId(String id) {
	    EntityManager em = JpaUtil.getEntityManager();
	    try {
	        String jpql = "SELECT doc FROM Doctor doc WHERE doc.department.id = :id";
	        
	        var query = em.createQuery(jpql, Doctor.class);
	        
	        query.setParameter("id", Long.parseLong(id));
	        
	        return query.getResultList();
	    } catch (Exception e){
	        e.printStackTrace();
	        return Collections.emptyList();
	    } finally {
	        if (em != null && em.isOpen()) {
	            em.close();
	        }
	    }
	}

	@Override
	public Doctor findByUser(com.dhakcare.entity.User user) {
		EntityManager em = JpaUtil.getEntityManager();
		try {
			String jpql = "SELECT d FROM Doctor d WHERE d.user.id = :userId";
			var query = em.createQuery(jpql, Doctor.class);
			query.setParameter("userId", user.getId());
			return query.getSingleResult();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			if (em != null && em.isOpen()) {
				em.close();
			}
		}
	}
}
