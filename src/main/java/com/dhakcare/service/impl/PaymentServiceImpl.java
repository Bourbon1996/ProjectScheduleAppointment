package com.dhakcare.service.impl;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import com.dhakcare.dao.AppointmentsDAO;
import com.dhakcare.dao.PaymentDAO;
import com.dhakcare.dao.impl.AppointmentDAOImpl;
import com.dhakcare.dao.impl.PaymentDAOImpl;
import com.dhakcare.entity.Appointment;
import com.dhakcare.entity.Payment;
import com.dhakcare.enums.AppointmentStatus;
import com.dhakcare.enums.PaymentStatus;
import com.dhakcare.enums.TransactionStatus;
import com.dhakcare.enums.WsEventType;
import com.dhakcare.service.PaymentService;
import com.dhakcare.utils.JpaUtil;
import com.dhakcare.ws.AdminDashboardWS;

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
		
		var em = JpaUtil.getEntityManager();
		var trans = em.getTransaction();
		
		try {
			
			trans.begin();

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
		        
		        Long totalAppointments = appointmentsDAO.count();
		        BigDecimal totalRevenue = dao.calculateTotal();
		        
		        trans.commit();

		        Map<String, Object> statsData = new HashMap<>();
		        statsData.put("totalAppointments", totalAppointments);
		        statsData.put("totalRevenue", totalRevenue);
	
		      
		        AdminDashboardWS.broadcast(WsEventType.PAYMENT_SUCCESS, statsData);
		    }
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			trans.rollback();
		} finally {
			em.close();
		}
	}
}
