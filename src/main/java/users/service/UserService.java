package users.service;

import java.util.List;

import users.entity.User;

public interface UserService {

	List<User> findAll();
	
	User login(String phone, String password);

}
