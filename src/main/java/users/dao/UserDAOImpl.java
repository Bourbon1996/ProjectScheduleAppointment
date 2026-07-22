package users.dao;

import users.entity.User;
import utils.GenericCRUDUtil;

public class UserDAOImpl extends GenericCRUDUtil<User> implements UserDAO {

    public UserDAOImpl() {
        super(User.class);
    }
}