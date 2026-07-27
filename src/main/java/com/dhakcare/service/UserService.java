package com.dhakcare.service;

import java.util.List;

import com.dhakcare.entity.User;

public interface UserService {

	public User login(String phone, String password);
	
	public List<User> findAll();

}
