package com.dhakcare.dao.impl;

import java.util.List;

import com.dhakcare.dao.PatientsDAO;
import com.dhakcare.entity.Patient;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

public class PatientDAOImpl extends GenericDAOImpl<Patient> implements PatientsDAO{

	public PatientDAOImpl() {
		super(Patient.class);
		
	}

	@Override
	public boolean insert(Patient patient) {
		EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        
        try {
            trans.begin();
            em.persist(patient); 
            trans.commit();
            return true;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
	}

	@Override
	public List<Patient> findByUserId(Long id) {
		EntityManager em = JpaUtil.getEntityManager();
        
        try {
            String jpql = "SELECT p FROM Patient p WHERE p.user.id = :id";

            var query = em.createQuery(jpql, Patient.class);
            query.setParameter("id", id);
            
            return query.getResultList();
            
        } finally {
            em.close();
        }
	}
	

}
