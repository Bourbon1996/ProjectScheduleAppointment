package utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class GenericDAOImpl<T> implements GenericDAO<T> {

    private final EntityManager em = JpaUtil.getEntityManager();
    private final Class<T> entityClass;

    public GenericDAOImpl(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    /**
     * Create
     */
    public boolean create(T entity) {
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            em.persist(entity);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update
     */
    public T update(T entity) {
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            T updatedEntity = em.merge(entity);
            transaction.commit();
            return updatedEntity;
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Delete by id
     */
    public boolean delete(Object id) {
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();

            T entity = em.find(entityClass, id);
            if (entity != null) {
                em.remove(entity);
            }

            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Find by id
     */
    public T findById(Object id) {
        return em.find(entityClass, id);
    }

    /**
     * Find all
     */
    public List<T> findAll() {
        String jpql = "FROM " + entityClass.getSimpleName();
        TypedQuery<T> query = em.createQuery(jpql, entityClass);
        return query.getResultList();
    }

    /**
     * Count
     */
    public long count() {
        String jpql = "SELECT COUNT(e) FROM " + entityClass.getSimpleName() + " e";
        return em.createQuery(jpql, Long.class).getSingleResult();
    }

    /**
     * Check exists
     */
    public boolean exists(Object id) {
        return findById(id) != null;
    }

    /**
     * Refresh entity
     */
    public void refresh(T entity) {
        em.refresh(entity);
    }

    /**
     * Detach entity
     */
    public void detach(T entity) {
        em.detach(entity);
    }
}
