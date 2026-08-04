package com.dhakcare.dao;

import com.dhakcare.entity.Payment;
import com.dhakcare.utils.GenericDAO;

public interface PaymentDAO extends GenericDAO<Payment> {
	public Payment findByTransactionCode(String txnRef);
}
