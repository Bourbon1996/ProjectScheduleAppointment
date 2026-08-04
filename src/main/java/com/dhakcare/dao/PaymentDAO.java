package com.dhakcare.dao;

import java.math.BigDecimal;

import com.dhakcare.entity.Payment;
import com.dhakcare.utils.GenericDAO;

public interface PaymentDAO extends GenericDAO<Payment> {
	public Payment findByTransactionCode(String txnRef);
	public BigDecimal calculateTotal();
}
