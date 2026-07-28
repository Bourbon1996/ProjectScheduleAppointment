package com.dhakcare.dao.impl;

import java.util.List;

import com.dhakcare.dao.UserDAO;
import com.dhakcare.entity.User;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class UserDAOImpl extends GenericDAOImpl<User> implements UserDAO {
	
	private final EntityManager em;

    public UserDAOImpl() {
        super(User.class);
        this.em = JpaUtil.getEntityManager();
    }
    
    @Override
    public User findByPhone(String phone) {
    	String jpql = " select o from User o where o.phone = :phone";
    	
    	TypedQuery<User> query  = em.createQuery(jpql, User.class);
    	query.setParameter("phone", phone );
    	
    	List<User> users  = query.getResultList();
    	
    	if(users.isEmpty()) {
    		return null;
    		
    	}
    	 return users.get(0);
    	
    }
    
    @Override
    public User findByEmail(String email) {
    	String jpql = " select o from User o where o.email = :email ";
    	
    	TypedQuery<User> query = em.createQuery(jpql, User.class);
    	query.setParameter("email", email);
    	
    	List<User> users = query.getResultList();
    	
    	if(users.isEmpty()) {
    		return null;
    	}
    	 return users.get(0);
    }

	@Override
	public Integer countTotalUser() {
		String jpql = " select count(u.id) from User u ";
		TypedQuery<Integer> query = em.createQuery(jpql, Integer.class);
		return query.getSingleResult();
	}
}