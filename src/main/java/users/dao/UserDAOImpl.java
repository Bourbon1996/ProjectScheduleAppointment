package users.dao;

import users.entity.User;
import utils.GenericDAOImpl;

public class UserDAOImpl extends GenericDAOImpl<User> implements UserDAO {

    public UserDAOImpl() {
        super(User.class);
    }
}