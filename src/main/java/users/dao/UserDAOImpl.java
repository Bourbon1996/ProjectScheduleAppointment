package users.dao;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import users.entity.User;
import utils.GenericDAOImpl;
import utils.JpaUtil;

public class UserDAOImpl extends GenericDAOImpl<User> implements UserDAO {
	
	private final EntityManager em;

    public UserDAOImpl() {
        super(User.class);
        this.em = JpaUtil.getEntityManager();
    }
    
    @Override
    public User findByPhone(String phone) {
    	String jpql = " select o from User o where o.phone = :phone";
    	
    	TypedQuery<User> query  = em.createQuery(jpql, User.class);
    	query.setParameter("phone", phone );
    	
    	List<User> users  = query.getResultList();
    	
    	if(users.isEmpty()) {
    		return null;
    		
    	}
    	 return users.get(0);
    	
    }
    
    @Override
    public User findByEmail(String email) {
    	String jpql = " select o from User o where o.email = :email ";
    	
    	TypedQuery<User> query = em.createQuery(jpql, User.class);
    	query.setParameter("email", email);
    	
    	List<User> users = query.getResultList();
    	
    	if(users.isEmpty()) {
    		return null;
    	}
    	 return users.get(0);
    }
}