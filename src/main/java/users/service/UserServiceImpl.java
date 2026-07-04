package users.service;

import java.util.List;


import users.dao.UserDAOImpl;
import users.entity.User;


public class UserServiceImpl implements UserService {
	
	UserDAOImpl dao = new UserDAOImpl();
	@Override
	public List<User> findAll() {
		
		return dao.findAll();
	}

	

	
	

}
