package users.dao;

import java.util.List;

import users.entity.User;
import utils.GenericDAO;

public interface UserDAO extends GenericDAO<User> {
	
	List<User> findAll();

	 User findByPhone(String phone) ;
	
	 User findByEmail(String email);
}
