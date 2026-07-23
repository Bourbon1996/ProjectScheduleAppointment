package patients.dao;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import patients.entity.Patient;
import utils.GenericDAOImpl;
import utils.JpaUtil;

public class PatientDAOImpl extends GenericDAOImpl<Patient> implements PatientsDAO{

	public PatientDAOImpl() {
		super(Patient.class);
		
	}

	@Override
	public boolean insert(Patient patient) {
		EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        
        try {
            trans.begin();
            em.persist(patient); 
            trans.commit();
            return true;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
	}

	@Override
	public List<Patient> findByUserId(Long id) {
		EntityManager em = JpaUtil.getEntityManager();
        
        try {
            String jpql = "select o.patients from User o where o.id = :id";

            var query = em.createQuery(jpql, Patient.class);
            query.setParameter("id", id);
            
            return query.getResultList();
            
        } finally {
            em.close();
        }
	}
	

}
