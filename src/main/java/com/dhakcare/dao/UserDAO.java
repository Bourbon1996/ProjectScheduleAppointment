package com.dhakcare.dao;

import com.dhakcare.entity.User;
import com.dhakcare.utils.GenericDAO;

public interface UserDAO extends GenericDAO<User> {

	 public User findByPhone(String phone) ;
	
	 public User findByEmail(String email);
	 
	 public Long countTotalUser();
}
