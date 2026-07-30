package com.dhakcare.dao.impl;

import com.dhakcare.dao.DoctorDAO;
import com.dhakcare.entity.Doctor;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

public class DoctorDAOImpl extends GenericDAOImpl<Doctor> implements DoctorDAO{

	private final EntityManager em;
	
	public DoctorDAOImpl() {
		super(Doctor.class);
		this.em = JpaUtil.getEntityManager();
	}

	@Override
	public Long countTotalDoctor() {
		String jpql = "select count(d.id) from Doctor d";
		TypedQuery<Long> query = em.createQuery(jpql, Long.class);
		return query.getSingleResult();
	}

	@Override
	public boolean deleteById(String id) {
		EntityTransaction transaction = em.getTransaction();

		String jpql = "DELETE FROM Doctor d WHERE d.id = :doctorId";
		try {
			em.getTransaction().begin();
			var query = em.createQuery(jpql);
			query.setParameter("doctorId",Long.parseLong(id));
			int result = query.executeUpdate();
			if(result > 0) {
				return true;	
			}
			return false;
			
		} catch (Exception e){
			em.getTransaction().rollback();
			return false;
			
		} finally {
			em.close();
		}
	}
	
}
