package com.dhakcare.dao.impl;

import java.util.List;

import com.dhakcare.dao.UserDAO;
import com.dhakcare.entity.User;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class UserDAOImpl extends GenericDAOImpl<User> implements UserDAO {

    public UserDAOImpl() {
        super(User.class);
    }
    
    @Override
    public User findByPhone(String phone) {
    	EntityManager em = JpaUtil.getEntityManager();
    	
    	try {
	    	String jpql = " select o from User o where o.phone = :phone";
	    	
	    	TypedQuery<User> query  = em.createQuery(jpql, User.class);
	    	query.setParameter("phone", phone );
	    	
	    	List<User> users  = query.getResultList();
	    	
	    	if(users.isEmpty()) {
	    		return null;
	    		
	    	}
	    	 return users.get(0);
    	} catch (Exception e){
    		e.printStackTrace();
			em.getTransaction().rollback();
			return null;
			
		} finally {
			em.close();
		}
    	
    }
    
    @Override
    public User findByEmail(String email) {
    	EntityManager em = JpaUtil.getEntityManager();
    	
    	try {
	    	String jpql = " select o from User o where o.email = :email ";
	    	
	    	TypedQuery<User> query = em.createQuery(jpql, User.class);
	    	query.setParameter("email", email);
	    	
	    	List<User> users = query.getResultList();
	    	
	    	if(users.isEmpty()) {
	    		return null;
	    	}
	    	 return users.get(0);
    	} catch (Exception e){
    		e.printStackTrace();
			em.getTransaction().rollback();
			return null;
			
		} finally {
			em.close();
		}
    }

	@Override
	public Long countTotalUser() {
		EntityManager em = JpaUtil.getEntityManager();
		
		try {
			String jpql = " select count(u.id) from User u ";
			TypedQuery<Long> query = em.createQuery(jpql, Long.class);
			return query.getSingleResult();
		} catch (Exception e){
    		e.printStackTrace();
			em.getTransaction().rollback();
			return null;
			
		} finally {
			em.close();
		}
	}
}