package com.dhakcare.dao.impl;

import java.time.LocalDate;
import java.util.List;

import com.dhakcare.dao.AppointmentsDAO;
import com.dhakcare.entity.Appointment;
import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.User;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

public class AppointmentDAOImpl extends GenericDAOImpl<Appointment>	implements AppointmentsDAO {

	public AppointmentDAOImpl() {
		super(Appointment.class);
	}

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
	public Integer findMaxQueueNumberByDoctorAndDate(Doctor doctor, LocalDate date) {
		EntityManager em = JpaUtil.getEntityManager();
	    try {
	        String jpql = "SELECT MAX(a.queueNumber) FROM Appointment a "
	                    + "WHERE a.doctor = :doctor AND a.slot.workDate = :date";
	        
	        TypedQuery<Integer> query = em.createQuery(jpql, Integer.class);
	        query.setParameter("doctor", doctor);
	        query.setParameter("date", date);
	        
	        Integer max = query.getSingleResult();
	        return max != null ? max : 0;
	    } catch (Exception e) {
	        return 0;
	    } finally {
	        if (em != null && em.isOpen()) {
	            em.close();
	        }
	    }
	}
	
	@Override
	public List<Appointment> findByUser(User user) {
		EntityManager em = JpaUtil.getEntityManager();
		try {
		    String jpql = "SELECT a FROM Appointment a WHERE a.bookedBy = :user ORDER BY a.createdAt DESC";
		    TypedQuery<Appointment> query = em.createQuery(jpql, Appointment.class);
		    query.setParameter("user", user);
		    return query.getResultList();
		} catch (Exception e) {
		    e.printStackTrace();
		    return java.util.Collections.emptyList();
		} finally {
		    if (em != null && em.isOpen()) {
		        em.close();
		    }
		}
	}

	@Override
	public List<Appointment> findByDoctorUser(User user) {
		EntityManager em = JpaUtil.getEntityManager();
		try {
		    String jpql = "SELECT a FROM Appointment a WHERE a.doctor.user = :user ORDER BY a.createdAt DESC";
		    TypedQuery<Appointment> query = em.createQuery(jpql, Appointment.class);
		    query.setParameter("user", user);
		    return query.getResultList();
		} catch (Exception e) {
		    e.printStackTrace();
		    return java.util.Collections.emptyList();
		} finally {
		    if (em != null && em.isOpen()) {
		        em.close();
		    }
		}
	}

	@Override
	public java.util.List<Object[]> getTopDepartments(int limit) {
		var em = JpaUtil.getEntityManager();
		try {
			String jpql = "SELECT a.department, COUNT(a) FROM Appointment a " +
					"WHERE a.status IN ('CONFIRMED', 'COMPLETED') " +
					"GROUP BY a.department ORDER BY COUNT(a) DESC";
			return em.createQuery(jpql, Object[].class)
					.setMaxResults(limit)
					.getResultList();
		} catch (Exception e) {
			e.printStackTrace();
			return new java.util.ArrayList<>();
		} finally {
			if (em != null && em.isOpen()) {
				em.close();
			}
		}
	}

	@Override
	public java.util.List<Object[]> getTopDoctors(int limit) {
		var em = JpaUtil.getEntityManager();
		try {
			String jpql = "SELECT a.doctor, COUNT(a) FROM Appointment a " +
					"WHERE a.status IN ('CONFIRMED', 'COMPLETED') " +
					"GROUP BY a.doctor ORDER BY COUNT(a) DESC";
			return em.createQuery(jpql, Object[].class)
					.setMaxResults(limit)
					.getResultList();
		} catch (Exception e) {
			e.printStackTrace();
			return new java.util.ArrayList<>();
		} finally {
			if (em != null && em.isOpen()) {
				em.close();
			}
		}
	}
}
