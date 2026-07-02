package utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaUtil {
	static EntityManagerFactory factory;
	static EntityManager manager;
	
	public static EntityManager getEntityManager() {
		if(factory == null || !factory.isOpen()) {
			factory = Persistence.createEntityManagerFactory("scheduleappointment");
		}
		if(manager == null || !manager.isOpen()) {
			manager = factory.createEntityManager();
		}
		return manager;
	}
}
