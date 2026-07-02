package users.dao;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import users.entity.User;
import utils.JpaUtils;

public class UserDAOImpl implements UserDAO {
	EntityManager em =  JpaUtils.getEntityManager();
	EntityTransaction trans = em.getTransaction();
	
	
	@Override
	public User create(User entity) {
		try {
			trans.begin();
			em.persist(entity);
			trans.commit();
		} catch (Exception e) {
			trans.rollback();
		}
		return null;
	}
	
	@Override
	public void update(User entity) {
		try {
			trans.begin();
			em.merge(entity);
			trans.commit();
		} catch (Exception e) {
			trans.rollback();
		}
		
	}
	@Override
	public void deleteById(String id) {
		try {
			trans.begin();
			User u = em.find(User.class, id);
			em.remove(u);
			trans.commit();
		} catch (Exception e) {
			trans.rollback();
		}
		
	}
	@Override
	public List<User> findAll() {
		var jpql = "select o from user o";
		var query = em.createQuery(jpql, User.class );
		return query.getResultList();
	}
	@Override
	public User findById(String id) {
	
		return em.find(User.class, id);
	}
	
	
	
}
