package com.dhakcare.service;

import java.math.BigDecimal;

import com.dhakcare.entity.Appointment;
import com.dhakcare.entity.Payment;

public interface PaymentService {
	public boolean insert(Payment pay);
	public Payment createPayment(Appointment appointment, BigDecimal amount, String method, String transactionCode);
	public void updatePaymentSuccess(String txnRef);
}
