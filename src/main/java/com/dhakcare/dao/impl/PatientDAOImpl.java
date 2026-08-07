package com.dhakcare.dao.impl;

import java.util.Collections;
import java.util.List;

import com.dhakcare.dao.PatientsDAO;
import com.dhakcare.entity.Patient;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

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
            
            if (patient.getUser() != null && patient.getUser().getId() != null) {
            	// Attach the user to this EntityManager context
            	com.dhakcare.entity.User managedUser = em.getReference(com.dhakcare.entity.User.class, patient.getUser().getId());
            	patient.setUser(managedUser);
            }
            
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
            
        } catch(Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
			em.close();
		}
	}

	@Override
	public Long countTotalPatients() {
		EntityManager em = JpaUtil.getEntityManager();
		try {
			String jpql = "Select count(p.id) from Patient p";
			TypedQuery<Long> query = em.createQuery(jpql, Long.class);
			return query.getSingleResult();
		} catch(Exception e) {
            e.printStackTrace();
            return 0L;
        } finally {
			em.close();
		}

	}

	@Override
	public boolean deleteByUserId(String id) {
		EntityManager em = JpaUtil.getEntityManager();
		
		String jpql = "DELETE FROM Patient p WHERE p.user.id = :userId ";
		try {
			em.getTransaction().begin();
			
			var query = em.createQuery(jpql);
			query.setParameter("userId",id);
			int result = query.executeUpdate();
			
			em.getTransaction().commit();
			
			return result > 0;
			
		} catch (Exception e){
			em.getTransaction().rollback();
			return false;
			
		} finally {
			em.close();
		}
		
	}
	

}
