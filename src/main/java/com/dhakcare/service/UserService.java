package com.dhakcare.service;

import java.util.List;

import com.dhakcare.entity.User;

public interface UserService {

	public User login(String phone, String password);
	
	User register( String fullName,
		            String phone,
		            String email,
		            String password,
		            String confirmPassword);
	
	public List<User> findAll();
	
	public boolean deleteById(String id);
		
	public Integer getTotalUser();

}
