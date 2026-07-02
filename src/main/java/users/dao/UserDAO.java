package users.dao;



import java.util.List;

import users.entity.User;

public interface UserDAO {
	User create (User entity);
	
	void update (User entity);
	
	void deleteById(String id);
	
	List<User> findAll();
	
	
	User findById(String id);
	
}
