package com.dhakcare.service.impl;

import com.dhakcare.dao.PaymentDAO;
import com.dhakcare.dao.impl.PaymentDAOImpl;
import com.dhakcare.entity.Payment;
import com.dhakcare.service.PaymentService;

public class PaymentServiceImpl implements PaymentService{

	private PaymentDAO dao = new PaymentDAOImpl();
	
	
	@Override
	public boolean insert(Payment pay) {
		// TODO Auto-generated method stub
		return dao.create(pay);
	}

}
