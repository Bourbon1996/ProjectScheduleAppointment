package com.dhakcare.dao.impl;

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
			return null;
		} finally {
			em.close();
		}
	}

	@Override
	public boolean deleteById(String id) {
		EntityManager em = JpaUtil.getEntityManager();
		EntityTransaction transaction = em.getTransaction();

		String jpql = "DELETE FROM Doctor d WHERE d.id = :doctorId";
		try {
			transaction.begin();
			
			var query = em.createQuery(jpql);
			query.setParameter("doctorId", Long.parseLong(id));
			int result = query.executeUpdate();
			
			transaction.commit();
			return result > 0;
			
		} catch (Exception e){
			e.printStackTrace();
			transaction.rollback();
			return false;
		} finally {
			em.close();
		}
	}
	
}
