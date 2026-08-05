package com.dhakcare.dao.impl;

import java.math.BigDecimal;
import java.util.List;

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
	    } finally {
	        if (em != null && em.isOpen()) {
	            em.close();
	        }
	    }
	}
	
	@Override
	public BigDecimal calculateTotal() {
		var em = JpaUtil.getEntityManager();
	    try {
	        String jpql = "SELECT SUM(p.amount) FROM Payment p WHERE p.status = 'SUCCESS'";
	        BigDecimal total = em.createQuery(jpql, BigDecimal.class).getSingleResult();
	        return total != null ? total : BigDecimal.ZERO;
	    } catch (Exception e) {
	        return BigDecimal.ZERO;
	    } finally {
	        if (em != null && em.isOpen()) {
	            em.close();
	        }
	    }
	}

	@Override
	public List<BigDecimal> getMonthlyRevenue(int year) {
		var em = JpaUtil.getEntityManager();
		try {
			// Initialize list with 12 zeros
			java.util.List<BigDecimal> monthlyRevenue = new java.util.ArrayList<>();
			for (int i = 0; i < 12; i++) {
				monthlyRevenue.add(BigDecimal.ZERO);
			}

			// Group by month
			String jpql = "SELECT MONTH(p.paidAt), SUM(p.amount) FROM Payment p " +
					"WHERE YEAR(p.paidAt) = :year AND p.status = 'SUCCESS' " +
					"GROUP BY MONTH(p.paidAt)";

			java.util.List<Object[]> results = em.createQuery(jpql, Object[].class)
					.setParameter("year", year)
					.getResultList();

			for (Object[] row : results) {
				int month = (Integer) row[0]; // 1 to 12
				BigDecimal total = (BigDecimal) row[1];
				monthlyRevenue.set(month - 1, total);
			}

			return monthlyRevenue;
		} catch (Exception e) {
			e.printStackTrace();
			return java.util.Collections.nCopies(12, BigDecimal.ZERO);
		} finally {
			if (em != null && em.isOpen()) {
				em.close();
			}
		}
	}

}
