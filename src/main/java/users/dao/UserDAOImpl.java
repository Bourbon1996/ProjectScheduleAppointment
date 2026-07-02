package users.dao;

import jakarta.persistence.EntityManager;
import users.entity.User;
import utils.GenericCRUDUtil;
import utils.JpaUtil;

public class UserDAOImpl implements UserDAO {
	EntityManager em =  JpaUtil.getEntityManager();

	GenericCRUDUtil<User> userDAO =
	        new GenericCRUDUtil<>(em, User.class);
	
	
	
}
