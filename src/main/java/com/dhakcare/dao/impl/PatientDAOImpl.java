package com.dhakcare.dao.impl;

import java.sql.SQLException;
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
            return null;
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
            return null;
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
