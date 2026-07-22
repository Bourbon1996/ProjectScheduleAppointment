package utils;

import java.util.List;

public interface GenericDAO<T> {
    
    /** Create */
    boolean create(T entity);
    
    /** Update */
    T update(T entity);
    
    /** Delete by id */
    boolean delete(Object id);
    
    /** Find by id */
    T findById(Object id);
    
    /** Find all */
    List<T> findAll();
    
    /** Count */
    long count();
    
    /** Check exists */
    boolean exists(Object id);
    
    /** Refresh entity */
    void refresh(T entity);
    
    /** Detach entity */
    void detach(T entity);
}