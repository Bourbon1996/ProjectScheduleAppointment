package com.dhakcare.dao.impl;

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

}
