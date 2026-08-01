package com.dhakcare.dao.impl;

import com.dhakcare.dao.AppointmentsDAO;
import com.dhakcare.entity.Appointment;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

public class AppointmentDAOImpl extends GenericDAOImpl<Appointment>	implements AppointmentsDAO {

	public AppointmentDAOImpl() {
		super(Appointment.class);
	}
 
	AppointmentsDAO dao = new AppointmentDAOImpl();

	@Override
	public boolean deleteByDoctorId(String id) {
		EntityManager em = JpaUtil.getEntityManager();
		String jpql = "DELETE FROM Appointment a WHERE a.doctor.id = :doctorId";
		try {
			em.getTransaction().begin();
			var query = em.createQuery(jpql);
			query.setParameter("doctorId", Long.parseLong(id));
			int result = query.executeUpdate();
						
			em.getTransaction().commit();
			
			return result >= 0;
		}catch(Exception e) {
			em.getTransaction().rollback();
			return false;
		} finally {
			em.close();
		}
		
	}

	@Override
	public boolean removeDepartmentByDepartmentId(String id) {
		EntityManager em = JpaUtil.getEntityManager();
		EntityTransaction transaction = em.getTransaction();
		
		String jpql = """
				UPDATE Appointment a
                SET a.department = NULL
                WHERE a.department.id = :departmentId
				""";
		try {
			transaction.begin();
			
			var query = em.createQuery(jpql);
			query.setParameter("departmentId", Long.parseLong(id));
			int result = query.executeUpdate();
			
			transaction.commit();
			return result >= 0;
		}catch (Exception e){
			e.printStackTrace();
			transaction.rollback();
			return false;
		} finally {
			em.close();
		}
				
	}

	@Override
	public boolean deleteDepartmentById(String id) {
		// TODO Auto-generated method stub
		return dao.delete(id);
	}

	
	
	
}
