package com.dhakcare.service;

import java.util.List;

import com.dhakcare.entity.User;

public interface UserService {

	List<User> findAll();
	
	User login(String phone, String password);

}
