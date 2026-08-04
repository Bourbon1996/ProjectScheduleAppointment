package com.dhakcare.service.impl;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.dhakcare.dao.AppointmentsDAO;
import com.dhakcare.dao.PaymentDAO;
import com.dhakcare.dao.impl.AppointmentDAOImpl;
import com.dhakcare.dao.impl.PaymentDAOImpl;
import com.dhakcare.entity.Appointment;
import com.dhakcare.entity.Payment;
import com.dhakcare.enums.AppointmentStatus;
import com.dhakcare.enums.PaymentStatus;
import com.dhakcare.enums.TransactionStatus;
import com.dhakcare.service.PaymentService;

public class PaymentServiceImpl implements PaymentService{

	private PaymentDAO dao = new PaymentDAOImpl();
	private AppointmentsDAO appointmentsDAO = new AppointmentDAOImpl();
	
	
	@Override
	public boolean insert(Payment pay) {
		// TODO Auto-generated method stub
		return dao.create(pay);
	}

	@Override
	public Payment createPayment(Appointment appointment, BigDecimal amount, String method, String transactionCode) {
	    Payment payment = new Payment();
	    payment.setAppointment(appointment);
	    payment.setAmount(amount);
	    payment.setMethod(method);
	    payment.setStatus(TransactionStatus.PENDING);
	    payment.setTransactionCode(transactionCode);

	    
	    dao.create(payment);
	    return payment;
	}
	
	@Override
	public void updatePaymentSuccess(String txnRef) {

	    Payment payment = dao.findByTransactionCode(txnRef);
	    
	    if (payment != null) {
	       
	        payment.setStatus(TransactionStatus.SUCCESS); 
	        payment.setPaidAt(LocalDateTime.now()); 
	        
	        
	        Appointment appointment = payment.getAppointment();
	        if (appointment != null) {
	            appointment.setPaymentStatus(PaymentStatus.PAID); 
	            appointment.setStatus(AppointmentStatus.CONFIRMED); 
	            
	            appointmentsDAO.update(appointment);
	        }

	        dao.update(payment);
	    }
	}
}
