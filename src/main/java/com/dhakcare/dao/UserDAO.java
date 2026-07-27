package com.dhakcare.dao;

import java.util.List;

import com.dhakcare.entity.User;
import com.dhakcare.utils.GenericDAO;

public interface UserDAO extends GenericDAO<User> {
	
	List<User> findAll();

	 User findByPhone(String phone) ;
	
	 User findByEmail(String email);
}
