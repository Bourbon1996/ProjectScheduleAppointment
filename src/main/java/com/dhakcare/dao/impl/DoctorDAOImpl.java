package com.dhakcare.dao.impl;

import com.dhakcare.dao.DoctorDAO;
import com.dhakcare.entity.Doctor;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class DoctorDAOImpl extends GenericDAOImpl<Doctor> implements DoctorDAO{

	private final EntityManager em;
	
	public DoctorDAOImpl() {
		super(Doctor.class);
		this.em = JpaUtil.getEntityManager();
	}

	@Override
	public Integer countTotalDoctor() {
		String jpql = "select count(d.id) from Doctor d";
		TypedQuery<Integer> query = em.createQuery(jpql, Integer.class);
		return query.getSingleResult();
	}
	
}
