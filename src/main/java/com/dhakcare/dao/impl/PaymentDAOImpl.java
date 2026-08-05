package com.dhakcare.dao.impl;

import com.dhakcare.dao.PaymentDAO;
import com.dhakcare.entity.Payment;
import com.dhakcare.utils.GenericDAOImpl;

public class PaymentDAOImpl extends GenericDAOImpl<Payment> implements PaymentDAO {

	public PaymentDAOImpl() {
		super(Payment.class);
		// TODO Auto-generated constructor stub
	}

}
