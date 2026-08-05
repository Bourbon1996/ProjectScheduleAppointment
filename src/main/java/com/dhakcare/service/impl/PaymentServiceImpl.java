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

			// Tìm payment bằng chính EM này (thay vì gọi DAO riêng)
			String jpql = "SELECT p FROM Payment p WHERE p.transactionCode = :txnRef";
			Payment payment = em.createQuery(jpql, Payment.class)
			        .setParameter("txnRef", txnRef)
			        .getResultStream()
			        .findFirst()
			        .orElse(null);
		    
		    if (payment != null) {
		       
		        payment.setStatus(TransactionStatus.SUCCESS); 
		        payment.setPaidAt(LocalDateTime.now()); 
		        
		        Appointment appointment = payment.getAppointment();
		        if (appointment != null) {
		            appointment.setPaymentStatus(PaymentStatus.PAID); 
		            appointment.setStatus(AppointmentStatus.CONFIRMED); 
		            // Không cần gọi merge vì appointment đã managed trong EM này

		            // Send Email and WebSocket Notification
		            com.dhakcare.utils.XMail.sendBookingSuccess(appointment);
		            if (appointment.getDoctor() != null) {
		            	com.dhakcare.websocket.NotificationWebSocket.sendNotification(
		            			appointment.getDoctor().getId(), 
		            			"{\"type\": \"NEW_APPOINTMENT\", \"message\": \"Bạn có một lịch hẹn mới!\"}");
		            }
		        }
	
		        // Không cần gọi merge cho payment vì nó cũng đã managed
		        
		        // Đếm tổng trong cùng EM
		        Long totalAppointments = em.createQuery(
		                "SELECT COUNT(a) FROM Appointment a", Long.class)
		                .getSingleResult();
		        BigDecimal totalRevenue = em.createQuery(
		                "SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.status = 'SUCCESS'", BigDecimal.class)
		                .getSingleResult();
		        
		        trans.commit();

		        Map<String, Object> statsData = new HashMap<>();
		        statsData.put("totalAppointments", totalAppointments);
		        statsData.put("totalRevenue", totalRevenue);
	
		        AdminDashboardWS.broadcast(WsEventType.PAYMENT_SUCCESS, statsData);
		    } else {
		        trans.commit(); // Không tìm thấy payment, commit rỗng
		    }
		} catch (Exception e) {
			e.printStackTrace();
			if (trans != null && trans.isActive()) {
				trans.rollback();
			}
		} finally {
			if (em != null && em.isOpen()) {
				em.close();
			}
		}
	}

	@Override
	public java.util.List<BigDecimal> getMonthlyRevenue(int year) {
		return dao.getMonthlyRevenue(year);
	}
}
