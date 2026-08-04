package com.dhakcare.dao.impl;

import com.dhakcare.dao.PaymentDAO;
import com.dhakcare.entity.Payment;
import com.dhakcare.utils.GenericDAOImpl;
import com.dhakcare.utils.JpaUtil;

import jakarta.persistence.TypedQuery;

public class PaymentDAOImpl extends GenericDAOImpl<Payment> implements PaymentDAO {

	public PaymentDAOImpl() {
		super(Payment.class);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	public Payment findByTransactionCode(String txnRef) {
		var em = JpaUtil.getEntityManager();
	    try {
	        String jpql = "SELECT p FROM Payment p WHERE p.transactionCode = :txnRef";
	        TypedQuery<Payment> query = em.createQuery(jpql, Payment.class);
	        query.setParameter("txnRef", txnRef);
	        return query.getSingleResult();
	    } catch (Exception e) {
	        return null;
	    }
	}

}
