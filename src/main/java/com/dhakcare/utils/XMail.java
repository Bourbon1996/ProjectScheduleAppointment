package com.dhakcare.utils;

import java.util.Properties;

import com.dhakcare.entity.User;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;


public class XMail {
    static String path = ConfigUtil.get("app.url");
    
    static final String USERNAME = ConfigUtil.get("mail.username");
    static final String PASSWORD = ConfigUtil.get("mail.password");
	
	static public void sendWelcome(User user) {
		var to = user.getEmail();
		var subject = "Chào mừng bạn đến với DHAK Healthcare";
		var body = path + "/home/index/";
		XMail.send(to, subject, body);
	}
	
	static public void sendPassword(User user) {
		var to = user.getEmail();
		var subject = "Your password";
		var body = user.getPasswordHash();
		XMail.send(to, subject, body);
	}
	
	static public void sendOtp(String email, String otp) {
		var subject = "Mã xác nhận khôi phục mật khẩu (OTP)";
		var body = "<h2>Khôi phục mật khẩu</h2>" +
		           "<p>Mã OTP của bạn là: <strong>" + otp + "</strong></p>" +
		           "<p>Mã này sẽ hết hạn trong 5 phút. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>";
		XMail.send(email, subject, body);
	}

	static public void sendBookingSuccess(com.dhakcare.entity.Appointment appt) {
		if (appt == null || appt.getBookedBy() == null) return;
		var email = appt.getBookedBy().getEmail();
		if (email == null || email.isEmpty()) return;

		var subject = "Xác nhận đặt lịch thành công - DHA Healthcare";
		
		String docName = appt.getDoctor() != null ? appt.getDoctor().getUser().getFullName() : "Bác sĩ DHA";
		String deptName = appt.getDepartment() != null ? appt.getDepartment().getName() : "Khám chung";
		String date = appt.getSlot() != null ? appt.getSlot().getWorkDate().toString() : "";
		String time = appt.getSlot() != null ? appt.getSlot().getStartTime().toString() : "";
		
		var body = "<h2>Đặt lịch khám thành công</h2>" +
				   "<p>Chào " + appt.getBookedBy().getFullName() + ",</p>" +
				   "<p>Bạn đã đặt lịch khám thành công tại DHA Healthcare. Dưới đây là thông tin chi tiết:</p>" +
				   "<ul>" +
				   "<li><strong>Mã lịch hẹn:</strong> #" + appt.getId() + "</li>" +
				   "<li><strong>Chuyên khoa:</strong> " + deptName + "</li>" +
				   "<li><strong>Bác sĩ:</strong> BS. " + docName + "</li>" +
				   "<li><strong>Ngày khám:</strong> " + date + "</li>" +
				   "<li><strong>Giờ khám dự kiến:</strong> " + time + "</li>" +
				   "</ul>" +
				   "<p>Vui lòng đến đúng giờ để được phục vụ tốt nhất.</p>" +
				   "<p>Trân trọng,<br>DHA Healthcare</p>";
				   
		// Use CompletableFuture to run asynchronously
		java.util.concurrent.CompletableFuture.runAsync(() -> {
			XMail.send(email, subject, body);
		});
	}
	
	static public void send(String to, String subject, String content) {
		var from = "FPT Polytechnic <183anhka@gmail.com>";
		send(from, to, subject, content);
	}
	
	static public void send(String from, String to, String subject, String content) {
		var props = new Properties();
		props.setProperty("mail.smtp.host", "smtp.gmail.com");
		props.setProperty("mail.smtp.port", "587");
		props.setProperty("mail.smtp.auth", "true");
		props.setProperty("mail.smtp.starttls.enable", "true");
		var session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(USERNAME, PASSWORD);
			}
		});

		try {
			var mail = new MimeMessage(session);
			mail.setFrom(new InternetAddress(from));
			mail.setRecipients(Message.RecipientType.TO, to);
			mail.setSubject(subject, "utf8");
			mail.setContent(content, "text/html; charset=utf8");
			mail.setReplyTo(mail.getFrom());
			
			Transport.send(mail);
			System.out.println("Mail was sent to " + to);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}
}