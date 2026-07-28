package com.dhakcare.utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class GenericDAOImpl<T> implements GenericDAO<T> {

    private final Class<T> entityClass;

    public GenericDAOImpl(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    protected EntityManager getEm() {
        EntityManager em = JpaUtil.getEntityManager();
        
        if (em == null || !em.isOpen()) {
            em = JpaUtil.getEntityManager();
        }
        return em;
    }

    /**
     * Create
     */
    @Override
    public boolean create(T entity) {
        EntityManager em = getEm();
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
    @Override
    public T update(T entity) {
        EntityManager em = getEm();
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
    @Override
    public boolean delete(Object id) {
        EntityManager em = getEm();
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
    @Override
    public T findById(Object id) {
        return getEm().find(entityClass, id);
    }

    /**
     * Find all
     */
    @Override
    public List<T> findAll() {
        EntityManager em = getEm();
        String jpql = "FROM " + entityClass.getSimpleName();
        TypedQuery<T> query = em.createQuery(jpql, entityClass);
        return query.getResultList();
    }

    /**
     * Count
     */
    @Override
    public long count() {
        EntityManager em = getEm();
        String jpql = "SELECT COUNT(e) FROM " + entityClass.getSimpleName() + " e";
        return em.createQuery(jpql, Long.class).getSingleResult();
    }

    /**
     * Check exists
     */
    @Override
    public boolean exists(Object id) {
        return findById(id) != null;
    }

    /**
     * Refresh entity
     */
    @Override
    public void refresh(T entity) {
        getEm().refresh(entity);
    }

    /**
     * Detach entity
     */
    @Override
    public void detach(T entity) {
        getEm().detach(entity);
    }
}