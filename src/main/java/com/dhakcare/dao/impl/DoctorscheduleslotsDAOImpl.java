package com.dhakcare.dao.impl;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import com.dhakcare.dao.DoctorscheduleslotsDAO;
import com.dhakcare.entity.DoctorScheduleSlot;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;

public class DoctorscheduleslotsDAOImpl extends GenericDAOImpl<DoctorScheduleSlot> implements DoctorscheduleslotsDAO {

	public DoctorscheduleslotsDAOImpl() {
		super(DoctorScheduleSlot.class);
	}
	

	@Override
	public boolean deleteByDoctorId(String id) {
		EntityManager em = JpaUtil.getEntityManager();
		String jpql = "DELETE FROM DoctorScheduleSlot d WHERE d.doctor.id = :doctorId ";
		
		try {
			em.getTransaction().begin();
			var query = em.createQuery(jpql);
			query.setParameter("doctorId", Long.parseLong(id) );
			int result = query.executeUpdate();
			
			em.getTransaction().commit();
			
			return result >= 0;
		} catch(Exception e) {
			em.getTransaction().rollback();
			return false;
		} finally {
			em.close();
		}
		
	
		
	}


	@Override
	public List<DoctorScheduleSlot> findSlotsByDoctorAndDate(String doctorId, LocalDate workDate) {
	    EntityManager em = JpaUtil.getEntityManager();
	    
	    try {

	        String jpql = "SELECT s FROM DoctorScheduleSlot s " +
	                      "WHERE s.doctor.id = :id AND s.workDate = :date " +
	                      "ORDER BY s.startTime ASC";
	        
	        var query = em.createQuery(jpql, DoctorScheduleSlot.class);
	        
	        query.setParameter("id", Long.parseLong(doctorId));
	        query.setParameter("date", workDate); 
	        
	        return query.getResultList();
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        return Collections.emptyList();
	    } finally {
	        if (em != null && em.isOpen()) {
	            em.close();
	        }
	    }
	}
	public List<DoctorScheduleSlot> findByDoctorUser(com.dhakcare.entity.User user) {
		EntityManager em = JpaUtil.getEntityManager();
		try {
			String jpql = "SELECT s FROM DoctorScheduleSlot s WHERE s.doctor.user.id = :userId ORDER BY s.workDate DESC, s.startTime ASC";
			var query = em.createQuery(jpql, DoctorScheduleSlot.class);
			query.setParameter("userId", user.getId());
			return query.getResultList();
		} catch (Exception e) {
			e.printStackTrace();
			return Collections.emptyList();
		} finally {
			if (em != null && em.isOpen()) {
				em.close();
			}
		}
	}

}
