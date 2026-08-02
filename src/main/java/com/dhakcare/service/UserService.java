package com.dhakcare.service;

import java.util.List;

import com.dhakcare.entity.User;

public interface UserService {

	public User login(String phone, String password);
	
	User register( String fullName,
					String gender,
		            String phone,
		            String email,
		            String password,
		            String confirmPassword);
	
	public List<User> findAll();
	
	public boolean deleteById(String id);
		
	public Long getTotalUser();
	
	public User findById(Long id);
	
	public User findByEmmail(String email);

	public boolean update(User user);
	
	public boolean create(User user);

}
