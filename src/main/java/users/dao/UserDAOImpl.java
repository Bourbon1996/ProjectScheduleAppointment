package users.dao;

import jakarta.persistence.EntityManager;
import users.entity.User;
import utils.GenericCRUDUtil;

public class UserDAOImpl extends GenericCRUDUtil<User> implements UserDAO {

    public UserDAOImpl() {
        super(User.class);
    }
}